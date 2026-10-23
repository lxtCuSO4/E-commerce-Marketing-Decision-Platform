import test from "node:test"
import assert from "node:assert/strict"

import {
	resolveReportDownloadUrl,
	startBrowserDownloadFromBlob,
	startBrowserDownloadFromUrl,
} from "./report-download.js"

test("resolveReportDownloadUrl keeps absolute urls", () => {
	assert.equal(
		resolveReportDownloadUrl("https://example.com/files/report.pdf", (value) => `http://127.0.0.1:54903${value}`),
		"https://example.com/files/report.pdf",
	)
})

test("resolveReportDownloadUrl resolves relative urls with provided resolver", () => {
	assert.equal(
		resolveReportDownloadUrl("/files/report.pdf", (value) => `http://127.0.0.1:54903${value}`),
		"http://127.0.0.1:54903/files/report.pdf",
	)
})

test("startBrowserDownloadFromUrl fetches file and clicks hidden anchor", async () => {
	const originalFetch = globalThis.fetch
	const originalDocument = globalThis.document
	const originalURL = globalThis.URL

	const clicked = []
	const appended = []
	const removed = []
	const revoked = []
	const blobValue = { type: "application/pdf" }

	globalThis.fetch = async (url) => ({
		ok: true,
		blob: async () => ({ ...blobValue, requestedUrl: url }),
	})

	globalThis.URL = {
		createObjectURL(blob) {
			assert.equal(blob.requestedUrl, "http://127.0.0.1:54903/files/report.pdf")
			return "blob:report"
		},
		revokeObjectURL(url) {
			revoked.push(url)
		},
	}

	globalThis.document = {
		body: {
			appendChild(node) {
				appended.push(node)
			},
			removeChild(node) {
				removed.push(node)
			},
		},
		createElement(tag) {
			assert.equal(tag, "a")
			return {
				href: "",
				download: "",
				style: {},
				click() {
					clicked.push({ href: this.href, download: this.download })
				},
			}
		},
	}

	try {
		await startBrowserDownloadFromUrl("http://127.0.0.1:54903/files/report.pdf", "emdmp-report.pdf")
	} finally {
		globalThis.fetch = originalFetch
		globalThis.document = originalDocument
		globalThis.URL = originalURL
	}

	assert.equal(appended.length, 1)
	assert.equal(removed.length, 1)
	assert.deepEqual(clicked, [
		{ href: "blob:report", download: "emdmp-report.pdf" },
	])
	assert.deepEqual(revoked, ["blob:report"])
})

test("startBrowserDownloadFromBlob clicks hidden anchor with object url", () => {
	const originalDocument = globalThis.document
	const originalURL = globalThis.URL
	const clicked = []
	const revoked = []

	globalThis.URL = {
		createObjectURL() {
			return "blob:report-blob"
		},
		revokeObjectURL(url) {
			revoked.push(url)
		},
	}

	globalThis.document = {
		body: {
			appendChild() {},
			removeChild() {},
		},
		createElement() {
			return {
				href: "",
				download: "",
				style: {},
				click() {
					clicked.push({ href: this.href, download: this.download })
				},
			}
		},
	}

	try {
		startBrowserDownloadFromBlob(new Blob(["pdf"], { type: "application/pdf" }), "browser-report.pdf")
	} finally {
		globalThis.document = originalDocument
		globalThis.URL = originalURL
	}

	assert.deepEqual(clicked, [{ href: "blob:report-blob", download: "browser-report.pdf" }])
	assert.deepEqual(revoked, ["blob:report-blob"])
})

test("startBrowserDownloadFromUrl throws when download request fails", async () => {
	const originalFetch = globalThis.fetch
	globalThis.fetch = async () => ({ ok: false, status: 503 })

	try {
		await assert.rejects(
			() => startBrowserDownloadFromUrl("http://127.0.0.1:54903/files/report.pdf"),
			/error 503/i,
		)
	} finally {
		globalThis.fetch = originalFetch
	}
})
