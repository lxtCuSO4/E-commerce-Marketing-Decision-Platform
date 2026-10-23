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

export function unwrapAIProxyPayload(value) {
	let current = value
	const seen = new Set()

	while (current !== null && current !== undefined) {
		if (typeof current === "string" && current) {
			const parsed = parseJsonText(current)
			if (parsed === null) {
				return {}
			}
			current = parsed
			continue
		}

		if (Array.isArray(current)) {
			current = current[0] ?? {}
			continue
		}

		if (typeof current !== "object") {
			return {}
		}

		if (seen.has(current)) {
			return current
		}
		seen.add(current)

		if (current.data && typeof current.data === "object") {
			current = current.data
			continue
		}

		if (current.content && typeof current.content === "object") {
			current = current.content
			continue
		}

		return current
	}

	return {}
}

export function normalizeAIResponseArray(value) {
	if (Array.isArray(value)) {
		return value
	}

	if (typeof value === "string" && value) {
		const parsed = parseJsonText(value)
		return Array.isArray(parsed) ? parsed : []
	}

	return []
}
