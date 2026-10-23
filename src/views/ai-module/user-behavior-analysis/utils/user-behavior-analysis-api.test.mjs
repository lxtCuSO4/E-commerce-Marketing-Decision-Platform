import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"
import { unwrapAIProxyPayload } from "../../utils/ai-response-normalizer.js"

const file = new URL("./user-behavior-analysis-api.js", import.meta.url)

test("user behavior diagnosis proxy requests wrap body in payload", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/request\.post\(\s*"\/AiModule\/generateUserBehaviorDiagnosisProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
	assert.match(
		source,
		/request\.post\(\s*"\/AiModule\/startGenerateUserBehaviorDiagnosisProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
})

test("shared proxy payload unwrapping can read nested diagnosis content payloads", () => {
	const result = unwrapAIProxyPayload({
		success: true,
		data: {
			content: {
				title: "AI诊断标题",
				summary: "AI诊断摘要",
				recommendations: ["建议1"],
			},
		},
	})

	assert.equal(result.title, "AI诊断标题")
	assert.equal(result.summary, "AI诊断摘要")
	assert.deepEqual(result.recommendations, ["建议1"])
})
