export function resolveReportDownloadUrl(pdfDownloadUrl, resolveFastAPIUrl) {
	if (!pdfDownloadUrl) {
		return ""
	}

	return /^https?:\/\//i.test(pdfDownloadUrl)
		? pdfDownloadUrl
		: resolveFastAPIUrl(pdfDownloadUrl)
}

export function startBrowserDownloadFromBlob(blob, filename = "emdmp-ai-report.pdf") {
	const objectUrl = URL.createObjectURL(blob)
	const link = document.createElement("a")

	try {
		link.href = objectUrl
		link.download = filename
		link.style.display = "none"
		document.body.appendChild(link)
		link.click()
	} finally {
		if (link.parentNode) {
			link.parentNode.removeChild(link)
		} else if (document.body?.removeChild) {
			document.body.removeChild(link)
		}
		URL.revokeObjectURL(objectUrl)
	}
}

export async function startBrowserDownloadFromUrl(url, filename = "emdmp-ai-report.pdf") {
	const response = await fetch(url, {
		method: "GET",
		credentials: "include",
	})

	if (!response.ok) {
		throw new Error(`PDF download request failed with error ${response.status}`)
	}

	const blob = await response.blob()
	startBrowserDownloadFromBlob(blob, filename)
}
