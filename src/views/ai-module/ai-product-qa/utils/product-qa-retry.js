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

	return result || {}
}

function hasMeaningfulQuestion(question) {
	const text = String(question ?? "").trim()
	return text.length >= 2
}

function normalizeAnswerText(result) {
	const answer = String(result?.answer || result?.content || result?.text || "").trim()
	return answer
}

function looksLikeProxyFallbackAnswer(answer) {
	if (!answer) return true

	const fallbackPatterns = [
		"没有拿到可展示的分析结果",
		"没能顺利拿到完整回答",
		"请补充商品",
		"请补充商家",
		"请补充类目",
		"请补充时间范围",
		"换个条件再试试",
		"更换锚点",
		"缩小筛选条件后重试",
	]

	return fallbackPatterns.some((pattern) => answer.includes(pattern))
}

export function shouldRetryProductQaWithFastApi(result, payload) {
	const normalized = normalizeObjectResult(result)
	if (!hasMeaningfulQuestion(payload?.question)) return false

	const llmStatus = String(normalized?.llmStatus || "").trim()
	if (llmStatus === "needs_clarification") return true
	if (llmStatus === "no_data" || llmStatus === "database_unavailable") return true

	const answer = normalizeAnswerText(normalized)
	if (looksLikeProxyFallbackAnswer(answer)) return true

	return false
}
