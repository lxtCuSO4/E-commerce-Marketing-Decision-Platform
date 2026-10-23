import { request } from "@kesplus/kesplus"

import { resolveFastAPIUrl } from "../../utils/fastapi-url.js"

export { resolveFastAPIUrl }

function logReportRoute(routeLabel, details = {}) {
	console.info(`[EMDMP_REPORT_ROUTE] ${routeLabel}`, details)
}

function normalizeObjectResult(result) {
	const payload = result?.data ?? result?.content ?? result

	if (payload && payload !== result) {
		return normalizeObjectResult(payload)
	}

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

	return result || {}
}

export function getItemRecommendationCandidatesApi(params) {
	return request.get("/AiModule/itemRecommendationCandidates", {
		params,
		appPrefix: true,
	})
}

export function getItemRecommendationByAIApi(params) {
	return request.get("/AiModule/itemRecommendationByAI", {
		params,
		appPrefix: true,
	})
}

export function generateBusinessReportByAIApi(params) {
	return request.post("/AiModule/generateBusinessReportByAIWithItems", params, {
		appPrefix: true,
	})
}

export async function generateBusinessReportPreviewByFastApi(params) {
	logReportRoute("generateReportPreviewProxy -> /generate-report", {
		itemCount: Array.isArray(params?.items) ? params.items.length : 0,
		reportType: params?.reportType || "business",
	})
	const result = await request.post("/AiModule/generateReportPreviewProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function startBusinessReportPreviewByFastApi(params) {
	logReportRoute("startGenerateReportProxy -> /generate-report/start", {
		itemCount: Array.isArray(params?.items) ? params.items.length : 0,
		reportType: params?.reportType || "business",
	})
	const result = await request.post("/AiModule/startGenerateReportProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function getBusinessReportEnhancementStatusByFastApi(taskId) {
	logReportRoute("getGenerateReportTaskProxy -> /generate-report/tasks", {
		taskId,
	})
	const result = await request.get("/AiModule/getGenerateReportTaskProxy", {
		params: {
			taskId,
			task_id: taskId,
		},
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function generateBusinessReportPdfByFastApi(params) {
	const result = await request.post("/AiModule/generateReportPdfProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function generateMarketingCopyByAIApi(params) {
	const result = await request.post("/AiModule/generateMarketingCopyProxy", {
		payload: params,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}
