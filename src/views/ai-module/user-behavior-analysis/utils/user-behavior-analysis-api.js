import { request } from "@kesplus/kesplus"

import { resolveFastAPIUrl } from "../../utils/fastapi-url.js"

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

function normalizePagedResult(result) {
	const payload = result?.data ?? result?.content ?? result

	if (payload && payload !== result) {
		return normalizePagedResult(payload)
	}

	if (typeof result === "string" && result) {
		try {
			return normalizePagedResult(JSON.parse(result))
		} catch (error) {
			return {
				totalElements: 0,
				content: [],
			}
		}
	}

	if (Array.isArray(result)) {
		return {
			totalElements: result.length,
			content: result,
			summary: {},
		}
	}

	return {
		totalElements: Number(result?.totalElements ?? 0),
		content: Array.isArray(result?.content) ? result.content : [],
		summary: normalizeObjectResult(result?.summary),
	}
}

export { resolveFastAPIUrl }

export async function getUserBehaviorAnalysisSummaryApi(params) {
	const result = await request.get("/AiModule/userBehaviorAnalysisSummaryV2", {
		params,
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeObjectResult(result)
}

export async function getUserBehaviorAnalysisByPageApi(params) {
	const result = await request.get("/AiModule/userBehaviorAnalysisByPageV2", {
		params,
		appPrefix: true,
		ignoreError: true,
	})
	return normalizePagedResult(result)
}

export async function getUserBehaviorAnalysisFallbackApi(params) {
	const result = await request.get("/AiModule/itemRecommendationCandidates", {
		params,
		appPrefix: true,
		ignoreError: true,
	})
	return normalizePagedResult(result)
}

export async function generateUserBehaviorDiagnosisByFastApi(params) {
	const result = await request.post(
		"/AiModule/generateUserBehaviorDiagnosisProxy",
		{
			payload: params,
		},
		{
			appPrefix: true,
			ignoreError: true,
		},
	)
	return normalizeObjectResult(result)
}

export async function startUserBehaviorDiagnosisByFastApi(params) {
	const result = await request.post(
		"/AiModule/startGenerateUserBehaviorDiagnosisProxy",
		{
			payload: params,
		},
		{
			appPrefix: true,
			ignoreError: true,
		},
	)
	return normalizeObjectResult(result)
}

export async function getUserBehaviorDiagnosisEnhancementStatusByFastApi(taskId) {
	const result = await request.get(
		"/AiModule/getGenerateUserBehaviorDiagnosisTaskProxy",
		{
			params: {
				taskId,
				task_id: taskId,
			},
			appPrefix: true,
			ignoreError: true,
		},
	)
	return normalizeObjectResult(result)
}
