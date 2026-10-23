import test from "node:test"
import assert from "node:assert/strict"

import { normalizeProductQaResult } from "./product-qa-response-normalizer.js"
import { shouldRetryProductQaWithFastApi } from "./product-qa-retry.js"

test("shouldRetryProductQaWithFastApi retries when proxy asks for clarification on a non-empty question", () => {
	assert.equal(
		shouldRetryProductQaWithFastApi(
			{ llmStatus: "needs_clarification" },
			{ question: "销量最高的是哪一个商品" }
		),
		true
	)
})

test("shouldRetryProductQaWithFastApi does not retry for successful answers", () => {
	assert.equal(
		shouldRetryProductQaWithFastApi(
			{ llmStatus: "success", answer: "目前搜索到的候选商品里，销量最高的是 A 商品。" },
			{ question: "销量最高的是哪一个商品" }
		),
		false
	)
})

test("shouldRetryProductQaWithFastApi retries when proxy returns a generic empty fallback answer", () => {
	assert.equal(
		shouldRetryProductQaWithFastApi(
			{
				llmStatus: "success",
				answer: "我先给你一个简短结论：当前没有拿到可展示的分析结果，换个条件再试试。",
			},
			{ question: "近期销量最高的秋装是哪件商品" }
		),
		true
	)
})

test("shouldRetryProductQaWithFastApi retries when proxy returns no_data for a meaningful question", () => {
	assert.equal(
		shouldRetryProductQaWithFastApi(
			{ llmStatus: "no_data", answer: "当前问题对应的数据查询没有返回结果，请更换锚点或缩小筛选条件后重试。" },
			{ question: "近期销量最高的秋装是哪件商品" }
		),
		true
	)
})

test("shouldRetryProductQaWithFastApi does not retry when the original question is empty", () => {
	assert.equal(
		shouldRetryProductQaWithFastApi(
			{ llmStatus: "needs_clarification" },
			{ question: "   " }
		),
		false
	)
})

test("normalizeProductQaResult unwraps nested proxy payload and maps content to answer", () => {
	const result = normalizeProductQaResult({
		data: {
			content: {
				content: "这是问答结果",
				llmStatus: "success",
			},
		},
	})

	assert.equal(result.answer, "这是问答结果")
	assert.equal(result.content, "这是问答结果")
	assert.equal(result.llmStatus, "success")
})
test("normalizeProductQaResult prefers richer content over terse answer", () => {
	const detailed = "Do not continue scaling promotion. Main reasons: weak recent conversions, zero 7-day forecast, and poor follow-through from clicks to payments."
	const result = normalizeProductQaResult({
		data: {
			content: {
				answer: "Do not continue scaling promotion.",
				content: detailed,
				llmStatus: "success",
			},
		},
	})

	assert.equal(result.answer, detailed)
	assert.equal(result.content, detailed)
	assert.equal(result.llmStatus, "success")
})
