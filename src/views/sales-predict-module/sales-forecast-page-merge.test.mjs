import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const featurePageUrl = new URL(
	"./rec-tmall-sales-forecast-feature/index.vue",
	import.meta.url,
)
const predictionsPageUrl = new URL(
	"./rec-sales-forecast-predictions/index.vue",
	import.meta.url,
)

test("feature page exposes online prediction summary and visual detail entry", async () => {
	const source = await readFile(featurePageUrl, "utf8")

	assert.match(source, /在线预测/)
	assert.match(source, /查看可视化详情/)
	assert.match(source, /saveOnlinePredictionSnapshot/)
	assert.match(source, /getNextSelectedPredictionRow/)
	assert.match(source, /predictSalesForecastOnlineApi/)
	assert.match(
		source,
		/\/sales-predict-module\/rec-sales-forecast-predictions\/detail\?predictionKey=/,
	)
})

test("legacy predictions list route redirects to the feature page", async () => {
	const source = await readFile(predictionsPageUrl, "utf8")

	assert.match(source, /router\.replace\("\/sales-predict-module\/rec-tmall-sales-forecast-feature"\)/)
	assert.doesNotMatch(source, /销售预测历史结果/)
})
