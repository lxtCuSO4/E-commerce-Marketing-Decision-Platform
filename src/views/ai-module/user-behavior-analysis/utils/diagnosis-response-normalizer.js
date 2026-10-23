import { normalizeAIResponseArray, unwrapAIProxyPayload } from "../../utils/ai-response-normalizer.js"

function parseJsonText(value) {
	if (typeof value !== "string" || !value) {
		return null
	}

	try {
		return JSON.parse(value)
	} catch (error) {
		return null
	}
}

function normalizeObject(value) {
	if (Array.isArray(value)) {
		return value[0] || {}
	}

	if (typeof value === "string" && value) {
		const parsed = parseJsonText(value)
		if (parsed === null) {
			return {}
		}
		return normalizeObject(parsed)
	}

	return value && typeof value === "object" ? value : {}
}

function normalizeSections(value) {
	return normalizeAIResponseArray(value)
		.map((section, index) => {
			if (typeof section === "string") {
				return {
					title: `诊断章节 ${index + 1}`,
					content: section,
				}
			}

			if (!section || typeof section !== "object") {
				return null
			}

			return {
				...section,
				title: section.title || `诊断章节 ${index + 1}`,
				content: section.content || section.text || section.summary || "",
			}
		})
		.filter(Boolean)
}

export function normalizeDiagnosisResponsePayload(result, fallbackTitle = "", fallbackDraft = {}) {
	const row = normalizeObject(unwrapAIProxyPayload(result))
	const content = row.content || row.reportContent || row.text || ""
	const parsedContent = normalizeObject(parseJsonText(content))
	const merged = parsedContent && Object.keys(parsedContent).length
		? { ...row, ...parsedContent }
		: row
	const fallback = normalizeObject(fallbackDraft)
	const analysisSections = normalizeSections(merged.analysisSections)
	const recommendations = normalizeAIResponseArray(merged.recommendations)
	const riskAlerts = normalizeAIResponseArray(merged.riskAlerts)

	return {
		title: String(merged.title || fallback.title || fallbackTitle || ""),
		summary: String(merged.summary || (typeof content === "string" ? content : "") || fallback.summary || ""),
		analysisSections: analysisSections.length ? analysisSections : normalizeSections(fallback.analysisSections),
		recommendations: recommendations.length
			? recommendations
			: normalizeAIResponseArray(fallback.recommendations),
		riskAlerts: riskAlerts.length ? riskAlerts : normalizeAIResponseArray(fallback.riskAlerts),
		llmStatus: String(merged.llmStatus || fallback.llmStatus || "success"),
	}
}
