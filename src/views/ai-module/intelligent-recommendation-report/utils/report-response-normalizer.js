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

function normalizeReportSections(value) {
	return normalizeAIResponseArray(value)
		.map((section, index) => {
			if (typeof section === "string") {
				return {
					title: `分析章节 ${index + 1}`,
					content: section,
				}
			}

			if (!section || typeof section !== "object") {
				return null
			}

			return {
				...section,
				title: section.title || section.sectionTitle || `分析章节 ${index + 1}`,
				content: section.content || section.sectionContent || section.text || section.summary || "",
			}
		})
		.filter(Boolean)
}

function normalizeMarketingCopyItems(value) {
	return normalizeAIResponseArray(value)
		.map((item) => {
			if (!item || typeof item !== "object") {
				return null
			}

			return {
				...item,
				headlineOptions: normalizeAIResponseArray(item.headlineOptions),
				sellingPoints: normalizeAIResponseArray(item.sellingPoints),
				shortPromotions: normalizeAIResponseArray(item.shortPromotions),
			}
		})
		.filter(Boolean)
}

export function normalizeReportResponsePayload(result, fallbackReport = {}) {
	const row = normalizeObject(unwrapAIProxyPayload(result))
	const content = row.content || row.reportContent || row.text || ""
	const parsedContent = normalizeObject(parseJsonText(content))
	const merged = parsedContent && Object.keys(parsedContent).length
		? { ...row, ...parsedContent }
		: row
	const fallback = normalizeObject(fallbackReport)
	const analysisSections = normalizeReportSections(merged.analysisSections)
	const recommendations = normalizeAIResponseArray(merged.recommendations)
	const riskAlerts = normalizeAIResponseArray(merged.riskAlerts)
	const actionItems = normalizeAIResponseArray(merged.actionItems)
	const summary = merged.summary || (typeof content === "string" ? content : "") || fallback.summary || ""

	return {
		reportTitle: merged.reportTitle || fallback.reportTitle || "AI 商业分析报告",
		summary,
		analysisSections: analysisSections.length
			? analysisSections
			: normalizeReportSections(fallback.analysisSections),
		recommendations: recommendations.length
			? recommendations
			: normalizeAIResponseArray(fallback.recommendations),
		riskAlerts: riskAlerts.length
			? riskAlerts
			: normalizeAIResponseArray(fallback.riskAlerts),
		actionItems: actionItems.length
			? actionItems
			: normalizeAIResponseArray(fallback.actionItems),
		pdfDownloadUrl: merged.pdfDownloadUrl || merged.downloadUrl || "",
		pdfReady: Boolean(merged.pdfReady || merged.pdfDownloadUrl || merged.downloadUrl),
		pdfMode: merged.pdfMode || "",
		pdfMessage: merged.pdfMessage || "",
		llmStatus:
			merged.enhancementStatus === "pending"
				? "pending"
				: merged.llmStatus || (summary ? "success" : fallback.llmStatus || "success"),
	}
}

export function normalizeMarketingCopyResponsePayload(result, fallbackDraft = {}) {
	const row = normalizeObject(unwrapAIProxyPayload(result))
	const content = row.content || row.text || ""
	const parsedContent = normalizeObject(parseJsonText(content))
	const merged = parsedContent && Object.keys(parsedContent).length
		? { ...row, ...parsedContent }
		: row
	const fallback = normalizeObject(fallbackDraft)
	const copies = normalizeMarketingCopyItems(merged.copies)
	const fallbackCopies = normalizeMarketingCopyItems(fallback.copies)
	const summary =
		merged.summary ||
		(typeof content === "string" && !copies.length ? content : "") ||
		fallback.summary ||
		""

	return {
		summary,
		copies: copies.length ? copies : fallbackCopies,
		llmStatus:
			merged.llmStatus ||
			(summary || copies.length || fallbackCopies.length ? "success" : "error"),
	}
}
