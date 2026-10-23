<template>
	<KPage class="emdmp-shell emdmp-shell--wide competitor-page">
		<div class="emdmp-page-hero competitor-hero">
			<div>
				<p class="emdmp-page-kicker">AI Intelligence</p>
				<h1 class="emdmp-page-title">竞品智能分析</h1>
				<p class="emdmp-page-description">
					围绕主商品与相似商品构建竞品关系图谱，结合销量与销量预测趋势，输出竞争态势与差异化策略建议。
				</p>
			</div>
		</div>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">主商品</div>
						<div class="summary-value summary-value--compact">
							{{ primaryItem?.itemId || queryForm.selectedSourceItemId || "-" }}
						</div>
						<div class="summary-meta">
							{{
								primaryItem?.displayTitle ||
								selectedSourceCandidate?.displayTitle ||
								"先按商品标题关键字搜索，再从候选中选择主商品"
							}}
						</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">竞品候选数</div>
						<div class="summary-value">{{ competitorProfiles.length }}</div>
						<div class="summary-meta">基于相似度数据筛出的主商品竞争候选集合</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">已选深度对比</div>
						<div class="summary-value">{{ selectedCompetitors.length }}</div>
						<div class="summary-meta">请保持 2-3 个竞品参与深度对比与 AI 解读</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
						<div class="summary-card">
						<div class="summary-label">实时预测状态</div>
						<div class="summary-value summary-value--compact">{{ coverageStats.statusLabel }}</div>
						<div class="summary-meta">
							{{ coverageStats.statusDetail }}
						</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-card shadow="never" class="query-panel m-b-16px">
			<el-form class="emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="商品标题关键字">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品标题关键字，纯数字将兼容按商品 ID 搜索"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="竞品上限">
					<el-select v-model="queryForm.topN" placeholder="请选择竞品上限">
						<el-option :value="4" label="4 个" />
						<el-option :value="6" label="6 个" />
						<el-option :value="8" label="8 个" />
						<el-option :value="10" label="10 个" />
					</el-select>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
					<el-button type="primary" :loading="candidateLoading" @click="handleSearch">
						搜索候选
					</el-button>
					<el-button @click="handleReset">重置</el-button>
					<el-button
						type="success"
						plain
						:loading="aiLoading"
						:disabled="selectedCompetitors.length < MIN_SELECTED_COMPETITORS"
						@click="handleGenerateAIReport"
					>
						AI 深度解读
					</el-button>
				</el-form-item>
			</el-form>
			<div class="query-note">
				先按标题关键字筛出候选主商品，再选择 1 个作为分析基线。当前页面默认优先展示销量预测趋势，价格字段暂未在现有接口中稳定提供，因此首版仅做提示，不伪造价格数据。
			</div>
		</el-card>

		<el-card shadow="never" class="panel-card m-b-16px" v-loading="candidateLoading">
			<template #header>
				<div class="panel-header">
					<span>主商品候选区</span>
					<span class="panel-header__meta">关键字命中多个商品时，请先明确选择 1 个主商品</span>
				</div>
			</template>
			<el-table
				:data="keywordCandidates"
				size="small"
				stripe
				empty-text="请输入商品标题关键字后搜索候选商品"
			>
				<el-table-column label="主商品" min-width="280">
					<template #default="{ row }">
						<div class="candidate-title">{{ row.displayTitle }}</div>
						<div class="candidate-sub">商品 ID：{{ row.itemId }}</div>
					</template>
				</el-table-column>
				<el-table-column label="类目" min-width="140">
					<template #default="{ row }">
						{{ row.category || "-" }}
					</template>
				</el-table-column>
				<el-table-column label="卖家 ID" min-width="120">
					<template #default="{ row }">
						{{ row.sellerId || "-" }}
					</template>
				</el-table-column>
				<el-table-column label="状态" width="120" align="center">
					<template #default="{ row }">
						<el-tag v-if="queryForm.selectedSourceItemId === row.itemId" size="small" type="success">
							当前主商品
						</el-tag>
						<span v-else class="candidate-sub">待选择</span>
					</template>
				</el-table-column>
				<el-table-column label="操作" width="140" align="center">
					<template #default="{ row }">
						<el-button
							type="primary"
							link
							:loading="loading && queryForm.selectedSourceItemId === row.itemId"
							@click="handleSelectPrimaryItem(row)"
						>
							{{ queryForm.selectedSourceItemId === row.itemId ? "重新分析" : "设为主商品" }}
						</el-button>
					</template>
				</el-table-column>
			</el-table>
		</el-card>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="16">
				<el-card shadow="never" class="panel-card chart-panel-card" v-loading="loading">
					<template #header>
						<div class="panel-header">
							<span>竞品关系图谱</span>
							<span class="panel-header__meta">点击节点可联动右侧商品焦点卡</span>
						</div>
					</template>
					<div v-if="graphReady" ref="graphChartRef" class="graph-canvas"></div>
					<el-empty v-else description="选择主商品后展示竞品网络关系" />
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="8">
				<el-card shadow="never" class="panel-card focus-card">
					<template #header>竞品焦点卡</template>
					<div v-if="focusedProfile" class="focus-card__content">
						<div class="focus-card__title">{{ focusedProfile.displayTitle }}</div>
						<div class="focus-card__sub">
							商品 ID：{{ focusedProfile.itemId || "-" }}
						</div>
						<div class="focus-card__tags">
							<el-tag size="small" effect="light">
								{{ focusedProfile.isPrimary ? "主商品" : "竞品候选" }}
							</el-tag>
							<el-tag size="small" effect="plain">
								类目 {{ focusedProfile.category || "-" }}
							</el-tag>
							<el-tag v-if="!focusedProfile.isPrimary" size="small" effect="plain">
								相似度 {{ formatDecimal(focusedProfile.similarityScore) }}
							</el-tag>
						</div>
						<div class="focus-card__metrics">
							<div class="focus-card__metric">
								<span>累计支付</span>
								<strong>{{ formatMetric(focusedProfile.payCnt) }}</strong>
							</div>
							<div class="focus-card__metric">
								<span>近 30 天支付</span>
								<strong>{{ formatMetric(focusedProfile.payCnt30D) }}</strong>
							</div>
							<div class="focus-card__metric">
								<span>未来 7 天预测</span>
								<strong>{{ formatMetric(focusedProfile.pred7DPay) }}</strong>
							</div>
							<div class="focus-card__metric">
								<span>价格维度</span>
								<strong>{{ focusedProfile.priceStatus }}</strong>
							</div>
						</div>
					</div>
					<el-empty v-else description="图谱加载后显示商品焦点详情" />
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="10">
				<el-card shadow="never" class="panel-card">
					<template #header>
						<div class="panel-header">
							<span>竞品对比分析器</span>
							<span class="panel-header__meta">从候选集中选择 2-3 个竞品</span>
						</div>
					</template>
					<el-table :data="competitorProfiles" size="small" stripe empty-text="暂无竞品候选数据">
						<el-table-column label="选择" width="78" align="center">
							<template #default="{ row }">
								<el-checkbox
									:model-value="selectedCompetitorIds.includes(row.itemId)"
									@change="toggleCompetitorSelection(row)"
								/>
							</template>
						</el-table-column>
						<el-table-column label="竞品" min-width="220">
							<template #default="{ row }">
								<div class="candidate-title">{{ row.displayTitle }}</div>
								<div class="candidate-sub">商品 ID：{{ row.itemId }}</div>
							</template>
						</el-table-column>
						<el-table-column label="相似度" width="110" align="center">
							<template #default="{ row }">
								{{ formatDecimal(row.similarityScore) }}
							</template>
						</el-table-column>
						<el-table-column label="预测 7 天" width="120" align="center">
							<template #default="{ row }">
								{{ formatMetric(row.pred7DPay) }}
							</template>
						</el-table-column>
					</el-table>
					<div class="selector-footer">
						<span>已选 {{ selectedCompetitors.length }} 个竞品</span>
						<span>建议保持 2-3 个竞品进行深度对比</span>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="14">
				<el-card shadow="never" class="panel-card comparison-card m-b-16px">
					<template #header>竞品对比概览</template>
					<div v-if="comparisonItems.length" class="comparison-grid">
						<div
							v-for="item in comparisonItems"
							:key="item.itemId"
							class="comparison-card__item"
							:class="{ 'comparison-card__item--primary': item.isPrimary }"
						>
							<div class="comparison-card__title">{{ item.displayTitle }}</div>
							<div class="comparison-card__subtitle">
								{{ item.isPrimary ? "主商品基线" : `竞品相似度 ${formatDecimal(item.similarityScore)}` }}
							</div>
							<div class="comparison-card__metric">
								<span>类目</span>
								<strong>{{ item.category || "-" }}</strong>
							</div>
							<div class="comparison-card__metric">
								<span>卖家 ID</span>
								<strong>{{ item.sellerId || "-" }}</strong>
							</div>
							<div class="comparison-card__metric">
								<span>累计支付</span>
								<strong>{{ formatMetric(item.payCnt) }}</strong>
							</div>
							<div class="comparison-card__metric">
								<span>近 30 天支付</span>
								<strong>{{ formatMetric(item.payCnt30D) }}</strong>
							</div>
							<div class="comparison-card__metric">
								<span>未来 7 天预测</span>
								<strong>{{ formatMetric(item.pred7DPay) }}</strong>
							</div>
							<div class="comparison-card__metric">
								<span>价格</span>
								<strong>{{ item.priceStatus }}</strong>
							</div>
						</div>
					</div>
					<el-empty v-else description="请选择竞品后展示对比概览" />
				</el-card>

				<el-card shadow="never" class="panel-card chart-panel-card" v-loading="liveTrendLoading">
					<template #header>
						<div class="panel-header">
							<span>趋势对比</span>
							<span class="panel-header__meta">已选商品全部实时预测成功后展示趋势对比</span>
						</div>
					</template>
					<div v-if="trendReady" ref="trendChartRef" class="trend-canvas"></div>
					<el-empty v-else :description="trendEmptyText" />
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16">
			<el-col :xs="24" :lg="14">
				<el-card
					shadow="never"
					class="panel-card report-card"
				>
					<template #header>
						<div class="card-header-with-status">
							<span>竞争态势报告</span>
							<div v-if="aiLoading" class="llm-generating-indicator">
								<span class="llm-generating-indicator__dot"></span>
								<span>大模型生成中</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowCompetitorReportContent" class="report-content">
						<p class="report-summary">{{ displayReport.summary }}</p>
						<div class="report-section">
							<h3>竞品关系解读</h3>
							<ul>
								<li v-for="(item, index) in displayReport.relationshipInsights" :key="`rel-${index}`">
									{{ item }}
								</li>
							</ul>
						</div>
						<div class="report-section">
							<h3>竞品对比亮点</h3>
							<ul>
								<li v-for="(item, index) in displayReport.comparisonHighlights" :key="`cmp-${index}`">
									{{ item }}
								</li>
							</ul>
						</div>
						<div class="report-section">
							<h3>竞争位置判断</h3>
							<p>{{ displayReport.marketPosition }}</p>
						</div>
					</div>
					<el-empty v-else-if="aiLoading" description="大模型生成中" />
					<el-empty v-else description="查询并选择竞品后展示竞争态势报告" />
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="10">
				<el-card
					shadow="never"
					class="panel-card report-card"
				>
					<template #header>
						<div class="card-header-with-status">
							<span>差异化策略建议</span>
							<div v-if="aiLoading" class="llm-generating-indicator">
								<span class="llm-generating-indicator__dot"></span>
								<span>大模型生成中</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowCompetitorReportContent" class="strategy-content">
						<div class="strategy-block">
							<div class="strategy-block__title">优势</div>
							<el-tag
								v-for="(item, index) in displayReport.strengths"
								:key="`strength-${index}`"
								size="small"
								effect="plain"
							>
								{{ item }}
							</el-tag>
						</div>
						<div class="strategy-block">
							<div class="strategy-block__title">劣势 / 风险</div>
							<el-tag
								v-for="(item, index) in displayReport.weaknesses"
								:key="`weakness-${index}`"
								size="small"
								effect="plain"
								type="warning"
							>
								{{ item }}
							</el-tag>
						</div>
						<div class="strategy-block">
							<div class="strategy-block__title">建议动作</div>
							<ul class="strategy-list">
								<li
									v-for="(item, index) in displayReport.strategySuggestions"
									:key="`suggestion-${index}`"
								>
									{{ item }}
								</li>
							</ul>
						</div>
						<div class="strategy-status">
							分析状态：{{ reportStatusLabel }}
						</div>
					</div>
					<el-empty v-else-if="aiLoading" description="大模型生成中" />
					<el-empty v-else description="分析完成后展示差异化策略建议" />
				</el-card>
			</el-col>
		</el-row>
	</KPage>
</template>
<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from "vue"
import * as echarts from "echarts"
import { defineRouteMeta, message } from "@kesplus/kesplus"
import {
	getCompetitorAnalysisEnhancementStatusByAIApi,
	getCompetitorSimilarityCandidatesApi,
	getItemBaseByItemIdApi,
	getItemSalesByItemIdApi,
	getLatestSalesFeatureByItemIdApi,
	predictCompetitorTrendByLiveForecastApi,
	getSalesForecastPredictionByItemIdApi,
	searchItemCandidatesApi,
	startCompetitorAnalysisByAIApi,
} from "./utils/ai-competitor-analysis-api"
import {
	buildCompetitorAnalysisPayload,
	buildCompetitorProfile,
	buildGraphData,
	buildLocalCompetitorReport,
	buildLiveTrendComparison,
	buildLiveTrendRequest,
	getLiveTrendCoverageStats,
	normalizeCompetitorAnalysisResult,
} from "./utils/ai-competitor-analysis-helpers"

defineRouteMeta({
	title: "竞品智能分析",
})

const MIN_SELECTED_COMPETITORS = 2
const MAX_SELECTED_COMPETITORS = 3
const DEFAULT_TOP_N = 6

const queryForm = reactive({
	keyword: "",
	selectedSourceItemId: "",
	topN: DEFAULT_TOP_N,
})

const loading = ref(false)
const candidateLoading = ref(false)
const aiLoading = ref(false)
const keywordCandidates = ref([])
const primaryItem = ref(null)
const competitorProfiles = ref([])
const selectedCompetitorIds = ref([])
const focusedItemId = ref("")
const aiReport = ref(null)
const aiReportRequested = ref(false)
const competitorEnhancementTaskId = ref("")
const liveTrendLoading = ref(false)
const liveTrendFailureReason = ref("")

const graphChartRef = ref(null)
const trendChartRef = ref(null)

let graphChart = null
let trendChart = null
let competitorEnhancementTimer = null
let liveTrendRefreshTimer = null
let liveTrendRequestToken = 0

const selectedSourceCandidate = computed(
	() =>
		keywordCandidates.value.find((item) => item.itemId === queryForm.selectedSourceItemId) || null,
)

const selectedCompetitors = computed(() =>
	competitorProfiles.value.filter((item) => selectedCompetitorIds.value.includes(item.itemId)),
)

const comparisonItems = computed(() =>
	[primaryItem.value, ...selectedCompetitors.value].filter(Boolean),
)

const fallbackReport = computed(() => {
	if (!primaryItem.value) {
		return {
			summary: "",
			relationshipInsights: [],
			comparisonHighlights: [],
			marketPosition: "",
			strengths: [],
			weaknesses: [],
			strategySuggestions: [],
			llmStatus: "idle",
		}
	}

	return buildLocalCompetitorReport(
		primaryItem.value,
		selectedCompetitors.value,
		competitorProfiles.value,
	)
})

const displayReport = computed(() => aiReport.value || fallbackReport.value)
const shouldShowCompetitorReportContent = computed(
	() => !aiLoading.value && aiReportRequested.value && Boolean(displayReport.value?.summary),
)

const graphData = computed(() =>
	primaryItem.value
		? buildGraphData(primaryItem.value, competitorProfiles.value, selectedCompetitorIds.value)
		: { nodes: [], links: [], categories: [] },
)

const trendSelectionReady = computed(
	() => Boolean(primaryItem.value?.itemId) && selectedCompetitors.value.length >= MIN_SELECTED_COMPETITORS,
)

const trendData = computed(() =>
	trendSelectionReady.value
		? buildLiveTrendComparison(primaryItem.value, selectedCompetitors.value)
		: { labels: [], series: [], ready: false, failureReason: "" },
)

const graphReady = computed(
	() => graphData.value.nodes.length > 1 && graphData.value.links.length > 0,
)

const trendReady = computed(() => trendData.value.ready === true)

const coverageStats = computed(() =>
	primaryItem.value
		? getLiveTrendCoverageStats(primaryItem.value, selectedCompetitors.value)
		: {
				totalProfiles: 0,
				successProfiles: 0,
				statusLabel: "待预测",
				statusDetail: "0/0 个商品已完成实时预测",
			},
)

const trendEmptyText = computed(() => {
	if (!primaryItem.value) {
		return "选择主商品后可进行实时趋势预测"
	}

	if (selectedCompetitors.value.length < MIN_SELECTED_COMPETITORS) {
		return "至少保留主商品与 2 个竞品后展示趋势对比"
	}

	if (liveTrendFailureReason.value === "missing_feature") {
		return "所选商品缺少最新预测特征，无法生成实时趋势图"
	}

	if (liveTrendFailureReason.value === "error") {
		return "所选商品实时预测失败，当前未展示趋势对比"
	}

	if (liveTrendLoading.value) {
		return "实时预测中"
	}

	return "已选商品全部实时预测成功后展示趋势对比"
})

const reportStatusLabel = computed(() => {
	if (aiLoading.value) {
		return "大模型生成中"
	}

	const statusMap = {
		success: "AI 已生成",
		frontend: "基于大模型生成",
		"frontend-fallback": "基于大模型生成",
		fallback: "基于大模型生成",
		error: "调用失败",
		idle: "未分析",
	}

	return statusMap[displayReport.value?.llmStatus] || "基于大模型生成"
})

const focusedProfile = computed(() => {
	const allProfiles = [primaryItem.value, ...competitorProfiles.value].filter(Boolean)
	return (
		allProfiles.find((item) => item.itemId === focusedItemId.value) ||
		selectedCompetitors.value[0] ||
		primaryItem.value ||
		null
	)
})

function formatMetric(value) {
	if (value === null || value === undefined || value === "") {
		return "-"
	}

	return Number.isFinite(Number(value)) ? Number(value).toLocaleString() : value
}

function formatDecimal(value) {
	const numericValue = Number(value)
	return Number.isFinite(numericValue) ? numericValue.toFixed(2) : "-"
}

function resetAnalysisState() {
	stopCompetitorEnhancementPolling()
	stopLiveTrendRefresh(true)
	primaryItem.value = null
	competitorProfiles.value = []
	selectedCompetitorIds.value = []
	focusedItemId.value = ""
	aiReport.value = null
	aiReportRequested.value = false
	competitorEnhancementTaskId.value = ""
	liveTrendLoading.value = false
	liveTrendFailureReason.value = ""
	disposeGraphChart()
	disposeTrendChart()
}

function stopCompetitorEnhancementPolling() {
	if (competitorEnhancementTimer) {
		clearTimeout(competitorEnhancementTimer)
		competitorEnhancementTimer = null
	}
}

function stopLiveTrendRefresh(cancelPending = false) {
	if (liveTrendRefreshTimer) {
		clearTimeout(liveTrendRefreshTimer)
		liveTrendRefreshTimer = null
	}

	if (cancelPending) {
		liveTrendRequestToken += 1
	}
}

function getSelectedTrendProfiles() {
	return [primaryItem.value, ...selectedCompetitors.value].filter(Boolean)
}

function updateProfileLiveTrendState(itemId, nextState) {
	if (!itemId) {
		return
	}

	if (primaryItem.value?.itemId === itemId) {
		Object.assign(primaryItem.value, nextState)
	}

	const target = competitorProfiles.value.find((item) => item.itemId === itemId)
	if (target) {
		Object.assign(target, nextState)
	}
}

function normalizeLiveTrendValues(result) {
	const values = [
		result?.predPayD1,
		result?.predPayD2,
		result?.predPayD3,
		result?.predPayD4,
		result?.predPayD5,
		result?.predPayD6,
		result?.predPayD7,
	].map((item) => Number(item))

	return values.every((item) => Number.isFinite(item)) ? values : []
}

function primeLiveTrendProfiles(status = "idle") {
	getSelectedTrendProfiles().forEach((item) => {
		updateProfileLiveTrendState(item.itemId, {
			liveTrendStatus: status,
			liveTrendValues: [],
		})
	})
}

async function fetchLiveTrendComparison(token, profiles) {
	const results = await Promise.all(
		profiles.map(async (profile) => {
			const requestPayload = buildLiveTrendRequest(profile)
			if (!requestPayload) {
				return {
					itemId: profile.itemId,
					status: "missing_feature",
					values: [],
				}
			}

			try {
				const result = await predictCompetitorTrendByLiveForecastApi(requestPayload)
				const values = normalizeLiveTrendValues(result)
				if (result?.success !== true || values.length !== 7) {
					return {
						itemId: profile.itemId,
						status: "error",
						values: [],
					}
				}

				return {
					itemId: profile.itemId,
					status: "success",
					values,
				}
			} catch (error) {
				return {
					itemId: profile.itemId,
					status: "error",
					values: [],
				}
			}
		}),
	)

	if (token !== liveTrendRequestToken) {
		return
	}

	results.forEach((result) => {
		updateProfileLiveTrendState(result.itemId, {
			liveTrendStatus: result.status,
			liveTrendValues: result.values,
		})
	})

	liveTrendFailureReason.value = results.find((item) => item.status !== "success")?.status || ""
	liveTrendLoading.value = false
}

function scheduleLiveTrendRefresh(delay = 400) {
	stopLiveTrendRefresh(true)
	liveTrendFailureReason.value = ""

	if (!trendSelectionReady.value) {
		liveTrendLoading.value = false
		primeLiveTrendProfiles("idle")
		return
	}

	const profiles = getSelectedTrendProfiles()
	const missingFeatureProfile = profiles.find((item) => !buildLiveTrendRequest(item))
	if (missingFeatureProfile) {
		profiles.forEach((item) => {
			updateProfileLiveTrendState(item.itemId, {
				liveTrendStatus: "missing_feature",
				liveTrendValues: [],
			})
		})
		updateProfileLiveTrendState(missingFeatureProfile.itemId, {
			liveTrendStatus: "missing_feature",
			liveTrendValues: [],
		})
		liveTrendFailureReason.value = "missing_feature"
		liveTrendLoading.value = false
		return
	}

	primeLiveTrendProfiles("loading")
	liveTrendLoading.value = true
	const requestToken = ++liveTrendRequestToken
	liveTrendRefreshTimer = setTimeout(() => {
		void fetchLiveTrendComparison(requestToken, profiles)
	}, delay)
}

function scheduleCompetitorEnhancementPolling(taskId, delay = 2000) {
	if (!taskId) {
		return
	}

	stopCompetitorEnhancementPolling()
	competitorEnhancementTimer = setTimeout(() => {
		void pollCompetitorEnhancement(taskId)
	}, delay)
}

async function pollCompetitorEnhancement(taskId) {
	if (!taskId || competitorEnhancementTaskId.value !== taskId) {
		return
	}

	try {
		const result = await getCompetitorAnalysisEnhancementStatusByAIApi(taskId)
		if (competitorEnhancementTaskId.value !== taskId) {
			return
		}

		const enhancementStatus = result?.enhancementStatus || "pending"
		if (enhancementStatus === "pending") {
			scheduleCompetitorEnhancementPolling(taskId)
			return
		}

		stopCompetitorEnhancementPolling()
		aiLoading.value = false

		if (enhancementStatus === "completed") {
			aiReport.value = normalizeCompetitorAnalysisResult(result, fallbackReport.value)
			if (result?.llmStatus === "success") {
				message("竞品深度解读已更新", { type: "success" })
				return
			}

			aiReport.value = null
			message(result?.message || "AI 深度解读暂未完整返回，当前已展示分析内容", { type: "warning" })
			return
		}

		aiReport.value = null
		message(result?.message || "AI 深度解读暂未完整返回，当前已展示分析内容", { type: "warning" })
	} catch (error) {
		if (competitorEnhancementTaskId.value !== taskId) {
			return
		}

		stopCompetitorEnhancementPolling()
		aiLoading.value = false
		aiReport.value = null
		message(error?.message || "竞品分析状态获取失败，当前展示规则分析结果", { type: "warning" })
	}
}

function normalizeKeywordQuery() {
	queryForm.keyword = String(queryForm.keyword ?? "").trim()
	queryForm.selectedSourceItemId = String(queryForm.selectedSourceItemId ?? "").trim()
}

function buildKeywordSearchParams(keyword) {
	if (/^\d+$/.test(keyword)) {
		return {
			itemId: keyword,
			item_id: keyword,
		}
	}

	return {
		title: keyword,
	}
}

function normalizeCandidateItem(row = {}) {
	const itemId = String(row?.itemId ?? row?.item_id ?? "").trim()
	const displayTitle = String(row?.titleClean ?? row?.title ?? "").trim() || `商品 ${itemId || "-"}`

	return {
		...row,
		itemId,
		displayTitle,
		title: String(row?.title ?? displayTitle).trim(),
		titleClean: String(row?.titleClean ?? displayTitle).trim(),
		category: String(row?.category ?? "").trim(),
		sellerId: String(row?.sellerId ?? "").trim(),
	}
}

function dedupeCandidateItems(items = []) {
	const seen = new Set()

	return items.filter((item) => {
		if (!item?.itemId || seen.has(item.itemId)) {
			return false
		}

		seen.add(item.itemId)
		return true
	})
}

async function loadItemProfile(itemId, options = {}) {
	const normalizedItemId = String(itemId ?? "").trim()
	if (!normalizedItemId) {
		return null
	}

	const [baseResult, salesResult, featureResult, predictionResult] = await Promise.allSettled([
		options.baseRow
			? Promise.resolve(options.baseRow)
			: getItemBaseByItemIdApi({
					itemId: normalizedItemId,
					item_id: normalizedItemId,
				}),
		getItemSalesByItemIdApi({
			itemId: normalizedItemId,
			item_id: normalizedItemId,
		}),
		getLatestSalesFeatureByItemIdApi({
			itemId: normalizedItemId,
			item_id: normalizedItemId,
		}),
		getSalesForecastPredictionByItemIdApi({
			itemId: normalizedItemId,
			item_id: normalizedItemId,
		}),
	])

	return buildCompetitorProfile({
		itemId: normalizedItemId,
		similarityRow: options.similarityRow || {},
		baseRow: baseResult.status === "fulfilled" ? baseResult.value : {},
		salesRows: salesResult.status === "fulfilled" ? salesResult.value : [],
		featureRows: featureResult.status === "fulfilled" ? featureResult.value : [],
		predictionRows: predictionResult.status === "fulfilled" ? predictionResult.value : [],
		isPrimary: options.isPrimary === true,
	})
}

function sortCompetitors(items = []) {
	return items.slice().sort((left, right) => {
		const similarityDiff = Number(right.similarityScore || 0) - Number(left.similarityScore || 0)
		if (similarityDiff !== 0) {
			return similarityDiff
		}

		return Number(right.pred7DPay || 0) - Number(left.pred7DPay || 0)
	})
}

async function handleSearch() {
	normalizeKeywordQuery()

	if (!queryForm.keyword) {
		message("请输入商品标题关键字", { type: "warning" })
		return
	}

	candidateLoading.value = true
	queryForm.selectedSourceItemId = ""
	keywordCandidates.value = []
	resetAnalysisState()

	try {
		const result = await searchItemCandidatesApi(buildKeywordSearchParams(queryForm.keyword))
		const candidates = dedupeCandidateItems(result.map((item) => normalizeCandidateItem(item)))
		keywordCandidates.value = candidates

		if (!candidates.length) {
			message("没有搜索到匹配的商品候选", { type: "warning" })
			return
		}

		message("候选商品已加载，请先选择 1 个主商品", { type: "success" })
	} catch (error) {
		message(error?.message || "商品候选搜索失败，请稍后重试", { type: "error" })
	} finally {
		candidateLoading.value = false
	}
}

async function loadCompetitorAnalysis(sourceItemId, sourceCandidate = null) {
	loading.value = true
	aiReport.value = null

	try {
		const similarityRows = await getCompetitorSimilarityCandidatesApi({
			sourceItemId,
			source_item_id: sourceItemId,
		})

		const rankedSimilarityRows = similarityRows
			.filter((item) => String(item?.similarItemId ?? "").trim())
			.slice()
			.sort((left, right) => Number(right?.similarityScore || 0) - Number(left?.similarityScore || 0))
			.slice(0, Number(queryForm.topN || DEFAULT_TOP_N))

		const [mainProfile, ...competitorResults] = await Promise.all([
			loadItemProfile(sourceItemId, {
				isPrimary: true,
				baseRow: sourceCandidate || undefined,
			}),
			...rankedSimilarityRows.map((row) =>
				loadItemProfile(row.similarItemId, {
					similarityRow: row,
				}),
			),
		])

		const competitors = sortCompetitors(
			competitorResults.filter((item) => item?.itemId && item.itemId !== sourceItemId),
		)

		if (!mainProfile?.itemId) {
			message("未获取到主商品基础信息，请确认候选商品是否有效", { type: "error" })
			resetAnalysisState()
			return
		}

		primaryItem.value = mainProfile
		competitorProfiles.value = competitors
		selectedCompetitorIds.value = competitors.slice(0, MIN_SELECTED_COMPETITORS).map((item) => item.itemId)
		focusedItemId.value = mainProfile.itemId

		if (!competitors.length) {
			message("已找到主商品，但暂无可用竞品候选", { type: "warning" })
		} else {
			message("竞品智能分析数据已加载", { type: "success" })
		}

		await nextTick()
		renderGraphChart()
		renderTrendChart()
	} catch (error) {
		resetAnalysisState()
		message(error?.message || "竞品分析数据加载失败，请稍后重试", { type: "error" })
	} finally {
		loading.value = false
	}
}

async function handleSelectPrimaryItem(row) {
	const sourceItemId = String(row?.itemId ?? "").trim()
	if (!sourceItemId) {
		message("当前候选商品缺少商品 ID，无法进行竞品分析", { type: "warning" })
		return
	}

	queryForm.selectedSourceItemId = sourceItemId
	resetAnalysisState()
	await loadCompetitorAnalysis(sourceItemId, row)
}

function handleReset() {
	queryForm.keyword = ""
	queryForm.selectedSourceItemId = ""
	queryForm.topN = DEFAULT_TOP_N
	keywordCandidates.value = []
	resetAnalysisState()
}

function toggleCompetitorSelection(row) {
	const currentIds = selectedCompetitorIds.value.slice()
	const currentIndex = currentIds.indexOf(row.itemId)

	if (currentIndex >= 0) {
		currentIds.splice(currentIndex, 1)
		selectedCompetitorIds.value = currentIds
		return
	}

	if (currentIds.length >= MAX_SELECTED_COMPETITORS) {
		message(`最多只能选择 ${MAX_SELECTED_COMPETITORS} 个竞品`, { type: "warning" })
		return
	}

	selectedCompetitorIds.value = [...currentIds, row.itemId]
	focusedItemId.value = row.itemId
}

async function handleGenerateAIReport() {
	if (!primaryItem.value) {
		message("请先选择主商品并加载竞品候选", { type: "warning" })
		return
	}

	if (selectedCompetitors.value.length < MIN_SELECTED_COMPETITORS) {
		message("请至少选择 2 个竞品后再进行 AI 深度解读", { type: "warning" })
		return
	}

	aiLoading.value = true

	try {
		stopCompetitorEnhancementPolling()
		aiReport.value = null
		aiReportRequested.value = true
		competitorEnhancementTaskId.value = ""
		const payload = buildCompetitorAnalysisPayload(
			primaryItem.value,
			selectedCompetitors.value,
			competitorProfiles.value,
		)
		const result = await startCompetitorAnalysisByAIApi(payload)
		competitorEnhancementTaskId.value = result?.enhancementTaskId || ""
		if (result?.enhancementStatus === "pending" && competitorEnhancementTaskId.value) {
			scheduleCompetitorEnhancementPolling(competitorEnhancementTaskId.value)
			message("大模型生成中", { type: "success" })
			return
		}

		aiReport.value = normalizeCompetitorAnalysisResult(result, fallbackReport.value)
		aiLoading.value = false
		message("已生成竞品深度解读", { type: "success" })
	} catch (error) {
		aiReport.value = null
		aiLoading.value = false
		message(error?.message || "AI 接口暂不可用，当前已展示分析内容", { type: "warning" })
	} finally {
		if (!competitorEnhancementTaskId.value) {
			aiLoading.value = false
		}
	}
}

function disposeGraphChart() {
	if (graphChart) {
		graphChart.dispose()
		graphChart = null
	}
}

function disposeTrendChart() {
	if (trendChart) {
		trendChart.dispose()
		trendChart = null
	}
}

function renderGraphChart() {
	if (!graphReady.value || !graphChartRef.value) {
		disposeGraphChart()
		return
	}

	if (!graphChart) {
		graphChart = echarts.init(graphChartRef.value)
		graphChart.on("click", (params) => {
			if (params?.data?.id) {
				focusedItemId.value = params.data.id
			}
		})
	}

	graphChart.setOption({
		tooltip: {
			trigger: "item",
			formatter: (params) => {
				if (params.dataType === "edge") {
					return `相似度：${formatDecimal(params.data?.value)}`
				}
				return params.data?.name || "-"
			},
		},
		legend: {
			top: 0,
		},
		series: [
			{
				type: "graph",
				layout: "force",
				draggable: true,
				roam: true,
				focusNodeAdjacency: true,
				categories: graphData.value.categories,
				data: graphData.value.nodes,
				links: graphData.value.links,
				label: {
					show: true,
					position: "right",
					formatter: "{b}",
				},
				force: {
					repulsion: 260,
					edgeLength: [110, 180],
				},
				lineStyle: {
					curveness: 0.12,
				},
			},
		],
	})
}

function renderTrendChart() {
	if (!trendReady.value || !trendChartRef.value) {
		disposeTrendChart()
		return
	}

	if (!trendChart) {
		trendChart = echarts.init(trendChartRef.value)
	}

	trendChart.setOption({
		tooltip: {
			trigger: "axis",
		},
		legend: {
			top: 0,
		},
		grid: {
			left: 48,
			right: 24,
			top: 56,
			bottom: 40,
		},
		xAxis: {
			type: "category",
			boundaryGap: false,
			data: trendData.value.labels,
		},
		yAxis: {
			type: "value",
		},
		series: trendData.value.series,
	})
}

function handleResize() {
	if (graphChart) {
		graphChart.resize()
	}

	if (trendChart) {
		trendChart.resize()
	}
}

watch(
	() => graphData.value,
	async () => {
		await nextTick()
		renderGraphChart()
	},
	{ deep: true },
)

watch(
	() => trendData.value,
	async () => {
		await nextTick()
		renderTrendChart()
	},
	{ deep: true },
)

watch(
	() => selectedCompetitorIds.value.slice().join(","),
	() => {
		stopCompetitorEnhancementPolling()
		competitorEnhancementTaskId.value = ""
		aiLoading.value = false
		aiReport.value = null
		aiReportRequested.value = false
		scheduleLiveTrendRefresh()
	},
)

watch(
	() => primaryItem.value?.itemId || "",
	() => {
		scheduleLiveTrendRefresh()
	},
)

onMounted(() => {
	window.addEventListener("resize", handleResize)
})

onBeforeUnmount(() => {
	window.removeEventListener("resize", handleResize)
	stopCompetitorEnhancementPolling()
	stopLiveTrendRefresh(true)
	disposeGraphChart()
	disposeTrendChart()
})
</script>

<style scoped lang="scss">
.competitor-page {
	display: flex;
	flex-direction: column;
}

.card-header-with-status {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
}

.llm-generating-indicator {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	font-size: 13px;
	font-weight: 600;
	color: #2563eb;
	white-space: nowrap;
}

.llm-generating-indicator__dot {
	width: 10px;
	height: 10px;
	border-radius: 999px;
	background: #3b82f6;
	box-shadow: 0 0 0 6px rgba(59, 130, 246, 0.12);
	animation: llm-generating-pulse 1.6s ease-in-out infinite;
}

.competitor-hero {
	margin-bottom: 16px;
	background:
		linear-gradient(145deg, rgba(255, 255, 255, 0.95), rgba(240, 248, 255, 0.9) 54%, rgba(255, 247, 243, 0.92)),
		radial-gradient(circle at top left, rgba(37, 99, 235, 0.16), transparent 28%);
}

.summary-panel,
.query-panel,
.panel-card {
	border: 1px solid rgba(148, 163, 184, 0.16);
	box-shadow: 0 24px 54px rgba(15, 23, 42, 0.08);
}

@keyframes llm-generating-pulse {
	0%,
	100% {
		transform: scale(0.92);
		box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.18);
	}

	50% {
		transform: scale(1.08);
		box-shadow: 0 0 0 8px rgba(59, 130, 246, 0.08);
	}
}

.summary-card {
	display: flex;
	flex-direction: column;
	gap: 10px;
	min-height: 136px;
}

.summary-label {
	font-size: 12px;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: #64748b;
}

.summary-value {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: clamp(34px, 2vw, 48px);
	font-weight: 700;
	line-height: 1.1;
	color: #0f172a;
}

.summary-value--compact {
	font-size: 24px;
}

.summary-meta {
	font-size: 13px;
	line-height: 1.7;
	color: #94a3b8;
	word-break: break-word;
}

.query-note {
	margin-top: 8px;
	font-size: 13px;
	line-height: 1.7;
	color: #64748b;
}

.panel-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
}

.panel-header__meta {
	font-size: 12px;
	color: #94a3b8;
}

.graph-canvas,
.trend-canvas {
	width: 100%;
	height: 420px;
}

.focus-card__content {
	display: flex;
	flex-direction: column;
	gap: 14px;
}

.focus-card__title {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: 28px;
	font-weight: 700;
	color: #0f172a;
	word-break: break-word;
}

.focus-card__sub {
	font-size: 13px;
	color: #64748b;
}

.focus-card__tags {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.focus-card__metrics {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 12px;
}

.focus-card__metric,
.comparison-card__metric {
	padding: 12px 14px;
	border-radius: 14px;
	background: rgba(248, 250, 252, 0.92);
	border: 1px solid rgba(148, 163, 184, 0.12);
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.focus-card__metric span,
.comparison-card__metric span {
	font-size: 12px;
	color: #64748b;
}

.focus-card__metric strong,
.comparison-card__metric strong {
	font-size: 14px;
	color: #0f172a;
	word-break: break-word;
}

.candidate-title {
	font-weight: 600;
	color: #0f172a;
	line-height: 1.6;
}

.candidate-sub {
	font-size: 12px;
	color: #94a3b8;
}

.selector-footer {
	margin-top: 12px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	font-size: 12px;
	color: #64748b;
}

.comparison-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 14px;
}

.comparison-card__item {
	padding: 16px;
	border-radius: 18px;
	border: 1px solid rgba(148, 163, 184, 0.16);
	background:
		linear-gradient(180deg, rgba(248, 250, 252, 0.98) 0%, rgba(241, 245, 249, 0.9) 100%);
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.comparison-card__item--primary {
	border-color: rgba(59, 130, 246, 0.28);
	background:
		radial-gradient(circle at top, rgba(59, 130, 246, 0.12), transparent 46%),
		linear-gradient(180deg, rgba(239, 246, 255, 0.98) 0%, rgba(224, 242, 254, 0.92) 100%);
}

.comparison-card__title {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: 22px;
	font-weight: 700;
	color: #0f172a;
}

.comparison-card__subtitle {
	font-size: 12px;
	color: #64748b;
}

.report-content,
.strategy-content {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.report-summary {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

.report-section {
	padding: 16px 18px;
	border-radius: 20px;
	background: rgba(248, 250, 252, 0.92);
	border: 1px solid rgba(148, 163, 184, 0.12);
}

.report-section h3 {
	margin-bottom: 10px;
	font-size: 15px;
	font-weight: 700;
	color: #0f172a;
}

.report-section p,
.report-section li,
.strategy-list li {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

.report-section ul,
.strategy-list {
	padding-left: 18px;
}

.strategy-block {
	display: flex;
	flex-direction: column;
	gap: 10px;
	padding: 16px 18px;
	border-radius: 20px;
	background: rgba(248, 250, 252, 0.92);
	border: 1px solid rgba(148, 163, 184, 0.12);
}

.strategy-block__title {
	font-size: 14px;
	font-weight: 700;
	color: #0f172a;
}

.strategy-content :deep(.el-tag) {
	white-space: normal;
	height: auto;
	line-height: 1.6;
}

.strategy-status {
	font-size: 13px;
	color: #64748b;
}

@media (max-width: 1200px) {
	.graph-canvas,
	.trend-canvas {
		height: 340px;
	}
}

@media (max-width: 768px) {
	.focus-card__metrics {
		grid-template-columns: 1fr;
	}

	.selector-footer {
		flex-direction: column;
		align-items: flex-start;
	}
}
</style>


