import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const appFileUrl = new URL("./app.jsx", import.meta.url)

test("sales forecast menu hides the legacy predictions list entry", async () => {
	const source = await readFile(appFileUrl, "utf8")

	assert.match(source, /filterSalesPredictMenus/)
	assert.match(
		source,
		/\/sales-predict-module\/rec-sales-forecast-predictions/,
	)
	assert.match(
		source,
		/children:\s*children\.filter\(\(child\) => !isLegacySalesPredictionMenu\(child\)\)/,
	)
})
