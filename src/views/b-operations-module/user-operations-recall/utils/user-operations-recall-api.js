import { request } from "@kesplus/kesplus"

export function getUserOperationsRecallSummaryApi(params) {
	return request.get("/BOperationsModule/userOperationsRecallSummary", {
		params,
		appPrefix: true,
	})
}

export function getUserOperationsRecallApi(params) {
	return request.get("/BOperationsModule/userOperationsRecallByPage", {
		params,
		appPrefix: true,
	})
}
