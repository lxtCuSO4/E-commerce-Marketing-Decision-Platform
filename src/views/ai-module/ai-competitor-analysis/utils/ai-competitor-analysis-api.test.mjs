import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const file = new URL("./ai-competitor-analysis-api.js", import.meta.url)

test("competitor analysis proxy requests wrap body in payload", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/request\.post\("\/AiModule\/generateCompetitorAnalysisProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
	assert.match(
		source,
		/request\.post\("\/AiModule\/startCompetitorAnalysisProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
})

test("live trend prediction delegates to the sales forecast online endpoint", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/request\.post\(\s*"\/SalesPredictModule\/predictSalesForecastOnline"/s,
	)
	assert.match(
		source,
		/horizonDays:\s*params\?\.horizonDays\s*\?\?\s*7/s,
	)
	assert.match(
		source,
		/featureData:\s*params\?\.featureData\s*\?\?\s*\{\}/s,
	)
})

test("live trend prediction flattens nested proxy data before returning it", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/result\s*&&\s*typeof result === "object"[\s\S]*?result\.data[\s\S]*?return \{\s*\.\.\.result,\s*\.\.\.result\.data,\s*data: result\.data,\s*\}/s,
	)
})

test("live trend prediction retries against the FastAPI route when the proxy call fails", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/import\s+\{\s*resolveFastAPIUrl\s*\}\s+from\s+"..\/..\/utils\/fastapi-url\.js"/s,
	)
	assert.match(
		source,
		/request\.post\(\s*resolveFastAPIUrl\("\/api\/EMDMPAI\/sales-forecast\/predict"\)/s,
	)
	assert.match(
		source,
		/shouldRetryCompetitorTrendWithFastApi\(\s*normalizedResult\s*\)[\s\S]*?resolveFastAPIUrl\("\/api\/EMDMPAI\/sales-forecast\/predict"\)[\s\S]*?return normalizeObjectResult\(directResult\)/s,
	)
})
