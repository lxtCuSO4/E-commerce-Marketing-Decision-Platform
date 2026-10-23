import test from "node:test"
import assert from "node:assert/strict"

import { normalizeDiagnosisResponsePayload } from "./diagnosis-response-normalizer.js"

test("normalizeDiagnosisResponsePayload falls back to raw content summary", () => {
	const result = normalizeDiagnosisResponsePayload({
		data: {
			content: "这是 AI 诊断原始文本",
		},
	}, "默认标题")

	assert.equal(result.title, "默认标题")
	assert.equal(result.summary, "这是 AI 诊断原始文本")
	assert.deepEqual(result.analysisSections, [])
	assert.equal(result.llmStatus, "success")
})

test("normalizeDiagnosisResponsePayload converts string sections into section objects", () => {
	const result = normalizeDiagnosisResponsePayload({
		data: {
			content: JSON.stringify({
				title: "AI诊断",
				summary: "AI诊断摘要",
				analysisSections: ["章节一内容", "章节二内容"],
				recommendations: ["建议1"],
				riskAlerts: ["风险1"],
			}),
		},
	}, "默认标题")

	assert.equal(result.title, "AI诊断")
	assert.equal(result.summary, "AI诊断摘要")
	assert.deepEqual(result.analysisSections, [
		{ title: "诊断章节 1", content: "章节一内容" },
		{ title: "诊断章节 2", content: "章节二内容" },
	])
	assert.deepEqual(result.recommendations, ["建议1"])
	assert.deepEqual(result.riskAlerts, ["风险1"])
})
