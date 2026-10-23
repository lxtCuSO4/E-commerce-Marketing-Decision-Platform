import test from "node:test"
import assert from "node:assert/strict"

import { buildReportPdfBlob, buildReportPdfLinePlan } from "./report-pdf-browser.js"

test("buildReportPdfBlob creates a pdf blob for structured report content", async () => {
	const blob = buildReportPdfBlob({
		reportTitle: "AI Business Report",
		summary: "Summary text",
		analysisSections: [
			{ title: "Performance", content: "Performance content" },
			{ title: "Conversion", content: "Conversion content" },
		],
		recommendations: ["Recommendation A"],
		riskAlerts: ["Risk A"],
		actionItems: ["Action A"],
	})

	assert.equal(blob.type, "application/pdf")

	const bytes = new Uint8Array(await blob.arrayBuffer())
	const header = new TextDecoder().decode(bytes.slice(0, 8))
	assert.match(header, /^%PDF-1\./)
})

test("buildReportPdfLinePlan uses chinese section headers and skips empty section bodies", () => {
	const lines = buildReportPdfLinePlan({
		reportTitle: "中文报告",
		summary: "这是摘要",
		analysisSections: [
			{ title: "流量表现分析", content: "" },
			{ title: "转化率诊断", content: "需要关注详情页转化。" },
		],
		recommendations: ["建议一"],
		riskAlerts: ["风险一"],
		actionItems: ["动作一"],
	})

	const texts = lines.map((line) => line.text)
	assert.ok(texts.includes("运营建议"))
	assert.ok(texts.includes("风险提示"))
	assert.ok(texts.includes("行动项"))
	assert.ok(texts.includes("转化率诊断"))
	assert.ok(!texts.includes("流量表现分析"))
})
