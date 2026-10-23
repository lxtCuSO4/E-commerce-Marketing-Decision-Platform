import { request } from "@kesplus/kesplus"
import { resolveFastAPIUrl } from "../../utils/fastapi-url.js"

function normalizeArrayResult(result) {
	if (Array.isArray(result)) {
		return result
	}

	if (typeof result === "string" && result) {
		try {
			const parsed = JSON.parse(result)
			return Array.isArray(parsed) ? parsed : []
		} catch (error) {
			return []
		}
	}

	if (Array.isArray(result?.content)) {
		return result.content
	}

	return []
}

function normalizeListResult(result) {
	if (Array.isArray(result)) {
		return result
	}

	if (typeof result === "string" && result) {
		try {
			const parsed = JSON.parse(result)
			if (Array.isArray(parsed)) {
				return parsed
			}
			return parsed && typeof parsed === "object" ? [parsed] : []
		} catch (error) {
			return []
		}
	}

	if (Array.isArray(result?.content)) {
		return result.content
	}

	return result && typeof result === "object" ? [result] : []
}

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

function shouldRetryCompetitorTrendWithFastApi(result) {
	if (!result || typeof result !== "object") {
		return true
	}

	if (result.success === true) {
		return false
	}

	const requestUrl = String(result.requestUrl || "")
	return requestUrl.includes("/api/EMDMP/sales-forecast/predict")
		|| String(result.errorCode || "") === "forward_failed"
		|| String(result.errorCode || "") === "invalid_response"
}

export async function getCompetitorSimilarityCandidatesApi(params) {
	const result = await request.get("/DataImportModule/itemSimilarity", {
		params,
		appPrefix: true,
	})
	return normalizeArrayResult(result)
}

export async function searchItemCandidatesApi(params) {
	const result = await request.get("/DataImportModule/item", {
		params,
		appPrefix: true,
	})
	return normalizeListResult(result)
}

export async function getItemBaseByItemIdApi(params) {
	const result = await request.get("/DataImportModule/item", {
		params,
		appPrefix: true,
	})
	return normalizeObjectResult(result)
}

export async function getItemSalesByItemIdApi(params) {
	const result = await request.get("/DataImportModule/itemSales", {
		params,
		appPrefix: true,
	})
	return normalizeArrayResult(result)
}

export async function getLatestSalesFeatureByItemIdApi(params) {
	const result = await request.get("/SalesPredictModule/salesForecastFeature", {
		params,
		appPrefix: true,
	})
	return normalizeArrayResult(result)
}

export async function getSalesForecastPredictionByItemIdApi(params) {
	const result = await request.get("/SalesPredictModule/salesForecastPredictions", {
		params,
		appPrefix: true,
	})
	return normalizeArrayResult(result)
}

export async function predictCompetitorTrendByLiveForecastApi(params) {
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

	const normalizedResult = normalizeObjectResult(result)
	if (!shouldRetryCompetitorTrendWithFastApi(normalizedResult)) {
		return normalizedResult
	}

	const directResult = await request.post(
		resolveFastAPIUrl("/api/EMDMPAI/sales-forecast/predict"),
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
			appPrefix: false,
			ignoreError: true,
		},
	)

	return normalizeObjectResult(directResult)
}

export async function generateCompetitorAnalysisByAIApi(params) {
	const result = await request.post("/AiModule/generateCompetitorAnalysisProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function startCompetitorAnalysisByAIApi(params) {
	const result = await request.post("/AiModule/startCompetitorAnalysisProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function getCompetitorAnalysisEnhancementStatusByAIApi(taskId) {
	return request.get("/AiModule/getCompetitorAnalysisTaskProxy", {
		params: {
			taskId,
			task_id: taskId,
		},
		appPrefix: true,
		ignoreError: true,
	})
}
