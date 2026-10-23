import test from "node:test"
import assert from "node:assert/strict"

import { unwrapAIProxyPayload } from "./ai-response-normalizer.js"
import { normalizeCompetitorAnalysisResult } from "../ai-competitor-analysis/utils/ai-competitor-analysis-helpers.js"

test("unwrapAIProxyPayload unwraps nested data payloads returned by AiModule proxies", () => {
	const result = unwrapAIProxyPayload({
		success: true,
		data: {
			summary: "报告摘要",
			analysisSections: [{ title: "章节一", content: "章节内容" }],
			recommendations: ["建议一"],
			llmStatus: "success",
		},
	})

	assert.equal(result.summary, "报告摘要")
	assert.deepEqual(result.analysisSections, [{ title: "章节一", content: "章节内容" }])
	assert.deepEqual(result.recommendations, ["建议一"])
	assert.equal(result.llmStatus, "success")
})

test("normalizeCompetitorAnalysisResult reads nested proxy payload instead of falling back to empty summary", () => {
	const fallback = {
		summary: "本地规则分析",
		relationshipInsights: ["规则关系"],
		comparisonHighlights: ["规则亮点"],
		marketPosition: "规则定位",
		strengths: ["规则优势"],
		weaknesses: ["规则劣势"],
		strategySuggestions: ["规则建议"],
		llmStatus: "frontend-fallback",
	}

	const result = normalizeCompetitorAnalysisResult(
		{
			success: true,
			data: {
				summary: "AI 竞品分析摘要",
				relationshipInsights: ["AI 关系解读"],
				comparisonHighlights: ["AI 亮点"],
				marketPosition: "AI 市场定位",
				strengths: ["AI 优势"],
				weaknesses: ["AI 劣势"],
				strategySuggestions: ["AI 建议"],
				llmStatus: "success",
			},
		},
		fallback,
	)

	assert.equal(result.summary, "AI 竞品分析摘要")
	assert.deepEqual(result.relationshipInsights, ["AI 关系解读"])
	assert.deepEqual(result.strategySuggestions, ["AI 建议"])
	assert.equal(result.llmStatus, "success")
})
