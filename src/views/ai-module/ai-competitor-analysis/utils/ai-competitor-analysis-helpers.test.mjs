import test from "node:test"
import assert from "node:assert/strict"

import {
	buildCompetitorProfile,
	buildCompetitorAnalysisPayload,
	buildLiveTrendComparison,
	buildLiveTrendRequest,
	getLiveTrendCoverageStats,
	normalizeCompetitorAnalysisResult,
} from "./ai-competitor-analysis-helpers.js"

test("buildCompetitorProfile keeps the latest feature snapshot for live prediction", () => {
	const profile = buildCompetitorProfile({
		itemId: "2001",
		featureRows: [
			{ itemId: "2001", anchorDate: "2026-04-10", payCnt30D: 80 },
			{ itemId: "2001", anchorDate: "2026-04-12", payCnt30D: 120, clickCnt7D: 330 },
		],
	})

	assert.equal(profile.latestFeatureAnchorDate, "2026-04-12")
	assert.deepEqual(profile.latestFeatureSnapshot, {
		itemId: "2001",
		anchorDate: "2026-04-12",
		payCnt30D: 120,
		clickCnt7D: 330,
	})
	assert.equal(profile.liveTrendStatus, "idle")
	assert.deepEqual(profile.liveTrendValues, [])
})

test("buildLiveTrendRequest uses the latest feature snapshot as prediction payload", () => {
	const profile = buildCompetitorProfile({
		itemId: "3001",
		baseRow: { title: "主商品" },
		featureRows: [
			{ itemId: "3001", anchorDate: "2026-04-08", payCnt30D: 75 },
			{ itemId: "3001", anchorDate: "2026-04-11", payCnt30D: 99, sellerId: "s-1" },
		],
	})

	assert.deepEqual(buildLiveTrendRequest(profile), {
		itemId: "3001",
		anchorDate: "2026-04-11",
		horizonDays: 7,
		featureData: {
			itemId: "3001",
			anchorDate: "2026-04-11",
			payCnt30D: 99,
			sellerId: "s-1",
		},
	})
})

test("buildLiveTrendComparison returns empty chart when any selected item lacks live forecast", () => {
	const primaryItem = {
		itemId: "1001",
		displayTitle: "主商品",
		liveTrendStatus: "success",
		liveTrendValues: [1.111, 2, 3, 4, 5, 6, 7],
	}
	const competitor = {
		itemId: "1002",
		displayTitle: "竞品",
		liveTrendStatus: "missing_feature",
		liveTrendValues: [],
	}

	assert.deepEqual(buildLiveTrendComparison(primaryItem, [competitor]), {
		labels: [],
		series: [],
		ready: false,
		failureReason: "missing_feature",
	})
})

test("buildLiveTrendComparison renders D1-D7 series only after all live forecasts succeed", () => {
	const primaryItem = {
		itemId: "1001",
		displayTitle: "主商品",
		liveTrendStatus: "success",
		liveTrendValues: [1.111, 2, 3, 4, 5, 6, 7],
	}
	const competitor = {
		itemId: "1002",
		displayTitle: "竞品",
		liveTrendStatus: "success",
		liveTrendValues: [7, 6, 5, 4, 3, 2, 1.236],
	}

	assert.deepEqual(buildLiveTrendComparison(primaryItem, [competitor]), {
		labels: ["D1", "D2", "D3", "D4", "D5", "D6", "D7"],
		series: [
			{
				name: "主商品",
				type: "line",
				smooth: true,
				showSymbol: true,
				data: [1.11, 2, 3, 4, 5, 6, 7],
			},
			{
				name: "竞品",
				type: "line",
				smooth: true,
				showSymbol: true,
				data: [7, 6, 5, 4, 3, 2, 1.24],
			},
		],
		ready: true,
		failureReason: "",
	})
})

test("getLiveTrendCoverageStats reports live prediction status based on selected items only", () => {
	const primaryItem = { itemId: "1001", liveTrendStatus: "success" }
	const selectedCompetitors = [
		{ itemId: "1002", liveTrendStatus: "success" },
		{ itemId: "1003", liveTrendStatus: "loading" },
	]

	assert.deepEqual(getLiveTrendCoverageStats(primaryItem, selectedCompetitors), {
		totalProfiles: 3,
		successProfiles: 2,
		statusLabel: "预测中",
		statusDetail: "2/3 个商品已完成实时预测",
	})
})

test("normalizeCompetitorAnalysisResult reads summary and suggestions from raw content payload", () => {
	const fallback = {
		summary: "规则摘要",
		relationshipInsights: [],
		comparisonHighlights: [],
		marketPosition: "",
		strengths: [],
		weaknesses: [],
		strategySuggestions: [],
		llmStatus: "frontend-fallback",
	}

	const result = normalizeCompetitorAnalysisResult(
		{
			data: {
				content: JSON.stringify({
					summary: "AI 竞品摘要",
					relationshipInsights: ["关系1"],
					strategySuggestions: ["建议1"],
					llmStatus: "success",
				}),
			},
		},
		fallback,
	)

	assert.equal(result.summary, "AI 竞品摘要")
	assert.deepEqual(result.relationshipInsights, ["关系1"])
	assert.deepEqual(result.strategySuggestions, ["建议1"])
	assert.equal(result.llmStatus, "success")
})

test("normalizeCompetitorAnalysisResult understands structured Chinese competitor analysis payload", () => {
	const fallback = {
		summary: "规则摘要",
		relationshipInsights: [],
		comparisonHighlights: [],
		marketPosition: "",
		strengths: [],
		weaknesses: [],
		strategySuggestions: [],
		llmStatus: "frontend-fallback",
	}

	const result = normalizeCompetitorAnalysisResult(
		{
			data: {
				content: JSON.stringify({
					竞品分析结论: {
						市场定位: {
							竞争集中度: "同类目竞争激烈",
							竞品相似度分布: {
								核心竞品: [
									{
										商品标题: "竞品A",
										itemId: "2001",
										相似度: 0.22,
										竞争特征: "高位竞争",
									},
								],
							},
						},
						竞争优势: {
							销量表现: "累计支付更稳",
						},
						竞争劣势: {
							价格盲区: "缺少真实价格字段",
						},
						策略建议: {
							优化方向: ["优化主图"],
							执行优先级: ["补充价格字段"],
						},
						竞品对比: {
							核心竞品对比: [
								{
									竞品标题: "竞品A",
									销量数据: {
										近30天支付: 1,
										累计支付: 3,
										趋势方向: "下降",
									},
								},
							],
							类目关联: "同类目内竞争",
						},
					},
				}),
			},
		},
		fallback,
	)

	assert.equal(result.summary, "同类目竞争激烈；累计支付更稳；缺少真实价格字段")
	assert.deepEqual(result.relationshipInsights, ["竞品A（相似度 0.22）：高位竞争", "同类目内竞争"])
	assert.deepEqual(result.comparisonHighlights, ["竞品A：近30天支付1，累计支付3，趋势方向下降"])
	assert.equal(result.marketPosition, "同类目竞争激烈")
	assert.deepEqual(result.strengths, ["累计支付更稳"])
	assert.deepEqual(result.weaknesses, ["缺少真实价格字段"])
	assert.deepEqual(result.strategySuggestions, ["优化主图", "补充价格字段"])
	assert.equal(result.llmStatus, "success")
})

test("buildCompetitorAnalysisPayload keeps only a compact polishing payload", () => {
	const payload = buildCompetitorAnalysisPayload(
		{
			itemId: "1001",
			displayTitle: "主商品",
			category: "女装",
			sellerId: "s1",
			payCnt: 10,
			payCnt30D: 20,
			pred7DPay: 30,
			trendSource: "recent",
			trendLabels: ["D1", "D2", "D3"],
			trendValues: [1, 3, 2],
		},
		[
			{
				itemId: "2001",
				displayTitle: "竞品A",
				category: "女装",
				sellerId: "s2",
				similarityScore: 0.9,
				rankNo: 1,
				clickCnt: 99,
				payCnt: 9,
				payCnt30D: 19,
				pred7DPay: 29,
				trendSource: "recent",
				trendLabels: ["D1", "D2", "D3"],
				trendValues: [5, 4, 3],
			},
		],
		[
			{ itemId: "2001", displayTitle: "竞品A", category: "女装", similarityScore: 0.9, pred7DPay: 29 },
			{ itemId: "2002", displayTitle: "竞品B", category: "女装", similarityScore: 0.8, pred7DPay: 28 },
			{ itemId: "2003", displayTitle: "竞品C", category: "女装", similarityScore: 0.7, pred7DPay: 27 },
			{ itemId: "2004", displayTitle: "竞品D", category: "女装", similarityScore: 0.6, pred7DPay: 26 },
		],
	)

	assert.equal(payload.analysisMode, "polish")
	assert.equal(payload.mainItem.itemId, "1001")
	assert.equal(payload.mainItem.title, "主商品")
	assert.equal("trendLabels" in payload.mainItem, false)
	assert.equal("trendValues" in payload.mainItem, false)
	assert.equal("payCnt30D" in payload.mainItem, false)
	assert.equal(payload.selectedCompetitors.length, 1)
	assert.equal("payCnt" in payload.selectedCompetitors[0], false)
	assert.equal("payCnt30D" in payload.selectedCompetitors[0], false)
	assert.equal("trendLabels" in payload.selectedCompetitors[0], false)
	assert.equal("trendValues" in payload.selectedCompetitors[0], false)
	assert.deepEqual(payload.selectedCompetitors[0].trendSummary, {
		source: "recent",
		firstValue: 5,
		lastValue: 3,
		peakValue: 5,
		averageValue: 4,
		direction: "down",
	})
	assert.equal(typeof payload.reportDraft.summary, "string")
	assert.equal(typeof payload.reportDraft.marketPosition, "string")
	assert.ok(Array.isArray(payload.reportDraft.strategySuggestions))
	assert.equal(payload.reportDraft.strategySuggestions.length <= 3, true)
	assert.equal("relationshipInsights" in payload.reportDraft, false)
	assert.equal("comparisonHighlights" in payload.reportDraft, false)
	assert.equal("candidateSummary" in payload, false)
})
