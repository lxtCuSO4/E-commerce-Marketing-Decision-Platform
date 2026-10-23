function toNumber(value, fallback = 0) {
	const parsed = Number(value)
	return Number.isFinite(parsed) ? parsed : fallback
}

function normalizeText(value, fallback = "") {
	if (value === null || value === undefined) {
		return fallback
	}

	const text = String(value).trim()
	return text || fallback
}

function normalizeItemId(value) {
	return normalizeText(value, "")
}

function roundToTwoDecimals(value) {
	const numericValue = Number(value)
	if (!Number.isFinite(numericValue)) {
		return value
	}

	return Number(numericValue.toFixed(2))
}

const GRAPH_CATEGORY_COLORS = {
	primary: "#1d4ed8",
	candidate: "#38bdf8",
	selected: "#f97316",
}

function compareDateDesc(left, right, key) {
	const leftTime = left?.[key] ? new Date(left[key]).getTime() : 0
	const rightTime = right?.[key] ? new Date(right[key]).getTime() : 0
	return rightTime - leftTime
}

function pickLatest(rows, key) {
	if (!Array.isArray(rows) || rows.length === 0) {
		return {}
	}

	return rows.slice().sort((left, right) => compareDateDesc(left, right, key))[0] || {}
}

function buildFutureTrend(latestPrediction) {
	const labels = ["D1", "D2", "D3", "D4", "D5", "D6", "D7"]
	const values = [
		latestPrediction?.predPayD1 ?? null,
		latestPrediction?.predPayD2 ?? null,
		latestPrediction?.predPayD3 ?? null,
		latestPrediction?.predPayD4 ?? null,
		latestPrediction?.predPayD5 ?? null,
		latestPrediction?.predPayD6 ?? null,
		latestPrediction?.predPayD7 ?? null,
	].map((item) => (item === null || item === undefined || item === "" ? null : Number(item)))

	return {
		labels,
		values,
		hasValue: values.some((item) => item !== null && Number.isFinite(item)),
	}
}

function buildRecentTrend(featureRows) {
	if (!Array.isArray(featureRows) || featureRows.length === 0) {
		return {
			labels: [],
			values: [],
			hasValue: false,
		}
	}

	const rows = featureRows
		.slice()
		.sort((left, right) => {
			const leftTime = left?.anchorDate ? new Date(left.anchorDate).getTime() : 0
			const rightTime = right?.anchorDate ? new Date(right.anchorDate).getTime() : 0
			return leftTime - rightTime
		})
		.slice(-7)

	const labels = rows.map((item) => normalizeText(item.anchorDate, "-"))
	const values = rows.map((item) => toNumber(item.payCnt30D, 0))

	return {
		labels,
		values,
		hasValue: values.some((item) => item > 0),
	}
}

export function buildCompetitorProfile({
	itemId,
	similarityRow = {},
	baseRow = {},
	salesRows = [],
	featureRows = [],
	predictionRows = [],
	isPrimary = false,
}) {
	const normalizedItemId =
		normalizeItemId(itemId) ||
		normalizeItemId(baseRow.itemId) ||
		normalizeItemId(similarityRow.similarItemId) ||
		normalizeItemId(similarityRow.sourceItemId)

	const latestSales = pickLatest(salesRows, "lastActionTime")
	const latestFeature = pickLatest(featureRows, "anchorDate")
	const latestPrediction = pickLatest(predictionRows, "anchorDate")
	const futureTrend = buildFutureTrend(latestPrediction)
	const recentTrend = buildRecentTrend(featureRows)
	const displayTitle =
		normalizeText(baseRow.titleClean) ||
		normalizeText(baseRow.title) ||
		(isPrimary ? `主商品 ${normalizedItemId}` : `竞品 ${normalizedItemId}`)

	return {
		itemId: normalizedItemId,
		displayTitle,
		title: normalizeText(baseRow.title) || displayTitle,
		titleClean: normalizeText(baseRow.titleClean) || displayTitle,
		pictUrl: normalizeText(baseRow.pictUrl),
		category:
			normalizeText(baseRow.category) ||
			normalizeText(similarityRow.category) ||
			normalizeText(latestPrediction.category) ||
			normalizeText(latestFeature.category, "-"),
		brandId:
			normalizeText(baseRow.brandId) || normalizeText(latestPrediction.brandId) || "-",
		sellerId:
			normalizeText(baseRow.sellerId) || normalizeText(latestPrediction.sellerId) || "-",
		similarityScore: toNumber(similarityRow.similarityScore, isPrimary ? 1 : 0),
		rankNo: toNumber(similarityRow.rankNo, 0),
		clickCnt: toNumber(latestSales.clickCnt, 0),
		collectCnt: toNumber(latestSales.collectCnt, 0),
		cartCnt: toNumber(latestSales.cartCnt, 0),
		payCnt: toNumber(latestSales.payCnt, 0),
		clickCnt30D: toNumber(latestFeature.clickCnt30D, 0),
		collectCnt30D: toNumber(latestFeature.collectCnt30D, 0),
		cartCnt30D: toNumber(latestFeature.cartCnt30D, 0),
		payCnt30D: toNumber(latestFeature.payCnt30D ?? latestPrediction.payCnt30D, 0),
		payCnt7D: toNumber(latestPrediction.payCnt7D, 0),
		pred7DPay: toNumber(latestPrediction.pred7DPay, 0),
		predPayD1: toNumber(latestPrediction.predPayD1, 0),
		predPayD2: toNumber(latestPrediction.predPayD2, 0),
		predPayD3: toNumber(latestPrediction.predPayD3, 0),
		predPayD4: toNumber(latestPrediction.predPayD4, 0),
		predPayD5: toNumber(latestPrediction.predPayD5, 0),
		predPayD6: toNumber(latestPrediction.predPayD6, 0),
		predPayD7: toNumber(latestPrediction.predPayD7, 0),
		trendLabels: futureTrend.hasValue ? futureTrend.labels : recentTrend.labels,
		trendValues: futureTrend.hasValue ? futureTrend.values : recentTrend.values,
		trendSource: futureTrend.hasValue ? "forecast" : "recent",
		trendAnchorDate: normalizeText(latestPrediction.anchorDate || latestFeature.anchorDate),
		latestFeatureSnapshot: latestFeature && Object.keys(latestFeature).length ? { ...latestFeature } : null,
		latestFeatureAnchorDate: normalizeText(latestFeature.anchorDate),
		liveTrendStatus: "idle",
		liveTrendValues: [],
		priceStatus: "待接入真实价格字段",
		isPrimary,
	}
}

export function buildGraphData(primaryItem, competitors = [], selectedIds = []) {
	const selectedIdSet = new Set(selectedIds.map((item) => normalizeItemId(item)))
	const graphCompetitors = competitors.slice(0, 8)
	const nodes = []
	const links = []

	if (primaryItem?.itemId) {
		nodes.push({
			id: primaryItem.itemId,
			name: primaryItem.displayTitle,
			value: 1,
			symbolSize: 76,
			category: 0,
			itemStyle: {
				color: GRAPH_CATEGORY_COLORS.primary,
			},
		})
	}

	graphCompetitors.forEach((item) => {
		const similarityScore = toNumber(item.similarityScore, 0)
		const isSelected = selectedIdSet.has(normalizeItemId(item.itemId))
		nodes.push({
			id: item.itemId,
			name: item.displayTitle,
			value: similarityScore,
			symbolSize: Math.max(36, 30 + similarityScore * 26),
			category: isSelected ? 2 : 1,
			itemStyle: {
				color: isSelected ? GRAPH_CATEGORY_COLORS.selected : GRAPH_CATEGORY_COLORS.candidate,
			},
		})
		links.push({
			source: primaryItem.itemId,
			target: item.itemId,
			value: similarityScore,
			lineStyle: {
				width: Math.max(1.5, similarityScore * 6),
				opacity: Math.max(0.28, similarityScore),
				color: isSelected ? "#fb923c" : "#93c5fd",
			},
		})
	})

	return {
		nodes,
		links,
		categories: [
			{ name: "主商品", itemStyle: { color: GRAPH_CATEGORY_COLORS.primary } },
			{ name: "竞品候选", itemStyle: { color: GRAPH_CATEGORY_COLORS.candidate } },
			{ name: "已选竞品", itemStyle: { color: GRAPH_CATEGORY_COLORS.selected } },
		],
	}
}

export function buildTrendComparison(primaryItem, selectedCompetitors = []) {
	const seriesItems = [primaryItem, ...selectedCompetitors].filter(Boolean)
	const baseLabels =
		seriesItems.find((item) => Array.isArray(item.trendLabels) && item.trendLabels.length)?.trendLabels || []

	return {
		labels: baseLabels,
		series: seriesItems.map((item) => ({
			name: item.displayTitle,
			type: "line",
			smooth: true,
			showSymbol: true,
			data: Array.isArray(item.trendValues) ? item.trendValues : [],
		})),
	}
}

function getTopSimilarityItems(competitors = []) {
	return competitors
		.slice()
		.sort((left, right) => toNumber(right.similarityScore, 0) - toNumber(left.similarityScore, 0))
		.slice(0, 3)
}

function getTopPredictedItems(competitors = []) {
	return competitors
		.slice()
		.sort((left, right) => toNumber(right.pred7DPay, 0) - toNumber(left.pred7DPay, 0))
		.slice(0, 3)
}

function summarizeTrend(item = {}) {
	const values = Array.isArray(item?.trendValues)
		? item.trendValues.map((value) => toNumber(value, Number.NaN)).filter((value) => Number.isFinite(value))
		: []

	if (!values.length) {
		return {
			source: normalizeText(item?.trendSource, "unknown"),
			firstValue: 0,
			lastValue: 0,
			peakValue: 0,
			averageValue: 0,
			direction: "flat",
		}
	}

	const firstValue = values[0]
	const lastValue = values[values.length - 1]
	const averageValue = Number((values.reduce((sum, value) => sum + value, 0) / values.length).toFixed(2))
	const peakValue = Math.max(...values)
	const delta = lastValue - firstValue
	let direction = "flat"

	if (delta > 0) {
		direction = "up"
	} else if (delta < 0) {
		direction = "down"
	}

	return {
		source: normalizeText(item?.trendSource, "unknown"),
		firstValue: roundToTwoDecimals(firstValue),
		lastValue: roundToTwoDecimals(lastValue),
		peakValue: roundToTwoDecimals(peakValue),
		averageValue,
		direction,
	}
}

function normalizeStringListFromObject(value) {
	if (!value || typeof value !== "object" || Array.isArray(value)) {
		return []
	}

	return Object.values(value)
		.map((item) => normalizeText(item))
		.filter(Boolean)
}

function normalizeChineseCompetitorAnalysisPayload(value) {
	if (!value || typeof value !== "object") {
		return {}
	}

	const report = value["竞品分析结论"]
	if (!report || typeof report !== "object") {
		return {}
	}

	const marketPosition = report["市场定位"] || {}
	const similarityDistribution = marketPosition["竞品相似度分布"] || {}
	const coreCompetitors = Array.isArray(similarityDistribution["核心竞品"])
		? similarityDistribution["核心竞品"]
		: []
	const strengths = normalizeStringListFromObject(report["竞争优势"])
	const weaknesses = normalizeStringListFromObject(report["竞争劣势"])
	const strategyBlock = report["策略建议"] || {}
	const competitorComparison = report["竞品对比"] || {}
	const comparisonItems = Array.isArray(competitorComparison["核心竞品对比"])
		? competitorComparison["核心竞品对比"]
		: []

	return {
		summary: normalizeText(
			[
				marketPosition["竞争集中度"],
				strengths[0],
				weaknesses[0],
			]
				.filter(Boolean)
				.join("；"),
		),
		relationshipInsights: [
			...coreCompetitors
				.map((item) =>
					normalizeText(
						`${item?.["商品标题"] || item?.["竞品标题"] || "核心竞品"}（相似度 ${item?.["相似度"] ?? "-"}）${item?.["竞争特征"] ? `：${item["竞争特征"]}` : ""}`,
					),
				)
				.filter(Boolean),
			normalizeText(competitorComparison["类目关联"]),
		].filter(Boolean),
		comparisonHighlights: comparisonItems
			.map((item) => {
				const salesData = item?.["销量数据"] || {}
				return normalizeText(
					`${item?.["竞品标题"] || item?.["商品标题"] || "竞品"}：近30天支付${salesData["近30天支付"] ?? "-"}，累计支付${salesData["累计支付"] ?? "-"}，趋势方向${salesData["趋势方向"] || "-"}`,
				)
			})
			.filter(Boolean),
		marketPosition: normalizeText(marketPosition["竞争集中度"]),
		strengths,
		weaknesses,
		strategySuggestions: [
			...normalizeAIResponseArray(strategyBlock["优化方向"]),
			...normalizeAIResponseArray(strategyBlock["执行优先级"]),
		]
			.map((item) => normalizeText(item))
			.filter(Boolean),
		llmStatus: "success",
	}
}

function getCategoryBreakdown(competitors = []) {
	const counter = competitors.reduce((buffer, item) => {
		const key = normalizeText(item.category, "未分类")
		buffer[key] = (buffer[key] || 0) + 1
		return buffer
	}, {})

	return Object.entries(counter)
		.sort((left, right) => right[1] - left[1])
		.slice(0, 3)
}

function compareMetricText(label, leftValue, rightValue) {
	if (leftValue === rightValue) {
		return `${label}与主商品基本持平`
	}

	return leftValue > rightValue
		? `${label}高于主商品 ${Math.abs(leftValue - rightValue).toFixed(0)}`
		: `${label}低于主商品 ${Math.abs(leftValue - rightValue).toFixed(0)}`
}

export function buildLocalCompetitorReport(primaryItem, selectedCompetitors = [], allCompetitors = []) {
	const comparedItems = selectedCompetitors.filter(Boolean)
	const topSimilarityItems = getTopSimilarityItems(allCompetitors)
	const topPredictedItems = getTopPredictedItems(allCompetitors)
	const categoryBreakdown = getCategoryBreakdown(allCompetitors)
	const averageSimilarity = allCompetitors.length
		? (
				allCompetitors.reduce(
					(total, item) => total + toNumber(item.similarityScore, 0),
					0,
				) / allCompetitors.length
			).toFixed(2)
		: "0.00"

	const relationshipInsights = [
		topSimilarityItems.length
			? `与主商品最接近的竞品包括 ${topSimilarityItems
					.map((item) => `${item.displayTitle}（相似度 ${toNumber(item.similarityScore, 0).toFixed(2)}）`)
					.join("、")}。`
			: "当前未获取到有效竞品关系数据。",
		categoryBreakdown.length
			? `竞品候选主要集中在 ${categoryBreakdown
					.map(([name, count]) => `${name}（${count} 个）`)
					.join("、")}，说明竞争关系主要发生在同类目内部。`
			: "暂未形成稳定的类目竞争分布。",
		`当前候选竞品平均相似度为 ${averageSimilarity}，适合用于竞品关系图谱与差异化分析。`,
	]

	const comparisonHighlights =
		comparedItems.length > 0
			? comparedItems.map((item) => {
					const metricHighlights = [
						compareMetricText("累计支付", toNumber(item.payCnt, 0), toNumber(primaryItem.payCnt, 0)),
						compareMetricText("近30天支付", toNumber(item.payCnt30D, 0), toNumber(primaryItem.payCnt30D, 0)),
						compareMetricText("未来7天预测支付", toNumber(item.pred7DPay, 0), toNumber(primaryItem.pred7DPay, 0)),
					]
					return `${item.displayTitle}：${metricHighlights.join("；")}。`
				})
			: ["至少选择 2 个竞品后可生成更聚焦的对比分析。"]

	const marketLeader = topPredictedItems[0]
	const marketPosition = marketLeader?.itemId === primaryItem.itemId
		? "主商品在当前候选集内处于预测销量领先位，适合作为防守型经营对象。"
		: marketLeader
			? `从未来 7 天预测支付看，${marketLeader.displayTitle} 更接近当前竞争高位，主商品更适合采取追赶和差异化策略。`
			: "暂未识别出明确的竞争高位商品。"

	const strengths = []
	const weaknesses = []

	if (toNumber(primaryItem.pred7DPay, 0) >= Math.max(...comparedItems.map((item) => toNumber(item.pred7DPay, 0)), 0)) {
		strengths.push("主商品未来 7 天预测销量处于已选对比组前列。")
	} else {
		weaknesses.push("主商品未来 7 天预测销量低于至少一个已选竞品。")
	}

	if (toNumber(primaryItem.payCnt, 0) >= Math.max(...comparedItems.map((item) => toNumber(item.payCnt, 0)), 0)) {
		strengths.push("主商品累计支付表现更稳，具备一定存量成交基础。")
	} else {
		weaknesses.push("主商品累计支付规模不占优，需要补强成交承接。")
	}

	if (!strengths.length) {
		strengths.push("主商品与竞品处于同一竞争带，具备通过运营动作快速追平的基础。")
	}

	if (!weaknesses.length) {
		weaknesses.push("当前缺少真实价格字段，价格竞争力尚无法进行精确判断。")
	}

	const strategySuggestions = [
		"优先围绕高相似度竞品优化主图、标题卖点和详情页信息密度，降低用户横向比价时的流失。",
		marketLeader?.itemId && marketLeader.itemId !== primaryItem.itemId
			? `对 ${marketLeader.displayTitle} 的高表现维度进行专题拆解，重点复盘其销量趋势与成交承接。`
			: "保持主商品高位表现，重点防守核心转化入口和活动资源位。",
		"将未来 7 天预测趋势纳入日常经营看板，优先跟踪趋势转弱的竞品与主商品波动点。",
		"价格字段未接入前，先聚焦销量、趋势、相似度和类目位置做策略判断。",
	]

	return {
		summary: `当前围绕主商品 ${primaryItem.displayTitle} 共识别 ${allCompetitors.length} 个竞品候选，已选择 ${comparedItems.length} 个竞品进行深度对比。页面已结合相似度、销量与销量预测趋势生成本地竞品分析摘要。`,
		relationshipInsights,
		comparisonHighlights,
		marketPosition,
		strengths,
		weaknesses,
		strategySuggestions,
		llmStatus: "frontend-fallback",
	}
}

export function normalizeCompetitorAnalysisResult(result, fallbackReport) {
	const parseJsonText = (value) => {
		if (typeof value !== "string" || !value) {
			return null
		}

		try {
			return JSON.parse(value)
		} catch (error) {
			return null
		}
	}

	const base = unwrapAIProxyPayload(result)
	const parsedContent = parseJsonText(base?.content || base?.text || "")
	const chineseStructuredContent = normalizeChineseCompetitorAnalysisPayload(parsedContent)
	const normalized =
		parsedContent && typeof parsedContent === "object"
			? { ...base, ...parsedContent, ...chineseStructuredContent }
			: base && typeof base === "object"
				? base
				: {}
	const normalizeStringList = (value, fallbackValue) => {
		if (!Array.isArray(value)) {
			return fallbackValue
		}

		const list = value
			.map((item) => {
				if (typeof item === "string") {
					return item.trim()
				}
				if (item && typeof item === "object") {
					return normalizeText(item.content || item.text || item.title)
				}
				return ""
			})
			.filter(Boolean)

		return list.length ? list : fallbackValue
	}

	return {
		summary: normalizeText(normalized.summary || normalized.content, fallbackReport.summary),
		relationshipInsights: normalizeStringList(
			normalized.relationshipInsights,
			fallbackReport.relationshipInsights,
		),
		comparisonHighlights: normalizeStringList(
			normalized.comparisonHighlights,
			fallbackReport.comparisonHighlights,
		),
		marketPosition: normalizeText(normalized.marketPosition, fallbackReport.marketPosition),
		strengths: normalizeStringList(normalized.strengths, fallbackReport.strengths),
		weaknesses: normalizeStringList(normalized.weaknesses, fallbackReport.weaknesses),
		strategySuggestions: normalizeStringList(
			normalized.strategySuggestions,
			fallbackReport.strategySuggestions,
		),
		llmStatus: normalizeText(normalized.llmStatus, fallbackReport.llmStatus),
	}
}

export function buildCompetitorAnalysisPayload(primaryItem, selectedCompetitors = [], allCompetitors = []) {
	const reportDraft = buildLocalCompetitorReport(primaryItem, selectedCompetitors, allCompetitors)
	const compactDraft = {
		summary: reportDraft.summary || "",
		marketPosition: reportDraft.marketPosition || "",
		strategySuggestions: Array.isArray(reportDraft.strategySuggestions)
			? reportDraft.strategySuggestions.filter(Boolean).slice(0, 3)
			: [],
		llmStatus: reportDraft.llmStatus || "frontend-fallback",
	}

	return {
		analysisMode: "polish",
		mainItem: {
			itemId: primaryItem.itemId,
			title: primaryItem.displayTitle,
			category: primaryItem.category,
		},
		selectedCompetitors: selectedCompetitors.slice(0, 2).map((item) => ({
			itemId: item.itemId,
			title: item.displayTitle,
			similarityScore: item.similarityScore,
			pred7DPay: item.pred7DPay,
			trendSummary: summarizeTrend(item),
		})),
		reportDraft: compactDraft,
	}
}

export function buildLiveTrendRequest(profile) {
	if (!profile?.itemId || !profile?.latestFeatureAnchorDate || !profile?.latestFeatureSnapshot) {
		return null
	}

	return {
		itemId: profile.itemId,
		anchorDate: profile.latestFeatureAnchorDate,
		horizonDays: 7,
		featureData: profile.latestFeatureSnapshot,
	}
}

export function buildLiveTrendComparison(primaryItem, selectedCompetitors = []) {
	const seriesItems = [primaryItem, ...selectedCompetitors].filter(Boolean)
	const failedItem = seriesItems.find((item) => item?.liveTrendStatus !== "success")

	if (failedItem) {
		return {
			labels: [],
			series: [],
			ready: false,
			failureReason: String(failedItem.liveTrendStatus || "error"),
		}
	}

	return {
		labels: ["D1", "D2", "D3", "D4", "D5", "D6", "D7"],
		series: seriesItems.map((item) => ({
			name: item.displayTitle,
			type: "line",
			smooth: true,
			showSymbol: true,
			data: Array.isArray(item.liveTrendValues)
				? item.liveTrendValues.map((trendValue) => roundToTwoDecimals(trendValue))
				: [],
		})),
		ready: seriesItems.length > 1,
		failureReason: "",
	}
}

export function getCoverageStats(primaryItem, competitors = []) {
	const profiles = [primaryItem, ...competitors].filter(Boolean)
	const forecastCoverage = profiles.filter((item) => item.trendSource === "forecast").length
	return {
		totalProfiles: profiles.length,
		forecastCoverage,
		forecastCoverageRate: profiles.length
			? `${Math.round((forecastCoverage / profiles.length) * 100)}%`
			: "0%",
	}
}

export function getLiveTrendCoverageStats(primaryItem, selectedCompetitors = []) {
	const profiles = [primaryItem, ...selectedCompetitors].filter(Boolean)
	const successProfiles = profiles.filter((item) => item?.liveTrendStatus === "success").length
	const hasLoading = profiles.some((item) => item?.liveTrendStatus === "loading")
	const hasFailure = profiles.some((item) => ["error", "missing_feature"].includes(item?.liveTrendStatus))

	let statusLabel = "待预测"
	if (hasLoading) {
		statusLabel = "预测中"
	} else if (hasFailure) {
		statusLabel = "预测失败"
	} else if (profiles.length > 0 && successProfiles === profiles.length) {
		statusLabel = "预测完成"
	}

	return {
		totalProfiles: profiles.length,
		successProfiles,
		statusLabel,
		statusDetail: `${successProfiles}/${profiles.length} 个商品已完成实时预测`,
	}
}
import {
	normalizeAIResponseArray,
	unwrapAIProxyPayload,
} from "../../utils/ai-response-normalizer.js"
