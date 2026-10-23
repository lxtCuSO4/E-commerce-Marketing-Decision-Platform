import json
import os
import threading
import time
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Request
from pydantic import BaseModel, Field
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.cidfonts import UnicodeCIDFont
from reportlab.pdfgen import canvas

from .llm_client import get_client, get_llm_model


router = APIRouter()
PDF_DIR = Path(__file__).resolve().parents[4] / "report_generated"
PDF_DIR.mkdir(parents=True, exist_ok=True)
PDF_FONT = "STSong-Light"
PAGE_WIDTH, PAGE_HEIGHT = A4
LEFT_MARGIN = 50
RIGHT_MARGIN = 50
TOP_MARGIN = 800
BOTTOM_MARGIN = 60
CONTENT_WIDTH = PAGE_WIDTH - LEFT_MARGIN - RIGHT_MARGIN
SECTION_FILL = colors.HexColor("#F8FAFC")
SECTION_STROKE = colors.HexColor("#D7E3F4")
HEADER_FILL = colors.HexColor("#E8F1FB")
HEADER_ACCENT = colors.HexColor("#1D4ED8")
TEXT_PRIMARY = colors.HexColor("#0F172A")
TEXT_SECONDARY = colors.HexColor("#475569")
TEXT_MUTED = colors.HexColor("#64748B")
RISK_FILL = colors.HexColor("#FEF2F2")
RISK_STROKE = colors.HexColor("#FCA5A5")
ACTION_FILL = colors.HexColor("#EFF6FF")
ACTION_STROKE = colors.HexColor("#93C5FD")
REPORT_LLM_TIMEOUT_SECONDS = 20.0
REPORT_LLM_MAX_RETRIES = 0
REPORT_PROMPT_ITEM_LIMIT = 5
REPORT_ENHANCEMENT_TIMEOUT_SECONDS = 90.0
REPORT_ENHANCEMENT_MAX_RETRIES = 0
REPORT_ENHANCEMENT_TASKS: dict[str, dict[str, Any]] = {}
REPORT_ENHANCEMENT_LOCK = threading.Lock()


class ReportItem(BaseModel):
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


class ReportRequest(BaseModel):
    keyword: str | None = ""
    anchorDate: str | None = None
    reportType: str | None = "business"
    itemIds: list[int] = Field(default_factory=list)
    items: list[ReportItem] = Field(default_factory=list)
    enhancementTaskId: str | None = None


def log_report_event(trace_id: str, stage: str, started_at: float | None = None, **details: Any) -> None:
    elapsed_text = ""
    if started_at is not None:
        elapsed_text = f" elapsed={time.perf_counter() - started_at:.3f}s"

    detail_parts = []
    for key, value in details.items():
        if value is None:
            continue
        detail_parts.append(f"{key}={value}")

    suffix = f" {' '.join(detail_parts)}" if detail_parts else ""
    print(
        f"[REPORT_TRACE] ts={datetime.now().isoformat(timespec='seconds')} "
        f"traceId={trace_id} stage={stage}{elapsed_text}{suffix}"
    )


def get_report_llm_timeout_seconds() -> float:
    return float(os.getenv("REPORT_OPENAI_TIMEOUT_SECONDS", str(REPORT_LLM_TIMEOUT_SECONDS)))


def get_report_llm_max_retries() -> int:
    return int(os.getenv("REPORT_OPENAI_MAX_RETRIES", str(REPORT_LLM_MAX_RETRIES)))


def create_report_llm_client(
    timeout_seconds: float | None = None,
    max_retries: int | None = None,
):
    return get_client().with_options(
        timeout=timeout_seconds if timeout_seconds is not None else get_report_llm_timeout_seconds(),
        max_retries=max_retries if max_retries is not None else get_report_llm_max_retries(),
    )


def normalize_text(value: Any, default: str = "") -> str:
    if value is None:
        return default
    text = str(value).strip()
    return text or default


def normalize_text_list(values: Any) -> list[str]:
    if not isinstance(values, list):
        return []
    normalized = []
    for item in values:
        if isinstance(item, dict):
            text = normalize_text(
                item.get("content") or item.get("text") or item.get("title"),
                "",
            )
        else:
            text = normalize_text(item, "")
        if text:
            normalized.append(text)
    return normalized


def normalize_action_items(values: Any) -> list[dict[str, str]]:
    if not isinstance(values, list):
        return []

    normalized = []
    for index, item in enumerate(values):
        if isinstance(item, dict):
            normalized.append(
                {
                    "title": normalize_text(item.get("title"), f"行动项 {index + 1}"),
                    "priority": normalize_text(item.get("priority"), "中"),
                    "content": normalize_text(
                        item.get("content") or item.get("text"),
                        "请结合当前商品表现安排后续动作。",
                    ),
                }
            )
            continue

        text = normalize_text(item, "")
        if text:
            normalized.append(
                {
                    "title": f"行动项 {index + 1}",
                    "priority": "中",
                    "content": text,
                }
            )

    return normalized


def normalize_report_payload(data: dict[str, Any]) -> dict[str, Any]:
    sections = []
    for index, item in enumerate(data.get("analysisSections") or []):
        if not isinstance(item, dict):
            continue
        title = normalize_text(item.get("title"), f"分析章节 {index + 1}")
        content = normalize_text(item.get("content") or item.get("text"), "")
        if title and content:
            sections.append({"title": title, "content": content})

    normalized_status = normalize_text(data.get("llmStatus"), "success").lower()
    if normalized_status not in {"fallback", "error"}:
        normalized_status = "success"

    return {
        "reportTitle": normalize_text(data.get("reportTitle"), "AI商业分析报告"),
        "summary": normalize_text(data.get("summary"), ""),
        "analysisSections": sections,
        "recommendations": normalize_text_list(data.get("recommendations")),
        "actionItems": normalize_action_items(data.get("actionItems")),
        "riskAlerts": normalize_text_list(data.get("riskAlerts")),
        "llmStatus": normalized_status,
    }


def resolve_report_subject(payload: "ReportRequest") -> str:
    keyword = normalize_text(payload.keyword, "")
    if keyword:
        return keyword

    first_item = payload.items[0] if payload.items else None
    if first_item:
        item_title = normalize_text(getattr(first_item, "title", ""), "")
        if item_title:
            return item_title

    return "未指定"


def build_report_prompt(payload: ReportRequest, base_report: dict[str, Any] | None = None) -> str:
    compact_items = []
    for item in payload.items[:REPORT_PROMPT_ITEM_LIMIT]:
        compact_items.append(
            {
                "itemId": item.itemId,
                "title": item.title,
                "category": item.category,
                "clickCnt": item.clickCnt,
                "payCnt": item.payCnt,
                "clickCnt7D": item.clickCnt7D,
                "payPerClick7D": item.payPerClick7D,
                "recommendationScore": item.recommendationScore,
                "recommendationReason": item.recommendationReason,
            }
        )

    base_report_json = json.dumps(base_report or {}, ensure_ascii=False, separators=(",", ":"))
    report_subject = resolve_report_subject(payload)

    return (
        "你是电商经营分析顾问，请基于现有规则分析报告做润色增强。"
        "只返回 JSON，不要输出 Markdown，不要输出额外解释。"
        "JSON 必须包含 reportTitle、summary、analysisSections、recommendations、actionItems、riskAlerts。"
        "请保留规则报告的核心判断，不要推翻原有结论，不要凭空新增不存在的数据。"
        "优先润色 reportTitle 和 summary，让表达更自然、更专业、更简洁。"
        "analysisSections、recommendations、actionItems、riskAlerts 如无充分必要，请沿用规则报告原内容；"
        "只有在措辞优化时才允许轻微改写，但不能删除有效章节，也不能把非空数组改成空数组。"
        "summary 控制在 120 字内，请直接给结论，不要空话。"
        f"关键词：{report_subject}。"
        f"报告类型：{payload.reportType or 'business'}。"
        f"锚定日期：{payload.anchorDate or '未指定'}。"
        f"最多分析 {REPORT_PROMPT_ITEM_LIMIT} 个商品。"
        f"商品数据：{json.dumps(compact_items, ensure_ascii=False, separators=(',', ':'))}。"
        f"规则报告：{base_report_json}"
    )


def fallback_report(payload: ReportRequest) -> dict[str, Any]:
    items = payload.items
    top_items = sorted(
        items,
        key=lambda row: (
            float(row.recommendationScore or 0),
            float(row.payCnt or 0),
            float(row.clickCnt or 0),
        ),
        reverse=True,
    )[:5]

    report_subject = resolve_report_subject(payload)
    total_items = len(items)
    avg_score = round(
        sum(float(item.recommendationScore or 0) for item in items) / total_items,
        2,
    ) if total_items else 0

    item_overview = "；".join(
        [
            (
                f"{item.title or item.itemId}（推荐度 {float(item.recommendationScore or 0):.2f}，"
                f"销量 {float(item.payCnt or 0):.0f}，点击 {float(item.clickCnt or 0):.0f}，"
                f"近7日点击 {float(item.clickCnt7D or 0):.0f}，近7日支付转化 {float(item.payPerClick7D or 0):.4f}）"
            )
            for item in top_items
        ]
    ) or "暂无足够商品数据。"

    high_click_low_pay = [
        item for item in top_items if float(item.clickCnt or 0) > 0 and float(item.payPerClick7D or 0) <= 0
    ]

    analysis_sections = [
        {
            "title": "商品概览",
            "content": (
                f"当前分析对象“{report_subject}”共纳入 {total_items} 个商品进入分析，平均推荐度为 {avg_score:.2f}。"
                f"当前报告重点关注推荐度、销量、点击表现以及近7日点击与支付转化特征，以判断哪些商品更适合优先运营。"
            ),
        },
        {
            "title": "核心指标解读",
            "content": (
                "从当前样本看，推荐度高的商品通常同时具备较高的销量和点击基础。"
                f"重点商品表现如下：{item_overview}"
            ),
        },
        {
            "title": "推荐逻辑分析",
            "content": (
                "当前推荐排序以推荐度为主，推荐度又综合了销量、点击量、近7日点击、近7日点击UV和近7日支付转化。"
                "因此，推荐度高通常意味着商品既有基础成交能力，也有稳定的近期流量表现；"
                "如果推荐度高但转化偏弱，则说明商品具备流量吸引力，但仍存在页面表达、价格、促销或转化链路问题。"
            ),
        },
        {
            "title": "转化问题诊断",
            "content": (
                "需要重点关注高点击低支付的商品，这类商品往往说明用户已被标题或流量入口吸引，但购买决策未完成。"
                + (
                    "当前样本中已观察到部分商品近7日支付转化偏低，尤其是："
                    + "；".join(item.title or str(item.itemId) for item in high_click_low_pay[:3])
                    + "。"
                    if high_click_low_pay
                    else "当前头部商品暂未出现明显的高点击零转化极端情况，但仍需关注近7日转化变化。"
                )
            ),
        },
        {
            "title": "运营优化建议",
            "content": (
                "建议优先针对高推荐度商品提升曝光和活动资源配置，同时对高点击低转化商品进行页面内容、主图、卖点表达和价格机制排查。"
                "对于推荐度居中但近期点击增长的商品，可作为下一批重点培育对象，通过短期活动验证转化潜力。"
            ),
        },
        {
            "title": "执行优先级",
            "content": (
                "第一优先级：保障高推荐度商品的流量承接和转化稳定；"
                "第二优先级：定位高点击低支付商品的转化阻塞点；"
                "第三优先级：跟踪近7日点击和转化趋势，对波动商品建立持续监控。"
            ),
        },
    ]

    return {
        "reportTitle": "AI商业分析报告",
        "summary": (
            f"围绕分析对象“{report_subject}”共分析 {total_items} 个商品。"
            f"当前报告认为，应优先关注推荐度较高且销量、点击表现稳定的商品，同时对高点击低支付商品开展转化诊断。"
        ),
        "analysisSections": analysis_sections,
        "recommendations": [
            "优先为高推荐度商品配置核心资源位和活动曝光，扩大优势商品的成交贡献。",
            "针对高点击低支付商品优化标题、主图、卖点表达与价格策略，提升点击后的购买转化。",
            "对近7日点击增长但支付尚未同步提升的商品安排短期测试活动，验证真实经营潜力。",
            "建立推荐度、点击和支付转化的联合追踪机制，按周复盘重点商品表现。",
        ],
        "actionItems": [
            {
                "title": "核查头部商品资源配置",
                "priority": "高",
                "content": "优先检查推荐度最高商品的曝光位、库存和价格策略，确保高潜商品不会因为资源不足而错失成交。",
            },
            {
                "title": "处理高点击低转化商品",
                "priority": "高",
                "content": "对高点击但近7日支付转化偏低的商品逐一排查主图、详情页、价格、评价和优惠策略。",
            },
            {
                "title": "建立近7日趋势监控",
                "priority": "中",
                "content": "按商品持续跟踪点击、点击UV和支付转化变化，及时识别增长和回落信号。",
            },
        ],
        "riskAlerts": [
            "部分商品可能存在高点击但支付转化不足的问题，说明流量吸引与成交承接之间存在断层。",
            "如果头部高推荐商品缺少足够曝光或活动支撑，整体推荐体系的经营价值会被削弱。",
        ],
        "llmStatus": "fallback",
    }


def merge_report_payload(
    base_report: dict[str, Any],
    polished_report: dict[str, Any],
) -> dict[str, Any]:
    merged = dict(base_report)

    for key in ("reportTitle", "summary"):
        next_value = normalize_text(polished_report.get(key), "")
        if next_value:
            merged[key] = next_value

    for key in ("analysisSections", "recommendations", "actionItems", "riskAlerts"):
        next_value = polished_report.get(key)
        if isinstance(next_value, list) and next_value:
            merged[key] = next_value

    merged["llmStatus"] = "success"
    return merged


def parse_report_response(content: str) -> dict:
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


def generate_report_content(
    payload: ReportRequest,
    timeout_seconds: float | None = None,
    max_retries: int | None = None,
) -> dict[str, Any]:
    trace_id = uuid.uuid4().hex[:8]
    started_at = time.perf_counter()
    llm_timeout_seconds = timeout_seconds if timeout_seconds is not None else get_report_llm_timeout_seconds()
    llm_max_retries = max_retries if max_retries is not None else get_report_llm_max_retries()
    log_report_event(
        trace_id,
        "enter_generate_report_content",
        started_at,
        keyword=normalize_text(payload.keyword, "-"),
        reportType=normalize_text(payload.reportType, "business"),
        itemCount=len(payload.items),
    )
    base_report = fallback_report(payload)
    prompt = build_report_prompt(payload, base_report)
    log_report_event(
        trace_id,
        "llm_request_start",
        started_at,
        promptLength=len(prompt),
        timeoutSeconds=llm_timeout_seconds,
        maxRetries=llm_max_retries,
    )

    try:
        client = create_report_llm_client(
            timeout_seconds=llm_timeout_seconds,
            max_retries=llm_max_retries,
        )
        response = client.chat.completions.create(
            model=get_llm_model(),
            temperature=0.3,
            messages=[
                {"role": "system", "content": "你是严谨的电商经营分析顾问。"},
                {"role": "user", "content": prompt},
            ],
            response_format={"type": "json_object"},
        )
        log_report_event(
            trace_id,
            "llm_response_received",
            started_at,
            choiceCount=len(response.choices or []),
        )
        content = response.choices[0].message.content or "{}"
        data = parse_report_response(content)
        report = merge_report_payload(base_report, normalize_report_payload(data))
        log_report_event(
            trace_id,
            "generate_report_content_success",
            started_at,
            llmStatus=report.get("llmStatus"),
            sectionCount=len(report.get("analysisSections") or []),
        )
        return report
    except Exception as exc:  # noqa: BLE001
        log_report_event(
            trace_id,
            "llm_request_failed",
            started_at,
            errorType=type(exc).__name__,
            error=str(exc),
        )
        report = base_report
        log_report_event(
            trace_id,
            "fallback_report_generated",
            started_at,
            sectionCount=len(report.get("analysisSections") or []),
        )
        return report


def build_report_task_response(
    report: dict[str, Any],
    task_id: str | None,
    status: str,
) -> dict[str, Any]:
    response = dict(report)
    response["success"] = True
    response["enhancementTaskId"] = task_id
    response["enhancementStatus"] = status
    return response


def get_report_enhancement_timeout_seconds() -> float:
    return float(
        os.getenv(
            "REPORT_ENHANCEMENT_OPENAI_TIMEOUT_SECONDS",
            str(REPORT_ENHANCEMENT_TIMEOUT_SECONDS),
        )
    )


def get_report_enhancement_max_retries() -> int:
    return int(
        os.getenv(
            "REPORT_ENHANCEMENT_OPENAI_MAX_RETRIES",
            str(REPORT_ENHANCEMENT_MAX_RETRIES),
        )
    )


def set_report_task_state(task_id: str, **values: Any) -> None:
    with REPORT_ENHANCEMENT_LOCK:
        current = REPORT_ENHANCEMENT_TASKS.get(task_id, {})
        current.update(values)
        REPORT_ENHANCEMENT_TASKS[task_id] = current


def get_report_task_state(task_id: str) -> dict[str, Any] | None:
    with REPORT_ENHANCEMENT_LOCK:
        current = REPORT_ENHANCEMENT_TASKS.get(task_id)
        return dict(current) if current else None


def resolve_report_for_pdf(payload: ReportRequest) -> dict[str, Any]:
    task_id = normalize_text(payload.enhancementTaskId, "")
    if task_id:
        task_state = get_report_task_state(task_id)
        task_report = task_state.get("report") if task_state else None
        if isinstance(task_report, dict) and task_report:
            return dict(task_report)

    return generate_report_content(payload)


def run_report_enhancement(task_id: str, payload: ReportRequest) -> None:
    try:
        enhanced_report = generate_report_content(
            payload,
            timeout_seconds=get_report_enhancement_timeout_seconds(),
            max_retries=get_report_enhancement_max_retries(),
        )
        set_report_task_state(
            task_id,
            status="completed",
            report=enhanced_report,
            completedAt=datetime.now().isoformat(timespec="seconds"),
        )
    except Exception as exc:  # noqa: BLE001
        set_report_task_state(
            task_id,
            status="failed",
            error=str(exc),
            completedAt=datetime.now().isoformat(timespec="seconds"),
        )


def schedule_report_enhancement(task_id: str, payload: ReportRequest) -> None:
    worker = threading.Thread(
        target=run_report_enhancement,
        args=(task_id, payload),
        daemon=True,
        name=f"report-enhancement-{task_id}",
    )
    worker.start()


def wrap_text(text: str, max_width: float, font_name: str, font_size: int) -> list[str]:
    normalized = normalize_text(text, "")
    if not normalized:
        return [""]

    lines = []
    for paragraph in normalized.splitlines() or [""]:
        current = ""
        for char in paragraph:
            trial = current + char
            if pdfmetrics.stringWidth(trial, font_name, font_size) <= max_width:
                current = trial
            else:
                if current:
                    lines.append(current)
                current = char
        lines.append(current)
    return lines or [""]


def write_pdf(report: dict[str, Any]) -> str:
    pdfmetrics.registerFont(UnicodeCIDFont(PDF_FONT))
    filename = f"emdmp_ai_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}.pdf"
    file_path = PDF_DIR / filename

    pdf = canvas.Canvas(str(file_path), pagesize=A4)
    current_y = TOP_MARGIN
    page_number = 1

    def ensure_space(required_height: int, font_name: str = PDF_FONT, font_size: int = 12) -> None:
        nonlocal current_y, page_number
        if current_y - required_height < BOTTOM_MARGIN:
            draw_footer()
            pdf.showPage()
            pdf.setFont(font_name, font_size)
            current_y = TOP_MARGIN
            page_number += 1

    def draw_footer() -> None:
        pdf.setStrokeColor(colors.HexColor("#E2E8F0"))
        pdf.line(LEFT_MARGIN, 34, PAGE_WIDTH - RIGHT_MARGIN, 34)
        pdf.setFillColor(TEXT_MUTED)
        pdf.setFont(PDF_FONT, 10)
        pdf.drawString(LEFT_MARGIN, 20, "EMDMP AI 商业分析报告")
        pdf.drawRightString(PAGE_WIDTH - RIGHT_MARGIN, 20, f"第 {page_number} 页")

    def draw_section_box(title: str, text: str, fill_color, stroke_color) -> None:
        nonlocal current_y
        wrapped = wrap_text(text, CONTENT_WIDTH - 28, PDF_FONT, 12)
        box_height = 26 + len(wrapped) * 20 + 18
        ensure_space(box_height + 12)
        top_y = current_y
        rect_y = top_y - box_height + 6
        pdf.setFillColor(fill_color)
        pdf.setStrokeColor(stroke_color)
        pdf.roundRect(LEFT_MARGIN, rect_y, CONTENT_WIDTH, box_height, 10, fill=1, stroke=1)
        pdf.setFillColor(TEXT_PRIMARY)
        pdf.setFont(PDF_FONT, 14)
        pdf.drawString(LEFT_MARGIN + 14, top_y - 18, title)
        current_y = top_y - 44
        pdf.setFillColor(TEXT_SECONDARY)
        pdf.setFont(PDF_FONT, 12)
        for line in wrapped:
            pdf.drawString(LEFT_MARGIN + 14, current_y, line)
            current_y -= 20
        current_y = rect_y - 14

    def write_block(text: str, font_size: int = 12, leading: int = 20) -> None:
        nonlocal current_y
        lines = wrap_text(text, CONTENT_WIDTH, PDF_FONT, font_size)
        ensure_space(len(lines) * leading + 6, PDF_FONT, font_size)
        pdf.setFont(PDF_FONT, font_size)
        pdf.setFillColor(TEXT_SECONDARY)
        for line in lines:
            pdf.drawString(LEFT_MARGIN, current_y, line)
            current_y -= leading

    def write_heading(text: str, font_size: int = 16, gap_after: int = 12) -> None:
        nonlocal current_y
        ensure_space(font_size + gap_after + 8, PDF_FONT, font_size)
        pdf.setFont(PDF_FONT, font_size)
        pdf.setFillColor(TEXT_PRIMARY)
        pdf.drawString(LEFT_MARGIN, current_y, text)
        current_y -= gap_after + 6

    def draw_cover() -> None:
        nonlocal current_y
        pdf.setFillColor(HEADER_FILL)
        pdf.roundRect(LEFT_MARGIN, PAGE_HEIGHT - 180, CONTENT_WIDTH, 112, 14, fill=1, stroke=0)
        pdf.setFillColor(HEADER_ACCENT)
        pdf.rect(LEFT_MARGIN, PAGE_HEIGHT - 180, 8, 112, fill=1, stroke=0)
        pdf.setFillColor(TEXT_PRIMARY)
        pdf.setFont(PDF_FONT, 20)
        pdf.drawString(LEFT_MARGIN + 24, PAGE_HEIGHT - 104, report.get("reportTitle", "AI商业分析报告"))
        pdf.setFont(PDF_FONT, 12)
        pdf.setFillColor(TEXT_MUTED)
        pdf.drawString(LEFT_MARGIN + 24, PAGE_HEIGHT - 130, f"生成时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        pdf.drawString(LEFT_MARGIN + 24, PAGE_HEIGHT - 150, "数据来源：EMDMP 智能推荐与商业分析")
        current_y = PAGE_HEIGHT - 210

        summary = normalize_text(report.get("summary"), "暂无摘要。")
        draw_section_box("执行摘要", summary, SECTION_FILL, SECTION_STROKE)

    draw_cover()

    for section in report.get("analysisSections", []):
        title = normalize_text(section.get("title"), "分析章节")
        content = normalize_text(section.get("content"), "")
        draw_section_box(title, content, SECTION_FILL, SECTION_STROKE)

    recommendations = report.get("recommendations", []) or []
    if recommendations:
        draw_section_box("运营建议", "\n".join(f"- {item}" for item in recommendations), ACTION_FILL, ACTION_STROKE)

    risk_alerts = report.get("riskAlerts", []) or []
    if risk_alerts:
        draw_section_box("风险提示", "\n".join(f"- {item}" for item in risk_alerts), RISK_FILL, RISK_STROKE)

    action_items = report.get("actionItems", []) or []
    if action_items:
        write_heading("【行动优先级】", 15, 10)
        for item in action_items:
            if isinstance(item, dict):
                title = normalize_text(item.get("title"), "行动项")
                priority = normalize_text(item.get("priority"), "中")
                content = normalize_text(item.get("content"), "")
                draw_section_box(
                    f"{title}（优先级：{priority}）",
                    content or "请结合当前商品表现安排后续动作。",
                    ACTION_FILL,
                    ACTION_STROKE,
                )
            else:
                draw_section_box("行动项", normalize_text(item, "请结合当前商品表现安排后续动作。"), ACTION_FILL, ACTION_STROKE)

    draw_footer()
    pdf.save()
    return filename


@router.post("/generate-report")
async def generate_report(payload: ReportRequest) -> dict[str, Any]:
    route_started_at = time.perf_counter()
    route_trace_id = uuid.uuid4().hex[:8]
    log_report_event(
        route_trace_id,
        "enter_generate_report_route",
        route_started_at,
        itemCount=len(payload.items),
        itemIdCount=len(payload.itemIds),
    )
    report = generate_report_content(payload)
    report["success"] = True
    log_report_event(
        route_trace_id,
        "return_generate_report_route",
        route_started_at,
        llmStatus=report.get("llmStatus"),
        sectionCount=len(report.get("analysisSections") or []),
    )
    return report


@router.post("/generate-report/start")
async def start_generate_report(payload: ReportRequest) -> dict[str, Any]:
    route_started_at = time.perf_counter()
    route_trace_id = uuid.uuid4().hex[:8]
    log_report_event(
        route_trace_id,
        "enter_generate_report_start_route",
        route_started_at,
        itemCount=len(payload.items),
        itemIdCount=len(payload.itemIds),
    )
    task_id = uuid.uuid4().hex
    immediate_report = fallback_report(payload)
    set_report_task_state(
        task_id,
        status="pending",
        report=immediate_report,
        startedAt=datetime.now().isoformat(timespec="seconds"),
    )
    schedule_report_enhancement(task_id, payload)
    response = build_report_task_response(immediate_report, task_id, "pending")
    log_report_event(
        route_trace_id,
        "return_generate_report_start_route",
        route_started_at,
        enhancementStatus=response.get("enhancementStatus"),
        taskId=task_id,
    )
    return response


@router.get("/generate-report/tasks/{task_id}")
async def get_generate_report_task(task_id: str) -> dict[str, Any]:
    route_started_at = time.perf_counter()
    route_trace_id = uuid.uuid4().hex[:8]
    log_report_event(
        route_trace_id,
        "enter_get_generate_report_task_route",
        route_started_at,
        taskId=task_id,
    )
    task_state = get_report_task_state(task_id)
    if not task_state:
        return {
            "success": False,
            "enhancementTaskId": task_id,
            "enhancementStatus": "missing",
            "message": "报告增强任务不存在或已过期",
        }

    report = task_state.get("report") or {}
    response = build_report_task_response(report, task_id, task_state.get("status") or "pending")
    if task_state.get("error"):
        response["message"] = task_state["error"]
    log_report_event(
        route_trace_id,
        "return_get_generate_report_task_route",
        route_started_at,
        enhancementStatus=response.get("enhancementStatus"),
        success=response.get("success"),
    )
    return response


@router.post("/generate-report-pdf")
async def generate_report_pdf(payload: ReportRequest, request: Request) -> dict[str, Any]:
    report = resolve_report_for_pdf(payload)
    filename = write_pdf(report)
    report["success"] = True
    report["pdfDownloadUrl"] = str(request.base_url).rstrip("/") + f"/files/{filename}"
    return report
