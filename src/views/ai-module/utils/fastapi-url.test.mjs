import test from "node:test"
import assert from "node:assert/strict"

import {
	getFastAPIBaseURL,
	resolveFastAPIUrl,
} from "./fastapi-url.js"

test("getFastAPIBaseURL falls back to localhost when runtime location is unavailable", () => {
	assert.equal(getFastAPIBaseURL({}), "http://127.0.0.1:54903")
})

test("getFastAPIBaseURL uses current browser host with the FastAPI port", () => {
	assert.equal(
		getFastAPIBaseURL({
			location: {
				protocol: "http:",
				hostname: "139.196.38.53",
			},
		}),
		"http://139.196.38.53:54903",
	)
})

test("getFastAPIBaseURL uses localhost with the FastAPI port in local development", () => {
	assert.equal(
		getFastAPIBaseURL({
			location: {
				protocol: "http:",
				hostname: "localhost",
			},
		}),
		"http://localhost:54903",
	)
})

test("getFastAPIBaseURL prefers explicit EMDMP runtime config", () => {
	assert.equal(
		getFastAPIBaseURL({
			__EMDMP_FASTAPI_BASE_URL: " https://fastapi.internal:8443/ ",
		}),
		"https://fastapi.internal:8443",
	)
})

test("getFastAPIBaseURL falls back to shared runtime config when present", () => {
	assert.equal(
		getFastAPIBaseURL({
			__KESPLUS_FASTAPI_BASE_URL: "http://runtime-fastapi:54903/",
		}),
		"http://runtime-fastapi:54903",
	)
})

test("resolveFastAPIUrl appends API paths against the configured base URL", () => {
	assert.equal(
		resolveFastAPIUrl("/api/EMDMPAI/health", {
			__EMDMP_FASTAPI_BASE_URL: "http://fastapi:54903",
		}),
		"http://fastapi:54903/api/EMDMPAI/health",
	)
})
