import sys
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class ProductQaApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app
		self.payload = {
			"sessionId": "session-001",
			"question": "这款商品适合重点推广吗？",
			"itemContext": {
				"itemId": 1001,
				"title": "法式收腰连衣裙",
				"category": "女装",
				"brandId": "b001",
				"sellerId": "s001",
				"clickCnt": 1200,
				"payCnt": 180,
				"clickCnt7D": 320,
				"payCnt30D": 145,
				"pred7DPay": 58,
			},
			"messages": [
				{
					"role": "user",
					"content": "这款商品最近表现怎么样？",
				}
			],
		}

	def test_product_qa_routes_are_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/product-qa/chat", paths)
		self.assertIn("/api/EMDMPAI/product-qa/hot-questions", paths)

	def test_product_qa_chat_returns_fallback_shape_when_llm_fails(self):
		from apps.EMDMPAI.apis import product_qa_api

		original_get_client = product_qa_api.get_client
		original_execute_readonly_query = product_qa_api.execute_readonly_query

		def raising_client():
			raise RuntimeError("llm unavailable")

		def fake_rows(sql, params):
			return [
				{
					"itemId": 1001,
					"title": "法式收腰连衣裙",
					"category": "女装",
					"sellerId": "s001",
					"clickCnt": 1200,
					"payCnt": 180,
					"clickCnt7D": 320,
					"payCnt30D": 145,
					"pred7DPay": 58,
				}
			]

		product_qa_api.get_client = raising_client
		product_qa_api.execute_readonly_query = fake_rows

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/product-qa/chat", json=self.payload)
		finally:
			product_qa_api.get_client = original_get_client
			product_qa_api.execute_readonly_query = original_execute_readonly_query

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["sessionId"], "session-001")
		self.assertEqual(data["llmStatus"], "fallback")
		self.assertTrue(data["answer"])
		self.assertTrue(data["sources"])
		self.assertTrue(data["suggestedQuestions"])
		self.assertIn("analysisMeta", data)
		self.assertEqual(data["analysisMeta"]["rowCount"], 1)

	def test_product_qa_hot_questions_returns_question_list(self):
		client = TestClient(self.app)
		response = client.get(
			"/api/EMDMPAI/product-qa/hot-questions",
			params={"itemId": "1001", "title": "法式收腰连衣裙", "category": "女装"},
		)

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertTrue(data["questions"])
		self.assertGreaterEqual(len(data["questions"]), 4)

	def test_product_qa_chat_returns_clarification_when_anchor_missing(self):
		from apps.EMDMPAI.apis import product_qa_api

		original_get_client = product_qa_api.get_client

		def raising_client():
			raise RuntimeError("llm unavailable")

		product_qa_api.get_client = raising_client

		try:
			client = TestClient(self.app)
			response = client.post(
				"/api/EMDMPAI/product-qa/chat",
				json={
					"sessionId": "session-clarify",
					"question": "最近表现怎么样？",
					"messages": [],
				},
			)
		finally:
			product_qa_api.get_client = original_get_client

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "needs_clarification")
		self.assertEqual(data["analysisMeta"]["rowCount"], 0)

	def test_build_query_plan_infers_title_keyword_for_top_autumn_items(self):
		from apps.EMDMPAI.apis import product_qa_api

		payload = product_qa_api.ProductQaChatRequest(
			sessionId="session-nlq-001",
			question="目前销量最高的秋装是哪件商品？",
			messages=[],
		)

		plan = product_qa_api.build_query_plan(payload)

		self.assertEqual(plan["planType"], "title_summary")
		self.assertIn("title like 秋装", plan["filters"])
		self.assertIn("payCnt", plan["metrics"])
		self.assertIn("order by", plan["sqlPreview"].lower())

	def test_build_query_plan_infers_title_keyword_from_transport_encoded_question(self):
		from apps.EMDMPAI.apis import product_qa_api

		payload = product_qa_api.ProductQaChatRequest(
			sessionId="session-nlq-encoded-001",
			question="__EMDMP_B64__:6ZSA6YeP5pyA6auY55qE56eL6KOF5piv5ZOq5LiA5Lu25ZWG5ZOB",
			messages=[],
		)

		plan = product_qa_api.build_query_plan(payload)

		self.assertEqual(plan["planType"], "title_summary")
		self.assertIn("title like 秋装", plan["filters"])

	def test_build_query_plan_infers_title_keyword_for_best_selling_womenswear(self):
		from apps.EMDMPAI.apis import product_qa_api

		payload = product_qa_api.ProductQaChatRequest(
			sessionId="session-nlq-002",
			question="最近卖得最好的女装有哪些？",
			messages=[],
		)

		plan = product_qa_api.build_query_plan(payload)

		self.assertEqual(plan["planType"], "title_summary")
		self.assertIn("title like 女装", plan["filters"])
		self.assertIn("payCnt", plan["metrics"])

	def test_build_rule_analysis_answers_top_question_in_natural_language(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "title_summary",
			"metrics": ["payCnt30D"],
		}
		rows = [
			{
				"itemId": 2013,
				"title": "测试秋装 A",
				"payCnt": 35,
				"clickCnt": 210,
				"payCnt30D": 28,
				"pred7DPay": 6,
			},
			{
				"itemId": 2014,
				"title": "测试秋装 B",
				"payCnt": 20,
				"clickCnt": 120,
				"payCnt30D": 16,
				"pred7DPay": 3,
			},
		]
		payload = product_qa_api.ProductQaChatRequest(question="目前销量最高的秋装是哪件商品？")

		answer = product_qa_api.build_rule_analysis(payload.question, plan, rows, payload)

		self.assertIn("2013", answer)
		self.assertIn("销量最高的是", answer)
		self.assertIn("测试秋装 A", answer)
		self.assertIn("原因如下", answer)
		self.assertGreaterEqual(answer.count("1."), 1)
		self.assertGreaterEqual(answer.count("2."), 1)
		self.assertNotIn("命中", answer)

	def test_build_rule_analysis_answers_list_question_in_natural_language(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "title_summary",
			"metrics": ["payCnt30D"],
		}
		rows = [
			{
				"title": "女装样本 A",
				"payCnt": 40,
				"clickCnt": 300,
				"payCnt30D": 30,
				"pred7DPay": 5,
			},
			{
				"title": "女装样本 B",
				"payCnt": 35,
				"clickCnt": 280,
				"payCnt30D": 24,
				"pred7DPay": 4,
			},
		]
		payload = product_qa_api.ProductQaChatRequest(question="最近卖得最好的女装有哪些？")

		answer = product_qa_api.build_rule_analysis(payload.question, plan, rows, payload)

		self.assertIn("有这几款", answer)
		self.assertIn("女装样本 A", answer)
		self.assertIn("原因如下", answer)

	def test_build_rule_analysis_answers_worth_promoting_question_naturally(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "item_detail",
			"metrics": ["payCnt", "payCnt30D", "pred7DPay"],
		}
		rows = [
			{
				"itemId": 1001,
				"title": "测试商品 A",
				"payCnt": 420,
				"clickCnt": 1800,
				"payCnt30D": 96,
				"pred7DPay": 45,
			}
		]
		payload = product_qa_api.ProductQaChatRequest(question="这款商品值得继续推广吗？")

		answer = product_qa_api.build_rule_analysis(payload.question, plan, rows, payload)

		self.assertIn("值得继续推广", answer)
		self.assertIn("测试商品 A", answer)
		self.assertIn("原因如下", answer)
		self.assertGreaterEqual(answer.count("1."), 1)
		self.assertGreaterEqual(answer.count("2."), 1)

	def test_build_rule_analysis_answers_risk_question_naturally(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "item_detail",
			"metrics": ["payCnt", "payCnt30D", "pred7DPay"],
		}
		rows = [
			{
				"itemId": 1002,
				"title": "测试商品 B",
				"payCnt": 380,
				"clickCnt": 1600,
				"payCnt30D": 8,
				"pred7DPay": 0,
			}
		]
		payload = product_qa_api.ProductQaChatRequest(question="这款商品当前最大的风险是什么？")

		answer = product_qa_api.build_rule_analysis(payload.question, plan, rows, payload)

		self.assertIn("最大的风险", answer)
		self.assertIn("测试商品 B", answer)
		self.assertIn("原因如下", answer)

	def test_build_rule_analysis_answers_reason_question_naturally(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "item_detail",
			"metrics": ["payCnt", "payCnt30D", "pred7DPay"],
		}
		rows = [
			{
				"itemId": 1003,
				"title": "测试商品 C",
				"payCnt": 260,
				"clickCnt": 900,
				"payCnt30D": 52,
				"pred7DPay": 18,
			}
		]
		payload = product_qa_api.ProductQaChatRequest(question="为什么这款商品最近表现还不错")

		answer = product_qa_api.build_rule_analysis(payload.question, plan, rows, payload)

		self.assertIn("主要是因为", answer)
		self.assertIn("测试商品 C", answer)
		self.assertIn("原因如下", answer)

	def test_build_analysis_meta_uses_item_id_and_title_in_highlights(self):
		from apps.EMDMPAI.apis import product_qa_api

		plan = {
			"planType": "title_summary",
			"modules": ["DataImportModule"],
			"tables": ["DataImportModule.rec_tmall_item_base"],
			"metrics": ["payCnt", "clickCnt"],
			"filters": ["title like 秋装"],
			"sqlPreview": "select 1",
		}
		rows = [
			{
				"itemId": 2013,
				"title": "测试秋装 A",
				"payCnt": 35,
				"clickCnt": 210,
				"pred7DPay": 6,
			}
		]

		meta = product_qa_api.build_analysis_meta(plan, rows)

		self.assertEqual(meta["rowCount"], 1)
		self.assertTrue(meta["highlights"])
		self.assertIn("2013", meta["highlights"][0])
		self.assertIn("测试秋装 A", meta["highlights"][0])


if __name__ == "__main__":
	unittest.main()
