import json
import os
import re
import base64
from typing import Any

from fastapi import APIRouter, Query
from pydantic import BaseModel, Field

try:
	from .llm_client import get_client, get_llm_model
except ImportError:
	from llm_client import get_client, get_llm_model


router = APIRouter()
TRANSPORT_B64_PREFIX = "__EMDMP_B64__:"

ITEM_KEYWORDS = ("商品", "销量", "支付", "点击", "转化", "趋势", "预测", "推广", "类目", "卖家")
OPERATIONS_KEYWORDS = ("运营", "复购", "召回", "商家", "merchant", "用户", "人群", "优先级", "任务组")
WRITE_SQL_PATTERN = re.compile(
	r"\b(insert|update|delete|alter|create|drop|truncate|grant|revoke|comment|merge)\b",
	re.IGNORECASE,
)


class ProductQaMessage(BaseModel):
	role: str = "user"
	content: str = ""


class ProductQaItemContext(BaseModel):
	itemId: int | str | None = None
	title: str | None = ""
	category: str | None = ""
	brandId: str | int | None = None
	sellerId: str | int | None = None
	clickCnt: float | int | None = 0
	payCnt: float | int | None = 0
	clickCnt7D: float | int | None = 0
	clickUv7D: float | int | None = 0
	payCnt30D: float | int | None = 0
	pred7DPay: float | int | None = 0
	recommendationScore: float | int | None = 0
	recommendationLevel: str | None = ""
	recommendationReason: str | None = ""


class ProductQaContext(BaseModel):
	anchorDate: str | None = None
	preferredModule: str | None = ""


class ProductQaChatRequest(BaseModel):
	sessionId: str | None = ""
	itemContext: ProductQaItemContext | None = None
	messages: list[ProductQaMessage] = Field(default_factory=list)
	question: str | None = ""
	context: ProductQaContext | None = None


def normalize_text(value: Any, default: str = "") -> str:
	if value is None:
		return default
	text = decode_transport_text(str(value)).strip()
	return text or default


def decode_transport_text(value: str) -> str:
	text = str(value or "")
	if not text.startswith(TRANSPORT_B64_PREFIX):
		return text

	encoded = text[len(TRANSPORT_B64_PREFIX) :].strip()
	if not encoded:
		return ""

	try:
		return base64.b64decode(encoded).decode("utf-8")
	except Exception:  # noqa: BLE001
		return text


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

	result = []
	for item in values:
		if isinstance(item, dict):
			text = normalize_text(item.get("content") or item.get("text") or item.get("title"))
		else:
			text = normalize_text(item)
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


def build_empty_analysis_meta(
	modules: list[str] | None = None,
	tables: list[str] | None = None,
	metrics: list[str] | None = None,
	filters: list[str] | None = None,
	highlights: list[str] | None = None,
	sql_preview: str = "",
	row_count: int = 0,
) -> dict[str, Any]:
	return {
		"modules": modules or [],
		"tables": tables or [],
		"metrics": metrics or [],
		"filters": filters or [],
		"highlights": highlights or [],
		"sqlPreview": sql_preview,
		"rowCount": row_count,
	}


def normalize_analysis_meta(meta: dict[str, Any] | None) -> dict[str, Any]:
	meta = meta or {}
	return build_empty_analysis_meta(
		modules=normalize_text_list(meta.get("modules")),
		tables=normalize_text_list(meta.get("tables")),
		metrics=normalize_text_list(meta.get("metrics")),
		filters=normalize_text_list(meta.get("filters")),
		highlights=normalize_text_list(meta.get("highlights")),
		sql_preview=normalize_text(meta.get("sqlPreview"), ""),
		row_count=int(meta.get("rowCount") or 0),
	)


def normalize_chat_payload(data: dict[str, Any], fallback_payload: dict[str, Any]) -> dict[str, Any]:
	return {
		"sessionId": normalize_text(data.get("sessionId"), fallback_payload["sessionId"]),
		"answer": normalize_text(data.get("answer"), fallback_payload["answer"]),
		"analysisMeta": normalize_analysis_meta(data.get("analysisMeta") or fallback_payload["analysisMeta"]),
		"sources": normalize_text_list(data.get("sources")) or fallback_payload["sources"],
		"suggestedQuestions": normalize_text_list(data.get("suggestedQuestions")) or fallback_payload["suggestedQuestions"],
		"llmStatus": normalize_text(data.get("llmStatus"), fallback_payload["llmStatus"]),
	}


def get_db_settings() -> dict[str, Any]:
	return {
		"host": os.getenv("KINGBASE_HOST", ""),
		"port": int(os.getenv("KINGBASE_PORT", "54321")),
		"database": os.getenv("KINGBASE_DATABASE", ""),
		"user": os.getenv("KINGBASE_USER", ""),
		"password": os.getenv("KINGBASE_PASSWORD", ""),
		"connect_timeout": int(os.getenv("KINGBASE_CONNECT_TIMEOUT_SECONDS", "5")),
	}


def is_db_configured() -> bool:
	settings = get_db_settings()
	return all(
		[
			settings["host"],
			settings["database"],
			settings["user"],
			settings["password"],
		]
	)


def get_db_connection():
	try:
		import psycopg2
	except ImportError as exc:  # noqa: BLE001
		raise RuntimeError("psycopg2-binary is not installed") from exc

	settings = get_db_settings()
	if not is_db_configured():
		raise RuntimeError("Kingbase database connection is not configured")

	return psycopg2.connect(
		host=settings["host"],
		port=settings["port"],
		dbname=settings["database"],
		user=settings["user"],
		password=settings["password"],
		connect_timeout=settings["connect_timeout"],
	)


def execute_readonly_query(sql: str, params: list[Any] | tuple[Any, ...]) -> list[dict[str, Any]]:
	if WRITE_SQL_PATTERN.search(sql):
		raise RuntimeError("Only read-only SQL is allowed")

	connection = get_db_connection()
	try:
		connection.autocommit = True
		with connection.cursor() as cursor:
			cursor.execute("SET default_transaction_read_only = on")
			cursor.execute(sql, params)
			columns = [desc[0] for desc in (cursor.description or [])]
			rows = cursor.fetchall()
		return [dict(zip(columns, row)) for row in rows]
	finally:
		connection.close()


def escape_like_keyword(value: str) -> str:
	return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


def collapse_sql(sql: str) -> str:
	return re.sub(r"\s+", " ", sql).strip()


COMMON_TITLE_TERMS = (
	"秋装",
	"冬装",
	"夏装",
	"春装",
	"女装",
	"男装",
	"连衣裙",
	"羽绒服",
	"外套",
	"衬衫",
	"裤袜",
	"毛衣",
	"针织衫",
	"打底衫",
	"卫衣",
	"短袖",
	"长袖",
)
RECENT_TIME_TERMS = ("最近", "近期", "目前", "当前", "近30天", "近 30 天", "近7天", "近 7 天")


def infer_title_keywords(question: str) -> list[str]:
	matches = []
	for term in COMMON_TITLE_TERMS:
		if term in question and term not in matches:
			matches.append(term)
	return matches[:3]


def infer_sort_metric(question: str) -> str:
	lower_question = question.lower()
	has_recent_hint = any(term in question for term in RECENT_TIME_TERMS)

	if "预测" in question or "未来" in question or "趋势" in question:
		return "pred7DPay"
	if "点击" in question or "流量" in question:
		return "clickCnt7D" if has_recent_hint else "clickCnt"
	if (
		"销量" in question
		or "卖得" in question
		or "卖的" in question
		or "支付" in question
		or "热卖" in question
		or "top" in lower_question
	):
		return "payCnt30D" if has_recent_hint else "payCnt"
	return "payCnt"


def sort_metric_to_column(sort_metric: str) -> str:
	return {
		"payCnt30D": 'coalesce(f.pay_cnt_30d, 0)',
		"clickCnt7D": 'coalesce(f.click_cnt_7d, 0)',
		"pred7DPay": 'coalesce(p.pred_7d_pay, 0)',
		"clickCnt": 'coalesce(s.click_cnt, 0)',
	}.get(sort_metric, 'coalesce(s.pay_cnt, 0)')


def extract_anchor_date(text: str, context: ProductQaContext | None) -> str:
	if normalize_text(context.anchorDate if context else ""):
		return normalize_text(context.anchorDate)

	match = re.search(r"(20\d{2}-\d{2}-\d{2})", text)
	return match.group(1) if match else ""


def extract_anchors(payload: ProductQaChatRequest) -> dict[str, Any]:
	question = normalize_text(payload.question)
	item_context = payload.itemContext or ProductQaItemContext()
	preferred_module = normalize_text(payload.context.preferredModule if payload.context else "")

	item_id = normalize_text(item_context.itemId)
	if not item_id:
		match = re.search(r"(?:商品\s*ID|商品ID|item\s*id|itemId|ID)\s*[:：]?\s*(\d+)", question, re.IGNORECASE)
		if match:
			item_id = match.group(1)
	if not item_id:
		match = re.search(r"\b(\d{4,})\b", question)
		if match:
			item_id = match.group(1)

	title_keyword = normalize_text(item_context.title)
	if not title_keyword:
		match = re.search(r"[“\"]([^”\"]{2,40})[”\"]", question)
		if match:
			title_keyword = normalize_text(match.group(1))
	if not title_keyword:
		inferred_keywords = infer_title_keywords(question)
		if inferred_keywords:
			title_keyword = " ".join(inferred_keywords)

	seller_id = normalize_text(item_context.sellerId)
	if not seller_id:
		match = re.search(r"(?:卖家\s*ID|卖家ID|seller\s*id|sellerId)\s*[:：]?\s*([A-Za-z0-9_-]+)", question, re.IGNORECASE)
		if match:
			seller_id = match.group(1)

	merchant_id = ""
	match = re.search(r"(?:商家\s*ID|商家ID|merchant\s*id|merchantId)\s*[:：]?\s*([A-Za-z0-9_-]+)", question, re.IGNORECASE)
	if match:
		merchant_id = match.group(1)

	user_id = ""
	match = re.search(r"(?:用户\s*ID|用户ID|user\s*id|userId)\s*[:：]?\s*([A-Za-z0-9_-]+)", question, re.IGNORECASE)
	if match:
		user_id = match.group(1)

	category = normalize_text(item_context.category)
	if not category:
		match = re.search(r"(?:类目|品类)\s*[:：]?\s*([^\s，。；,.]{2,20})", question)
		if match:
			category = normalize_text(match.group(1))

	return {
		"question": question,
		"itemId": item_id,
		"titleKeyword": title_keyword,
		"titleKeywords": title_keyword.split() if title_keyword else [],
		"sellerId": seller_id,
		"merchantId": merchant_id,
		"userId": user_id,
		"category": category,
		"anchorDate": extract_anchor_date(question, payload.context),
		"preferredModule": preferred_module,
		"sortMetric": infer_sort_metric(question),
	}


def build_hot_questions(item: ProductQaItemContext | None) -> list[str]:
	title = normalize_text(item.title if item else "", "当前商品")
	return [
		f"{title} 最近的销量和点击表现怎么样？",
		f"{title} 未来 7 天的支付预测是否值得继续推广？",
		f"{title} 当前最大的经营风险是什么？",
		"请结合最近数据给出可执行的运营建议。",
	]


def build_item_detail_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	params: list[Any] = []
	where_clause = ""
	filters = []

	if anchors["itemId"]:
		where_clause = 'b.item_id = %s'
		params.append(int(anchors["itemId"]))
		filters.append(f"itemId = {anchors['itemId']}")
	else:
		like_value = f"%{escape_like_keyword(anchors['titleKeyword'])}%"
		where_clause = "b.title like %s"
		params.append(like_value)
		filters.append(f"title like {anchors['titleKeyword']}")

	anchor_date_filter = ""
	if anchors["anchorDate"]:
		anchor_date_filter = "and t.anchor_date = %s"
		params.append(anchors["anchorDate"])
		params.append(anchors["anchorDate"])
		filters.append(f"anchorDate = {anchors['anchorDate']}")

	sql = f"""
		select
			b.item_id as "itemId",
			b.title as "title",
			b.category as "category",
			b.brand_id as "brandId",
			b.seller_id as "sellerId",
			coalesce(s.click_cnt, 0) as "clickCnt",
			coalesce(s.pay_cnt, 0) as "payCnt",
			coalesce(f.click_cnt_7d, 0) as "clickCnt7D",
			coalesce(f.click_uv_7d, 0) as "clickUv7D",
			coalesce(f.pay_cnt_30d, 0) as "payCnt30D",
			coalesce(f.pay_per_click_7d, 0) as "payPerClick7D",
			coalesce(p.pred_7d_pay, 0) as "pred7DPay"
		from "DataImportModule".rec_tmall_item_base b
		left join "DataImportModule".rec_tmall_item_sales s
			on s.item_id = b.item_id
		left join lateral (
			select
				t.click_cnt_7d,
				t.click_uv_7d,
				t.pay_cnt_30d,
				t.pay_per_click_7d,
				t.anchor_date
			from "SalesPredictModule".rec_tmall_sales_forecast_feature t
			where t.item_id = b.item_id
			{anchor_date_filter}
			order by t.anchor_date desc nulls last
			limit 1
		) f on true
		left join lateral (
			select
				t.pred_7d_pay,
				t.anchor_date
			from "SalesPredictModule".rec_sales_forecast_predictions t
			where t.item_id = b.item_id
			{anchor_date_filter}
			order by t.anchor_date desc nulls last
			limit 1
		) p on true
		where {where_clause}
		order by coalesce(p.pred_7d_pay, 0) desc, coalesce(s.pay_cnt, 0) desc
		limit 10
	"""

	return {
		"planType": "item_detail",
		"modules": ["DataImportModule", "SalesPredictModule"],
		"tables": [
			"DataImportModule.rec_tmall_item_base",
			"DataImportModule.rec_tmall_item_sales",
			"SalesPredictModule.rec_tmall_sales_forecast_feature",
			"SalesPredictModule.rec_sales_forecast_predictions",
		],
		"metrics": ["clickCnt", "payCnt", "clickCnt7D", "clickUv7D", "payCnt30D", "payPerClick7D", "pred7DPay"],
		"filters": filters,
		"sql": sql,
		"params": params,
		"sqlPreview": collapse_sql(sql),
	}


def build_seller_summary_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	sql = """
		select
			b.seller_id as "sellerId",
			b.item_id as "itemId",
			b.title as "title",
			b.category as "category",
			coalesce(s.click_cnt, 0) as "clickCnt",
			coalesce(s.pay_cnt, 0) as "payCnt"
		from "DataImportModule".rec_tmall_item_base b
		left join "DataImportModule".rec_tmall_item_sales s
			on s.item_id = b.item_id
		where cast(b.seller_id as varchar) = %s
		order by coalesce(s.pay_cnt, 0) desc, coalesce(s.click_cnt, 0) desc
		limit 10
	"""
	return {
		"planType": "seller_summary",
		"modules": ["DataImportModule"],
		"tables": [
			"DataImportModule.rec_tmall_item_base",
			"DataImportModule.rec_tmall_item_sales",
		],
		"metrics": ["clickCnt", "payCnt"],
		"filters": [f"sellerId = {anchors['sellerId']}"],
		"sql": sql,
		"params": [anchors["sellerId"]],
		"sqlPreview": collapse_sql(sql),
	}


def build_category_summary_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	sql = """
		select
			b.category as "category",
			b.item_id as "itemId",
			b.title as "title",
			b.seller_id as "sellerId",
			coalesce(s.click_cnt, 0) as "clickCnt",
			coalesce(s.pay_cnt, 0) as "payCnt"
		from "DataImportModule".rec_tmall_item_base b
		left join "DataImportModule".rec_tmall_item_sales s
			on s.item_id = b.item_id
		where b.category like %s
		order by coalesce(s.pay_cnt, 0) desc, coalesce(s.click_cnt, 0) desc
		limit 10
	"""
	return {
		"planType": "category_summary",
		"modules": ["DataImportModule"],
		"tables": [
			"DataImportModule.rec_tmall_item_base",
			"DataImportModule.rec_tmall_item_sales",
		],
		"metrics": ["clickCnt", "payCnt"],
		"filters": [f"category like {anchors['category']}"],
		"sql": sql,
		"params": [f"%{escape_like_keyword(anchors['category'])}%"],
		"sqlPreview": collapse_sql(sql),
	}


def build_title_summary_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	title_keywords = anchors.get("titleKeywords") or [anchors["titleKeyword"]]
	title_keywords = [keyword for keyword in title_keywords if normalize_text(keyword)]
	params: list[Any] = []
	where_clauses = []
	filters = []

	for keyword in title_keywords:
		where_clauses.append("b.title like %s")
		params.append(f"%{escape_like_keyword(keyword)}%")
		filters.append(f"title like {keyword}")

	sort_metric = anchors.get("sortMetric") or "payCnt"
	order_column = sort_metric_to_column(sort_metric)

	sql = f"""
		select
			b.item_id as "itemId",
			b.title as "title",
			b.category as "category",
			b.seller_id as "sellerId",
			coalesce(s.click_cnt, 0) as "clickCnt",
			coalesce(s.pay_cnt, 0) as "payCnt",
			coalesce(f.click_cnt_7d, 0) as "clickCnt7D",
			coalesce(f.pay_cnt_30d, 0) as "payCnt30D",
			coalesce(p.pred_7d_pay, 0) as "pred7DPay"
		from "DataImportModule".rec_tmall_item_base b
		left join "DataImportModule".rec_tmall_item_sales s
			on s.item_id = b.item_id
		left join lateral (
			select
				t.click_cnt_7d,
				t.pay_cnt_30d,
				t.anchor_date
			from "SalesPredictModule".rec_tmall_sales_forecast_feature t
			where t.item_id = b.item_id
			order by t.anchor_date desc nulls last
			limit 1
		) f on true
		left join lateral (
			select
				t.pred_7d_pay,
				t.anchor_date
			from "SalesPredictModule".rec_sales_forecast_predictions t
			where t.item_id = b.item_id
			order by t.anchor_date desc nulls last
			limit 1
		) p on true
		where {" and ".join(where_clauses)}
		order by {order_column} desc, coalesce(s.pay_cnt, 0) desc, coalesce(s.click_cnt, 0) desc
		limit 10
	"""

	return {
		"planType": "title_summary",
		"modules": ["DataImportModule", "SalesPredictModule"],
		"tables": [
			"DataImportModule.rec_tmall_item_base",
			"DataImportModule.rec_tmall_item_sales",
			"SalesPredictModule.rec_tmall_sales_forecast_feature",
			"SalesPredictModule.rec_sales_forecast_predictions",
		],
		"metrics": list(dict.fromkeys(["clickCnt", "payCnt", "clickCnt7D", "payCnt30D", "pred7DPay", sort_metric])),
		"filters": filters,
		"sql": sql,
		"params": params,
		"sqlPreview": collapse_sql(sql),
	}


def build_overview_summary_plan() -> dict[str, Any]:
	sql = """
		select
			(
				select coalesce(sum(m.high_priority_user_count), 0)
				from "BOperationsModule".b_merchant_diagnostics m
			) as "highPriorityUserCount",
			(
				select count(*)
				from "BOperationsModule".b_recall_tasks t
			) as "recallTaskCount"
	"""
	return {
		"planType": "operations_overview",
		"modules": ["BOperationsModule"],
		"tables": [
			"BOperationsModule.b_merchant_diagnostics",
			"BOperationsModule.b_recall_tasks",
		],
		"metrics": ["highPriorityUserCount", "recallTaskCount"],
		"filters": ["overview summary"],
		"sql": sql,
		"params": [],
		"sqlPreview": collapse_sql(sql),
	}


def build_merchant_diagnostics_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	sql = """
		select
			t.merchant_id as "merchantId",
			t.merchant_buyer_count as "merchantBuyerCount",
			t.avg_repurchase_score as "avgRepurchaseScore",
			t.high_priority_user_count as "highPriorityUserCount",
			t.risk_user_count as "riskUserCount",
			t.merchant_tag as "merchantTag"
		from "BOperationsModule".b_merchant_diagnostics t
		where cast(t.merchant_id as varchar) = %s
		order by t.high_priority_user_count desc, t.avg_repurchase_score desc
		limit 10
	"""
	return {
		"planType": "merchant_diagnostics",
		"modules": ["BOperationsModule"],
		"tables": ["BOperationsModule.b_merchant_diagnostics"],
		"metrics": ["merchantBuyerCount", "avgRepurchaseScore", "highPriorityUserCount", "riskUserCount", "merchantTag"],
		"filters": [f"merchantId = {anchors['merchantId']}"],
		"sql": sql,
		"params": [anchors["merchantId"]],
		"sqlPreview": collapse_sql(sql),
	}


def build_user_recall_plan(anchors: dict[str, Any]) -> dict[str, Any]:
	where_clauses = ["1 = 1"]
	params: list[Any] = []
	filters = []

	if anchors["userId"]:
		where_clauses.append("cast(rs.user_id as varchar) = %s")
		params.append(anchors["userId"])
		filters.append(f"userId = {anchors['userId']}")

	if anchors["merchantId"]:
		where_clauses.append("cast(rs.merchant_id as varchar) = %s")
		params.append(anchors["merchantId"])
		filters.append(f"merchantId = {anchors['merchantId']}")

	sql = f"""
		select
			rs.user_id as "userId",
			rs.merchant_id as "merchantId",
			rs.repurchase_score as "repurchaseScore",
			rs.risk_level as "riskLevel",
			rs.priority_level as "priorityLevel",
			rs.score_rank_in_merchant as "scoreRankInMerchant",
			rs.top_reasons as "topReasons",
			us.segment_name as "segmentName",
			rt.recommended_action as "recommendedAction",
			rt.task_group as "taskGroup"
		from "BOperationsModule".b_repurchase_scores rs
		left join "BOperationsModule".b_user_segments us
			on rs.user_id = us.user_id
		left join "BOperationsModule".b_recall_tasks rt
			on rs.user_id = rt.user_id
			and rs.merchant_id = rt.merchant_id
		where {" and ".join(where_clauses)}
		order by rs.priority_level desc, rs.repurchase_score desc
		limit 20
	"""
	return {
		"planType": "user_recall",
		"modules": ["BOperationsModule"],
		"tables": [
			"BOperationsModule.b_repurchase_scores",
			"BOperationsModule.b_user_segments",
			"BOperationsModule.b_recall_tasks",
		],
		"metrics": ["repurchaseScore", "riskLevel", "priorityLevel", "scoreRankInMerchant", "segmentName", "taskGroup"],
		"filters": filters,
		"sql": sql,
		"params": params,
		"sqlPreview": collapse_sql(sql),
	}


def build_query_plan(payload: ProductQaChatRequest) -> dict[str, Any]:
	anchors = extract_anchors(payload)
	question = anchors["question"]
	preferred_module = anchors["preferredModule"].lower()
	operations_like = preferred_module.startswith("boperations") or any(keyword in question.lower() for keyword in OPERATIONS_KEYWORDS)

	if operations_like:
		if "总览" in question or "概览" in question:
			return build_overview_summary_plan()
		if anchors["merchantId"] and not anchors["userId"]:
			return build_merchant_diagnostics_plan(anchors)
		if anchors["merchantId"] or anchors["userId"]:
			return build_user_recall_plan(anchors)

	if anchors["sellerId"]:
		return build_seller_summary_plan(anchors)
	if anchors["category"] and ("类目" in question or "品类" in question):
		return build_category_summary_plan(anchors)
	if anchors["titleKeyword"] and not anchors["itemId"]:
		return build_title_summary_plan(anchors)
	if anchors["itemId"] or anchors["titleKeyword"]:
		return build_item_detail_plan(anchors)

	return {
		"planType": "clarification",
		"modules": [],
		"tables": [],
		"metrics": [],
		"filters": [],
		"sql": "",
		"params": [],
		"sqlPreview": "",
	}


def build_clarification_response(payload: ProductQaChatRequest) -> dict[str, Any]:
	return {
		"sessionId": normalize_text(payload.sessionId, "session-clarify"),
		"answer": "当前问题缺少有效锚点，请补充商品 ID、商品标题关键字、卖家 ID、类目、商家 ID、用户 ID 或时间范围后再试。",
		"analysisMeta": build_empty_analysis_meta(),
		"sources": [],
		"suggestedQuestions": [
			"商品 ID 1001 最近 30 天支付表现如何？",
			"商家 ID M001 当前的复购风险怎么样？",
		],
		"llmStatus": "needs_clarification",
	}


def build_highlights(plan: dict[str, Any], rows: list[dict[str, Any]]) -> list[str]:
	if not rows:
		return []

	plan_type = plan["planType"]
	highlights = []
	if plan_type == "operations_overview":
		row = rows[0]
		highlights.append(f"高优先用户总量 {row.get('highPriorityUserCount', 0)}")
		highlights.append(f"召回任务总量 {row.get('recallTaskCount', 0)}")
		return highlights

	for row in rows[:3]:
		if plan_type in {"item_detail", "seller_summary", "category_summary", "title_summary"}:
			title = normalize_text(row.get("title"), normalize_text(row.get("itemId"), "商品"))
			highlights.append(
				f"{title}：累计支付 {safe_float(row.get('payCnt')):.0f}，累计点击 {safe_float(row.get('clickCnt')):.0f}"
				+ (
					f"，未来 7 天预测支付 {safe_float(row.get('pred7DPay')):.0f}"
					if "pred7DPay" in row
					else ""
				)
			)
		elif plan_type == "merchant_diagnostics":
			highlights.append(
				f"商家 {row.get('merchantId')}：高优先用户 {safe_float(row.get('highPriorityUserCount')):.0f}，复购均分 {safe_float(row.get('avgRepurchaseScore')):.2f}"
			)
		elif plan_type == "user_recall":
			highlights.append(
				f"用户 {row.get('userId')}：复购分 {safe_float(row.get('repurchaseScore')):.2f}，优先级 {normalize_text(row.get('priorityLevel'), '-')}"
			)
	return highlights


def build_analysis_meta(plan: dict[str, Any], rows: list[dict[str, Any]]) -> dict[str, Any]:
	return build_empty_analysis_meta(
		modules=plan.get("modules", []),
		tables=plan.get("tables", []),
		metrics=plan.get("metrics", []),
		filters=plan.get("filters", []),
		highlights=build_highlights(plan, rows),
		sql_preview=plan.get("sqlPreview", ""),
		row_count=len(rows),
	)


def build_data_overview(rows: list[dict[str, Any]]) -> str:
	if not rows:
		return "未查到匹配数据。"

	preview_rows = rows[:5]
	return json.dumps(preview_rows, ensure_ascii=False)


def build_reason_block(reasons: list[str]) -> str:
	cleaned_reasons = [normalize_text(reason) for reason in reasons if normalize_text(reason)]
	if not cleaned_reasons:
		return ""
	return " 原因如下：\n" + "\n".join(f"{index}. {reason}" for index, reason in enumerate(cleaned_reasons, start=1))


def build_richer_answer(summary: str, reasons: list[str]) -> str:
	return normalize_text(summary) + build_reason_block(reasons)


def build_rule_analysis(question: str, plan: dict[str, Any], rows: list[dict[str, Any]], payload: ProductQaChatRequest) -> str:
	if not rows:
		if payload.itemContext:
			return (
				f"当前数据库查询未返回命中记录，但已有上下文显示商品 {normalize_text(payload.itemContext.title, normalize_text(payload.itemContext.itemId, '当前商品'))} "
				f"累计支付 {safe_float(payload.itemContext.payCnt):.0f}，未来 7 天预测支付 {safe_float(payload.itemContext.pred7DPay):.0f}。"
				" 建议补充更精确的锚点或确认数据库配置后再试。"
			)
		return "当前数据库查询未返回匹配结果，请补充更精确的筛选条件后再试。"

	plan_type = plan["planType"]
	if plan_type == "item_detail":
		row = rows[0]
		title = normalize_text(row.get('title'), normalize_text(row.get('itemId'), '当前商品'))
		click_cnt = safe_float(row.get('clickCnt'))
		pay_cnt = safe_float(row.get('payCnt'))
		pay_cnt_30d = safe_float(row.get('payCnt30D'))
		pred_7d_pay = safe_float(row.get('pred7DPay'))
		if "值得" in question and "推广" in question:
			if pay_cnt_30d > 0 and pred_7d_pay > 0:
				return build_richer_answer(
					f"{title} 目前还值得继续推广。",
					[
						f"它当前累计支付已经达到 {pay_cnt:.0f}，说明这款商品已经有比较明确的成交基础，不是完全靠短期流量冲起来的。",
						f"近 30 日支付还有 {pay_cnt_30d:.0f}，说明近期依然能稳定接住一部分订单，热度没有完全掉下去。",
						f"未来 7 天预测支付还有 {pred_7d_pay:.0f}，短期趋势没有明显转弱，更适合继续投放，但建议优先做精细化放量。",
					],
				)
			return build_richer_answer(
				f"{title} 目前不太适合继续加大推广。",
				[
					f"虽然它历史累计支付有 {pay_cnt:.0f}，但更能反映近期承接能力的近 30 日支付只有 {pay_cnt_30d:.0f}，近期动销偏弱。",
					f"未来 7 天预测支付也只有 {pred_7d_pay:.0f}，说明继续砸量未必能带来理想增量，短期扩投风险比较高。",
					"更稳妥的做法是先优化主图、标题和详情页转化，再决定是否重新放大预算。",
				],
			)
		if "风险" in question:
			if pred_7d_pay <= 0:
				return build_richer_answer(
					f"{title} 当前最大的风险是后续成交承接偏弱。",
					[
						f"它虽然已经积累了 {click_cnt:.0f} 次点击和 {pay_cnt:.0f} 笔累计支付，说明历史上并不是没人关注、没人下单。",
						f"但近 30 日支付只有 {pay_cnt_30d:.0f}，未来 7 天预测支付还是 {pred_7d_pay:.0f}，这说明近期转化和后续延续性都比较吃力。",
						"如果现在继续粗放投流，比较容易出现流量花出去了，但订单接不住、ROI 不稳定的问题。",
					],
				)
			return build_richer_answer(
				f"{title} 当前最大的风险是流量有了，但转化稳定性还需要继续观察。",
				[
					f"它目前累计点击 {click_cnt:.0f}、累计支付 {pay_cnt:.0f}，说明商品有一定曝光和成交基础。",
					f"不过近 30 日支付是 {pay_cnt_30d:.0f}，未来 7 天预测支付是 {pred_7d_pay:.0f}，短期表现还没有强到可以非常乐观。",
					"更适合一边维持基础投放，一边紧盯收藏、加购和支付承接，而不是只看流量增长。",
				],
			)
		if "为什么" in question:
			return build_richer_answer(
				f"{title} 最近表现还不错，主要是因为它的成交基础和短期趋势都不算弱。",
				[
					f"从历史积累看，它已经有 {pay_cnt:.0f} 的累计支付和 {click_cnt:.0f} 的累计点击，说明这不是一款完全冷启动的商品。",
					f"从近期表现看，近 30 日支付还有 {pay_cnt_30d:.0f}，说明最近依然有一定成交承接。",
					f"从短期趋势看，未来 7 天预测支付为 {pred_7d_pay:.0f}，后续还有继续维持表现的可能。",
				],
			)
		return build_richer_answer(
			f"围绕商品 {title}，我先给结论：它当前有一定经营基础，但更适合结合近期支付和短期预测一起判断下一步动作。",
			[
				f"当前累计点击 {click_cnt:.0f}、累计支付 {pay_cnt:.0f}，至少说明商品已经形成了基本的流量和成交沉淀。",
				f"近 30 日支付是 {pay_cnt_30d:.0f}，这个指标更能反映近期真实热度，适合用来判断它是不是还在持续卖动。",
				f"未来 7 天预测支付是 {pred_7d_pay:.0f}，可以和近 30 日支付一起看，判断后面该继续放量还是先稳住转化。",
			],
		)
	if plan_type in {"seller_summary", "category_summary", "title_summary"}:
		top_row = rows[0]
		top_title = normalize_text(top_row.get("title"), normalize_text(top_row.get("itemId"), "当前商品"))
		top_pay = safe_float(top_row.get("payCnt"))
		top_recent_pay = safe_float(top_row.get("payCnt30D"))
		top_click = safe_float(top_row.get("clickCnt"))
		top_pred = safe_float(top_row.get("pred7DPay"))
		if any(keyword in question for keyword in ("哪些", "哪几款", "有哪些")):
			top_titles = "、".join(
				normalize_text(row.get("title"), normalize_text(row.get("itemId"), "商品"))
				for row in rows[:3]
			)
			return build_richer_answer(
				f"目前命中的高表现商品有这几款：{top_titles}。",
				[
					f"其中排在最前的是 {top_title}，它当前累计支付 {top_pay:.0f}，说明整体成交规模在本轮命中样本里更靠前。",
					f"它近 30 日支付还有 {top_recent_pay:.0f}，相比只看历史累计值，这个指标更能说明最近一段时间并没有完全掉队。",
					f"如果你接下来要做选品、备货或推广排序，建议先从这几款里继续比较点击、转化和预测趋势。",
				],
			)
		if any(keyword in question for keyword in ("最高", "最好", "哪件", "哪个")):
			return build_richer_answer(
				f"目前命中的候选商品里，销量最高的是 {top_title}。",
				[
					f"它当前累计支付达到 {top_pay:.0f}，在这批候选商品里成交规模最靠前，说明整体卖货能力更强。",
					f"近 30 日支付还有 {top_recent_pay:.0f}，说明它不仅历史累计高，最近一段时间也仍然有持续成交。",
					f"同时它累计点击有 {top_click:.0f}，未来 7 天预测支付还有 {top_pred:.0f}，从流量和短期趋势看都值得优先关注。",
				],
			)
		return build_richer_answer(
			f"这次一共命中了 {len(rows)} 条候选记录，整体来看头部商品已经拉开了一定差距。",
			[
				f"当前排在前面的商品里，{top_title} 的支付表现更突出，累计支付达到 {top_pay:.0f}。",
				f"它近 30 日支付为 {top_recent_pay:.0f}，说明近期表现也并不弱，不只是历史数据好看。",
				"如果你是要做选品、备货或推广优先级判断，建议优先把头部几款当作重点观察对象。",
			],
		)
	if plan_type == "merchant_diagnostics":
		row = rows[0]
		return build_richer_answer(
			f"商家 {normalize_text(row.get('merchantId'), '-')} 目前更适合做分层运营，而不是用同一种方式覆盖所有用户。",
			[
				f"当前高优先用户数有 {safe_float(row.get('highPriorityUserCount')):.0f}，说明值得重点触达的人群规模并不小。",
				f"风险用户数也有 {safe_float(row.get('riskUserCount')):.0f}，这部分人如果不及时召回，后续流失压力会更明显。",
				f"平均复购得分是 {safe_float(row.get('avgRepurchaseScore')):.2f}，建议把高优先用户和风险用户拆开设计不同运营动作。",
			],
		)
	if plan_type == "user_recall":
		return build_richer_answer(
			f"这批用户里，建议你优先处理高优先级、且更有复购潜力的那一批。",
			[
				f"当前一共命中了 {len(rows)} 条用户召回记录，已经能看出明显的优先级分层。",
				"头部样本的召回优先级和复购倾向更高，越早触达，越容易把可转化用户先接回来。",
				"实际执行时可以先集中资源处理头部用户，再把剩余人群做自动化跟进。",
			],
		)
	if plan_type == "operations_overview":
		row = rows[0]
		return build_richer_answer(
			"从当前运营总览看，现阶段更适合按重点人群规模来安排召回节奏。",
			[
				f"高优先用户总量是 {safe_float(row.get('highPriorityUserCount')):.0f}，说明当前最值得优先处理的人群规模已经比较明确。",
				f"召回任务总量是 {safe_float(row.get('recallTaskCount')):.0f}，如果任务数和重点用户规模不匹配，就容易出现资源分散。",
				"更稳妥的做法是先把有限资源投向高优先人群，再决定是否扩到更广的召回范围。",
			],
		)
	return build_richer_answer(
		f"已根据你的问题“{question}”完成数据库查询，并提取了关键数据。",
		[
			"目前已经有了可用结果，可以继续围绕这批结果追问更细的问题。",
			"如果你希望我直接给出经营建议、风险判断或推广优先级，我可以在当前查询结果基础上继续往下分析。",
		],
	)


def build_analysis_prompt(question: str, plan: dict[str, Any], rows: list[dict[str, Any]]) -> str:
	return (
		"你是企业内部数据分析助手。请严格基于数据库查询结果回答，不要编造未出现的数据。"
		"回答需要简洁、明确，并给出分析结论。"
		f" 问题：{question}。"
		f" 查询类型：{plan.get('planType')}。"
		f" 命中模块：{json.dumps(plan.get('modules', []), ensure_ascii=False)}。"
		f" 命中表：{json.dumps(plan.get('tables', []), ensure_ascii=False)}。"
		f" 数据预览：{build_data_overview(rows)}。"
	)


def format_item_label(item_id: Any, title: Any, default: str = "当前商品") -> str:
	item_id_text = normalize_text(item_id)
	title_text = normalize_text(title)
	if item_id_text and title_text:
		return f"商品ID {item_id_text} {title_text}"
	if title_text:
		return title_text
	if item_id_text:
		return f"商品ID {item_id_text}"
	return default


def contains_any_keyword(text: str, keywords: tuple[str, ...]) -> bool:
	return any(keyword in text for keyword in keywords)


def build_highlights(plan: dict[str, Any], rows: list[dict[str, Any]]) -> list[str]:
	if not rows:
		return []

	plan_type = plan["planType"]
	highlights = []
	if plan_type == "operations_overview":
		row = rows[0]
		highlights.append(f"高优先用户总量 {row.get('highPriorityUserCount', 0)}")
		highlights.append(f"召回任务总量 {row.get('recallTaskCount', 0)}")
		return highlights

	for row in rows[:3]:
		if plan_type in {"item_detail", "seller_summary", "category_summary", "title_summary"}:
			item_label = format_item_label(row.get("itemId"), row.get("title"), "商品")
			summary = (
				f"{item_label}：累计支付 {safe_float(row.get('payCnt')):.0f}，累计点击 {safe_float(row.get('clickCnt')):.0f}"
			)
			if "pred7DPay" in row:
				summary += f"，未来 7 天预测支付 {safe_float(row.get('pred7DPay')):.0f}"
			highlights.append(summary)
		elif plan_type == "merchant_diagnostics":
			highlights.append(
				f"商家 {row.get('merchantId')}：高优先用户 {safe_float(row.get('highPriorityUserCount')):.0f}，复购均分 {safe_float(row.get('avgRepurchaseScore')):.2f}"
			)
		elif plan_type == "user_recall":
			highlights.append(
				f"用户 {row.get('userId')}：复购分 {safe_float(row.get('repurchaseScore')):.2f}，优先级 {normalize_text(row.get('priorityLevel'), '-')}"
			)
	return highlights


def build_rule_analysis(question: str, plan: dict[str, Any], rows: list[dict[str, Any]], payload: ProductQaChatRequest) -> str:
	question = normalize_text(question)
	if not rows:
		if payload.itemContext:
			item_label = format_item_label(payload.itemContext.itemId, payload.itemContext.title)
			return (
				f"当前数据库查询暂时没有搜索到记录，但上下文里已有 {item_label} 的基础信息："
				f"累计支付 {safe_float(payload.itemContext.payCnt):.0f}，未来 7 天预测支付 {safe_float(payload.itemContext.pred7DPay):.0f}。"
				"建议补充更精确的商品 ID、标题关键字或时间范围后再试。"
			)
		return "当前数据库查询暂时没有搜索到匹配结果，请补充更精确的筛选条件后再试。"

	plan_type = plan["planType"]
	if plan_type == "item_detail":
		row = rows[0]
		item_label = format_item_label(row.get("itemId"), row.get("title"))
		click_cnt = safe_float(row.get("clickCnt"))
		pay_cnt = safe_float(row.get("payCnt"))
		pay_cnt_30d = safe_float(row.get("payCnt30D"))
		pred_7d_pay = safe_float(row.get("pred7DPay"))
		if "值得" in question and "推广" in question:
			if pay_cnt_30d > 0 and pred_7d_pay > 0:
				return build_richer_answer(
					f"{item_label} 目前还值得继续推广。",
					[
						f"它当前累计支付达到 {pay_cnt:.0f}，说明这款商品已经有比较明确的成交基础。",
						f"近 30 日支付还有 {pay_cnt_30d:.0f}，说明最近仍然有持续成交，不只是历史数据好看。",
						f"未来 7 天预测支付还有 {pred_7d_pay:.0f}，短期趋势没有明显转弱，更适合继续投放。",
					],
				)
			return build_richer_answer(
				f"{item_label} 目前不太适合继续加大推广。",
				[
					f"虽然它历史累计支付有 {pay_cnt:.0f}，但近 30 日支付只有 {pay_cnt_30d:.0f}，近期动销偏弱。",
					f"未来 7 天预测支付也只有 {pred_7d_pay:.0f}，继续扩投的风险会更高。",
					"更稳妥的做法是先优化主图、标题和详情页转化，再决定是否重新放大预算。",
				],
			)
		if "风险" in question:
			if pred_7d_pay <= 0:
				return build_richer_answer(
					f"{item_label} 当前最大的风险是后续成交承接偏弱。",
					[
						f"它已经积累了 {click_cnt:.0f} 次点击和 {pay_cnt:.0f} 笔累计支付，说明并不是完全没人关注。",
						f"但近 30 日支付只有 {pay_cnt_30d:.0f}，未来 7 天预测支付还是 {pred_7d_pay:.0f}，近期延续性偏弱。",
						"如果现在继续粗放投流，容易出现流量花出去了，但订单接不住的情况。",
					],
				)
			return build_richer_answer(
				f"{item_label} 当前最大的风险是流量有了，但转化稳定性还需要继续观察。",
				[
					f"它目前累计点击 {click_cnt:.0f}、累计支付 {pay_cnt:.0f}，说明商品有一定曝光和成交基础。",
					f"不过近 30 日支付是 {pay_cnt_30d:.0f}，未来 7 天预测支付是 {pred_7d_pay:.0f}，短期表现还没有强到可以非常乐观。",
					"更适合一边维持基础投放，一边紧盯收藏、加购和支付承接，而不是只看流量增长。",
				],
			)
		if "为什么" in question:
			return build_richer_answer(
				f"{item_label} 最近表现还不错，主要是因为它的成交基础和短期趋势都不算弱。",
				[
					f"从历史积累看，它已经有 {pay_cnt:.0f} 的累计支付和 {click_cnt:.0f} 的累计点击。",
					f"从近期表现看，近 30 日支付还有 {pay_cnt_30d:.0f}，说明最近依然有一定成交承接。",
					f"从短期趋势看，未来 7 天预测支付为 {pred_7d_pay:.0f}，后续还有继续维持表现的可能。",
				],
			)
		return build_richer_answer(
			f"围绕 {item_label}，我先给结论：它当前有一定经营基础，但更适合结合近期支付和短期预测一起判断下一步动作。",
			[
				f"当前累计点击 {click_cnt:.0f}、累计支付 {pay_cnt:.0f}，说明商品已经形成了基础流量和成交沉淀。",
				f"近 30 日支付是 {pay_cnt_30d:.0f}，这个指标更能反映近期真实热度。",
				f"未来 7 天预测支付是 {pred_7d_pay:.0f}，可以和近 30 日支付一起看，判断后面该继续放量还是先稳住转化。",
			],
		)

	if plan_type in {"seller_summary", "category_summary", "title_summary"}:
		top_row = rows[0]
		top_label = format_item_label(top_row.get("itemId"), top_row.get("title"))
		top_pay = safe_float(top_row.get("payCnt"))
		top_recent_pay = safe_float(top_row.get("payCnt30D"))
		top_click = safe_float(top_row.get("clickCnt"))
		top_pred = safe_float(top_row.get("pred7DPay"))
		if contains_any_keyword(question, ("哪些", "哪几款", "有哪些")):
			top_labels = "、".join(format_item_label(row.get("itemId"), row.get("title"), "商品") for row in rows[:3])
			return build_richer_answer(
				f"目前搜索到的高表现商品有这几款：{top_labels}。",
				[
					f"其中排在最前的是 {top_label}，它当前累计支付 {top_pay:.0f}，说明整体成交规模更靠前。",
					f"它近 30 日支付还有 {top_recent_pay:.0f}，说明最近一段时间并没有掉队。",
					"如果你接下来要做选品、备货或推广排序，建议先从这几款里继续比较点击、转化和预测趋势。",
				],
			)
		if contains_any_keyword(question, ("最高", "最好", "哪件", "哪个")):
			return build_richer_answer(
				f"目前搜索到的候选商品里，销量最高的是 {top_label}。",
				[
					f"它当前累计支付达到 {top_pay:.0f}，在这批候选商品里成交规模最靠前。",
					f"近 30 日支付还有 {top_recent_pay:.0f}，说明它不仅历史累计高，最近也仍然有持续成交。",
					f"同时它累计点击有 {top_click:.0f}，未来 7 天预测支付还有 {top_pred:.0f}，从流量和短期趋势看都值得优先关注。",
				],
			)
		return build_richer_answer(
			f"这次一共搜索到 {len(rows)} 条候选记录，整体来看头部商品已经拉开了一定差距。",
			[
				f"当前排在前面的商品里，{top_label} 的支付表现更突出，累计支付达到 {top_pay:.0f}。",
				f"它近 30 日支付为 {top_recent_pay:.0f}，说明近期表现也并不弱。",
				"如果你是要做选品、备货或推广优先级判断，建议优先把头部几款当作重点观察对象。",
			],
		)

	if plan_type == "merchant_diagnostics":
		row = rows[0]
		return build_richer_answer(
			f"商家 {normalize_text(row.get('merchantId'), '-')} 目前更适合做分层运营，而不是用同一种方式覆盖所有用户。",
			[
				f"当前高优先用户数有 {safe_float(row.get('highPriorityUserCount')):.0f}，说明值得重点触达的人群规模并不小。",
				f"风险用户数也有 {safe_float(row.get('riskUserCount')):.0f}，这部分人如果不及时召回，后续流失压力会更明显。",
				f"平均复购得分是 {safe_float(row.get('avgRepurchaseScore')):.2f}，建议把高优先用户和风险用户拆开设计不同运营动作。",
			],
		)

	if plan_type == "user_recall":
		return build_richer_answer(
			f"这批用户里，建议你优先处理高优先级、且更有复购潜力的那一批。",
			[
				f"当前一共搜索到 {len(rows)} 条用户召回记录，已经能看出明显的优先级分层。",
				"头部样本的召回优先级和复购倾向更高，越早触达，越容易把可转化用户先接回来。",
				"实际执行时可以先集中资源处理头部用户，再把剩余人群做自动化跟进。",
			],
		)

	if plan_type == "operations_overview":
		row = rows[0]
		return build_richer_answer(
			"从当前运营总览看，现阶段更适合按重点人群规模来安排召回节奏。",
			[
				f"高优先用户总量是 {safe_float(row.get('highPriorityUserCount')):.0f}，说明当前最值得优先处理的人群规模已经比较明确。",
				f"召回任务总量是 {safe_float(row.get('recallTaskCount')):.0f}，如果任务数和重点用户规模不匹配，就容易出现资源分散。",
				"更稳妥的做法是先把有限资源投向高优先人群，再决定是否扩到更广的召回范围。",
			],
		)

	return build_richer_answer(
		f"已根据你的问题“{question}”完成数据库查询，并整理出可继续追问的结果。",
		[
			"目前已经有了可用结果，可以继续围绕这批结果追问更细的问题。",
			"如果你希望我直接给出经营建议、风险判断或推广优先级，我可以在当前查询结果基础上继续往下分析。",
		],
	)


def build_analysis_prompt(question: str, plan: dict[str, Any], rows: list[dict[str, Any]]) -> str:
	return (
		"你是企业内部数据分析助手。请严格基于数据库查询结果回答，不要编造未出现的数据。"
		"回答需要简洁、明确，并给出分析结论。"
		f" 问题：{question}。"
		f" 查询类型：{plan.get('planType')}。"
		f" 搜索到模块：{json.dumps(plan.get('modules', []), ensure_ascii=False)}。"
		f" 搜索到表：{json.dumps(plan.get('tables', []), ensure_ascii=False)}。"
		f" 数据预览：{build_data_overview(rows)}。"
	)


def call_llm_for_analysis(question: str, plan: dict[str, Any], rows: list[dict[str, Any]]) -> str:
	client = get_client()
	response = client.chat.completions.create(
		model=get_llm_model(),
		temperature=0.2,
		messages=[
			{"role": "system", "content": "你是严谨的企业内部数据分析助手。"},
			{"role": "user", "content": build_analysis_prompt(question, plan, rows)},
		],
	)
	return normalize_text(response.choices[0].message.content, "")


def build_db_unavailable_response(payload: ProductQaChatRequest, plan: dict[str, Any]) -> dict[str, Any]:
	return {
		"sessionId": normalize_text(payload.sessionId, "session-fallback"),
		"answer": build_rule_analysis(normalize_text(payload.question), plan, [], payload),
		"analysisMeta": build_analysis_meta(plan, []),
		"sources": plan.get("tables", []),
		"suggestedQuestions": build_hot_questions(payload.itemContext),
		"llmStatus": "fallback",
	}


def generate_chat_content(payload: ProductQaChatRequest) -> dict[str, Any]:
	question = normalize_text(payload.question)
	plan = build_query_plan(payload)

	if plan["planType"] == "clarification":
		return build_clarification_response(payload)

	try:
		rows = execute_readonly_query(plan["sql"], plan["params"])
	except Exception as exc:  # noqa: BLE001
		print(f"[ERROR] product_qa database query failed: {exc}")
		return build_db_unavailable_response(payload, plan)

	analysis_meta = build_analysis_meta(plan, rows)
	if not rows:
		return {
			"sessionId": normalize_text(payload.sessionId, "session-no-data"),
			"answer": "当前问题对应的数据查询没有返回结果，请更换锚点或缩小筛选条件后重试。",
			"analysisMeta": analysis_meta,
			"sources": plan.get("tables", []),
			"suggestedQuestions": build_hot_questions(payload.itemContext),
			"llmStatus": "no_data",
		}

	try:
		answer = call_llm_for_analysis(question, plan, rows)
		if not answer:
			raise RuntimeError("empty llm answer")
		return {
			"sessionId": normalize_text(payload.sessionId, "session-success"),
			"answer": answer,
			"analysisMeta": analysis_meta,
			"sources": plan.get("tables", []),
			"suggestedQuestions": build_hot_questions(payload.itemContext),
			"llmStatus": "success",
		}
	except Exception as exc:  # noqa: BLE001
		print(f"[ERROR] product_qa analysis LLM call failed: {exc}")
		return {
			"sessionId": normalize_text(payload.sessionId, "session-fallback"),
			"answer": build_rule_analysis(question, plan, rows, payload),
			"analysisMeta": analysis_meta,
			"sources": plan.get("tables", []),
			"suggestedQuestions": build_hot_questions(payload.itemContext),
			"llmStatus": "fallback",
		}


@router.get("/product-qa/hot-questions")
async def product_qa_hot_questions(
	item_id: str | None = Query(default=None, alias="itemId"),
	title: str | None = Query(default=None),
	category: str | None = Query(default=None),
) -> dict[str, Any]:
	item = ProductQaItemContext(itemId=item_id, title=title, category=category)
	return {
		"success": True,
		"questions": build_hot_questions(item),
	}


@router.post("/product-qa/chat")
async def product_qa_chat(payload: ProductQaChatRequest) -> dict[str, Any]:
	result = generate_chat_content(payload)
	result["success"] = True
	return result
