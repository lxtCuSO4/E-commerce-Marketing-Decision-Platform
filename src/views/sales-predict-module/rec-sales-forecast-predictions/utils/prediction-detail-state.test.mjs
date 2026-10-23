import test from "node:test"
import assert from "node:assert/strict"

import {
	createPredictionDetailState,
	buildDisplayedPredictionMetrics,
	formatPredictionMetric,
} from "./prediction-detail-state.js"

test("createPredictionDetailState keeps prediction values for online prediction detail", () => {
	const result = createPredictionDetailState(
		{
			itemId: 480807,
			anchorDate: "2013-09-23",
			category: "10-5434",
			brandId: "b1252",
			sellerId: "s31542",
			payCnt7D: 0,
			payCnt30D: 2,
			predPayD1: 1,
			predPayD2: 2,
			predPayD3: 3,
			predPayD4: 4,
			predPayD5: 5,
			predPayD6: 6,
			predPayD7: 7,
			pred7DPay: 28,
		},
		true,
	)

	assert.equal(result.hasOnlinePredictionData, true)
	assert.deepEqual(result.chartValues, [1, 2, 3, 4, 5, 6, 7])
	assert.equal(result.form.pred7DPay, 28)
})

test("createPredictionDetailState clears prediction values for non-online detail", () => {
	const result = createPredictionDetailState(
		{
			itemId: 480807,
			anchorDate: "2013-09-23",
			category: "10-5434",
			brandId: "b1252",
			sellerId: "s31542",
			payCnt7D: 0,
			payCnt30D: 2,
			predPayD1: 1,
			predPayD2: 2,
			predPayD3: 3,
			predPayD4: 4,
			predPayD5: 5,
			predPayD6: 6,
			predPayD7: 7,
			pred7DPay: 28,
		},
		false,
	)

	assert.equal(result.hasOnlinePredictionData, false)
	assert.deepEqual(result.chartValues, [null, null, null, null, null, null, null])
	assert.equal(result.form.predPayD1, "")
	assert.equal(result.form.pred7DPay, "")
	assert.equal(result.form.itemId, 480807)
})

test("formatPredictionMetric keeps the existing two-decimal display rule", () => {
	assert.equal(formatPredictionMetric(0.0033299633765831588), "0.00")
	assert.equal(formatPredictionMetric(12.345), "12.35")
	assert.equal(formatPredictionMetric(""), "-")
})

test("buildDisplayedPredictionMetrics sums the displayed daily values instead of raw pred7DPay", () => {
	const metrics = buildDisplayedPredictionMetrics({
		horizonDays: 7,
		predPayD1: 0.00022643006828049542,
		predPayD2: 0.0008514873612352878,
		predPayD3: 0.0009135782771306105,
		predPayD4: 0.001272976535332955,
		predPayD5: 0.0007978389603283302,
		predPayD6: 0.0026295882133366318,
		predPayD7: 0.0033299633765831588,
		pred7DPay: 0.01,
	})

	assert.deepEqual(
		metrics.map((item) => item.value),
		["0.00", "0.00", "0.00", "0.00", "0.00", "0.00", "0.00", "0.00"],
	)
	assert.equal(metrics.at(-1).label, "7D SUM")
	assert.equal(metrics.at(-1).value, "0.00")
})
