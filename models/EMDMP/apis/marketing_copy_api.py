import json
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel, Field

try:
	from .llm_client import get_client, get_llm_model
except ImportError:
	from llm_client import get_client, get_llm_model


router = APIRouter()


class MarketingCopyItem(BaseModel):
	itemId: int | None = None
	title: str | None = ""
	category: str | None = ""
	sellerId: str | int | None = None
	clickCnt: float | int | None = 0
	payCnt: float | int | None = 0
	clickCnt7D: float | int | None = 0
	clickUv7D: float | int | None = 0
	payPerClick7D: float | int | None = 0
	recommendationScore: float | int | None = 0
	recommendationLevel: str | None = ""
	recommendationReason: str | None = ""


class MarketingCopyRequest(BaseModel):
	keyword: str | None = ""
	anchorDate: str | None = None
	items: list[MarketingCopyItem] = Field(default_factory=list)


def normalize_text(value: Any, default: str = "") -> str:
	if value is None:
		return default
	text = str(value).strip()
	return text or default


def normalize_text_list(values: Any) -> list[str]:
	if not isinstance(values, list):
		return []

	result = []
	for item in values:
		if isinstance(item, dict):
			text = normalize_text(item.get("content") or item.get("text") or item.get("title"), "")
		else:
			text = normalize_text(item, "")
		if text:
			result.append(text)
	return result


def parse_json_response(content: str) -> dict[str, Any]:
	if not content or not content.strip():
		return {}

	text = content.strip()

	try:
		return json.loads(text)
	except json.JSONDecodeError:
		pass

	import re

	code_block_pattern = r"```(?:json)?\s*(.*?)\s*```"
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


def normalize_copy_item(row: Any, fallback: dict[str, Any]) -> dict[str, Any]:
	data = row if isinstance(row, dict) else {}
	return {
		"itemId": data.get("itemId") if data.get("itemId") is not None else fallback["itemId"],
		"title": normalize_text(data.get("title"), fallback["title"]),
		"headlineOptions": normalize_text_list(data.get("headlineOptions")) or fallback["headlineOptions"],
		"sellingPoints": normalize_text_list(data.get("sellingPoints")) or fallback["sellingPoints"],
		"shortPromotions": normalize_text_list(data.get("shortPromotions"))
		or fallback["shortPromotions"],
	}


def normalize_marketing_copy_payload(
	data: dict[str, Any],
	fallback_payload: dict[str, Any],
) -> dict[str, Any]:
	fallback_by_item_id = {
		str(item.get("itemId")): item
		for item in fallback_payload.get("copies", [])
		if item.get("itemId") is not None
	}

	normalized_copies = []
	for item in data.get("copies") or []:
		item_id = str(item.get("itemId")) if isinstance(item, dict) and item.get("itemId") is not None else ""
		fallback_item = fallback_by_item_id.get(item_id)
		if fallback_item:
			normalized_copies.append(normalize_copy_item(item, fallback_item))

	return {
		"summary": normalize_text(data.get("summary"), fallback_payload["summary"]),
		"copies": normalized_copies or fallback_payload["copies"],
		"llmStatus": normalize_text(data.get("llmStatus"), "success"),
	}


def build_marketing_copy_prompt(payload: MarketingCopyRequest) -> str:
	compact_items = []
	for item in payload.items[:3]:
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
				"recommendationScore": item.recommendationScore,
				"recommendationLevel": item.recommendationLevel,
				"recommendationReason": item.recommendationReason,
			}
		)

	return (
		"你是资深电商营销策划顾问。请基于给定商品生成中文营销文案。"
		"只返回 JSON，不要输出 Markdown，不要输出解释。"
		"JSON 必须包含 summary、copies、llmStatus。"
		"copies 必须是数组，每个商品都包含 itemId、title、headlineOptions、sellingPoints、shortPromotions。"
		"headlineOptions 输出 3 条标题优化建议；sellingPoints 输出 3-5 条核心卖点；shortPromotions 输出 3 条短推广文案。"
		"文案要贴合推荐度、销量、点击、近7日点击、近7日转化表现，避免虚构价格、销量冠军、全网第一等事实。"
		f"关键词：{payload.keyword or '未指定'}。"
		f"锚定日期：{payload.anchorDate or '未指定'}。"
		f"商品数据：{json.dumps(compact_items, ensure_ascii=False)}"
	)


def build_item_headline_options(item: MarketingCopyItem) -> list[str]:
	title = normalize_text(item.title, f"商品 {item.itemId or ''}").replace("  ", " ").strip()
	category = normalize_text(item.category, "商品")
	reason = normalize_text(item.recommendationReason, "综合表现突出")
	return [
		f"{title} | {category}高潜推荐，突出核心卖点与转化优势",
		f"{title} | 围绕{reason}强化点击后的购买决策",
		f"{title} | 面向高意向用户的精简卖点表达版本",
	]


def build_item_selling_points(item: MarketingCopyItem) -> list[str]:
	score = float(item.recommendationScore or 0)
	pay_cnt = float(item.payCnt or 0)
	click_cnt = float(item.clickCnt or 0)
	click_7d = float(item.clickCnt7D or 0)
	conversion = float(item.payPerClick7D or 0)
	reason = normalize_text(item.recommendationReason, "当前商品具备稳定经营潜力")
	level = normalize_text(item.recommendationLevel, "推荐")

	points = [
		f"{level}商品，当前推荐度为 {score:.2f}，适合作为重点曝光候选。",
		f"累计点击 {click_cnt:.0f}、累计销量 {pay_cnt:.0f}，说明商品已有明确市场反馈。",
		f"近7日点击 {click_7d:.0f}、近7日支付转化 {conversion:.4f}，可作为近期转化表达依据。",
		reason,
	]
	return [point for point in points if point][:4]


def build_item_short_promotions(item: MarketingCopyItem) -> list[str]:
	title = normalize_text(item.title, f"商品 {item.itemId or ''}")
	category = normalize_text(item.category, "好货")
	level = normalize_text(item.recommendationLevel, "推荐")
	return [
		f"{title}，{category}赛道中的{level}选择，先看卖点再下单更省心。",
		f"{title}正在释放转化潜力，适合优先加入你的重点运营池。",
		f"想找更稳的{category}选择，可以先从{title}开始重点关注。",
	]


def fallback_marketing_copy(payload: MarketingCopyRequest) -> dict[str, Any]:
	items = payload.items[:3]
	keyword = payload.keyword or "当前关键词"
	copies = []
	for item in items:
		copies.append(
			{
				"itemId": item.itemId,
				"title": normalize_text(item.title, f"商品 {item.itemId or ''}"),
				"headlineOptions": build_item_headline_options(item),
				"sellingPoints": build_item_selling_points(item),
				"shortPromotions": build_item_short_promotions(item),
			}
		)

	return {
		"summary": (
			f"已围绕“{keyword}”下勾选的 {len(copies)} 个商品生成首版营销文案，"
			"文案重点突出推荐度、点击表现、销量与近期转化特征。"
		),
		"copies": copies,
		"llmStatus": "fallback",
	}


def generate_marketing_copy_content(payload: MarketingCopyRequest) -> dict[str, Any]:
	fallback_payload = fallback_marketing_copy(payload)
	prompt = build_marketing_copy_prompt(payload)

	try:
		client = get_client()
		response = client.chat.completions.create(
			model=get_llm_model(),
			temperature=0.5,
			messages=[
				{"role": "system", "content": "你是资深电商营销策划顾问。"},
				{"role": "user", "content": prompt},
			],
			response_format={"type": "json_object"},
		)
		content = response.choices[0].message.content or "{}"
		data = parse_json_response(content)
		normalized = normalize_marketing_copy_payload(data, fallback_payload)
		if not normalized["copies"]:
			return fallback_payload
		return normalized
	except Exception as exc:  # noqa: BLE001
		print(f"[ERROR] generate_marketing_copy_content LLM call failed: {exc}")
		return fallback_payload


@router.post("/generate-marketing-copy")
async def generate_marketing_copy(payload: MarketingCopyRequest) -> dict[str, Any]:
	result = generate_marketing_copy_content(payload)
	result["success"] = True
	return result
