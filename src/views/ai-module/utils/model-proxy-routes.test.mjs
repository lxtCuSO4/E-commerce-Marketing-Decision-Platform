import test from "node:test"
import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"

const fileExpectations = [
	{
		file: new URL("../ai-product-qa/utils/ai-product-qa-api.js", import.meta.url),
		mustMatch: [/\/AiModule\/productQaChatProxy/],
		mustNotMatch: [/resolveFastAPIUrl\("\/api\/EMDMPAI\/product-qa\/chat"\)/],
	},
	{
		file: new URL(
			"../ai-competitor-analysis/utils/ai-competitor-analysis-api.js",
			import.meta.url,
		),
		mustMatch: [
			/\/AiModule\/generateCompetitorAnalysisProxy/,
			/\/AiModule\/startCompetitorAnalysisProxy/,
			/\/AiModule\/getCompetitorAnalysisTaskProxy/,
		],
		mustNotMatch: [
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/competitor-analysis"\)/,
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/competitor-analysis\/start"\)/,
		],
	},
	{
		file: new URL(
			"../intelligent-recommendation-report/utils/intelligent-recommendation-report-api.js",
			import.meta.url,
		),
		mustMatch: [
			/\/AiModule\/generateReportPreviewProxy/,
			/\/AiModule\/startGenerateReportProxy/,
			/\/AiModule\/getGenerateReportTaskProxy/,
			/\/AiModule\/generateReportPdfProxy/,
			/\/AiModule\/generateMarketingCopyProxy/,
		],
		mustNotMatch: [
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-report"\)/,
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-report\/start"\)/,
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-report-pdf"\)/,
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-marketing-copy"\)/,
		],
	},
	{
		file: new URL(
			"../user-behavior-analysis/utils/user-behavior-analysis-api.js",
			import.meta.url,
		),
		mustMatch: [
			/\/AiModule\/generateUserBehaviorDiagnosisProxy/,
			/\/AiModule\/startGenerateUserBehaviorDiagnosisProxy/,
			/\/AiModule\/getGenerateUserBehaviorDiagnosisTaskProxy/,
		],
		mustNotMatch: [
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-user-behavior-diagnosis"\)/,
			/resolveFastAPIUrl\("\/api\/EMDMPAI\/generate-user-behavior-diagnosis\/start"\)/,
		],
	},
]

for (const { file, mustMatch, mustNotMatch } of fileExpectations) {
	test(`model proxy route wiring: ${file.pathname.split("/").slice(-2).join("/")}`, async () => {
		const source = await readFile(file, "utf8")

		for (const pattern of mustMatch) {
			assert.match(source, pattern)
		}

		for (const pattern of mustNotMatch) {
			assert.doesNotMatch(source, pattern)
		}
	})
}
