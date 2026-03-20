import { request } from "@kesplus/kesplus"

export function getOverviewSummaryApi(params) {
	return request.get("/BOperationsModule/overviewSummary", {
		params,
		appPrefix: true,
	})
}

export function getMerchantDiagnosticsApi(params) {
	return request.get("/BOperationsModule/merchantDiagnosticsByPage", {
		params,
		appPrefix: true,
	})
}
