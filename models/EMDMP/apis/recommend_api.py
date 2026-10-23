import json
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel, Field

try:
	from .llm_client import get_client, probe_llm
except ImportError:
	from llm_client import get_client, probe_llm


router = APIRouter()


class RecommendItem(BaseModel):
    itemId: int | None = None
    title: str | None = ""
    category: str | None = ""
    sellerId: str | int | None = None
    clickCnt: float | int | None = 0
    collectCnt: float | int | None = 0
    cartCnt: float | int | None = 0
    payCnt: float | int | None = 0
    clickCnt7D: float | int | None = 0
    clickUv7D: float | int | None = 0
    payPerClick7D: float | int | None = 0
    recommendationScore: float | int | None = 0
    recommendationLevel: str | None = ""
    recommendationReason: str | None = ""


class RecommendRequest(BaseModel):
    keyword: str | None = ""
    anchorDate: str | None = None
    items: list[RecommendItem] = Field(default_factory=list)


def compute_rule_score(item: RecommendItem) -> float:
    score = (
        float(item.payCnt or 0) * 0.45
        + float(item.clickCnt or 0) * 0.20
        + float(item.clickCnt7D or 0) * 0.15
        + float(item.clickUv7D or 0) * 0.10
        + max(float(item.payPerClick7D or 0), 0.0) * 100 * 0.10
    )
    return round(score, 4)


def get_score_level(score: float) -> str:
    if score >= 80:
        return "高推荐"
    if score >= 55:
        return "中推荐"
    return "低推荐"


def fallback_recommendation_reason(item: RecommendItem, keyword: str) -> str:
    parts: list[str] = []
    if keyword:
        parts.append(f"标题与关键字“{keyword}”相关")
    if float(item.payCnt or 0) > 0:
        parts.append(f"累计销量为 {item.payCnt}")
    if float(item.clickCnt or 0) > 0:
        parts.append(f"累计点击为 {item.clickCnt}")
    if float(item.clickCnt7D or 0) > 0:
        parts.append(f"近7日点击为 {item.clickCnt7D}")
    if float(item.payPerClick7D or 0) > 0:
        parts.append(f"近7日转化效率为 {round(float(item.payPerClick7D), 4)}")
    if not parts:
        return "候选商品数据较少，当前使用规则分作为推荐依据。"
    return "；".join(parts) + "，因此推荐优先关注。"


def build_llm_prompt(keyword: str, items: list[RecommendItem]) -> str:
    compact_items = []
    for item in items[:10]:
        compact_items.append(
            {
                "itemId": item.itemId,
                "title": item.title,
                "category": item.category,
                "sellerId": item.sellerId,
                "clickCnt": item.clickCnt,
                "payCnt": item.payCnt,
                "clickCnt7D": item.clickCnt7D,
                "clickUv7D": item.clickUv7D,
                "payPerClick7D": item.payPerClick7D,
                "ruleScore": compute_rule_score(item),
            }
        )

    return (
        "你是电商运营分析助手。请根据商品标题关键字、销量、点击与近7日行为特征，"
        "为每个商品输出推荐理由与推荐等级。"
        "请仅返回 JSON，不要输出 Markdown。"
        'JSON 格式必须为 {"items":[{"itemId":123,"recommendationReason":"...","recommendationLevel":"高推荐"}]}。'
        f" 关键字：{keyword}。商品列表：{json.dumps(compact_items, ensure_ascii=False)}"
    )


def parse_llm_response(content: str) -> dict:
    if not content or not content.strip():
        return {}

    text = content.strip()

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

    code_block_pattern = r"```(?:json)?\s*(.*?)\s*```"
    import re

    matches = re.findall(code_block_pattern, text, re.DOTALL)
    for match in matches:
        try:
            return json.loads(match.strip())
        except json.JSONDecodeError:
            continue

    start = text.find("{")
    end = text.rfind("}")
    if start != -1 and end != -1 and end > start:
        return json.loads(text[start : end + 1])

    raise json.JSONDecodeError("Unable to parse JSON from LLM response", text, 0)


def call_llm(keyword: str, items: list[RecommendItem]) -> dict[int, dict[str, str]]:
    try:
        from .llm_client import get_llm_model
    except ImportError:
        from llm_client import get_llm_model

    client = get_client()
    prompt = build_llm_prompt(keyword, items)
    response = client.chat.completions.create(
        model=get_llm_model(),
        temperature=0.2,
        messages=[
            {"role": "system", "content": "你是严谨的电商运营分析助手。"},
            {"role": "user", "content": prompt},
        ],
        response_format={"type": "json_object"},
    )
    content = response.choices[0].message.content or "{}"
    data = parse_llm_response(content)

    result: dict[int, dict[str, str]] = {}
    for item in data.get("items", []):
        item_id = item.get("itemId")
        if item_id is None:
            continue
        result[int(item_id)] = {
            "recommendationReason": item.get("recommendationReason", ""),
            "recommendationLevel": item.get("recommendationLevel", ""),
        }
    return result


@router.get("/health")
async def health() -> dict[str, Any]:
    result = await probe_llm()
    result["service"] = "EMDMPAI"
    return result


@router.post("/recommend-items")
async def recommend_items(payload: RecommendRequest) -> dict[str, Any]:
    scored_items = []
    avg_score = 0.0
    high_count = 0
    llm_status = "success"
    llm_reason_map: dict[int, dict[str, str]] = {}

    try:
        if payload.items:
            llm_reason_map = call_llm(payload.keyword or "", payload.items)
    except Exception as exc:  # noqa: BLE001
        print(f"[ERROR] recommend_items LLM call failed: {exc}")
        llm_status = "fallback"

    for raw_item in payload.items:
        item = raw_item.model_copy()
        score = compute_rule_score(item)
        item.recommendationScore = score
        default_level = get_score_level(score)
        default_reason = fallback_recommendation_reason(item, payload.keyword or "")

        llm_item = llm_reason_map.get(int(item.itemId or 0), {})
        item.recommendationLevel = llm_item.get("recommendationLevel") or default_level
        item.recommendationReason = llm_item.get("recommendationReason") or default_reason

        avg_score += score
        if score >= 80:
            high_count += 1

        scored_items.append(item.model_dump())

    scored_items.sort(
        key=lambda row: (
            float(row.get("recommendationScore") or 0),
            float(row.get("payCnt") or 0),
            float(row.get("clickCnt") or 0),
        ),
        reverse=True,
    )

    item_count = len(scored_items)
    avg_score = round(avg_score / item_count, 4) if item_count else 0.0

    return {
        "success": True,
        "totalElements": item_count,
        "items": scored_items,
        "summary": {
            "matchedItemCount": item_count,
            "avgRecommendationScore": avg_score,
            "highRecommendationCount": high_count,
            "llmStatus": llm_status if item_count else "empty",
            "message": "已使用 HTTPS 云模型补充推荐理由" if llm_status == "success" else "HTTPS 云模型调用失败，已回退到规则推荐",
        },
    }
