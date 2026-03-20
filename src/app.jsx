import { defineRuntimeConfig } from "@kesplus/kesplus"
import RecTmallItemBaseForm from "./views/data-import-module/rec-tmall-item-base/form.vue"
import RecTmallItemBaseDetail from "./views/data-import-module/rec-tmall-item-base/detail.vue"
import RecSalesForecastPredictionsDetail from "./views/sales-predict-module/rec-sales-forecast-predictions/detail.vue"

const OPERATIONS_MENU = {
	name: "运营中心",
	icon: "DataAnalysis",
	path: "/b-operations-module",
	url: "/b-operations-module",
	redirect: "/b-operations-module/overview-merchant-diagnostics",
	children: [
		{
			name: "运营总览与商家诊断",
			path: "/b-operations-module/overview-merchant-diagnostics",
			url: "/b-operations-module/overview-merchant-diagnostics",
		},
		{
			name: "用户运营与召回",
			path: "/b-operations-module/user-operations-recall",
			url: "/b-operations-module/user-operations-recall",
		},
	],
}

function pushUnique(list, ...items) {
	items.filter(Boolean).forEach((item) => {
		if (!list.includes(item)) {
			list.push(item)
		}
	})
}

function cloneMenu(menu) {
	return {
		...menu,
		children: menu.children?.map(cloneMenu),
	}
}

function isSameMenuNode(left, right) {
	if (!left || !right) {
		return false
	}

	return (
		(left.path && right.path && left.path === right.path) ||
		(left.url && right.url && left.url === right.url) ||
		(left.name && right.name && left.name === right.name)
	)
}

function ensureOperationsMenuTree(menus = []) {
	const result = Array.isArray(menus) ? menus.map(cloneMenu) : []
	const currentMenu = result.find((item) => isSameMenuNode(item, OPERATIONS_MENU))

	if (!currentMenu) {
		result.push(cloneMenu(OPERATIONS_MENU))
		return reorderOperationsMenu(result)
	}

	currentMenu.children ??= []
	currentMenu.icon ||= OPERATIONS_MENU.icon
	currentMenu.path ||= OPERATIONS_MENU.path
	currentMenu.url ||= OPERATIONS_MENU.url
	currentMenu.redirect ||= OPERATIONS_MENU.redirect

	OPERATIONS_MENU.children.forEach((child) => {
		const exists = currentMenu.children.some((item) => isSameMenuNode(item, child))
		if (!exists) {
			currentMenu.children.push(cloneMenu(child))
		}
	})

	return reorderOperationsMenu(result)
}

function isWorkbenchMenu(menu) {
	return menu?.path === "/home" || menu?.url === "/home" || menu?.name === "工作台"
}

function isSalesPredictMenu(menu) {
	const routeValue = menu?.path || menu?.url || ""
	return routeValue.startsWith("/sales-predict-module") || menu?.name === "销售预测"
}

function reorderOperationsMenu(menus) {
	const operationsIndex = menus.findIndex((item) => isSameMenuNode(item, OPERATIONS_MENU))

	if (operationsIndex < 0) {
		return menus
	}

	const [operationsMenu] = menus.splice(operationsIndex, 1)
	const salesIndex = menus.findIndex((item) => isSalesPredictMenu(item))

	if (salesIndex >= 0) {
		menus.splice(salesIndex, 0, operationsMenu)
		return menus
	}

	const workbenchIndex = menus.findIndex((item) => isWorkbenchMenu(item))

	if (workbenchIndex >= 0) {
		menus.splice(workbenchIndex + 1, 0, operationsMenu)
		return menus
	}

	menus.push(operationsMenu)
	return menus
}

export function defineAccessConfig(memo) {
	memo.ignoreAccess ??= []
	pushUnique(
		memo.ignoreAccess,
		"/home",
		"/data-import-module/rec-tmall-item-base/form",
		"/data-import-module/rec-tmall-item-base/detail",
		"/sales-predict-module/rec-sales-forecast-predictions/detail",
		"/b-operations-module/overview-merchant-diagnostics",
		"/b-operations-module/user-operations-recall",
	)
	return memo
}

export default defineRuntimeConfig({})

export function onAppCreated({ app }) {}

export function onBeforeMenuMount(memo) {
	return ensureOperationsMenuTree(memo)
}

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
