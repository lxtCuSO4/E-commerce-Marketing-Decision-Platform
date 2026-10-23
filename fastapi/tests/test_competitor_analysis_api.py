import sys
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class CompetitorAnalysisApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app
		self.payload = {
			"mainItem": {
				"itemId": "1001",
				"title": "法式收腰连衣裙",
				"category": "女装",
				"sellerId": "s001",
				"payCnt": 180,
				"payCnt30D": 520,
				"pred7DPay": 145,
				"trendSource": "forecast",
				"trendLabels": ["D1", "D2", "D3"],
				"trendValues": [20, 21, 22],
			},
			"selectedCompetitors": [
				{
					"itemId": "2001",
					"title": "显瘦通勤连衣裙",
					"category": "女装",
					"sellerId": "s002",
					"similarityScore": 0.91,
					"rankNo": 1,
					"clickCnt": 980,
					"payCnt": 176,
					"payCnt30D": 500,
					"pred7DPay": 132,
					"trendSource": "forecast",
					"trendLabels": ["D1", "D2", "D3"],
					"trendValues": [19, 20, 21],
				},
				{
					"itemId": "2002",
					"title": "夏季气质连衣裙",
					"category": "女装",
					"sellerId": "s003",
					"similarityScore": 0.87,
					"rankNo": 2,
					"clickCnt": 920,
					"payCnt": 165,
					"payCnt30D": 470,
					"pred7DPay": 126,
					"trendSource": "forecast",
					"trendLabels": ["D1", "D2", "D3"],
					"trendValues": [17, 18, 20],
				},
			],
			"candidateSummary": [
				{
					"itemId": "2001",
					"title": "显瘦通勤连衣裙",
					"category": "女装",
					"similarityScore": 0.91,
					"pred7DPay": 132,
				},
				{
					"itemId": "2002",
					"title": "夏季气质连衣裙",
					"category": "女装",
					"similarityScore": 0.87,
					"pred7DPay": 126,
				},
			],
			"priceStatus": "当前前端未接入稳定价格字段，请聚焦销量、趋势、相似度与竞争位置。",
		}

	def test_competitor_analysis_routes_are_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/competitor-analysis", paths)
		self.assertIn("/api/EMDMPAI/competitor-analysis/start", paths)
		self.assertIn("/api/EMDMPAI/competitor-analysis/tasks/{task_id}", paths)

	def test_start_returns_fallback_report_and_pending_task(self):
		from apps.EMDMPAI.apis import competitor_analysis_api

		original_schedule = getattr(competitor_analysis_api, "schedule_competitor_analysis_enhancement", None)
		scheduled = {}

		def fake_schedule(task_id, payload):
			scheduled["task_id"] = task_id
			scheduled["payload"] = payload

		competitor_analysis_api.schedule_competitor_analysis_enhancement = fake_schedule

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/competitor-analysis/start", json=self.payload)
		finally:
			if original_schedule is None:
				delattr(competitor_analysis_api, "schedule_competitor_analysis_enhancement")
			else:
				competitor_analysis_api.schedule_competitor_analysis_enhancement = original_schedule

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertEqual(data["enhancementStatus"], "pending")
		self.assertTrue(data["enhancementTaskId"])
		self.assertEqual(data["enhancementTaskId"], scheduled["task_id"])
		self.assertEqual(scheduled["payload"].mainItem.itemId, self.payload["mainItem"]["itemId"])

	def test_get_task_returns_completed_report(self):
		from apps.EMDMPAI.apis import competitor_analysis_api

		task_id = "competitor-task-demo"
		original_tasks = getattr(competitor_analysis_api, "COMPETITOR_ANALYSIS_TASKS", None)
		competitor_analysis_api.COMPETITOR_ANALYSIS_TASKS = {
			task_id: {
				"status": "completed",
				"report": {
					"summary": "润色后的摘要",
					"relationshipInsights": ["关系解读"],
					"comparisonHighlights": ["对比亮点"],
					"marketPosition": "竞争位置判断",
					"strengths": ["优势"],
					"weaknesses": ["风险"],
					"strategySuggestions": ["建议动作"],
					"llmStatus": "success",
				},
			}
		}

		try:
			client = TestClient(self.app)
			response = client.get(f"/api/EMDMPAI/competitor-analysis/tasks/{task_id}")
		finally:
			if original_tasks is None:
				delattr(competitor_analysis_api, "COMPETITOR_ANALYSIS_TASKS")
			else:
				competitor_analysis_api.COMPETITOR_ANALYSIS_TASKS = original_tasks

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["enhancementStatus"], "completed")
		self.assertEqual(data["llmStatus"], "success")
		self.assertEqual(data["summary"], "润色后的摘要")

	def test_generate_competitor_analysis_falls_back_when_llm_fails(self):
		from apps.EMDMPAI.apis import competitor_analysis_api

		original_get_client = competitor_analysis_api.get_client

		def raising_client():
			raise RuntimeError("llm unavailable")

		competitor_analysis_api.get_client = raising_client

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/competitor-analysis", json=self.payload)
		finally:
			competitor_analysis_api.get_client = original_get_client

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertTrue(data["summary"])
		self.assertTrue(data["relationshipInsights"])


if __name__ == "__main__":
	unittest.main()
