import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const apiFiles = [
	new URL("../ai-competitor-analysis/utils/ai-competitor-analysis-api.js", import.meta.url),
	new URL("../ai-product-qa/utils/ai-product-qa-api.js", import.meta.url),
	new URL("../intelligent-recommendation-report/utils/intelligent-recommendation-report-api.js", import.meta.url),
	new URL("../user-behavior-analysis/utils/user-behavior-analysis-api.js", import.meta.url),
	new URL("../../sales-predict-module/rec-sales-forecast-predictions/utils/rec-sales-forecast-predictions-api.js", import.meta.url),
]

test("direct FastAPI callers use EMDMPAI while business proxies keep their own routes", async () => {
	for (const fileUrl of apiFiles) {
		const source = await readFile(fileUrl, "utf8")
		assert.doesNotMatch(source, /resolveFastAPIUrl\(["']\/api\/EMDMP\//, fileUrl.pathname)
		const directPaths = [...source.matchAll(/resolveFastAPIUrl\(["']([^"']+)["']/g)]
		for (const [, path] of directPaths) {
			assert.match(path, /^\/api\/EMDMPAI\//, fileUrl.pathname)
		}
		if (directPaths.length === 0) {
			assert.match(source, /\/(AiModule|SalesPredictModule)\//, fileUrl.pathname)
		}
	}
})
