import { unwrapAIProxyPayload } from "../../utils/ai-response-normalizer.js"

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

export function normalizeProductQaResult(result) {
	const row = normalizeObject(unwrapAIProxyPayload(result))
	const content = row.answer || row.content || row.text || ""
	const parsedContent = normalizeObject(parseJsonText(content))
	const merged = parsedContent && Object.keys(parsedContent).length
		? { ...row, ...parsedContent }
		: row
	const shortAnswer = String(merged.answer || "")
	const richContent = String(merged.content || merged.text || "")
	const answer = richContent.length > shortAnswer.length
		? richContent
		: String(shortAnswer || richContent)

	return {
		...merged,
		answer,
		content: answer,
		llmStatus: String(merged.llmStatus || "success"),
	}
}
