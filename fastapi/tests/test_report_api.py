import sys
import io
import os
import unittest
from pathlib import Path
from contextlib import redirect_stdout

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class ReportApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app
		self.payload = {
			"keyword": "连衣裙",
			"anchorDate": "2026-03-29",
			"reportType": "business",
			"itemIds": [1001, 1002],
			"items": [
				{
					"itemId": 1001,
					"title": "法式收腰连衣裙",
					"category": "女装",
					"sellerId": "s001",
					"clickCnt": 1200,
					"payCnt": 180,
					"clickCnt7D": 320,
					"clickUv7D": 240,
					"payPerClick7D": 0.21,
					"recommendationScore": 88.5,
					"recommendationLevel": "高推荐",
					"recommendationReason": "近7日点击和成交都较强",
				},
				{
					"itemId": 1002,
					"title": "通勤显瘦连衣裙",
					"category": "女装",
					"sellerId": "s002",
					"clickCnt": 980,
					"payCnt": 136,
					"clickCnt7D": 280,
					"clickUv7D": 210,
					"payPerClick7D": 0.18,
					"recommendationScore": 81.2,
					"recommendationLevel": "中推荐",
					"recommendationReason": "点击表现稳定，转化有提升空间",
				},
			],
		}

	def test_report_routes_are_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/generate-report", paths)
		self.assertIn("/api/EMDMPAI/generate-report-pdf", paths)

	def test_report_pdf_dir_uses_project_root_report_generated(self):
		from apps.EMDMPAI.apis import report_api

		expected_dir = FASTAPI_DIR.parent / "report_generated"
		self.assertEqual(report_api.PDF_DIR, expected_dir)

	def test_generate_report_returns_structured_fallback_when_llm_fails(self):
		from apps.EMDMPAI.apis import report_api

		original_get_client = report_api.get_client

		def raising_client():
			raise RuntimeError("llm unavailable")

		report_api.get_client = raising_client

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/generate-report", json=self.payload)
		finally:
			report_api.get_client = original_get_client

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertTrue(data["summary"])
		self.assertTrue(data["analysisSections"])
		self.assertTrue(data["recommendations"])
		self.assertNotIn("pdfDownloadUrl", data)

	def test_generate_report_pdf_returns_download_url_when_llm_fails(self):
		from apps.EMDMPAI.apis import report_api

		original_get_client = report_api.get_client
		original_write_pdf = report_api.write_pdf

		def raising_client():
			raise RuntimeError("llm unavailable")

		report_api.get_client = raising_client
		report_api.write_pdf = lambda _report: "test-report.pdf"

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/generate-report-pdf", json=self.payload)
		finally:
			report_api.get_client = original_get_client
			report_api.write_pdf = original_write_pdf

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertTrue(data["pdfDownloadUrl"].endswith("/files/test-report.pdf"))
		self.assertTrue(data["analysisSections"])

	def test_generate_report_pdf_uses_cached_task_report_when_task_completed(self):
		from apps.EMDMPAI.apis import report_api

		task_id = "task-pdf-cache"
		original_tasks = getattr(report_api, "REPORT_ENHANCEMENT_TASKS", None)
		original_generate_report_content = report_api.generate_report_content
		original_write_pdf = report_api.write_pdf
		written_report = {}

		report_api.REPORT_ENHANCEMENT_TASKS = {
			task_id: {
				"status": "completed",
				"report": {
					"reportTitle": "增强版缓存报告",
					"summary": "增强版摘要",
					"analysisSections": [{"title": "章节", "content": "内容"}],
					"recommendations": ["建议"],
					"actionItems": [],
					"riskAlerts": [],
					"llmStatus": "success",
				},
			}
		}
		report_api.generate_report_content = lambda _payload: (_ for _ in ()).throw(
			AssertionError("should not regenerate report when cached task report exists")
		)

		def fake_write_pdf(report):
			written_report.update(report)
			return "cached-report.pdf"

		report_api.write_pdf = fake_write_pdf

		try:
			client = TestClient(self.app)
			response = client.post(
				"/api/EMDMPAI/generate-report-pdf",
				json={**self.payload, "enhancementTaskId": task_id},
			)
		finally:
			if original_tasks is None:
				delattr(report_api, "REPORT_ENHANCEMENT_TASKS")
			else:
				report_api.REPORT_ENHANCEMENT_TASKS = original_tasks
			report_api.generate_report_content = original_generate_report_content
			report_api.write_pdf = original_write_pdf

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertEqual(data["reportTitle"], "增强版缓存报告")
		self.assertEqual(data["llmStatus"], "success")
		self.assertTrue(data["pdfDownloadUrl"].endswith("/files/cached-report.pdf"))
		self.assertEqual(written_report["reportTitle"], "增强版缓存报告")

	def test_generate_report_start_returns_fallback_and_task_id(self):
		from apps.EMDMPAI.apis import report_api

		original_schedule = getattr(report_api, "schedule_report_enhancement", None)
		scheduled = {}

		def fake_schedule(task_id, payload):
			scheduled["task_id"] = task_id
			scheduled["payload"] = payload

		report_api.schedule_report_enhancement = fake_schedule

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/generate-report/start", json=self.payload)
		finally:
			if original_schedule is None:
				delattr(report_api, "schedule_report_enhancement")
			else:
				report_api.schedule_report_enhancement = original_schedule

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertEqual(data["enhancementStatus"], "pending")
		self.assertTrue(data["enhancementTaskId"])
		self.assertEqual(data["enhancementTaskId"], scheduled["task_id"])
		self.assertEqual(scheduled["payload"].itemIds, self.payload["itemIds"])

	def test_generate_report_start_logs_route_stage(self):
		from apps.EMDMPAI.apis import report_api

		original_schedule = getattr(report_api, "schedule_report_enhancement", None)
		log_buffer = io.StringIO()

		def fake_schedule(_task_id, _payload):
			return None

		report_api.schedule_report_enhancement = fake_schedule

		try:
			client = TestClient(self.app)
			with redirect_stdout(log_buffer):
				response = client.post("/api/EMDMPAI/generate-report/start", json=self.payload)
		finally:
			if original_schedule is None:
				delattr(report_api, "schedule_report_enhancement")
			else:
				report_api.schedule_report_enhancement = original_schedule

		self.assertEqual(response.status_code, 200)
		log_output = log_buffer.getvalue()
		self.assertIn("stage=enter_generate_report_start_route", log_output)
		self.assertIn("stage=return_generate_report_start_route", log_output)

	def test_get_report_task_status_returns_completed_report(self):
		from apps.EMDMPAI.apis import report_api

		task_id = "task-demo"
		original_tasks = getattr(report_api, "REPORT_ENHANCEMENT_TASKS", None)
		report_api.REPORT_ENHANCEMENT_TASKS = {
			task_id: {
				"status": "completed",
				"report": {
					"reportTitle": "增强报告",
					"summary": "增强摘要",
					"analysisSections": [{"title": "章节", "content": "内容"}],
					"recommendations": ["建议"],
					"actionItems": [],
					"riskAlerts": [],
					"llmStatus": "success",
				},
			}
		}

		try:
			client = TestClient(self.app)
			response = client.get(f"/api/EMDMPAI/generate-report/tasks/{task_id}")
		finally:
			if original_tasks is None:
				delattr(report_api, "REPORT_ENHANCEMENT_TASKS")
			else:
				report_api.REPORT_ENHANCEMENT_TASKS = original_tasks

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["enhancementStatus"], "completed")
		self.assertEqual(data["reportTitle"], "增强报告")
		self.assertEqual(data["llmStatus"], "success")

	def test_get_report_task_status_logs_route_stage(self):
		from apps.EMDMPAI.apis import report_api

		task_id = "task-log-demo"
		original_tasks = getattr(report_api, "REPORT_ENHANCEMENT_TASKS", None)
		log_buffer = io.StringIO()
		report_api.REPORT_ENHANCEMENT_TASKS = {
			task_id: {
				"status": "completed",
				"report": {
					"reportTitle": "日志测试报告",
					"summary": "日志测试摘要",
					"analysisSections": [{"title": "章节", "content": "内容"}],
					"recommendations": ["建议"],
					"actionItems": [],
					"riskAlerts": [],
					"llmStatus": "success",
				},
			}
		}

		try:
			client = TestClient(self.app)
			with redirect_stdout(log_buffer):
				response = client.get(f"/api/EMDMPAI/generate-report/tasks/{task_id}")
		finally:
			if original_tasks is None:
				delattr(report_api, "REPORT_ENHANCEMENT_TASKS")
			else:
				report_api.REPORT_ENHANCEMENT_TASKS = original_tasks

		self.assertEqual(response.status_code, 200)
		log_output = log_buffer.getvalue()
		self.assertIn("stage=enter_get_generate_report_task_route", log_output)
		self.assertIn("stage=return_get_generate_report_task_route", log_output)

	def test_generate_report_content_logs_timeline_when_llm_fails(self):
		from apps.EMDMPAI.apis import report_api

		original_get_client = report_api.get_client
		log_buffer = io.StringIO()

		def raising_client():
			raise RuntimeError("llm unavailable")

		report_api.get_client = raising_client

		try:
			with redirect_stdout(log_buffer):
				result = report_api.generate_report_content(report_api.ReportRequest(**self.payload))
		finally:
			report_api.get_client = original_get_client

		log_output = log_buffer.getvalue()
		self.assertEqual(result["llmStatus"], "fallback")
		self.assertIn("[REPORT_TRACE]", log_output)
		self.assertIn("stage=enter_generate_report_content", log_output)
		self.assertIn("stage=llm_request_start", log_output)
		self.assertIn("stage=llm_request_failed", log_output)
		self.assertIn("stage=fallback_report_generated", log_output)

	def test_generate_report_content_keeps_rule_based_sections_when_llm_only_polishes_summary(self):
		from apps.EMDMPAI.apis import report_api

		original_create_client = report_api.create_report_llm_client

		class FakeResponse:
			def __init__(self, content):
				self.choices = [
					type(
						"Choice",
						(),
						{"message": type("Message", (), {"content": content})()},
					)()
				]

		class FakeClient:
			class _Chat:
				class _Completions:
					@staticmethod
					def create(**_kwargs):
						return FakeResponse(
							'{"reportTitle":"润色后的报告","summary":"这是润色后的摘要","analysisSections":[],"recommendations":[],"actionItems":[],"riskAlerts":[],"llmStatus":"success"}'
						)

				completions = _Completions()

			chat = _Chat()

		report_api.create_report_llm_client = lambda *args, **kwargs: FakeClient()

		try:
			result = report_api.generate_report_content(report_api.ReportRequest(**self.payload))
		finally:
			report_api.create_report_llm_client = original_create_client

		self.assertEqual(result["reportTitle"], "润色后的报告")
		self.assertEqual(result["summary"], "这是润色后的摘要")
		self.assertEqual(result["llmStatus"], "success")
		self.assertTrue(result["analysisSections"])
		self.assertTrue(result["recommendations"])
		self.assertTrue(result["actionItems"])
		self.assertTrue(result["riskAlerts"])

	def test_normalize_report_payload_forces_success_when_model_returns_completed(self):
		from apps.EMDMPAI.apis import report_api

		report = report_api.normalize_report_payload(
			{
				"reportTitle": "测试报告",
				"summary": "测试摘要",
				"analysisSections": [{"title": "章节", "content": "内容"}],
				"recommendations": ["建议"],
				"actionItems": [],
				"riskAlerts": [],
				"llmStatus": "completed",
			}
		)

		self.assertEqual(report["llmStatus"], "success")

	def test_create_report_llm_client_uses_short_timeout_and_no_retry(self):
		from apps.EMDMPAI.apis import report_api

		original_get_client = report_api.get_client
		original_timeout = os.environ.get("REPORT_OPENAI_TIMEOUT_SECONDS")
		original_retries = os.environ.get("REPORT_OPENAI_MAX_RETRIES")
		calls = {}

		class FakeClient:
			def with_options(self, **kwargs):
				calls.update(kwargs)
				return self

		report_api.get_client = lambda: FakeClient()
		os.environ.pop("REPORT_OPENAI_TIMEOUT_SECONDS", None)
		os.environ.pop("REPORT_OPENAI_MAX_RETRIES", None)

		try:
			client = report_api.create_report_llm_client()
		finally:
			report_api.get_client = original_get_client
			if original_timeout is None:
				os.environ.pop("REPORT_OPENAI_TIMEOUT_SECONDS", None)
			else:
				os.environ["REPORT_OPENAI_TIMEOUT_SECONDS"] = original_timeout
			if original_retries is None:
				os.environ.pop("REPORT_OPENAI_MAX_RETRIES", None)
			else:
				os.environ["REPORT_OPENAI_MAX_RETRIES"] = original_retries

		self.assertIsNotNone(client)
		self.assertEqual(calls["timeout"], 20.0)
		self.assertEqual(calls["max_retries"], 0)

	def test_report_enhancement_timeout_defaults_to_ninety_seconds(self):
		from apps.EMDMPAI.apis import report_api

		original_timeout = os.environ.get("REPORT_ENHANCEMENT_OPENAI_TIMEOUT_SECONDS")

		os.environ.pop("REPORT_ENHANCEMENT_OPENAI_TIMEOUT_SECONDS", None)
		try:
			timeout_seconds = report_api.get_report_enhancement_timeout_seconds()
		finally:
			if original_timeout is None:
				os.environ.pop("REPORT_ENHANCEMENT_OPENAI_TIMEOUT_SECONDS", None)
			else:
				os.environ["REPORT_ENHANCEMENT_OPENAI_TIMEOUT_SECONDS"] = original_timeout

		self.assertEqual(timeout_seconds, 90.0)

	def test_build_report_prompt_limits_items_and_uses_compact_fields(self):
		from apps.EMDMPAI.apis import report_api

		payload = report_api.ReportRequest(
			keyword="女装",
			anchorDate="2026-04-12",
			reportType="business",
			itemIds=list(range(1, 8)),
			items=[
				{
					"itemId": index,
					"title": f"商品{index}",
					"category": "女装",
					"sellerId": f"s{index}",
					"clickCnt": 100 + index,
					"payCnt": 10 + index,
					"clickCnt7D": 20 + index,
					"clickUv7D": 30 + index,
					"payPerClick7D": 0.1 + index / 100,
					"recommendationScore": 80 + index,
					"recommendationLevel": "高推荐",
					"recommendationReason": "测试原因",
				}
				for index in range(1, 8)
			],
		)

		prompt = report_api.build_report_prompt(payload)

		self.assertIn("商品1", prompt)
		self.assertIn("商品5", prompt)
		self.assertNotIn("商品6", prompt)
		self.assertNotIn("商品7", prompt)
		self.assertIn("recommendationScore", prompt)
		self.assertNotIn("clickUv7D", prompt)
		self.assertNotIn("sellerId", prompt)

	def test_fallback_report_uses_selected_item_title_when_keyword_missing(self):
		from apps.EMDMPAI.apis import report_api

		payload = report_api.ReportRequest(
			keyword="",
			reportType="business",
			itemIds=[5286683],
			items=[
				{
					"itemId": 5286683,
					"title": "假一罚百 包邮 HVSK 正品 牛皮篮球 超 耐磨 水泥地 克星",
					"category": "74-838",
					"sellerId": "s79904",
					"clickCnt": 1797,
					"payCnt": 685,
					"clickCnt7D": 0,
					"clickUv7D": 0,
					"payPerClick7D": 0,
					"recommendationScore": 57.24,
					"recommendationLevel": "高推荐",
					"recommendationReason": "测试原因",
				}
			],
		)

		report = report_api.fallback_report(payload)

		self.assertNotIn("未指定", report["summary"])
		self.assertIn("假一罚百 包邮 HVSK 正品 牛皮篮球 超 耐磨 水泥地 克星", report["summary"])

	def test_build_report_prompt_uses_selected_item_title_when_keyword_missing(self):
		from apps.EMDMPAI.apis import report_api

		payload = report_api.ReportRequest(
			keyword="",
			reportType="business",
			itemIds=[5286683],
			items=[
				{
					"itemId": 5286683,
					"title": "假一罚百 包邮 HVSK 正品 牛皮篮球 超 耐磨 水泥地 克星",
					"category": "74-838",
					"sellerId": "s79904",
					"clickCnt": 1797,
					"payCnt": 685,
					"clickCnt7D": 0,
					"clickUv7D": 0,
					"payPerClick7D": 0,
					"recommendationScore": 57.24,
					"recommendationLevel": "高推荐",
					"recommendationReason": "测试原因",
				}
			],
		)

		prompt = report_api.build_report_prompt(payload)

		self.assertNotIn("关键词：未指定", prompt)
		self.assertIn("关键词：假一罚百 包邮 HVSK 正品 牛皮篮球 超 耐磨 水泥地 克星", prompt)


if __name__ == "__main__":
	unittest.main()
