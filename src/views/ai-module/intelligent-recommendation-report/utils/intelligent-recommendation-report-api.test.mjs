import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const file = new URL("./intelligent-recommendation-report-api.js", import.meta.url)

test("report and marketing proxy requests wrap body in payload", async () => {
	const source = await readFile(file, "utf8")

	assert.match(
		source,
		/request\.post\("\/AiModule\/generateReportPreviewProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
	assert.match(
		source,
		/request\.post\("\/AiModule\/startGenerateReportProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
	assert.match(
		source,
		/request\.post\("\/AiModule\/generateReportPdfProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
	assert.match(
		source,
		/request\.post\("\/AiModule\/generateMarketingCopyProxy",\s*\{\s*payload:\s*params,\s*\},/s,
	)
})

test("report proxy requests log which route is being used", async () => {
	const source = await readFile(file, "utf8")

	assert.match(source, /console\.info\(`\[EMDMP_REPORT_ROUTE\] \$\{routeLabel\}`,\s*details\)/)
	assert.match(source, /logReportRoute\("generateReportPreviewProxy -> \/generate-report"/)
	assert.match(source, /logReportRoute\("startGenerateReportProxy -> \/generate-report\/start"/)
	assert.match(source, /logReportRoute\("getGenerateReportTaskProxy -> \/generate-report\/tasks"/)
})
