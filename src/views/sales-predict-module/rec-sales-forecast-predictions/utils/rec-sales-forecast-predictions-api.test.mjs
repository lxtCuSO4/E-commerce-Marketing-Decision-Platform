import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"
import vm from "node:vm"

const apiFileUrl = new URL("./rec-sales-forecast-predictions-api.js", import.meta.url)

async function loadNormalizeObjectResult() {
	const source = await readFile(apiFileUrl, "utf8")
	const start = source.indexOf("function normalizeObjectResult")
	const end = source.indexOf("\nexport function addApi")
	const functionSource = source.slice(start, end).trim()
	return vm.runInNewContext(`${functionSource}\nnormalizeObjectResult`, {})
}

test("sales forecast online prediction uses the app-side proxy instead of direct FastAPI access", async () => {
	const source = await readFile(apiFileUrl, "utf8")

	assert.match(source, /request\.post\(\s*"\/SalesPredictModule\/predictSalesForecastOnline"/)
	assert.doesNotMatch(source, /resolveFastAPIUrl\("\/api\/EMDMPAI\/sales-forecast\/predict"\)/)
})

test("normalizeObjectResult flattens nested online prediction data returned by debug proxy responses", async () => {
	const normalizeObjectResult = await loadNormalizeObjectResult()
	const result = normalizeObjectResult({
		success: true,
		message: "在线预测成功",
		requestUrl: "http://fastapi:54903/api/EMDMPAI/sales-forecast/predict",
		data: {
			success: true,
			itemId: 480807,
			anchorDate: "2013-09-23",
			horizonDays: 7,
			predPayD1: 12.34,
			pred7DPay: 88.88,
			modelLabel: "Sales Forecast Python Model",
		},
	})

	assert.equal(result.success, true)
	assert.equal(result.itemId, 480807)
	assert.equal(result.anchorDate, "2013-09-23")
	assert.equal(result.predPayD1, 12.34)
	assert.equal(result.pred7DPay, 88.88)
	assert.equal(result.modelLabel, "Sales Forecast Python Model")
	assert.equal(
		result.requestUrl,
		"http://fastapi:54903/api/EMDMPAI/sales-forecast/predict",
	)
})
