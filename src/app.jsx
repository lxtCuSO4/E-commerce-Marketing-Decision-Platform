import { defineRuntimeConfig } from "@kesplus/kesplus"
import AICompetitorAnalysis from "./views/ai-module/ai-competitor-analysis/index.vue"
import AIProductQa from "./views/ai-module/ai-product-qa/index.vue"
import IntelligentRecommendationReport from "./views/ai-module/intelligent-recommendation-report/index.vue"
import UserBehaviorAnalysis from "./views/ai-module/user-behavior-analysis/index.vue"
import RecTmallItemBaseDetail from "./views/data-import-module/rec-tmall-item-base/detail.vue"
import RecTmallItemBaseForm from "./views/data-import-module/rec-tmall-item-base/form.vue"
import RecSalesForecastPredictionsDetail from "./views/sales-predict-module/rec-sales-forecast-predictions/detail.vue"
import { initialState } from "@@/initialState"
import { getSidebarLogo, withStableMenuIds } from "./utils/layout-runtime.js"

const AI_MENU = {
	name: "AI 智能分析",
	icon: "MagicStick",
	path: "/ai-module",
	url: "/ai-module",
	redirect: "/ai-module/intelligent-recommendation-report",
	children: [
		{
			name: "智能推荐与报告",
			path: "/ai-module/intelligent-recommendation-report",
			url: "/ai-module/intelligent-recommendation-report",
		},
		{
			name: "竞品智能分析",
			path: "/ai-module/ai-competitor-analysis",
			url: "/ai-module/ai-competitor-analysis",
		},
		{
			name: "商品问答助手",
			path: "/ai-module/ai-product-qa",
			url: "/ai-module/ai-product-qa",
		},
		{
			name: "用户行为分析",
			path: "/ai-module/user-behavior-analysis",
			url: "/ai-module/user-behavior-analysis",
		},
	],
}

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

function ensureMenuTree(menus = [], targetMenu) {
	const result = Array.isArray(menus) ? menus.map(cloneMenu) : []
	const currentMenu = result.find((item) => isSameMenuNode(item, targetMenu))

	if (!currentMenu) {
		result.push(cloneMenu(targetMenu))
		return withStableMenuIds(result)
	}

	currentMenu.children ??= []
	currentMenu.icon ||= targetMenu.icon
	currentMenu.path ||= targetMenu.path
	currentMenu.url ||= targetMenu.url
	currentMenu.redirect ||= targetMenu.redirect

	targetMenu.children.forEach((child) => {
		const exists = currentMenu.children.some((item) => isSameMenuNode(item, child))
		if (!exists) {
			currentMenu.children.push(cloneMenu(child))
		}
	})

	return withStableMenuIds(result)
}

function isWorkbenchMenu(menu) {
	return menu?.path === "/home" || menu?.url === "/home" || menu?.name === "工作台"
}

function isSalesPredictMenu(menu) {
	const routeValue = menu?.path || menu?.url || ""
	return routeValue.startsWith("/sales-predict-module") || menu?.name === "销售预测"
}

function isLegacySalesPredictionMenu(menu) {
	return (
		menu?.path === "/sales-predict-module/rec-sales-forecast-predictions"
		|| menu?.url === "/sales-predict-module/rec-sales-forecast-predictions"
	)
}

function filterSalesPredictMenus(menus = []) {
	if (!Array.isArray(menus)) {
		return []
	}

	return menus
		.filter((menu) => !isLegacySalesPredictionMenu(menu))
		.map((menu) => {
			const children = Array.isArray(menu.children) ? filterSalesPredictMenus(menu.children) : []
			if (!Array.isArray(menu.children)) {
				return menu
			}

			return {
				...menu,
				children: children.filter((child) => !isLegacySalesPredictionMenu(child)),
			}
		})
}

function reorderManagedMenus(menus) {
	const pullMenu = (menuConfig) => {
		const menuIndex = menus.findIndex((item) => isSameMenuNode(item, menuConfig))
		return menuIndex >= 0 ? menus.splice(menuIndex, 1)[0] : null
	}

	const aiMenu = pullMenu(AI_MENU)
	const operationsMenu = pullMenu(OPERATIONS_MENU)
	const managedMenus = [aiMenu, operationsMenu].filter(Boolean)

	if (!managedMenus.length) {
		return menus
	}

	const workbenchIndex = menus.findIndex((item) => isWorkbenchMenu(item))
	if (workbenchIndex >= 0) {
		menus.splice(workbenchIndex + 1, 0, ...managedMenus)
		return menus
	}

	const salesIndex = menus.findIndex((item) => isSalesPredictMenu(item))
	if (salesIndex >= 0) {
		menus.splice(salesIndex, 0, ...managedMenus)
		return menus
	}

	menus.push(...managedMenus)
	return menus
}

function ensureManagedMenus(menus = []) {
	return withStableMenuIds(
		filterSalesPredictMenus(
			reorderManagedMenus(ensureMenuTree(ensureMenuTree(menus, AI_MENU), OPERATIONS_MENU)),
		),
	)
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
		"/ai-module/intelligent-recommendation-report",
		"/ai-module/ai-competitor-analysis",
		"/ai-module/ai-product-qa",
		"/ai-module/user-behavior-analysis",
	)
	return memo
}

export default defineRuntimeConfig({})

export function onAppCreated() {
	initialState.icon = getSidebarLogo(initialState.icon)

	if (initialState?.appInfo?.id) {
		window.localStorage.setItem(`icon-${initialState.appInfo.id}`, initialState.icon)
	}
}

export function onBeforeMenuMount(memo) {
	return ensureManagedMenus(memo)
}

export function patchRoutes({ routes }) {
	const rootRoute = routes.find((item) => item.path === "/")
	const childRoutes = rootRoute?.children ?? []
	const aiPagePath = "/ai-module/intelligent-recommendation-report"
	const competitorAnalysisPath = "/ai-module/ai-competitor-analysis"
	const productQaPath = "/ai-module/ai-product-qa"
	const userBehaviorAnalysisPath = "/ai-module/user-behavior-analysis"
	const formPath = "/data-import-module/rec-tmall-item-base/form"
	const itemDetailPath = "/data-import-module/rec-tmall-item-base/detail"
	const predictionDetailPath = "/sales-predict-module/rec-sales-forecast-predictions/detail"

	if (!childRoutes.some((item) => item.path === aiPagePath)) {
		childRoutes.push({
			path: aiPagePath,
			component: IntelligentRecommendationReport,
			name: "ai-module_intelligent-recommendation-report_index",
			meta: {
				title: "智能推荐与报告",
			},
		})
	}

	if (!childRoutes.some((item) => item.path === competitorAnalysisPath)) {
		childRoutes.push({
			path: competitorAnalysisPath,
			component: AICompetitorAnalysis,
			name: "ai-module_ai-competitor-analysis_index",
			meta: {
				title: "竞品智能分析",
			},
		})
	}

	if (!childRoutes.some((item) => item.path === productQaPath)) {
		childRoutes.push({
			path: productQaPath,
			component: AIProductQa,
			name: "ai-module_ai-product-qa_index",
			meta: {
				title: "商品问答助手",
			},
		})
	}

	if (!childRoutes.some((item) => item.path === userBehaviorAnalysisPath)) {
		childRoutes.push({
			path: userBehaviorAnalysisPath,
			component: UserBehaviorAnalysis,
			name: "ai-module_user-behavior-analysis_index",
			meta: {
				title: "用户行为分析",
			},
		})
	}

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
				predictionKey: route.query?.predictionKey ?? "",
			}),
			meta: {
				title: "销量预测结果可视化详情",
				isHide: true,
			},
		})
	}
}
