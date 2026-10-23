import sys
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class UserBehaviorDiagnosisApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app
		self.payload = {
			"viewType": "item",
			"query": {
				"keyword": "连衣裙",
				"itemId": "6614469",
				"sellerId": "s15206",
				"category": "女装",
				"anchorDate": "2026-04-13",
				"windowDays": 7,
				"behaviorTag": "高点击低支付",
			},
			"summary": {
				"matchedCount": 8,
				"avgClickCnt": 1280,
				"avgPayPerClick": 0.042,
				"avgCartPerClick": 0.11,
				"highRiskCount": 3,
				"highPotentialCount": 2,
				"message": "当前样本存在明显漏斗流失",
			},
			"records": [
				{
					"viewType": "item",
					"itemId": 6614469,
					"sellerId": "s15206",
					"title": "秋季显瘦连衣裙",
					"category": "女装",
					"itemCount": 1,
					"clickCnt": 1280,
					"cartCnt": 143,
					"payCnt": 54,
					"clickCntDelta7D": 18,
					"payCntDelta7D": -6,
					"behaviorScore": 72,
					"behaviorLevel": "高风险",
					"behaviorTags": ["高点击低支付", "转化恶化"],
					"avgCartPerClick": 0.11,
					"avgPayPerClick": 0.042,
					"highRiskCount": 1,
					"highPotentialCount": 0,
				}
			],
		}

	def test_route_is_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/generate-user-behavior-diagnosis", paths)
		self.assertIn("/api/EMDMPAI/generate-user-behavior-diagnosis/start", paths)
		self.assertIn("/api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}", paths)

	def test_fallback_diagnosis_uses_readable_chinese_text(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		result = user_behavior_diagnosis_api.fallback_diagnosis(
			user_behavior_diagnosis_api.BehaviorDiagnosisRequest(**self.payload)
		)

		self.assertIn("诊断", result["title"])
		self.assertIn("点击", result["summary"])
		self.assertTrue(result["analysisSections"])
		self.assertFalse(any("?" in item["title"] for item in result["analysisSections"]))
		self.assertFalse(any("?" in item for item in result["recommendations"]))
		self.assertFalse(any("?" in item for item in result["riskAlerts"]))

	def test_item_fallback_avoids_business_report_language(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		result = user_behavior_diagnosis_api.fallback_diagnosis(
			user_behavior_diagnosis_api.BehaviorDiagnosisRequest(**self.payload)
		)
		joined_text = "\n".join(
			[
				result["title"],
				result["summary"],
				*(section["content"] for section in result["analysisSections"]),
				*result["recommendations"],
				*result["riskAlerts"],
			]
		)

		self.assertNotIn("重点运营池", joined_text)
		self.assertNotIn("资源配置", joined_text)
		self.assertNotIn("培育对象", joined_text)
		self.assertNotIn("经营价值", joined_text)

	def test_item_fallback_uses_diagnostic_section_titles(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		result = user_behavior_diagnosis_api.fallback_diagnosis(
			user_behavior_diagnosis_api.BehaviorDiagnosisRequest(**self.payload)
		)
		section_titles = [section["title"] for section in result["analysisSections"]]

		self.assertIn("异常概览", section_titles)
		self.assertIn("阻塞判断", section_titles)
		self.assertIn("成因拆解", section_titles)
		self.assertIn("排查动作", section_titles)
		self.assertNotIn("商品概览", section_titles)
		self.assertNotIn("运营优化建议", section_titles)

	def test_endpoint_returns_fallback_when_llm_fails(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		original_get_client = user_behavior_diagnosis_api.get_client

		def raising_client():
			raise RuntimeError("llm unavailable")

		user_behavior_diagnosis_api.get_client = raising_client

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/generate-user-behavior-diagnosis", json=self.payload)
		finally:
			user_behavior_diagnosis_api.get_client = original_get_client

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertIn("诊断", data["title"])
		self.assertFalse("?" in data["summary"])

	def test_start_returns_fallback_report_and_pending_task(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		original_schedule = getattr(user_behavior_diagnosis_api, "schedule_diagnosis_enhancement", None)
		scheduled = {}

		def fake_schedule(task_id, payload):
			scheduled["task_id"] = task_id
			scheduled["payload"] = payload

		user_behavior_diagnosis_api.schedule_diagnosis_enhancement = fake_schedule

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/generate-user-behavior-diagnosis/start", json=self.payload)
		finally:
			if original_schedule is None:
				delattr(user_behavior_diagnosis_api, "schedule_diagnosis_enhancement")
			else:
				user_behavior_diagnosis_api.schedule_diagnosis_enhancement = original_schedule

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertEqual(data["enhancementStatus"], "pending")
		self.assertTrue(data["enhancementTaskId"])
		self.assertEqual(data["enhancementTaskId"], scheduled["task_id"])
		self.assertEqual(scheduled["payload"].viewType, self.payload["viewType"])

	def test_get_task_returns_completed_diagnosis(self):
		from apps.EMDMPAI.apis import user_behavior_diagnosis_api

		task_id = "user-behavior-task-demo"
		original_tasks = getattr(user_behavior_diagnosis_api, "DIAGNOSIS_ENHANCEMENT_TASKS", None)
		user_behavior_diagnosis_api.DIAGNOSIS_ENHANCEMENT_TASKS = {
			task_id: {
				"status": "completed",
				"report": {
					"title": "润色后的商品行为诊断摘要",
					"summary": "润色后的摘要",
					"analysisSections": [{"title": "行为概览", "content": "内容"}],
					"recommendations": ["建议 1"],
					"riskAlerts": ["风险 1"],
					"llmStatus": "success",
				},
			}
		}

		try:
			client = TestClient(self.app)
			response = client.get(f"/api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}")
		finally:
			if original_tasks is None:
				delattr(user_behavior_diagnosis_api, "DIAGNOSIS_ENHANCEMENT_TASKS")
			else:
				user_behavior_diagnosis_api.DIAGNOSIS_ENHANCEMENT_TASKS = original_tasks

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["enhancementStatus"], "completed")
		self.assertEqual(data["llmStatus"], "success")
		self.assertEqual(data["summary"], "润色后的摘要")


if __name__ == "__main__":
	unittest.main()
