import { request } from "@kesplus/kesplus"

const crudRoot = "/SalesPredictModule/recSalesForecastPredictions"
const searchRoot = "/SalesPredictModule/salesForecastPredictions"

function normalizeObjectResult(result) {
	if (Array.isArray(result)) {
		return result[0] || {}
	}

	if (typeof result === "string" && result) {
		try {
			const parsed = JSON.parse(result)
			return Array.isArray(parsed) ? parsed[0] || {} : parsed || {}
		} catch (error) {
			return {}
		}
	}

	if (
		result
		&& typeof result === "object"
		&& !Array.isArray(result)
		&& result.data
		&& typeof result.data === "object"
		&& !Array.isArray(result.data)
	) {
		return {
			...result,
			...result.data,
			data: result.data,
		}
	}

	return result || {}
}
export function addApi(params) {
	return request.post(crudRoot.concat("/add"), params, { appPrefix: true })
}

export function updateApi(params) {
	return request.put(crudRoot.concat("/update"), params, { appPrefix: true })
}

export function deleteApi(params) {
	return request.post(crudRoot.concat("/del"), params, { appPrefix: true })
}

export function detailApi(params) {
	return request.get(crudRoot.concat("/detail"), { params, appPrefix: true })
}

export function pageApi(params) {
	return request.get(crudRoot.concat("/page"), { params, appPrefix: true })
}

export function listApi(params) {
	return request.get(crudRoot.concat("/list"), { params, appPrefix: true })
}

export function getSalesForecastPredictionsByParamsApi(params) {
	return request.get(searchRoot, { params, appPrefix: true })
}

export function getSalesForecastPredictionDetailApi(params) {
	return request.get("/SalesPredictModule/salesForecastPredictionDetail", {
		params,
		appPrefix: true,
	})
}

export async function predictSalesForecastOnlineApi(params) {
	const result = await request.post(
		"/SalesPredictModule/predictSalesForecastOnline",
		{
			itemId: params?.itemId,
			item_id: params?.itemId,
			anchorDate: params?.anchorDate,
			anchor_date: params?.anchorDate,
			horizonDays: params?.horizonDays ?? 7,
			horizon_days: params?.horizonDays ?? 7,
			featureData: params?.featureData ?? {},
			feature_data: params?.featureData ?? {},
		},
		{
			appPrefix: true,
			ignoreError: true,
		},
	)

	return normalizeObjectResult(result)
}
