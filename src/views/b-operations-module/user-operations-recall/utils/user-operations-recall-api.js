import { request } from "@kesplus/kesplus"

export function getUserOperationsRecallApi(params) {
	return request.get("/BOperationsModule/userOperationsRecallByPage", {
		params,
		appPrefix: true,
	})
}
