import sys
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class MarketingCopyApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app

	def test_generate_marketing_copy_route_is_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/generate-marketing-copy", paths)

	def test_generate_marketing_copy_returns_fallback_shape_when_llm_fails(self):
		from apps.EMDMPAI.apis import marketing_copy_api

		original_get_client = marketing_copy_api.get_client

		def raising_client():
			raise RuntimeError("llm unavailable")

		marketing_copy_api.get_client = raising_client

		try:
			client = TestClient(self.app)
			response = client.post(
				"/api/EMDMPAI/generate-marketing-copy",
				json={
					"keyword": "连衣裙",
					"anchorDate": "2026-03-29",
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
						}
					],
				},
			)
		finally:
			marketing_copy_api.get_client = original_get_client

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertTrue(data["summary"])
		self.assertEqual(len(data["copies"]), 1)
		self.assertTrue(data["copies"][0]["headlineOptions"])
		self.assertTrue(data["copies"][0]["sellingPoints"])
		self.assertTrue(data["copies"][0]["shortPromotions"])


if __name__ == "__main__":
	unittest.main()
