const PDF_PAGE_WIDTH = 595.28
const PDF_PAGE_HEIGHT = 841.89
const LEFT_MARGIN = 52
const RIGHT_MARGIN = 52
const TOP_MARGIN = 56
const BOTTOM_MARGIN = 56
const LINE_GAP = 8
const CANVAS_SCALE = 2

function canUseBrowserCanvas() {
	return typeof document !== "undefined" && typeof document.createElement === "function"
}

function estimateCharWidth(char, fontSize) {
	if (/[\u0000-\u00ff]/.test(char)) {
		if (char === " ") {
			return fontSize * 0.28
		}
		return fontSize * 0.55
	}

	return fontSize
}

function wrapText(text, maxWidth, fontSize) {
	const normalized = String(text || "").replace(/\r\n/g, "\n")
	if (!normalized) {
		return [""]
	}

	const lines = []
	for (const paragraph of normalized.split("\n")) {
		let current = ""
		let currentWidth = 0
		for (const char of paragraph) {
			const charWidth = estimateCharWidth(char, fontSize)
			if (current && currentWidth + charWidth > maxWidth) {
				lines.push(current)
				current = char
				currentWidth = charWidth
				continue
			}

			current += char
			currentWidth += charWidth
		}
		lines.push(current || "")
	}

	return lines
}

function normalizeBulletItems(values, fallbackTitlePrefix) {
	return (Array.isArray(values) ? values : [])
		.map((item, index) => {
			if (typeof item === "string") {
				return item
			}

			if (!item || typeof item !== "object") {
				return ""
			}

			const title = item.title || `${fallbackTitlePrefix}${index + 1}`
			const content = item.content || item.text || item.summary || ""
			return content ? `${title}: ${content}` : title
		})
		.filter(Boolean)
}

export function buildReportPdfLinePlan(report) {
	const contentWidth = PDF_PAGE_WIDTH - LEFT_MARGIN - RIGHT_MARGIN
	const lines = []
	const pushLine = (text, fontSize = 12, gapBefore = 0) => {
		if (!text && text !== "") {
			return
		}

		lines.push({
			text: String(text),
			fontSize,
			gapBefore,
			height: fontSize + LINE_GAP,
		})
	}

	pushLine(report.reportTitle || "AI Business Report", 20, 0)

	for (const line of wrapText(report.summary || "No summary available.", contentWidth, 12)) {
		pushLine(line, 12, 12)
	}

	for (const section of Array.isArray(report.analysisSections) ? report.analysisSections : []) {
		const title = section?.title || section?.sectionTitle || "分析章节"
		const content = section?.content || section?.sectionContent || section?.text || section?.summary || ""
		if (!String(content || "").trim()) {
			continue
		}
		pushLine(title, 15, 14)
		for (const line of wrapText(content, contentWidth, 12)) {
			pushLine(line, 12, 0)
		}
	}

	const recommendations = normalizeBulletItems(report.recommendations, "建议")
	if (recommendations.length) {
		pushLine("运营建议", 15, 14)
		for (const item of recommendations) {
			for (const line of wrapText(`- ${item}`, contentWidth, 12)) {
				pushLine(line, 12, 0)
			}
		}
	}

	const riskAlerts = normalizeBulletItems(report.riskAlerts, "风险")
	if (riskAlerts.length) {
		pushLine("风险提示", 15, 14)
		for (const item of riskAlerts) {
			for (const line of wrapText(`- ${item}`, contentWidth, 12)) {
				pushLine(line, 12, 0)
			}
		}
	}

	const actionItems = normalizeBulletItems(report.actionItems, "行动项")
	if (actionItems.length) {
		pushLine("行动项", 15, 14)
		for (const item of actionItems) {
			for (const line of wrapText(`- ${item}`, contentWidth, 12)) {
				pushLine(line, 12, 0)
			}
		}
	}

	return lines
}

function paginateLines(lines) {
	const pages = []
	let page = []
	let cursorY = PDF_PAGE_HEIGHT - TOP_MARGIN

	for (const line of lines) {
		const nextY = cursorY - line.gapBefore - line.height
		if (nextY < BOTTOM_MARGIN && page.length) {
			pages.push(page)
			page = []
			cursorY = PDF_PAGE_HEIGHT - TOP_MARGIN
		}

		cursorY -= line.gapBefore
		page.push({
			...line,
			y: cursorY,
		})
		cursorY -= line.height
	}

	if (page.length) {
		pages.push(page)
	}

	return pages.length
		? pages
		: [[{ text: "No content", fontSize: 12, y: PDF_PAGE_HEIGHT - TOP_MARGIN, height: 20, gapBefore: 0 }]]
}

function renderPageToJpeg(pageLines) {
	const canvas = document.createElement("canvas")
	canvas.width = Math.round(PDF_PAGE_WIDTH * CANVAS_SCALE)
	canvas.height = Math.round(PDF_PAGE_HEIGHT * CANVAS_SCALE)

	const ctx = canvas.getContext("2d")
	if (!ctx) {
		throw new Error("Canvas 2D context unavailable")
	}

	ctx.scale(CANVAS_SCALE, CANVAS_SCALE)
	ctx.fillStyle = "#ffffff"
	ctx.fillRect(0, 0, PDF_PAGE_WIDTH, PDF_PAGE_HEIGHT)
	ctx.textBaseline = "top"
	ctx.fillStyle = "#111827"

	for (const line of pageLines) {
		const fontWeight = line.fontSize >= 15 ? 700 : 400
		ctx.font = `${fontWeight} ${line.fontSize}px "Microsoft YaHei", "PingFang SC", "Noto Sans CJK SC", "SimSun", sans-serif`
		ctx.fillText(line.text, LEFT_MARGIN, PDF_PAGE_HEIGHT - line.y - line.fontSize)
	}

	return {
		width: canvas.width,
		height: canvas.height,
		dataUrl: canvas.toDataURL("image/jpeg", 0.92),
	}
}

function dataUrlToJpegBytes(dataUrl) {
	const base64 = String(dataUrl || "").split(",")[1] || ""
	const binary = atob(base64)
	const bytes = new Uint8Array(binary.length)
	for (let i = 0; i < binary.length; i += 1) {
		bytes[i] = binary.charCodeAt(i)
	}
	return bytes
}

function concatUint8Arrays(chunks) {
	const totalLength = chunks.reduce((sum, chunk) => sum + chunk.length, 0)
	const merged = new Uint8Array(totalLength)
	let offset = 0

	for (const chunk of chunks) {
		merged.set(chunk, offset)
		offset += chunk.length
	}

	return merged
}

function createBinaryPdfFromImages(images) {
	const encoder = new TextEncoder()
	const objectSpecs = []
	const addTextObject = (body) => {
		objectSpecs.push({ type: "text", body })
		return objectSpecs.length
	}
	const addImageObject = (width, height, bytes) => {
		objectSpecs.push({ type: "image", width, height, bytes })
		return objectSpecs.length
	}

	const catalogId = addTextObject("<< /Type /Catalog /Pages 2 0 R >>")
	const pagesId = addTextObject("<< /Type /Pages /Kids [] /Count 0 >>")

	const pageIds = []
	for (let index = 0; index < images.length; index += 1) {
		const image = images[index]
		const imageId = addImageObject(image.width, image.height, image.bytes)
		const imageName = `/Im${index + 1}`
		const contentStream = [
			"q",
			`${PDF_PAGE_WIDTH} 0 0 ${PDF_PAGE_HEIGHT} 0 0 cm`,
			`${imageName} Do`,
			"Q",
		].join("\n")
		const contentId = addTextObject(`<< /Length ${contentStream.length} >>\nstream\n${contentStream}\nendstream`)
		const pageId = addTextObject(
			`<< /Type /Page /Parent ${pagesId} 0 R /MediaBox [0 0 ${PDF_PAGE_WIDTH} ${PDF_PAGE_HEIGHT}] /Resources << /XObject << ${imageName} ${imageId} 0 R >> >> /Contents ${contentId} 0 R >>`,
		)
		pageIds.push(pageId)
	}

	objectSpecs[pagesId - 1] = {
		type: "text",
		body: `<< /Type /Pages /Kids [${pageIds.map((id) => `${id} 0 R`).join(" ")}] /Count ${pageIds.length} >>`,
	}

	const serializedObjects = objectSpecs.map((spec, index) => {
		const objectId = index + 1
		if (spec.type === "image") {
			const prefix = encoder.encode(
				`${objectId} 0 obj\n<< /Type /XObject /Subtype /Image /Width ${spec.width} /Height ${spec.height} /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode /Length ${spec.bytes.length} >>\nstream\n`,
			)
			const suffix = encoder.encode("\nendstream\nendobj\n")
			return concatUint8Arrays([prefix, spec.bytes, suffix])
		}

		return encoder.encode(`${objectId} 0 obj\n${spec.body}\nendobj\n`)
	})

	const header = encoder.encode("%PDF-1.4\n%\xE2\xE3\xCF\xD3\n")
	const offsets = [0]
	const bodyChunks = [header]
	let currentOffset = header.length

	for (const objectBytes of serializedObjects) {
		offsets.push(currentOffset)
		bodyChunks.push(objectBytes)
		currentOffset += objectBytes.length
	}

	const xrefOffset = currentOffset
	const xrefLines = [`xref\n0 ${serializedObjects.length + 1}\n`, "0000000000 65535 f \n"]
	for (let i = 1; i < offsets.length; i += 1) {
		xrefLines.push(`${String(offsets[i]).padStart(10, "0")} 00000 n \n`)
	}

	const trailer = `trailer\n<< /Size ${serializedObjects.length + 1} /Root ${catalogId} 0 R >>\nstartxref\n${xrefOffset}\n%%EOF`
	return concatUint8Arrays([
		...bodyChunks,
		encoder.encode(xrefLines.join("")),
		encoder.encode(trailer),
	])
}

function createFallbackPdfBytes() {
	const encoder = new TextEncoder()
	const body = "%PDF-1.4\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595.28 841.89] >>\nendobj\nxref\n0 4\n0000000000 65535 f \n0000000009 00000 n \n0000000058 00000 n \n0000000115 00000 n \ntrailer\n<< /Size 4 /Root 1 0 R >>\nstartxref\n186\n%%EOF"
	return encoder.encode(body)
}

export function buildReportPdfBlob(report) {
	if (!canUseBrowserCanvas()) {
		return new Blob([createFallbackPdfBytes()], { type: "application/pdf" })
	}

	const lines = buildReportPdfLinePlan(report)
	const pages = paginateLines(lines)
	const images = pages.map((pageLines) => {
		const jpeg = renderPageToJpeg(pageLines)
		return {
			width: jpeg.width,
			height: jpeg.height,
			bytes: dataUrlToJpegBytes(jpeg.dataUrl),
		}
	})

	return new Blob([createBinaryPdfFromImages(images)], { type: "application/pdf" })
}
