const DEFAULT_FASTAPI_BASE_URL = "http://127.0.0.1:54903"
const DEFAULT_FASTAPI_PORT = "54903"

function normalizeBaseUrl(value) {
	if (typeof value !== "string") {
		return ""
	}

	return value.trim().replace(/\/+$/, "")
}

function getBrowserFastAPIBaseUrl(runtime) {
	const protocol = normalizeBaseUrl(runtime?.location?.protocol).replace(/:$/, "")
	const hostname = runtime?.location?.hostname

	if (!protocol || !hostname) {
		return ""
	}

	return `${protocol}://${hostname}:${DEFAULT_FASTAPI_PORT}`
}

export function getFastAPIBaseURL(runtime = globalThis) {
	const configuredBaseUrl = normalizeBaseUrl(runtime?.__EMDMP_FASTAPI_BASE_URL)
		|| normalizeBaseUrl(runtime?.__KESPLUS_FASTAPI_BASE_URL)
		|| getBrowserFastAPIBaseUrl(runtime)

	return configuredBaseUrl || DEFAULT_FASTAPI_BASE_URL
}

export function resolveFastAPIUrl(path, runtime = globalThis) {
	return new URL(path, getFastAPIBaseURL(runtime)).toString()
}
