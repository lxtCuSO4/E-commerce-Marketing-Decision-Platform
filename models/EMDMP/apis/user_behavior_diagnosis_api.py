import json
import threading
import uuid
from datetime import datetime
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel, Field

try:
	from .llm_client import get_client, get_llm_model
except ImportError:
	from llm_client import get_client, get_llm_model


router = APIRouter()
DIAGNOSIS_ENHANCEMENT_TASKS: dict[str, dict[str, Any]] = {}
DIAGNOSIS_ENHANCEMENT_LOCK = threading.Lock()


class BehaviorQuery(BaseModel):
	keyword: str | None = ""
	itemId: str | int | None = None
	sellerId: str | int | None = None
	category: str | None = ""
	anchorDate: str | None = None
	windowDays: int | None = 7
	behaviorTag: str | None = ""


class BehaviorSummary(BaseModel):
	matchedCount: int | None = 0
	avgClickCnt: float | int | None = 0
	avgPayPerClick: float | int | None = 0
	avgCartPerClick: float | int | None = 0
	highRiskCount: int | None = 0
	highPotentialCount: int | None = 0
	message: str | None = ""


class BehaviorRecord(BaseModel):
	viewType: str | None = "item"
	itemId: int | None = None
	sellerId: str | int | None = None
	title: str | None = ""
	category: str | None = ""
	itemCount: int | None = 0
	clickCnt: float | int | None = 0
	cartCnt: float | int | None = 0
	payCnt: float | int | None = 0
	clickCntDelta7D: float | int | None = 0
	payCntDelta7D: float | int | None = 0
	behaviorScore: float | int | None = 0
	behaviorLevel: str | None = ""
	behaviorTags: list[str] = Field(default_factory=list)
	avgCartPerClick: float | int | None = 0
	avgPayPerClick: float | int | None = 0
	highRiskCount: int | None = 0
	highPotentialCount: int | None = 0


class BehaviorDiagnosisRequest(BaseModel):
	viewType: str | None = "item"
	query: BehaviorQuery = Field(default_factory=BehaviorQuery)
	summary: BehaviorSummary = Field(default_factory=BehaviorSummary)
	records: list[BehaviorRecord] = Field(default_factory=list)
	enhancementTaskId: str | None = None


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


def normalize_sections(values: Any) -> list[dict[str, str]]:
	if not isinstance(values, list):
		return []

	sections = []
	for index, item in enumerate(values):
		if not isinstance(item, dict):
			continue
		title = normalize_text(item.get("title"), f"诊断章节 {index + 1}")
		content = normalize_text(item.get("content") or item.get("text"), "")
		if title and content:
			sections.append({"title": title, "content": content})
	return sections


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


def normalize_payload(data: dict[str, Any], fallback_payload: dict[str, Any]) -> dict[str, Any]:
	sections = normalize_sections(data.get("analysisSections")) or fallback_payload["analysisSections"]
	recommendations = normalize_text_list(data.get("recommendations")) or fallback_payload["recommendations"]
	risk_alerts = normalize_text_list(data.get("riskAlerts")) or fallback_payload["riskAlerts"]

	llm_status = normalize_text(data.get("llmStatus"), "success").lower()
	if llm_status not in {"fallback", "error"}:
		llm_status = "success"

	return {
		"title": normalize_text(data.get("title"), fallback_payload["title"]),
		"summary": normalize_text(data.get("summary"), fallback_payload["summary"]),
		"analysisSections": sections,
		"recommendations": recommendations,
		"riskAlerts": risk_alerts,
		"llmStatus": llm_status,
	}


def fallback_diagnosis(payload: BehaviorDiagnosisRequest) -> dict[str, Any]:
	view_type = normalize_text(payload.viewType, "item")
	matched_count = int(payload.summary.matchedCount or len(payload.records))
	avg_click = float(payload.summary.avgClickCnt or 0)
	avg_pay_per_click = float(payload.summary.avgPayPerClick or 0)
	avg_cart_per_click = float(payload.summary.avgCartPerClick or 0)
	high_risk_count = int(payload.summary.highRiskCount or 0)
	high_potential_count = int(payload.summary.highPotentialCount or 0)

	top_records = payload.records[:5]
	record_summary = "；".join(
		[
			(
				f"{normalize_text(item.title, str(item.itemId or item.sellerId or '-'))}"
				f"（点击 {float(item.clickCnt or 0):.0f}、加购 {float(item.cartCnt or 0):.0f}、支付 {float(item.payCnt or 0):.0f}、"
				f"点击变化 {float(item.clickCntDelta7D or 0):.2f}、支付变化 {float(item.payCntDelta7D or 0):.2f}）"
			)
			for item in top_records
		]
	) or "暂无可展示的代表样本。"

	if view_type == "merchant":
		title = "商家行为诊断摘要"
		summary = (
			f"当前商家视角共纳入 {matched_count} 个商家，平均点击为 {avg_click:.0f}，"
			f"平均支付转化率为 {avg_pay_per_click:.4f}，高风险商家数为 {high_risk_count}。"
			"诊断重点是识别高风险商家的异常行为结构、流量承接断点与支付转化偏弱问题。"
		)
		sections = [
			{
				"title": "异常概览",
				"content": (
					f"当前结果集聚焦商家整体行为结构，既关注商家下商品规模，也关注高风险商品数与异常行为分布。"
					f"当前高潜力商品数为 {high_potential_count}，可作为后续观察样本，但本次诊断不对经营优先级做判断。"
				),
			},
			{
				"title": "阻塞判断",
				"content": f"当前最需要关注的是高风险对象占比与支付转化效率，代表样本如下：{record_summary}",
			},
			{
				"title": "成因拆解",
				"content": (
					"如果商家整体点击不低但支付转化偏弱，通常说明商品页表达、价格承接、活动策略或流量结构存在问题。"
					"如果高风险商品数量偏多，则更可能是商家整体选品与详情页运营策略需要系统调整。"
				),
			},
			{
				"title": "优先动作",
				"content": "建议先锁定高风险商家中的头部流量商品做漏斗排查，再按点击、加购、支付三个节点逐项核查承接断点。",
			},
		]
		recommendations = [
			"优先排查高风险商家内的头部流量商品，确认详情页与价格承接问题。",
			"按商家维度拆开流量异常、加购异常和支付异常，避免把不同问题混成一个结论。",
			"按商家维度跟踪点击变化与支付变化的背离情况，及早发现流量失真。",
		]
		risk_alerts = [
			"高风险商家占比偏高时，说明问题不只是单品偶发，而是商家整体经营结构问题。",
			"如果支付变化持续弱于点击变化，后续可能出现流量浪费与投放回报下降。",
		]
	else:
		title = "商品行为诊断摘要"
		summary = (
			f"当前商品视角共纳入 {matched_count} 个商品，平均点击为 {avg_click:.0f}，"
			f"平均加购转化率为 {avg_cart_per_click:.4f}，平均支付转化率为 {avg_pay_per_click:.4f}。"
			f"当前高风险商品数为 {high_risk_count}，需要优先关注高点击低支付、高加购低支付与转化恶化等异常链路。"
		)
		sections = [
			{
				"title": "异常概览",
				"content": f"当前商品行为诊断重点围绕点击、加购、支付三环节展开，代表样本如下：{record_summary}",
			},
			{
				"title": "阻塞判断",
				"content": "当前最关键的是识别高点击低支付、高加购低支付与流量下滑等典型问题商品，并区分是流量问题还是转化问题。",
			},
			{
				"title": "成因拆解",
				"content": (
					"如果点击较高但支付偏低，通常说明标题和流量入口有效，但详情页说服力、价格机制、评价或库存承接不足。"
					"如果加购后仍未支付，则更可能是价格、促销或决策成本问题。"
				),
			},
			{
				"title": "排查动作",
				"content": "建议先按流量入口、详情页表达、价格促销、库存履约四个方向拆解排查，定位具体阻塞点后再验证修复动作。",
			},
		]
		recommendations = [
			"优先定位高点击低支付商品，排查详情页表达、价格与促销承接。",
			"针对高加购低支付商品，检查是否存在价格敏感、库存或履约顾虑。",
			"对支付变化明显弱于点击变化的商品做逐日复盘，确认异常是短期波动还是持续恶化。",
		]
		risk_alerts = [
			"高点击但支付转化长期偏低，会持续消耗流量效率。",
			"支付变化弱于点击变化时，说明流量质量或页面承接正在恶化。",
		]

	return {
		"title": title,
		"summary": summary,
		"analysisSections": sections,
		"recommendations": recommendations,
		"riskAlerts": risk_alerts,
		"llmStatus": "fallback",
	}


def build_polish_prompt(payload: BehaviorDiagnosisRequest, fallback_payload: dict[str, Any]) -> str:
	compact_records = []
	for item in payload.records[:10]:
		compact_records.append(
			{
				"viewType": item.viewType,
				"itemId": item.itemId,
				"sellerId": item.sellerId,
				"title": item.title,
				"category": item.category,
				"itemCount": item.itemCount,
				"clickCnt": item.clickCnt,
				"cartCnt": item.cartCnt,
				"payCnt": item.payCnt,
				"clickCntDelta7D": item.clickCntDelta7D,
				"payCntDelta7D": item.payCntDelta7D,
				"behaviorScore": item.behaviorScore,
				"behaviorLevel": item.behaviorLevel,
				"behaviorTags": item.behaviorTags,
				"avgCartPerClick": item.avgCartPerClick,
				"avgPayPerClick": item.avgPayPerClick,
				"highRiskCount": item.highRiskCount,
				"highPotentialCount": item.highPotentialCount,
			}
		)

	structured_report = {
		"title": fallback_payload.get("title"),
		"summary": fallback_payload.get("summary"),
		"analysisSections": fallback_payload.get("analysisSections"),
		"recommendations": fallback_payload.get("recommendations"),
		"riskAlerts": fallback_payload.get("riskAlerts"),
	}

	return (
		"你是电商运营行为诊断顾问，请只对现有规则诊断结果做润色和压缩表达，不要推翻原结论，不要新增无法从输入验证的数据结论。"
		"你需要把规则生成的文本改写得更像专业诊断报告，表达更自然、结论更聚焦、建议更可执行。"
		"只返回 JSON，不要输出 Markdown，不要输出额外解释。"
		"JSON 必须包含 title、summary、analysisSections、recommendations、riskAlerts、llmStatus。"
		"analysisSections 保持 4 个左右的章节，每个章节包含 title 和 content。"
		"章节标题优先使用“异常概览、阻塞判断、成因拆解、排查动作”这一类诊断命名。"
		"recommendations 输出 3 到 5 条；riskAlerts 输出 2 到 4 条。"
		"内容必须严格依赖输入中的点击、加购、支付、7日变化、行为标签与风险规模，不能编造额外事实。"
		"输出要明确偏向行为异常诊断、漏斗阻塞判断、风险信号与排查动作。"
		"不要使用推荐度、优先运营、资源位、经营价值、商业机会、重点培育、经营优先级等商业分析报告口径。"
		f"视角：{payload.viewType or 'item'}。"
		f"筛选条件：{json.dumps(payload.query.model_dump(), ensure_ascii=False)}。"
		f"汇总指标：{json.dumps(payload.summary.model_dump(), ensure_ascii=False)}。"
		f"样本记录：{json.dumps(compact_records, ensure_ascii=False)}。"
		f"规则诊断初稿：{json.dumps(structured_report, ensure_ascii=False)}。"
	)


def generate_behavior_diagnosis_content(payload: BehaviorDiagnosisRequest) -> dict[str, Any]:
	fallback_payload = fallback_diagnosis(payload)
	prompt = build_polish_prompt(payload, fallback_payload)

	try:
		client = get_client()
		response = client.chat.completions.create(
			model=get_llm_model(),
			temperature=0.3,
			messages=[
				{"role": "system", "content": "你是严谨的电商运营行为诊断顾问。"},
				{"role": "user", "content": prompt},
			],
			response_format={"type": "json_object"},
		)
		content = response.choices[0].message.content or "{}"
		data = parse_json_response(content)
		normalized = normalize_payload(data, fallback_payload)
		if not normalized["summary"]:
			return fallback_payload
		return normalized
	except Exception as exc:  # noqa: BLE001
		print(f"[ERROR] generate_behavior_diagnosis_content LLM call failed: {exc}")
		return fallback_payload


def build_diagnosis_task_response(report: dict[str, Any], task_id: str | None, status: str) -> dict[str, Any]:
	response = dict(report)
	response["success"] = True
	response["enhancementTaskId"] = task_id
	response["enhancementStatus"] = status
	return response


def set_diagnosis_task_state(task_id: str, **values: Any) -> None:
	with DIAGNOSIS_ENHANCEMENT_LOCK:
		current = DIAGNOSIS_ENHANCEMENT_TASKS.get(task_id, {})
		current.update(values)
		DIAGNOSIS_ENHANCEMENT_TASKS[task_id] = current


def get_diagnosis_task_state(task_id: str) -> dict[str, Any] | None:
	with DIAGNOSIS_ENHANCEMENT_LOCK:
		current = DIAGNOSIS_ENHANCEMENT_TASKS.get(task_id)
		return dict(current) if current else None


def run_diagnosis_enhancement(task_id: str, payload: BehaviorDiagnosisRequest) -> None:
	try:
		enhanced_report = generate_behavior_diagnosis_content(payload)
		set_diagnosis_task_state(
			task_id,
			status="completed",
			report=enhanced_report,
			completedAt=datetime.now().isoformat(timespec="seconds"),
		)
	except Exception as exc:  # noqa: BLE001
		set_diagnosis_task_state(
			task_id,
			status="failed",
			error=str(exc),
			report=fallback_diagnosis(payload),
			completedAt=datetime.now().isoformat(timespec="seconds"),
		)


def schedule_diagnosis_enhancement(task_id: str, payload: BehaviorDiagnosisRequest) -> None:
	worker = threading.Thread(
		target=run_diagnosis_enhancement,
		args=(task_id, payload),
		daemon=True,
		name=f"user-behavior-diagnosis-enhancement-{task_id}",
	)
	worker.start()


@router.post("/generate-user-behavior-diagnosis")
async def generate_user_behavior_diagnosis(payload: BehaviorDiagnosisRequest) -> dict[str, Any]:
	result = generate_behavior_diagnosis_content(payload)
	result["success"] = True
	return result


@router.post("/generate-user-behavior-diagnosis/start")
async def start_generate_user_behavior_diagnosis(payload: BehaviorDiagnosisRequest) -> dict[str, Any]:
	task_id = uuid.uuid4().hex
	immediate_report = fallback_diagnosis(payload)
	set_diagnosis_task_state(
		task_id,
		status="pending",
		report=immediate_report,
		startedAt=datetime.now().isoformat(timespec="seconds"),
	)
	schedule_diagnosis_enhancement(task_id, payload)
	return build_diagnosis_task_response(immediate_report, task_id, "pending")


@router.get("/generate-user-behavior-diagnosis/tasks/{task_id}")
async def get_generate_user_behavior_diagnosis_task(task_id: str) -> dict[str, Any]:
	task_state = get_diagnosis_task_state(task_id)
	if not task_state:
		return {
			"success": False,
			"enhancementTaskId": task_id,
			"enhancementStatus": "missing",
			"message": "用户行为诊断增强任务不存在或已过期",
		}

	report = task_state.get("report") or {}
	response = build_diagnosis_task_response(report, task_id, task_state.get("status") or "pending")
	if task_state.get("error"):
		response["message"] = task_state["error"]
	return response
