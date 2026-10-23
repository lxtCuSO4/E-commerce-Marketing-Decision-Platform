const STORAGE_PREFIX = "emdmp:sales-forecast:online:"

function resolveStorage(storage) {
	if (storage) return storage
	if (typeof window !== "undefined" && window.sessionStorage) {
		return window.sessionStorage
	}
	return null
}

export function saveOnlinePredictionSnapshot(snapshot, storage) {
	const targetStorage = resolveStorage(storage)
	if (!targetStorage || !snapshot || typeof snapshot !== "object") {
		return ""
	}

	const key = `${STORAGE_PREFIX}${Date.now()}-${Math.random().toString(36).slice(2, 10)}`
	targetStorage.setItem(key, JSON.stringify(snapshot))
	return key
}

export function readOnlinePredictionSnapshot(key, storage) {
	if (!key) {
		return null
	}

	const targetStorage = resolveStorage(storage)
	if (!targetStorage) {
		return null
	}

	const rawValue = targetStorage.getItem(key)
	if (!rawValue) {
		return null
	}

	try {
		return JSON.parse(rawValue)
	} catch {
		targetStorage.removeItem(key)
		return null
	}
}
