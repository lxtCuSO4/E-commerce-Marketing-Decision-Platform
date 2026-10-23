import test from "node:test"
import assert from "node:assert/strict"

import { normalizeReportResponsePayload } from "./report-response-normalizer.js"

test("normalizeReportResponsePayload supports KES browser-pdf report payload", () => {
	const result = normalizeReportResponsePayload({
		success: true,
		data: {
			content: JSON.stringify({
				reportTitle: "KES Report",
				summary: "KES Summary",
				analysisSections: [
					{ sectionTitle: "Section A", sectionContent: "Section content" },
				],
				recommendations: ["Recommendation A"],
				riskAlerts: ["Risk A"],
				actionItems: ["Action A"],
				pdfReady: true,
				pdfMode: "browser",
				pdfMessage: "Generate PDF in browser",
			}),
		},
	})

	assert.equal(result.reportTitle, "KES Report")
	assert.equal(result.summary, "KES Summary")
	assert.equal(result.analysisSections.length, 1)
	assert.equal(result.analysisSections[0].title, "Section A")
	assert.equal(result.analysisSections[0].content, "Section content")
	assert.deepEqual(result.recommendations, ["Recommendation A"])
	assert.deepEqual(result.riskAlerts, ["Risk A"])
	assert.deepEqual(result.actionItems, ["Action A"])
	assert.equal(result.pdfReady, true)
	assert.equal(result.pdfMode, "browser")
	assert.equal(result.pdfMessage, "Generate PDF in browser")
})
