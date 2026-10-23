import json
import threading
import uuid
from datetime import datetime
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel, Field

from .llm_client import get_client, get_llm_model


router = APIRouter()
COMPETITOR_ANALYSIS_TASKS: dict[str, dict[str, Any]] = {}
COMPETITOR_ANALYSIS_LOCK = threading.Lock()


class CompetitorMetric(BaseModel):
	itemId: int | str | None = None
	title: str | None = ""
	category: str | None = ""
	sellerId: str | int | None = None
	similarityScore: float | int | None = 0
	rankNo: int | None = 0
	clickCnt: float | int | None = 0
	payCnt: float | int | None = 0
	payCnt30D: float | int | None = 0
	pred7DPay: float | int | None = 0
	trendSource: str | None = ""
	trendLabels: list[str] = Field(default_factory=list)
	trendValues: list[float | int | None] = Field(default_factory=list)


class MainItemMetric(BaseModel):
	itemId: int | str | None = None
	title: str | None = ""
	category: str | None = ""
	sellerId: str | int | None = None
	payCnt: float | int | None = 0
	payCnt30D: float | int | None = 0
	pred7DPay: float | int | None = 0
	trendSource: str | None = ""
	trendLabels: list[str] = Field(default_factory=list)
	trendValues: list[float | int | None] = Field(default_factory=list)


class CompetitorAnalysisRequest(BaseModel):
	mainItem: MainItemMetric | None = None
	selectedCompetitors: list[CompetitorMetric] = Field(default_factory=list)
	candidateSummary: list[CompetitorMetric] = Field(default_factory=list)
	priceStatus: str | None = ""
	enhancementTaskId: str | None = None


def normalize_text(value: Any, default: str = "") -> str:
	if value is None:
		return default
	text = str(value).strip()
	return text or default


def safe_float(value: Any, default: float = 0.0) -> float:
	try:
		if value is None or value == "":
			return default
		return float(value)
	except Exception:  # noqa: BLE001
		return default


def normalize_text_list(values: Any) -> list[str]:
	if not isinstance(values, list):
		return []

	result: list[str] = []
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


def normalize_analysis_payload(data: dict[str, Any]) -> dict[str, Any]:
	llm_status = normalize_text(data.get("llmStatus"), "success").lower()
	if llm_status not in {"fallback", "error"}:
		llm_status = "success"

	return {
		"summary": normalize_text(data.get("summary"), ""),
		"relationshipInsights": normalize_text_list(data.get("relationshipInsights")),
		"comparisonHighlights": normalize_text_list(data.get("comparisonHighlights")),
		"marketPosition": normalize_text(data.get("marketPosition"), ""),
		"strengths": normalize_text_list(data.get("strengths")),
		"weaknesses": normalize_text_list(data.get("weaknesses")),
		"strategySuggestions": normalize_text_list(data.get("strategySuggestions")),
		"llmStatus": llm_status,
	}


def fallback_competitor_analysis(payload: CompetitorAnalysisRequest) -> dict[str, Any]:
	main_item = payload.mainItem or MainItemMetric()
	selected_items = payload.selectedCompetitors
	candidate_items = payload.candidateSummary

	avg_similarity = (
		round(sum(safe_float(item.similarityScore) for item in candidate_items) / len(candidate_items), 2)
		if candidate_items
		else 0.0
	)

	top_similarity_items = sorted(
		candidate_items,
		key=lambda item: safe_float(item.similarityScore),
		reverse=True,
	)[:3]

	top_pred_items = sorted(
		[main_item, *selected_items],
		key=lambda item: safe_float(getattr(item, "pred7DPay", 0)),
		reverse=True,
	)
	market_leader = top_pred_items[0] if top_pred_items else None

	comparison_highlights = []
	for item in selected_items:
		parts = []
		if safe_float(item.payCnt) >= safe_float(main_item.payCnt):
			parts.append("累计支付高于或持平主商品")
		else:
			parts.append("累计支付低于主商品")

		if safe_float(item.payCnt30D) >= safe_float(main_item.payCnt30D):
			parts.append("近30天支付更强")
		else:
			parts.append("近30天支付偏弱")

		if safe_float(item.pred7DPay) >= safe_float(main_item.pred7DPay):
			parts.append("未来7天预测更强")
		else:
			parts.append("未来7天预测偏弱")

		comparison_highlights.append(
			f"{normalize_text(item.title, normalize_text(item.itemId, '竞品'))}：{'；'.join(parts)}。"
		)

	if not comparison_highlights:
		comparison_highlights.append("至少选择 2 个竞品后可得到更聚焦的深度对比结论。")

	if top_similarity_items:
		relationship_insights = [
			"高相似竞品包括："
			+ "、".join(
				f"{normalize_text(item.title, normalize_text(item.itemId, '竞品'))}（相似度 {safe_float(item.similarityScore):.2f}）"
				for item in top_similarity_items
			)
			+ "。",
			f"当前候选竞品平均相似度为 {avg_similarity:.2f}，说明主商品与候选集合存在明确竞争关系。",
		]
	else:
		relationship_insights = [
			"当前未识别到高质量竞品候选。",
			"暂时缺少稳定的相似度关系，建议补充主商品或重试筛选条件。",
		]

	market_position = (
		"主商品在已选对比组中处于预测销量领先位置，适合采取防守型经营策略。"
		if market_leader and normalize_text(market_leader.itemId) == normalize_text(main_item.itemId)
		else (
			f"{normalize_text(market_leader.title, normalize_text(market_leader.itemId, '竞品'))} 在未来7天预测销量上更占优，主商品更适合采取追赶和差异化策略。"
			if market_leader
			else "暂未识别出明确的竞争高位商品。"
		)
	)

	strengths = []
	weaknesses = []

	if safe_float(main_item.pred7DPay) >= max([safe_float(item.pred7DPay) for item in selected_items] or [0.0]):
		strengths.append("主商品未来7天预测销量处于已选对比组前列。")
	else:
		weaknesses.append("主商品未来7天预测销量低于至少一个已选竞品。")

	if safe_float(main_item.payCnt30D) > 0:
		strengths.append("主商品已具备近30天成交基础，可承接进一步运营动作。")
	else:
		weaknesses.append("主商品近30天成交基础偏弱，需要优先补强转化承接。")

	if not strengths:
		strengths.append("主商品与竞品仍处于同一竞争带，具备通过运营优化追平的空间。")

	if not weaknesses:
		weaknesses.append("当前缺少真实价格字段，价格竞争力仍需补充验证。")

	return {
		"summary": (
			f"围绕主商品 {normalize_text(main_item.title, normalize_text(main_item.itemId, '主商品'))}，"
			f"当前已对 {len(selected_items)} 个已选竞品和 {len(candidate_items)} 个候选竞品进行了规则分析，"
			"重点依据相似度、成交表现和销量预测趋势判断竞争态势。"
		),
		"relationshipInsights": relationship_insights,
		"comparisonHighlights": comparison_highlights,
		"marketPosition": market_position,
		"strengths": strengths,
		"weaknesses": weaknesses,
		"strategySuggestions": [
			"优先围绕高相似竞品优化主图、标题卖点和详情页表达，降低横向比价流失。",
			"持续跟踪未来7天预测趋势更强的竞品，拆解其增长来源并制定针对性动作。",
			"在真实价格字段接入前，先聚焦销量、趋势、相似度和竞争位置，不下价格战结论。",
		],
		"llmStatus": "fallback",
	}


def build_polish_prompt(payload: CompetitorAnalysisRequest, fallback_report: dict[str, Any]) -> str:
	main_item = payload.mainItem.model_dump() if payload.mainItem else {}
	selected_items = [item.model_dump() for item in payload.selectedCompetitors[:3]]
	candidate_items = [item.model_dump() for item in payload.candidateSummary[:10]]
	structured_report = {
		"summary": fallback_report.get("summary"),
		"relationshipInsights": fallback_report.get("relationshipInsights"),
		"comparisonHighlights": fallback_report.get("comparisonHighlights"),
		"marketPosition": fallback_report.get("marketPosition"),
		"strengths": fallback_report.get("strengths"),
		"weaknesses": fallback_report.get("weaknesses"),
		"strategySuggestions": fallback_report.get("strategySuggestions"),
	}

	return (
		"你是电商竞品分析顾问，请只对现有规则分析结果做润色和压缩表达，不要推翻原结论，不要新增无法从输入验证的数据结论。"
		"你需要把规则生成的文本改写得更像专业分析报告，表达更自然、结论更聚焦、建议更可执行。"
		"只返回 JSON，不要输出 Markdown，不要输出任何额外解释。"
		"JSON 必须包含字段：summary、relationshipInsights、comparisonHighlights、marketPosition、strengths、weaknesses、strategySuggestions、llmStatus。"
		"relationshipInsights、comparisonHighlights、strengths、weaknesses、strategySuggestions 必须是字符串数组。"
		"summary 控制在 120 字内；每个数组建议 2 到 4 条；保持事实边界，不要编造价格信息。"
		"如果输入里明确说明价格字段缺失，请保留这个边界提醒。"
		f"主商品：{json.dumps(main_item, ensure_ascii=False)}。"
		f"已选竞品：{json.dumps(selected_items, ensure_ascii=False)}。"
		f"候选竞品摘要：{json.dumps(candidate_items, ensure_ascii=False)}。"
		f"价格说明：{normalize_text(payload.priceStatus, '当前缺少价格字段')}。"
		f"规则分析初稿：{json.dumps(structured_report, ensure_ascii=False)}。"
	)


def generate_competitor_analysis_content(payload: CompetitorAnalysisRequest) -> dict[str, Any]:
	fallback_report = fallback_competitor_analysis(payload)
	prompt = build_polish_prompt(payload, fallback_report)

	try:
		client = get_client()
		response = client.chat.completions.create(
			model=get_llm_model(),
			temperature=0.3,
			messages=[
				{"role": "system", "content": "你是严谨的电商竞品分析顾问。"},
				{"role": "user", "content": prompt},
			],
			response_format={"type": "json_object"},
		)
		content = response.choices[0].message.content or "{}"
		data = parse_json_response(content)
		normalized = normalize_analysis_payload(data)

		if not normalized["summary"]:
			return fallback_report

		return normalized
	except Exception as exc:  # noqa: BLE001
		print(f"[ERROR] competitor_analysis LLM call failed: {exc}")
		return fallback_report


def build_competitor_task_response(report: dict[str, Any], task_id: str | None, status: str) -> dict[str, Any]:
	response = dict(report)
	response["success"] = True
	response["enhancementTaskId"] = task_id
	response["enhancementStatus"] = status
	return response


def set_competitor_task_state(task_id: str, **values: Any) -> None:
	with COMPETITOR_ANALYSIS_LOCK:
		current = COMPETITOR_ANALYSIS_TASKS.get(task_id, {})
		current.update(values)
		COMPETITOR_ANALYSIS_TASKS[task_id] = current


def get_competitor_task_state(task_id: str) -> dict[str, Any] | None:
	with COMPETITOR_ANALYSIS_LOCK:
		current = COMPETITOR_ANALYSIS_TASKS.get(task_id)
		return dict(current) if current else None


def run_competitor_analysis_enhancement(task_id: str, payload: CompetitorAnalysisRequest) -> None:
	try:
		enhanced_report = generate_competitor_analysis_content(payload)
		set_competitor_task_state(
			task_id,
			status="completed",
			report=enhanced_report,
			completedAt=datetime.now().isoformat(timespec="seconds"),
		)
	except Exception as exc:  # noqa: BLE001
		set_competitor_task_state(
			task_id,
			status="failed",
			error=str(exc),
			report=fallback_competitor_analysis(payload),
			completedAt=datetime.now().isoformat(timespec="seconds"),
		)


def schedule_competitor_analysis_enhancement(task_id: str, payload: CompetitorAnalysisRequest) -> None:
	worker = threading.Thread(
		target=run_competitor_analysis_enhancement,
		args=(task_id, payload),
		daemon=True,
		name=f"competitor-analysis-enhancement-{task_id}",
	)
	worker.start()


@router.post("/competitor-analysis")
async def competitor_analysis(payload: CompetitorAnalysisRequest) -> dict[str, Any]:
	report = generate_competitor_analysis_content(payload)
	report["success"] = True
	return report


@router.post("/competitor-analysis/start")
async def start_competitor_analysis(payload: CompetitorAnalysisRequest) -> dict[str, Any]:
	task_id = uuid.uuid4().hex
	immediate_report = fallback_competitor_analysis(payload)
	set_competitor_task_state(
		task_id,
		status="pending",
		report=immediate_report,
		startedAt=datetime.now().isoformat(timespec="seconds"),
	)
	schedule_competitor_analysis_enhancement(task_id, payload)
	return build_competitor_task_response(immediate_report, task_id, "pending")


@router.get("/competitor-analysis/tasks/{task_id}")
async def get_competitor_analysis_task(task_id: str) -> dict[str, Any]:
	task_state = get_competitor_task_state(task_id)
	if not task_state:
		return {
			"success": False,
			"enhancementTaskId": task_id,
			"enhancementStatus": "missing",
			"message": "竞品分析增强任务不存在或已过期",
		}

	report = task_state.get("report") or {}
	response = build_competitor_task_response(report, task_id, task_state.get("status") or "pending")
	if task_state.get("error"):
		response["message"] = task_state["error"]
	return response
