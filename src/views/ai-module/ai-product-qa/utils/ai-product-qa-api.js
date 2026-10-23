import { request } from "@kesplus/kesplus"

import { normalizeProductQaResult } from "./product-qa-response-normalizer.js"

const TRANSPORT_B64_PREFIX = "__EMDMP_B64__:"

function encodeTransportText(value) {
	const text = String(value ?? "")
	if (!text) {
		return text
	}

	const bytes = new TextEncoder().encode(text)
	let binary = ""
	for (const byte of bytes) {
		binary += String.fromCharCode(byte)
	}
	return `${TRANSPORT_B64_PREFIX}${btoa(binary)}`
}

function encodeItemContext(context) {
	if (!context || typeof context !== "object") {
		return context
	}

	return {
		...context,
		title: encodeTransportText(context.title),
		category: encodeTransportText(context.category),
		recommendationLevel: encodeTransportText(context.recommendationLevel),
		recommendationReason: encodeTransportText(context.recommendationReason),
	}
}

function encodeChatPayload(payload) {
	if (!payload || typeof payload !== "object") {
		return payload
	}

	return {
		...payload,
		question: encodeTransportText(payload.question),
		draftAnswer: encodeTransportText(payload.draftAnswer),
		messages: Array.isArray(payload.messages)
			? payload.messages.map((item) => ({
				...item,
				content: encodeTransportText(item?.content),
			}))
			: [],
		itemContext: encodeItemContext(payload.itemContext),
	}
}

export async function productQaChatApi(params) {
	const encodedPayload = encodeChatPayload(params)
	const result = await request.post("/AiModule/productQaChatProxy", {
		payload: encodedPayload,
	}, {
		appPrefix: true,
		ignoreError: true,
	})
	return normalizeProductQaResult(result)
}

export async function productQaHotQuestionsApi(params = {}) {
	return {
		success: true,
		questions: [],
		params,
	}
}
