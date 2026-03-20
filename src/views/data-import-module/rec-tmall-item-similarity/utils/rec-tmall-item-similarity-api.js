import { request } from "@kesplus/kesplus"
const crudRoot = "/DataImportModule/recTmallItemSimilarity"
const searchRoot = "/DataImportModule/itemSimilarity"
export function addApi(params) {
	return request.post(crudRoot.concat("/add"), params, { appPrefix: true })
}
export function updateApi(params) {
	return request.put(crudRoot.concat("/update"), params, { appPrefix: true })
}
export function deleteApi(params) {
	return request.post(crudRoot.concat("/del"), params, { appPrefix: true })
}
export function detailApi(params) {
	return request.get(crudRoot.concat("/detail"), { params, appPrefix: true })
}
export function pageApi(params) {
	return request.get(crudRoot.concat("/page"), { params, appPrefix: true })
}
export function listApi(params) {
	return request.get(crudRoot.concat("/list"), { params, appPrefix: true })
}
export function getItemSimilarityByParamsApi(params) {
	return request.get(searchRoot, { params, appPrefix: true })
}
