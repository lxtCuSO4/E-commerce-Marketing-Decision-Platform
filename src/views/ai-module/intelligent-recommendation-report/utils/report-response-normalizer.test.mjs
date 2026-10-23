import test from "node:test"
import assert from "node:assert/strict"

import {
	normalizeMarketingCopyResponsePayload,
	normalizeReportResponsePayload,
} from "./report-response-normalizer.js"

test("normalizeReportResponsePayload keeps structured report fields when proxy returns report object", () => {
	const result = normalizeReportResponsePayload({
		success: true,
		data: {
			reportTitle: "经营分析报告",
			summary: "这是摘要",
			analysisSections: [{ title: "趋势", content: "趋势向好" }],
			recommendations: ["保持投放"],
			llmStatus: "success",
		},
	})

	assert.equal(result.reportTitle, "经营分析报告")
	assert.equal(result.summary, "这是摘要")
	assert.deepEqual(result.analysisSections, [{ title: "趋势", content: "趋势向好" }])
	assert.deepEqual(result.recommendations, ["保持投放"])
	assert.equal(result.llmStatus, "success")
})

test("normalizeReportResponsePayload falls back to raw content when only content text is returned", () => {
	const result = normalizeReportResponsePayload({
		success: true,
		data: {
			content: "这是大模型直接生成的原始报告文本",
			enhancementStatus: "completed",
		},
	})

	assert.equal(result.reportTitle, "AI 商业分析报告")
	assert.equal(result.summary, "这是大模型直接生成的原始报告文本")
	assert.deepEqual(result.analysisSections, [])
	assert.deepEqual(result.recommendations, [])
	assert.equal(result.llmStatus, "success")
})

test("normalizeReportResponsePayload reads structured fields from JSON content string", () => {
	const result = normalizeReportResponsePayload({
		success: true,
		data: {
			content: JSON.stringify({
				reportTitle: "JSON报告",
				summary: "JSON摘要",
				analysisSections: [{ title: "章节1", content: "内容1" }],
				recommendations: ["建议1"],
			}),
		},
	})

	assert.equal(result.reportTitle, "JSON报告")
	assert.equal(result.summary, "JSON摘要")
	assert.deepEqual(result.analysisSections, [{ title: "章节1", content: "内容1" }])
	assert.deepEqual(result.recommendations, ["建议1"])
})

test("normalizeReportResponsePayload converts string analysis sections into displayable section objects", () => {
	const result = normalizeReportResponsePayload({
		success: true,
		data: {
			content: JSON.stringify({
				reportTitle: "字符串章节报告",
				summary: "章节为字符串数组",
				analysisSections: ["第一部分分析内容", "第二部分分析内容"],
			}),
		},
	})

	assert.deepEqual(result.analysisSections, [
		{ title: "分析章节 1", content: "第一部分分析内容" },
		{ title: "分析章节 2", content: "第二部分分析内容" },
	])
})

test("normalizeMarketingCopyResponsePayload falls back to raw content summary", () => {
	const result = normalizeMarketingCopyResponsePayload({
		success: true,
		data: {
			content: "这是营销文案原始内容",
		},
	})

	assert.equal(result.summary, "这是营销文案原始内容")
	assert.deepEqual(result.copies, [])
	assert.equal(result.llmStatus, "success")
})

test("normalizeMarketingCopyResponsePayload reads structured copies from JSON content string", () => {
	const result = normalizeMarketingCopyResponsePayload({
		success: true,
		data: {
			content: JSON.stringify({
				summary: "文案摘要",
				copies: [
					{
						itemId: 1,
						title: "商品A",
						headlineOptions: ["标题1"],
						sellingPoints: ["卖点1"],
						shortPromotions: ["短文案1"],
					},
				],
			}),
		},
	})

	assert.equal(result.summary, "文案摘要")
	assert.equal(result.copies.length, 1)
	assert.deepEqual(result.copies[0].headlineOptions, ["标题1"])
})
