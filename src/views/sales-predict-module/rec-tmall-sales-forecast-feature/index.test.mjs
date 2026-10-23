import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const featurePageUrl = new URL("./index.vue", import.meta.url)

test("feature page imports the search API used by the query action", async () => {
	const source = await readFile(featurePageUrl, "utf8")

	assert.match(source, /getSalesForecastFeatureByParamsApi/)
	assert.match(
		source,
		/import[\s\S]*getSalesForecastFeatureByParamsApi[\s\S]*from\s*".\/utils\/rec-tmall-sales-forecast-feature-api"/,
	)
})
