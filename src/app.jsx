import { defineRuntimeConfig } from "@kesplus/kesplus"
import RecTmallItemBaseForm from "./views/data-import-module/rec-tmall-item-base/form.vue"
import RecTmallItemBaseDetail from "./views/data-import-module/rec-tmall-item-base/detail.vue"
import RecSalesForecastPredictionsDetail from "./views/sales-predict-module/rec-sales-forecast-predictions/detail.vue"

export function defineAccessConfig(memo) {
	memo.ignoreAccess ??= []
	memo.ignoreAccess.push("/home")
	memo.ignoreAccess.push("/data-import-module/rec-tmall-item-base/form")
	memo.ignoreAccess.push("/data-import-module/rec-tmall-item-base/detail")
	memo.ignoreAccess.push("/sales-predict-module/rec-sales-forecast-predictions/detail")
	return memo
}

export default defineRuntimeConfig({})

export function onAppCreated({ app }) {}

export function patchRoutes({ routes }) {
	const rootRoute = routes.find((item) => item.path === "/")
	const childRoutes = rootRoute?.children ?? []
	const formPath = "/data-import-module/rec-tmall-item-base/form"
	const itemDetailPath = "/data-import-module/rec-tmall-item-base/detail"
	const predictionDetailPath =
		"/sales-predict-module/rec-sales-forecast-predictions/detail"

	if (!childRoutes.some((item) => item.path === formPath)) {
		childRoutes.push({
			path: formPath,
			component: RecTmallItemBaseForm,
			name: "data-import-module_rec-tmall-item-base_form",
			props: (route) => ({
				id: route.query?.id ?? "",
			}),
			meta: {
				title: "商品基础信息表单",
				isHide: true,
			},
		})
	}

	if (!childRoutes.some((item) => item.path === itemDetailPath)) {
		childRoutes.push({
			path: itemDetailPath,
			component: RecTmallItemBaseDetail,
			name: "data-import-module_rec-tmall-item-base_detail",
			props: (route) => ({
				id: route.query?.id ?? "",
			}),
			meta: {
				title: "商品基础信息详情",
				isHide: true,
			},
		})
	}

	if (!childRoutes.some((item) => item.path === predictionDetailPath)) {
		childRoutes.push({
			path: predictionDetailPath,
			component: RecSalesForecastPredictionsDetail,
			name: "sales-predict-module_rec-sales-forecast-predictions_detail",
			props: (route) => ({
				id: route.query?.id ?? "",
			}),
			meta: {
				title: "销量预测结果可视化详情",
				isHide: true,
			},
		})
	}
}
