export function formatPredictionMetric(value) {
	if (value === null || value === undefined || value === "") {
		return "-"
	}

	const numericValue = Number(value)
	return Number.isFinite(numericValue) ? numericValue.toFixed(2) : value
}

export function buildDisplayedPredictionMetrics(result = {}) {
	const horizonDays = Number(result?.horizonDays || 7)
	const metrics = Array.from({ length: horizonDays }, (_, index) => {
		const rawValue = result?.[`predPayD${index + 1}`]
		return {
			label: `D${index + 1}`,
			value: formatPredictionMetric(rawValue),
		}
	})

	const displayedSum = metrics.reduce((sum, metric) => {
		const numericValue = Number(metric.value)
		return Number.isFinite(numericValue) ? sum + numericValue : sum
	}, 0)

	metrics.push({
		label: "7D SUM",
		value: formatPredictionMetric(displayedSum),
	})

	return metrics
}

export function createPredictionDetailState(row = {}, includePredictionData = false) {
	const chartValues = includePredictionData
		? [
				row.predPayD1 ?? null,
				row.predPayD2 ?? null,
				row.predPayD3 ?? null,
				row.predPayD4 ?? null,
				row.predPayD5 ?? null,
				row.predPayD6 ?? null,
				row.predPayD7 ?? null,
			]
		: [null, null, null, null, null, null, null]

	return {
		hasOnlinePredictionData: includePredictionData,
		form: {
			id: row.id ?? "",
			itemId: row.itemId ?? "",
			anchorDate: row.anchorDate ?? "",
			category: row.category ?? "",
			brandId: row.brandId ?? "",
			sellerId: row.sellerId ?? "",
			payCnt7D: row.payCnt7D ?? "",
			payCnt30D: row.payCnt30D ?? "",
			predPayD1: includePredictionData ? row.predPayD1 ?? "" : "",
			predPayD2: includePredictionData ? row.predPayD2 ?? "" : "",
			predPayD3: includePredictionData ? row.predPayD3 ?? "" : "",
			predPayD4: includePredictionData ? row.predPayD4 ?? "" : "",
			predPayD5: includePredictionData ? row.predPayD5 ?? "" : "",
			predPayD6: includePredictionData ? row.predPayD6 ?? "" : "",
			predPayD7: includePredictionData ? row.predPayD7 ?? "" : "",
			pred7DPay: includePredictionData ? row.pred7DPay ?? "" : "",
		},
		chartValues,
	}
}
