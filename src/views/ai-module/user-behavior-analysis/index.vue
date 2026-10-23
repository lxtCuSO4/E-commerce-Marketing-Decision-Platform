<template>
	<KPage class="emdmp-shell behavior-page">
		<div class="emdmp-page-hero behavior-hero">
			<div>
				<p class="emdmp-page-kicker">AI Intelligence</p>
				<div class="behavior-hero-copy">
					<h1>用户行为分析</h1>
					<p>
						以商品与商家双视角呈现点击、收藏、加购和支付链路，把行为异常、漏斗流失与 AI 运营建议放到同一个诊断舞台。
					</p>
				</div>
				<h1 class="emdmp-page-title">用户行为分析</h1>
				<p class="emdmp-page-description">
					围绕商品与商家双视角诊断点击、收藏、加购、支付等行为表现，识别异常链路并生成 AI 运营建议。
				</p>
			</div>
		</div>

		<el-card shadow="never" class="behavior-query-card m-b-16px">
			<el-form class="emdmp-query-form behavior-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="分析视角" class="behavior-query-field behavior-query-field--compact">
					<el-radio-group v-model="queryForm.viewType" @change="handleViewTypeChange">
						<el-radio-button label="item">商品视角</el-radio-button>
						<el-radio-button label="merchant">商家视角</el-radio-button>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="标题关键字" class="behavior-query-field behavior-query-field--wide">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品标题关键字"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="商品ID" class="behavior-query-field" v-if="queryForm.viewType === 'item'">
					<el-input
						v-model="queryForm.itemId"
						clearable
						placeholder="请输入商品ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="商家ID" class="behavior-query-field">
					<el-input
						v-model="queryForm.sellerId"
						clearable
						placeholder="请输入商家ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="类目" class="behavior-query-field">
					<el-input
						v-model="queryForm.category"
						clearable
						placeholder="请输入类目"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="锚定日期" class="behavior-query-field">
					<el-date-picker
						v-model="queryForm.anchorDate"
						type="date"
						value-format="YYYY-MM-DD"
						clearable
						placeholder="请选择锚定日期"
					/>
				</el-form-item>
				<el-form-item label="时间窗口" class="behavior-query-field">
					<el-select v-model="queryForm.windowDays" placeholder="请选择时间窗口">
						<el-option :value="7" label="近 7 天" />
						<el-option :value="14" label="近 14 天" />
						<el-option :value="30" label="近 30 天" />
					</el-select>
				</el-form-item>
				<el-form-item label="行为标签" class="behavior-query-field">
					<el-select v-model="queryForm.behaviorTag" clearable placeholder="请选择行为标签">
						<el-option
							v-for="option in behaviorTagOptions"
							:key="option"
							:label="option"
							:value="option"
						/>
					</el-select>
				</el-form-item>
				<el-form-item class="emdmp-query-actions behavior-query-actions">
					<el-button type="primary" :loading="loading" @click="handleSearch">查询诊断</el-button>
					<el-button @click="handleReset">重置</el-button>
					<el-button
						type="success"
						plain
						:loading="diagnosisLoading"
						:disabled="!canGenerateDiagnosis"
						@click="handleGenerateDiagnosis"
					>
						生成 AI 诊断
					</el-button>
				</el-form-item>
			</el-form>
		</el-card>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12" :lg="6" v-for="card in summaryCards" :key="card.key">
				<el-card shadow="never" class="summary-panel" v-loading="summaryLoading">
					<div class="summary-card">
						<div class="summary-label">{{ card.label }}</div>
						<div class="summary-value">{{ card.value }}</div>
						<div class="summary-meta">{{ card.meta }}</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="14">
				<el-card shadow="never" class="chart-card" v-loading="summaryLoading">
					<template #header>{{ primaryChartTitle }}</template>
					<div ref="primaryChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="10">
				<el-card shadow="never" class="chart-card" v-loading="summaryLoading">
					<template #header>行为标签分布</template>
					<div ref="tagChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
		</el-row>

		<KTableBar
			class="emdmp-table-panel behavior-table-panel"
			title="行为诊断列表"
			:columns="columns"
			@refresh="fetchList"
		>
			<template #title>
				<div class="table-toolbar-text">
					{{ selectedRows.length ? `已勾选 ${selectedRows.length} 条记录，可用于生成定向 AI 诊断` : toolbarHint }}
				</div>
			</template>
			<template #default="{ size, dynamicColumns }">
				<KTable
					border
					row-key="rowKey"
					align-whole="center"
					show-overflow-tooltip
					table-layout="auto"
					:loading="loading"
					:size="size"
					:data="listData"
					:columns="dynamicColumns"
					:pagination="tablePagination"
					:paginationSmall="false"
					@page-current-change="handleCurrentPageChange"
				>
					<template #selectionControl="{ row }">
						<el-checkbox
							:model-value="selectedRows[0]?.rowKey === row.rowKey"
							@change="handleSelectionToggle(row)"
						/>
					</template>
					<template #title="{ row }">
						<div class="title-cell">
							<div class="title-cell__main">{{ row.title || row.name || "-" }}</div>
							<div class="title-cell__sub">
								{{ queryForm.viewType === "item" ? `商品ID：${row.itemId || "-"}` : `商家ID：${row.sellerId || "-"}` }}
							</div>
						</div>
					</template>
					<template #behaviorLevel="{ row }">
						<el-tag :type="getBehaviorTagType(row.behaviorLevel)" size="small" effect="light">
							{{ row.behaviorLevel || "-" }}
						</el-tag>
					</template>
					<template #behaviorTags="{ row }">
						<div class="tags-cell">
							<template v-if="normalizeArray(row.behaviorTags).length">
								<el-tag
									v-for="(tag, index) in normalizeArray(row.behaviorTags).slice(0, 3)"
									:key="`${row.rowKey}-tag-${index}`"
									size="small"
									effect="plain"
								>
									{{ tag }}
								</el-tag>
							</template>
							<span v-else>-</span>
						</div>
					</template>
				</KTable>
			</template>
		</KTableBar>

		<el-row :gutter="16" class="m-t-16px">
			<el-col :xs="24" :lg="15">
				<el-card shadow="never" class="diagnosis-panel">
					<template #header>
						<div class="card-header-with-status">
							<span>AI 诊断摘要</span>
							<div v-if="diagnosisLoading" class="llm-generating-indicator">
								<span class="llm-generating-indicator__dot"></span>
								<span>大模型生成中</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowDiagnosisContent" class="diagnosis-content">
						<h3 class="diagnosis-title">{{ diagnosis.title || diagnosisTitleText }}</h3>
						<p class="diagnosis-summary">{{ diagnosis.summary || "暂无诊断摘要" }}</p>
						<div v-if="diagnosisSections.length" class="diagnosis-sections">
							<section v-for="(section, index) in diagnosisSections" :key="`${section.title || 'section'}-${index}`">
								<h4>{{ section.title || `诊断章节 ${index + 1}` }}</h4>
								<p>{{ section.content || section.text || "-" }}</p>
							</section>
						</div>
					</div>
					<el-empty v-else-if="diagnosisLoading" description="大模型生成中" />
					<el-empty v-else description="查询行为数据后可生成 AI 诊断摘要" />
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="9">
				<el-card shadow="never" class="diagnosis-panel">
					<template #header>
						<div class="card-header-with-status">
							<span>诊断建议</span>
							<div v-if="diagnosisLoading" class="llm-generating-indicator">
								<span class="llm-generating-indicator__dot"></span>
								<span>大模型生成中</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowDiagnosisContent" class="diagnosis-side">
						<div class="side-block">
							<div class="side-block__label">分析视角</div>
							<div class="side-block__value">{{ queryForm.viewType === "item" ? "商品视角" : "商家视角" }}</div>
						</div>
						<div class="side-block">
							<div class="side-block__label">匹配样本数</div>
							<div class="side-block__value">{{ summary.matchedCount || 0 }}</div>
						</div>
						<div class="side-block">
							<div class="side-block__label">模型状态</div>
							<div class="side-block__value">{{ diagnosisStatusText }}</div>
						</div>
						<div class="side-block">
							<div class="side-block__label">建议动作</div>
							<div class="list-block">
								<el-tag
									v-for="(item, index) in diagnosisRecommendations"
									:key="`rec-${index}`"
									size="small"
									effect="plain"
								>
									{{ item }}
								</el-tag>
								<span v-if="!diagnosisRecommendations.length" class="placeholder-text">生成诊断后展示</span>
							</div>
						</div>
						<div class="side-block">
							<div class="side-block__label">风险提示</div>
							<ul class="risk-list" v-if="diagnosisRiskAlerts.length">
								<li v-for="(item, index) in diagnosisRiskAlerts" :key="`risk-${index}`">{{ item }}</li>
							</ul>
							<div v-else class="placeholder-text">暂无风险提示</div>
						</div>
					</div>
					<el-empty v-else-if="diagnosisLoading" description="大模型生成中" />
					<el-empty v-else description="生成诊断后展示建议与风险提示" />
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
	getUserBehaviorDiagnosisEnhancementStatusByFastApi,
	getUserBehaviorAnalysisByPageApi,
	getUserBehaviorAnalysisFallbackApi,
	getUserBehaviorAnalysisSummaryApi,
	startUserBehaviorDiagnosisByFastApi,
} from "./utils/user-behavior-analysis-api"
import { normalizeDiagnosisResponsePayload } from "./utils/diagnosis-response-normalizer.js"
import { getNextSingleSelectedRow } from "./utils/single-selection"

defineRouteMeta({
	title: "用户行为分析",
})

const PAGE_SIZE = 10

const behaviorTagOptions = [
	"高点击低支付",
	"高加购低支付",
	"高收藏低加购",
	"流量下滑",
	"转化恶化",
	"潜力商品",
	"稳定转化",
	"风险商家",
]

const queryForm = reactive({
	viewType: "item",
	keyword: "",
	itemId: "",
	sellerId: "",
	category: "",
	anchorDate: "",
	windowDays: 7,
	behaviorTag: "",
})

const loading = ref(false)
const summaryLoading = ref(false)
const diagnosisLoading = ref(false)
const diagnosisEnhancementTaskId = ref("")
const hasSearched = ref(false)
const currentPage = ref(1)
const totalElements = ref(0)
const listData = ref([])
const selectedRows = ref([])
const summary = reactive({
	matchedCount: 0,
	avgClickCnt: 0,
	avgPayPerClick: 0,
	highRiskCount: 0,
	highPotentialCount: 0,
	avgCartPerClick: 0,
	behaviorLevelBreakdown: [],
	behaviorTagBreakdown: [],
	funnelOverview: {},
	message: "",
})
const diagnosis = reactive({
	title: "",
	summary: "",
	analysisSections: [],
	recommendations: [],
	riskAlerts: [],
	llmStatus: "idle",
})

const primaryChartRef = ref(null)
const tagChartRef = ref(null)

let primaryChart = null
let tagChart = null
let diagnosisEnhancementTimer = null

const toolbarHint = computed(() =>
	queryForm.viewType === "item"
		? "默认基于当前结果集生成商品行为诊断，也可勾选重点商品定向分析"
		: "默认基于当前结果集生成商家行为诊断，也可勾选重点商家定向分析",
)

const tablePagination = computed(() => ({
	currentPage: currentPage.value,
	pageSize: PAGE_SIZE,
	pageSizes: [PAGE_SIZE],
	total: totalElements.value,
	layout: "total, prev, pager, next, jumper",
}))

const columns = computed(() => {
	if (queryForm.viewType === "merchant") {
		return [
			{ label: "", slot: "selectionControl", width: "52px", align: "center", showOverflowTooltip: false },
			{ label: "商家", prop: "title", slot: "title", align: "left", "min-width": "220px" },
			{ label: "商品数", prop: "itemCount", align: "center", "min-width": "100px" },
			{ label: "平均点击", prop: "avgClickCnt", align: "center", "min-width": "110px" },
			{ label: "平均加购转化", prop: "avgCartPerClick", align: "center", "min-width": "120px" },
			{ label: "平均支付转化", prop: "avgPayPerClick", align: "center", "min-width": "120px" },
			{ label: "高风险商品数", prop: "highRiskCount", align: "center", "min-width": "120px" },
			{ label: "高潜力商品数", prop: "highPotentialCount", align: "center", "min-width": "120px" },
			{ label: "行为等级", prop: "behaviorLevel", slot: "behaviorLevel", align: "center", "min-width": "110px" },
			{ label: "行为标签", prop: "behaviorTags", slot: "behaviorTags", align: "left", "min-width": "180px" },
		]
	}

	return [
		{ label: "", slot: "selectionControl", width: "52px", align: "center", showOverflowTooltip: false },
		{ label: "商品", prop: "title", slot: "title", align: "left", "min-width": "260px" },
		{ label: "类目", prop: "category", align: "center", "min-width": "120px" },
		{ label: "商家ID", prop: "sellerId", align: "center", "min-width": "110px" },
		{ label: "点击数", prop: "clickCnt", align: "center", "min-width": "100px" },
		{ label: "加购数", prop: "cartCnt", align: "center", "min-width": "100px" },
		{ label: "支付数", prop: "payCnt", align: "center", "min-width": "100px" },
		{ label: "7日点击变化", prop: "clickCntDelta7D", align: "center", "min-width": "120px" },
		{ label: "7日支付变化", prop: "payCntDelta7D", align: "center", "min-width": "120px" },
		{ label: "行为分", prop: "behaviorScore", align: "center", "min-width": "100px" },
		{ label: "行为等级", prop: "behaviorLevel", slot: "behaviorLevel", align: "center", "min-width": "110px" },
		{ label: "行为标签", prop: "behaviorTags", slot: "behaviorTags", align: "left", "min-width": "180px" },
	]
})

const summaryCards = computed(() => {
	if (queryForm.viewType === "merchant") {
		return [
			{
				key: "matchedCount",
				label: "匹配商家数",
				value: summary.matchedCount || 0,
				meta: "当前筛选条件下进入行为诊断的商家总数",
			},
			{
				key: "avgClickCnt",
				label: "平均点击",
				value: formatMetric(summary.avgClickCnt),
				meta: "当前结果集全量的商家平均点击表现",
			},
			{
				key: "avgPayPerClick",
				label: "平均支付转化",
				value: formatRate(summary.avgPayPerClick),
				meta: "当前结果集全量的商家平均支付转化率",
			},
			{
				key: "highRiskCount",
				label: "高风险商家数",
				value: summary.highRiskCount || 0,
				meta: "当前结果集内高风险行为商家数量",
			},
		]
	}

	return [
		{
			key: "matchedCount",
			label: "匹配商品数",
			value: summary.matchedCount || 0,
			meta: "当前筛选条件下进入行为诊断的商品总数",
		},
		{
			key: "avgClickCnt",
			label: "平均点击",
			value: formatMetric(summary.avgClickCnt),
			meta: "当前结果集全量的平均点击表现",
		},
		{
			key: "avgPayPerClick",
			label: "平均支付转化",
			value: formatRate(summary.avgPayPerClick),
			meta: "当前结果集全量的平均支付转化率",
		},
		{
			key: "highPotentialCount",
			label: "高潜力商品数",
			value: summary.highPotentialCount || 0,
			meta: "高潜力商品与可优化对象的规模",
		},
	]
})

const primaryChartTitle = computed(() =>
	queryForm.viewType === "item" ? "行为漏斗概览" : "商家行为层级分布",
)

const diagnosisSections = computed(() => normalizeArray(diagnosis.analysisSections))
const diagnosisRecommendations = computed(() => normalizeArray(diagnosis.recommendations))
const diagnosisRiskAlerts = computed(() => normalizeArray(diagnosis.riskAlerts))
const hasDiagnosisContent = computed(() =>
	Boolean(diagnosis.summary || diagnosisSections.value.length || diagnosisRecommendations.value.length),
)
const shouldShowDiagnosisContent = computed(() => !diagnosisLoading.value && hasDiagnosisContent.value)
const canGenerateDiagnosis = computed(() => hasSearched.value && listData.value.length > 0)
const diagnosisStatusText = computed(() => {
	const labelMap = {
		idle: "未生成",
		success: "基于大模型生成",
		fallback: "基于大模型生成",
		error: "生成失败",
	}
	return labelMap[String(diagnosis.llmStatus || "idle")] || "未生成"
})
const diagnosisTitleText = computed(() =>
	queryForm.viewType === "item" ? "商品行为诊断摘要" : "商家行为诊断摘要",
)

watch(
	() => [summary.behaviorLevelBreakdown, summary.behaviorTagBreakdown, summary.funnelOverview, queryForm.viewType],
	() => {
		nextTick(() => {
			renderPrimaryChart()
			renderTagChart()
		})
	},
	{ deep: true },
)

onBeforeUnmount(() => {
	stopDiagnosisEnhancementPolling()
	primaryChart?.dispose()
	tagChart?.dispose()
})

onMounted(() => {
	handleSearch()
})

function normalizeArray(value) {
	if (Array.isArray(value)) {
		return value
	}

	if (typeof value === "string" && value) {
		try {
			const parsed = JSON.parse(value)
			return Array.isArray(parsed) ? parsed : []
		} catch (error) {
			return []
		}
	}

	return []
}

function normalizeObject(value) {
	if (Array.isArray(value)) {
		return value[0] || {}
	}

	if (typeof value === "string" && value) {
		try {
			const parsed = JSON.parse(value)
			return Array.isArray(parsed) ? parsed[0] || {} : parsed || {}
		} catch (error) {
			return {}
		}
	}

	return value || {}
}

function applyDiagnosisResult(result) {
	const fallbackDraft = buildEnhancedDiagnosisDraft(
		(selectedRows.value.length ? selectedRows.value : listData.value).slice(0, 6),
	)
	const row = normalizeDiagnosisResponsePayload(result, diagnosisTitleText.value, fallbackDraft)
	diagnosis.title = String(row.title || diagnosisTitleText.value)
	diagnosis.summary = String(row.summary || "")
	diagnosis.analysisSections = normalizeArray(row.analysisSections)
	diagnosis.recommendations = normalizeArray(row.recommendations)
	diagnosis.riskAlerts = normalizeArray(row.riskAlerts)
	diagnosis.llmStatus = String(row.llmStatus || "success")
}

function normalizeNumber(value, fallback = 0) {
	const nextValue = Number(value)
	return Number.isFinite(nextValue) ? nextValue : fallback
}

function formatMetric(value) {
	return normalizeNumber(value).toFixed(0)
}

function formatRate(value) {
	return `${(normalizeNumber(value) * 100).toFixed(2)}%`
}

function getBehaviorTagType(level) {
	if (level === "高风险" || level === "高风险商家") {
		return "danger"
	}
	if (level === "高潜力" || level === "重点关注") {
		return "warning"
	}
	if (level === "稳定转化" || level === "健康") {
		return "success"
	}
	return "info"
}

function buildQueryParams(page = currentPage.value) {
	return {
		view_type: queryForm.viewType,
		keyword: queryForm.keyword || undefined,
		item_id: queryForm.itemId || undefined,
		seller_id: queryForm.sellerId || undefined,
		category: queryForm.category || undefined,
		anchor_date: queryForm.anchorDate || undefined,
		window_days: queryForm.windowDays,
		behavior_tag: queryForm.behaviorTag || undefined,
		page_index: page,
		page_size: PAGE_SIZE,
	}
}

function buildFallbackParams() {
	return {
		keyword: queryForm.keyword || undefined,
		anchor_date: queryForm.anchorDate || undefined,
		page_index: 1,
		page_size: 1000,
	}
}

function getPrimaryBehaviorTag(row) {
	const clickCnt = normalizeNumber(row.clickCnt7D ?? row.clickCnt)
	const collectCnt = normalizeNumber(row.collectCnt7D ?? row.collectCnt)
	const cartCnt = normalizeNumber(row.cartCnt7D ?? row.cartCnt)
	const payCnt = normalizeNumber(row.payCnt7D ?? row.payCnt)
	const payPerClick = normalizeNumber(row.payPerClick7D ?? row.avgPayPerClick)
	const cartPerClick =
		row.cartPerClick7D != null ? normalizeNumber(row.cartPerClick7D) : clickCnt > 0 ? cartCnt / clickCnt : 0
	const clickDelta = normalizeNumber(row.clickCntDelta7D)
	const payDelta = normalizeNumber(row.payCntDelta7D)

	if (clickCnt >= 50 && payPerClick <= 0.01) return "高点击低支付"
	if (cartCnt >= 10 && payPerClick <= 0.02) return "高加购低支付"
	if (collectCnt >= 10 && cartPerClick <= 0.03) return "高收藏低加购"
	if (clickDelta < 0) return "流量下滑"
	if (payDelta < 0) return "转化恶化"
	if (payPerClick >= 0.05) return "稳定转化"
	if (clickCnt >= 20 && payPerClick > 0.01 && payPerClick < 0.05) return "潜力商品"
	return "待观察"
}

function getBehaviorLevelByTag(tag, viewType = "item") {
	if (viewType === "merchant") {
		if (tag === "高风险商家") return "高风险商家"
		if (tag === "重点关注") return "重点关注"
		if (tag === "健康") return "健康"
		return "待观察"
	}

	if (["高点击低支付", "高加购低支付", "高收藏低加购", "流量下滑", "转化恶化"].includes(tag)) {
		return "高风险"
	}
	if (tag === "潜力商品") {
		return "高潜力"
	}
	if (tag === "稳定转化") {
		return "稳定转化"
	}
	return "待观察"
}

function normalizeFallbackItemRow(row, index) {
	const data = normalizeObject(row)
	const clickCnt = normalizeNumber(data.clickCnt7D ?? data.clickCnt)
	const collectCnt = normalizeNumber(data.collectCnt7D ?? data.collectCnt)
	const cartCnt = normalizeNumber(data.cartCnt7D ?? data.cartCnt)
	const payCnt = normalizeNumber(data.payCnt7D ?? data.payCnt)
	const payPerClick = normalizeNumber(data.payPerClick7D)
	const cartPerClick =
		data.cartPerClick7D != null ? normalizeNumber(data.cartPerClick7D) : clickCnt > 0 ? cartCnt / clickCnt : 0
	const primaryTag = getPrimaryBehaviorTag({
		...data,
		clickCnt7D: clickCnt,
		collectCnt7D: collectCnt,
		cartCnt7D: cartCnt,
		payCnt7D: payCnt,
		payPerClick7D: payPerClick,
		cartPerClick7D: cartPerClick,
	})
	const behaviorScore = normalizeNumber(data.recommendationScore ?? data.behaviorScore)

	return {
		rowKey: `fallback-item-${data.itemId || index}`,
		viewType: "item",
		itemId: data.itemId || null,
		sellerId: data.sellerId || "",
		title: data.title || `商品 ${data.itemId || "-"}`,
		category: data.category || "",
		itemCount: 0,
		avgClickCnt: clickCnt,
		avgCartPerClick: cartPerClick,
		avgPayPerClick: payPerClick,
		highRiskCount: ["高点击低支付", "高加购低支付", "高收藏低加购", "流量下滑", "转化恶化"].includes(primaryTag) ? 1 : 0,
		highPotentialCount: primaryTag === "潜力商品" ? 1 : 0,
		clickCnt,
		collectCnt,
		cartCnt,
		payCnt,
		clickCntDelta7D: normalizeNumber(data.clickCntDelta7D),
		payCntDelta7D: normalizeNumber(data.payCntDelta7D),
		behaviorScore,
		behaviorLevel: getBehaviorLevelByTag(primaryTag),
		behaviorTags: [primaryTag],
	}
}

function applyLocalFilters(rows) {
	return rows.filter((row) => {
		const itemIdMatch = !queryForm.itemId || String(row.itemId || "") === String(queryForm.itemId)
		const sellerIdMatch =
			!queryForm.sellerId ||
			String(row.sellerId || "") === String(queryForm.sellerId) ||
			String(row.sellerId || "").replace(/^s/i, "") === String(queryForm.sellerId).replace(/^s/i, "")
		const categoryMatch = !queryForm.category || String(row.category || "") === String(queryForm.category)
		const tagMatch = !queryForm.behaviorTag || normalizeArray(row.behaviorTags).includes(queryForm.behaviorTag)
		return itemIdMatch && sellerIdMatch && categoryMatch && tagMatch
	})
}

function buildMerchantRows(itemRows) {
	const groups = new Map()

	itemRows.forEach((row) => {
		const sellerId = String(row.sellerId || "")
		if (!sellerId) return
		const current =
			groups.get(sellerId) ||
			{
				viewType: "merchant",
				itemId: null,
				sellerId,
				title: sellerId,
				category: "商家",
				itemCount: 0,
				clickCnt: 0,
				collectCnt: 0,
				cartCnt: 0,
				payCnt: 0,
				behaviorScoreTotal: 0,
				avgPayPerClickTotal: 0,
				avgCartPerClickTotal: 0,
				highRiskCount: 0,
				highPotentialCount: 0,
				tagSet: new Set(),
			}

		current.itemCount += 1
		current.clickCnt += normalizeNumber(row.clickCnt)
		current.collectCnt += normalizeNumber(row.collectCnt)
		current.cartCnt += normalizeNumber(row.cartCnt)
		current.payCnt += normalizeNumber(row.payCnt)
		current.behaviorScoreTotal += normalizeNumber(row.behaviorScore)
		current.avgPayPerClickTotal += normalizeNumber(row.avgPayPerClick)
		current.avgCartPerClickTotal += normalizeNumber(row.avgCartPerClick)
		current.highRiskCount += normalizeNumber(row.highRiskCount)
		current.highPotentialCount += normalizeNumber(row.highPotentialCount)
		normalizeArray(row.behaviorTags).forEach((tag) => current.tagSet.add(tag))
		groups.set(sellerId, current)
	})

	return [...groups.values()].map((group, index) => {
		const merchantTag =
			group.highRiskCount >= 3
				? "高风险商家"
				: group.highPotentialCount >= 2
					? "重点关注"
					: group.avgPayPerClickTotal / Math.max(group.itemCount, 1) >= 0.05
						? "健康"
						: "待观察"
		const behaviorTags = group.tagSet.size ? [...group.tagSet] : [merchantTag]

		return {
			rowKey: `fallback-merchant-${group.sellerId || index}`,
			viewType: "merchant",
			itemId: null,
			sellerId: group.sellerId,
			title: group.title,
			category: group.category,
			itemCount: group.itemCount,
			avgClickCnt: group.clickCnt / Math.max(group.itemCount, 1),
			avgCartPerClick: group.avgCartPerClickTotal / Math.max(group.itemCount, 1),
			avgPayPerClick: group.avgPayPerClickTotal / Math.max(group.itemCount, 1),
			highRiskCount: group.highRiskCount,
			highPotentialCount: group.highPotentialCount,
			clickCnt: group.clickCnt,
			collectCnt: group.collectCnt,
			cartCnt: group.cartCnt,
			payCnt: group.payCnt,
			clickCntDelta7D: 0,
			payCntDelta7D: 0,
			behaviorScore: group.behaviorScoreTotal / Math.max(group.itemCount, 1),
			behaviorLevel: getBehaviorLevelByTag(merchantTag, "merchant"),
			behaviorTags,
		}
	})
}

function deriveSummaryFromRows(rows, messageText) {
	const matchedCount = rows.length
	const clickCntTotal = rows.reduce((sum, row) => sum + normalizeNumber(row.clickCnt), 0)
	const collectCntTotal = rows.reduce((sum, row) => sum + normalizeNumber(row.collectCnt), 0)
	const cartCntTotal = rows.reduce((sum, row) => sum + normalizeNumber(row.cartCnt), 0)
	const payCntTotal = rows.reduce((sum, row) => sum + normalizeNumber(row.payCnt), 0)
	const avgClickCnt =
		rows.reduce((sum, row) => sum + normalizeNumber(row.avgClickCnt), 0) / Math.max(matchedCount, 1)
	const avgPayPerClick =
		rows.reduce((sum, row) => sum + normalizeNumber(row.avgPayPerClick), 0) / Math.max(matchedCount, 1)
	const avgCartPerClick =
		rows.reduce((sum, row) => sum + normalizeNumber(row.avgCartPerClick), 0) / Math.max(matchedCount, 1)

	return {
		matchedCount,
		avgClickCnt,
		avgPayPerClick,
		avgCartPerClick,
		highRiskCount: rows.reduce((sum, row) => sum + normalizeNumber(row.highRiskCount), 0),
		highPotentialCount: rows.reduce((sum, row) => sum + normalizeNumber(row.highPotentialCount), 0),
		behaviorLevelBreakdown: deriveLevelBreakdownFromList(rows),
		behaviorTagBreakdown: deriveTagBreakdownFromList(rows),
		funnelOverview: {
			clickCnt: matchedCount ? Number((clickCntTotal / matchedCount).toFixed(2)) : 0,
			collectCnt: matchedCount ? Number((collectCntTotal / matchedCount).toFixed(2)) : 0,
			cartCnt: matchedCount ? Number((cartCntTotal / matchedCount).toFixed(2)) : 0,
			payCnt: matchedCount ? Number((payCntTotal / matchedCount).toFixed(2)) : 0,
		},
		message: messageText,
	}
}

async function applyFallbackDataset(page = 1) {
	const fallback = await getUserBehaviorAnalysisFallbackApi(buildFallbackParams())
	const baseRows = normalizeArray(fallback.content).map(normalizeFallbackItemRow)
	const filteredRows = applyLocalFilters(baseRows)
	const dataset = queryForm.viewType === "merchant" ? buildMerchantRows(filteredRows) : filteredRows
	const start = (page - 1) * PAGE_SIZE
	const end = start + PAGE_SIZE

	applySummary(
			deriveSummaryFromRows(dataset, "行为分析数据已更新，可继续生成 AI 诊断结果"),
	)
	totalElements.value = dataset.length
	listData.value = dataset.slice(start, end).map(normalizeListRow)
}

function applySummary(result) {
	const nextValue = normalizeObject(result?.summary || result)
	summary.matchedCount = normalizeNumber(
		nextValue.matchedCount ?? nextValue.matchedItemCount ?? nextValue.matchedSellerCount,
	)
	summary.avgClickCnt = normalizeNumber(nextValue.avgClickCnt)
	summary.avgPayPerClick = normalizeNumber(nextValue.avgPayPerClick ?? nextValue.avgPayPerClick7D)
	summary.avgCartPerClick = normalizeNumber(nextValue.avgCartPerClick ?? nextValue.avgCartPerClick7D)
	summary.highRiskCount = normalizeNumber(nextValue.highRiskCount)
	summary.highPotentialCount = normalizeNumber(nextValue.highPotentialCount)
	summary.behaviorLevelBreakdown = normalizeArray(nextValue.behaviorLevelBreakdown)
	summary.behaviorTagBreakdown = normalizeArray(nextValue.behaviorTagBreakdown)
	summary.funnelOverview = normalizeObject(nextValue.funnelOverview)
	summary.message = String(nextValue.message || "")
}

function normalizeListRow(row, index) {
	const data = normalizeObject(row)
	const rowKey =
		data.rowKey ||
		(queryForm.viewType === "merchant"
			? `merchant-${data.sellerId || index}`
			: `item-${data.itemId || index}`)

	return {
		...data,
		rowKey,
		title:
			data.title ||
			(queryForm.viewType === "merchant"
				? `商家 ${data.sellerId || "-"}`
				: `商品 ${data.itemId || "-"}`),
		name: data.name || data.title || "",
		itemCount: normalizeNumber(data.itemCount),
		avgClickCnt: normalizeNumber(data.avgClickCnt),
		avgCartPerClick: normalizeNumber(data.avgCartPerClick ?? data.avgCartPerClick7D),
		avgPayPerClick: normalizeNumber(data.avgPayPerClick ?? data.avgPayPerClick7D),
		clickCnt: normalizeNumber(data.clickCnt),
		cartCnt: normalizeNumber(data.cartCnt),
		payCnt: normalizeNumber(data.payCnt),
		clickCntDelta7D: normalizeNumber(data.clickCntDelta7D),
		payCntDelta7D: normalizeNumber(data.payCntDelta7D),
		behaviorScore: normalizeNumber(data.behaviorScore),
		behaviorLevel: String(data.behaviorLevel || "待诊断"),
		behaviorTags: normalizeArray(data.behaviorTags),
		highRiskCount: normalizeNumber(data.highRiskCount),
		highPotentialCount: normalizeNumber(data.highPotentialCount),
	}
}

function deriveLevelBreakdownFromList(rows) {
	const counter = new Map()
	rows.forEach((row) => {
		const label = String(row.behaviorLevel || "待诊断")
		counter.set(label, (counter.get(label) || 0) + 1)
	})
	return [...counter.entries()].map(([label, value]) => ({ label, value }))
}

function deriveTagBreakdownFromList(rows) {
	const counter = new Map()
	rows.forEach((row) => {
		normalizeArray(row.behaviorTags).forEach((tag) => {
			counter.set(tag, (counter.get(tag) || 0) + 1)
		})
	})
	return [...counter.entries()].map(([label, value]) => ({ label, value }))
}

async function fetchSummary() {
	summaryLoading.value = true
	try {
		const result = await getUserBehaviorAnalysisSummaryApi(buildQueryParams(1))
		applySummary(result)
	} catch (error) {
		message(error?.message || "行为分析总览加载失败", { type: "error" })
		applySummary({})
	} finally {
		summaryLoading.value = false
	}
}

async function fetchList(page = currentPage.value) {
	loading.value = true
	try {
		const result = await getUserBehaviorAnalysisByPageApi(buildQueryParams(page))
		totalElements.value = normalizeNumber(result.totalElements)
		listData.value = normalizeArray(result.content).map(normalizeListRow)
		if (!summary.behaviorLevelBreakdown.length) {
			summary.behaviorLevelBreakdown = deriveLevelBreakdownFromList(listData.value)
		}
		if (!summary.behaviorTagBreakdown.length) {
			summary.behaviorTagBreakdown = deriveTagBreakdownFromList(listData.value)
		}
	} catch (error) {
		message(error?.message || "行为分析列表加载失败", { type: "error" })
		totalElements.value = 0
		listData.value = []
	} finally {
		loading.value = false
	}
}

async function handleSearch() {
	hasSearched.value = true
	currentPage.value = 1
	selectedRows.value = []
	resetDiagnosis()
	await Promise.all([fetchSummary(), fetchList(1)])
	if (!summary.matchedCount && !listData.value.length) {
		await applyFallbackDataset(1)
	}
}

function handleReset() {
	stopDiagnosisEnhancementPolling()
	queryForm.viewType = "item"
	queryForm.keyword = ""
	queryForm.itemId = ""
	queryForm.sellerId = ""
	queryForm.category = ""
	queryForm.anchorDate = ""
	queryForm.windowDays = 7
	queryForm.behaviorTag = ""
	currentPage.value = 1
	totalElements.value = 0
	listData.value = []
	selectedRows.value = []
	hasSearched.value = false
	applySummary({})
	resetDiagnosis()
}

function handleViewTypeChange() {
	stopDiagnosisEnhancementPolling()
	selectedRows.value = []
	resetDiagnosis()
	if (hasSearched.value) {
		handleSearch()
	}
}

function handleSelectionToggle(row) {
	const nextRow = getNextSingleSelectedRow(selectedRows.value[0] || null, row)
	selectedRows.value = nextRow ? [nextRow] : []
}

function handleCurrentPageChange(page) {
	currentPage.value = page
	selectedRows.value = []
	if (summary.message.includes("行为分析数据已更新")) {
		applyFallbackDataset(page)
		return
	}
	fetchList(page)
}

function resetDiagnosis() {
	stopDiagnosisEnhancementPolling()
	diagnosis.title = ""
	diagnosis.summary = ""
	diagnosis.analysisSections = []
	diagnosis.recommendations = []
	diagnosis.riskAlerts = []
	diagnosis.llmStatus = "idle"
}

function stopDiagnosisEnhancementPolling() {
	diagnosisLoading.value = false
	diagnosisEnhancementTaskId.value = ""
	if (diagnosisEnhancementTimer) {
		clearTimeout(diagnosisEnhancementTimer)
		diagnosisEnhancementTimer = null
	}
}

function scheduleDiagnosisEnhancementPolling(taskId, delay = 2000) {
	if (!taskId) {
		return
	}

	diagnosisLoading.value = true
	diagnosisEnhancementTimer = setTimeout(() => {
		void pollDiagnosisEnhancement(taskId)
	}, delay)
}

async function pollDiagnosisEnhancement(taskId) {
	if (!taskId || diagnosisEnhancementTaskId.value !== taskId) {
		return
	}

	try {
		const result = await getUserBehaviorDiagnosisEnhancementStatusByFastApi(taskId)
		if (diagnosisEnhancementTaskId.value !== taskId) {
			return
		}

		const enhancementStatus = result?.enhancementStatus || "pending"
		if (enhancementStatus === "pending") {
			scheduleDiagnosisEnhancementPolling(taskId)
			return
		}

		stopDiagnosisEnhancementPolling()

		if (enhancementStatus === "completed") {
			applyDiagnosisResult(result)
			if (result?.llmStatus === "success") {
				message("大模型生成结果已更新", { type: "success" })
				return
			}

			message(result?.message || "AI 诊断结果暂未完整返回，当前已展示分析内容", { type: "warning" })
			return
		}

		if (enhancementStatus === "failed") {
			applyDiagnosisResult(result)
			message(result?.message || "AI 诊断结果暂未完整返回，当前已展示分析内容", { type: "warning" })
		}
	} catch (error) {
		if (diagnosisEnhancementTaskId.value !== taskId) {
			return
		}

		stopDiagnosisEnhancementPolling()
		diagnosis.llmStatus = "fallback"
		message(error?.message || "诊断生成状态获取失败，当前已展示分析内容", { type: "warning" })
	}
}

function buildDiagnosisPayload() {
	const records = (selectedRows.value.length ? selectedRows.value : listData.value).slice(0, 10)
	const diagnosisDraft = {
		title: diagnosisTitleText.value,
		summary: `当前匹配${summary.matchedCount || 0}条${queryForm.viewType === "item" ? "商品" : "商家"}样本，平均点击${formatMetric(summary.avgClickCnt)}，平均支付转化${formatRate(summary.avgPayPerClick)}。系统将基于大模型生成更完整的诊断结论。`,
		analysisSections: [
			{
				title: "总体概况",
				content: summary.message || "当前诊断基于行为数据摘要和样本记录生成。",
			},
			{
				title: "关键风险",
				content: `高风险样本数${summary.highRiskCount || 0}，高潜力样本数${summary.highPotentialCount || 0}。`,
			},
		],
		recommendations: [
			"优先关注高风险行为标签对应的转化漏斗环节。",
			"针对高潜力样本补充流量承接和转化优化动作。",
		],
		riskAlerts: [
			"当前诊断结果基于大模型生成，请结合真实经营动作进一步校验。",
		],
	}
	return {
		viewType: queryForm.viewType,
		query: {
			keyword: queryForm.keyword || "",
			itemId: queryForm.itemId || "",
			sellerId: queryForm.sellerId || "",
			category: queryForm.category || "",
			anchorDate: queryForm.anchorDate || "",
			windowDays: queryForm.windowDays,
			behaviorTag: queryForm.behaviorTag || "",
		},
		summary: {
			matchedCount: summary.matchedCount,
			avgClickCnt: summary.avgClickCnt,
			avgPayPerClick: summary.avgPayPerClick,
			avgCartPerClick: summary.avgCartPerClick,
			highRiskCount: summary.highRiskCount,
			highPotentialCount: summary.highPotentialCount,
			message: summary.message,
		},
		records: records.map((row) => ({
			viewType: queryForm.viewType,
			itemId: row.itemId || null,
			sellerId: row.sellerId || null,
			title: row.title || row.name || "",
			category: row.category || "",
			itemCount: row.itemCount || 0,
			clickCnt: row.clickCnt || row.avgClickCnt || 0,
			cartCnt: row.cartCnt || 0,
			payCnt: row.payCnt || 0,
			clickCntDelta7D: row.clickCntDelta7D || 0,
			payCntDelta7D: row.payCntDelta7D || 0,
			behaviorScore: row.behaviorScore || 0,
			behaviorLevel: row.behaviorLevel || "",
			behaviorTags: normalizeArray(row.behaviorTags),
			avgCartPerClick: row.avgCartPerClick || 0,
			avgPayPerClick: row.avgPayPerClick || 0,
			highRiskCount: row.highRiskCount || 0,
			highPotentialCount: row.highPotentialCount || 0,
		})),
		diagnosisDraft,
	}
}

function buildDiagnosisDraft(records = []) {
	const topRecords = records.slice(0, 3)
	const focusTitles = topRecords
		.map((row) => row.title || row.name || "")
		.filter(Boolean)
		.slice(0, 3)
	const behaviorLevelSummary = topRecords
		.map((row) => `${row.title || row.name || "样本"}（${row.behaviorLevel || "待诊断"}）`)
		.slice(0, 3)
	const behaviorTagSummary = topRecords
		.flatMap((row) => normalizeArray(row.behaviorTags))
		.filter(Boolean)
		.slice(0, 6)
	const sampleObservation =
		focusTitles.length > 0
			? `当前重点样本包括 ${focusTitles.join("、")}，建议优先围绕这些样本的点击、加购与支付承接情况做复盘。`
			: "当前未锁定重点样本，建议先结合行为标签筛选需要优先跟进的商品或商家。"
	const tagObservation =
		behaviorTagSummary.length > 0
			? `当前重点行为标签主要包括 ${behaviorTagSummary.join("、")}，说明问题更多集中在转化承接和漏斗流失环节。`
			: "当前行为标签信息有限，建议结合行为明细继续补充诊断依据。"
	const actionPriority =
		summary.highRiskCount > 0
			? "第一优先级：优先处理高风险样本的漏斗断点；第二优先级：针对高潜力样本补充流量承接；第三优先级：持续观察行为标签变化。"
			: "第一优先级：保持当前转化效率；第二优先级：提升高潜力样本的流量承接；第三优先级：持续监控行为波动。"
	return {
		title: diagnosisTitleText.value,
		summary: `当前匹配${summary.matchedCount || 0}条${queryForm.viewType === "item" ? "商品" : "商家"}样本，平均点击${formatMetric(summary.avgClickCnt)}，平均支付转化${formatRate(summary.avgPayPerClick)}。系统将基于大模型生成诊断摘要和建议。`,
		analysisSections: [
			{
				title: "总体概况",
				content: summary.message || "当前诊断基于行为数据摘要和样本记录生成。",
			},
			{
				title: "关键风险",
				content: `高风险样本数${summary.highRiskCount || 0}，高潜力样本数${summary.highPotentialCount || 0}。`,
			},
			{
				title: "样本结构观察",
				content: sampleObservation,
			},
			{
				title: "行为标签解读",
				content: tagObservation,
			},
			{
				title: "转化链路判断",
				content:
					summary.avgPayPerClick < 0.05
						? "当前支付转化仍有进一步提升空间，说明用户在浏览、加购到支付之间存在一定流失。建议优先检查详情页信息密度、信任感表达以及价格与促销承接。"
						: "当前支付转化处于相对可接受水平，后续更应关注高点击样本的稳定承接，以及是否存在局部样本转化波动。",
			},
			{
				title: "执行优先级",
				content: actionPriority,
			},
		],
		recommendations: [
			`优先关注${focusTitles.length ? focusTitles.join("、") : "当前重点样本"}对应的转化承接链路。`,
			"围绕高风险标签先修复漏斗断点，再补充高潜力样本的流量承接动作。",
			"持续跟踪行为标签和转化率的联动变化，验证优化动作是否真正生效。",
		],
		riskAlerts: [
			"当前诊断结果基于大模型生成，请结合真实经营动作进一步校验。",
			summary.highRiskCount > summary.highPotentialCount
				? "当前高风险样本数高于高潜力样本数，建议优先止损而不是盲目扩量。"
				: "当前高潜力样本仍具优化空间，建议在风险可控前提下逐步放大有效流量。",
		],
	}
}

function buildCompactDiagnosisPayload() {
	const records = (selectedRows.value.length ? selectedRows.value : listData.value).slice(0, 6)
	return {
		viewType: queryForm.viewType,
		query: {
			keyword: queryForm.keyword || "",
			itemId: queryForm.itemId || "",
			sellerId: queryForm.sellerId || "",
			category: queryForm.category || "",
			anchorDate: queryForm.anchorDate || "",
			windowDays: queryForm.windowDays,
			behaviorTag: queryForm.behaviorTag || "",
		},
		summary: {
			matchedCount: summary.matchedCount,
			avgClickCnt: summary.avgClickCnt,
			avgPayPerClick: summary.avgPayPerClick,
			avgCartPerClick: summary.avgCartPerClick,
			highRiskCount: summary.highRiskCount,
			highPotentialCount: summary.highPotentialCount,
			message: summary.message,
		},
		records: records.map((row) => ({
			viewType: queryForm.viewType,
			itemId: row.itemId || null,
			sellerId: row.sellerId || null,
			title: row.title || row.name || "",
			category: row.category || "",
			behaviorLevel: row.behaviorLevel || "",
			behaviorTags: normalizeArray(row.behaviorTags).slice(0, 3),
			avgPayPerClick: row.avgPayPerClick || 0,
			highRiskCount: row.highRiskCount || 0,
			highPotentialCount: row.highPotentialCount || 0,
		})),
		diagnosisDraft: buildEnhancedDiagnosisDraft(records),
	}
}

function buildEnhancedDiagnosisDraft(records = []) {
	const topRecords = records.slice(0, 3)
	const focusTitles = topRecords
		.map((row) => row.title || row.name || "")
		.filter(Boolean)
		.slice(0, 3)
	const behaviorTagSummary = topRecords
		.flatMap((row) => normalizeArray(row.behaviorTags))
		.filter(Boolean)
		.slice(0, 6)
	const focusLabel = focusTitles.length ? focusTitles.join("、") : "当前重点样本"
	const tagLabel = behaviorTagSummary.length ? behaviorTagSummary.join("、") : "行为标签信息有限"
	const isItemView = queryForm.viewType === "item"

	if (isItemView) {
		const actionPriority =
			summary.highRiskCount > 0
				? "第一优先级：先修复高风险商品在点击到支付之间的断点；第二优先级：提升加购与收藏后的成交承接；第三优先级：跟踪行为标签与转化率的联动变化。"
				: "第一优先级：保持当前转化效率；第二优先级：放大高潜力商品的流量承接能力；第三优先级：持续监控单品行为波动。"
		return {
			title: diagnosisTitleText.value,
			summary: `当前匹配${summary.matchedCount || 0}条商品样本，平均点击${formatMetric(summary.avgClickCnt)}，平均支付转化${formatRate(summary.avgPayPerClick)}。系统将基于大模型生成商品行为诊断摘要和建议。`,
			analysisSections: [
				{
					title: "单品流量与曝光表现",
					content: `当前诊断重点样本包括 ${focusLabel}。从整体数据看，样本平均点击为 ${formatMetric(summary.avgClickCnt)}，说明当前商品已经获得一定曝光，但不同商品之间的流量承接差异仍然明显。`,
				},
				{
					title: "收藏与加购承接情况",
					content: `当前重点行为标签主要包括 ${tagLabel}。这意味着部分商品已经完成前半段兴趣建立，但在收藏、加购到支付的承接过程中仍存在明显流失。`,
				},
				{
					title: "支付转化诊断",
					content:
						summary.avgPayPerClick < 0.05
							? "当前支付转化率仍有提升空间，说明用户在商品详情页停留后未能充分完成成交决策。建议优先检查详情页卖点表达、价格接受度、评价信任感和促销承接。"
							: "当前支付转化处于相对可接受水平，但仍需关注高点击商品是否存在局部转化波动，避免流量放大后转化效率下滑。",
				},
				{
					title: "重点样本观察",
					content: `建议优先围绕 ${focusLabel} 这批商品做针对性复盘，重点关注其点击、收藏、加购与支付链路的衔接是否顺畅，以及是否存在单点断层。`,
				},
				{
					title: "单品优化建议",
					content: "优先从标题卖点、主图表达、详情页信息密度、价格锚点与评价信任感五个方面做调整，并重点验证这些动作是否能提升支付转化。",
				},
				{
					title: "执行优先级",
					content: actionPriority,
				},
			],
			recommendations: [
				`优先关注${focusLabel}对应的转化承接链路。`,
				"围绕高风险标签先修复漏斗断点，再补充高潜力商品的流量承接动作。",
				"持续跟踪行为标签和转化率的联动变化，验证优化动作是否真正生效。",
			],
			riskAlerts: [
				"当前诊断结果基于大模型生成，请结合真实经营动作进一步校验。",
				summary.highRiskCount > summary.highPotentialCount
					? "当前高风险样本数高于高潜力样本数，建议优先止损而不是盲目扩量。"
					: "当前高潜力样本仍具优化空间，建议在风险可控前提下逐步放大有效流量。",
			],
		}
	}

	const merchantActionPriority =
		summary.highRiskCount > 0
			? "第一优先级：优先处理高风险商品占比较高的经营环节；第二优先级：对高潜力商品建立单独提升策略；第三优先级：持续监控商家整体行为结构变化。"
			: "第一优先级：保持当前经营结构稳定；第二优先级：扩大高潜力商品贡献；第三优先级：优化商家整体流量分配与转化承接。"
	return {
		title: diagnosisTitleText.value,
		summary: `当前匹配${summary.matchedCount || 0}条商家样本，平均点击${formatMetric(summary.avgClickCnt)}，平均支付转化${formatRate(summary.avgPayPerClick)}。系统将基于大模型生成商家行为诊断摘要和建议。`,
		analysisSections: [
			{
				title: "商家样本概况",
				content: summary.message || `当前共覆盖 ${summary.matchedCount || 0} 条商家样本，说明本次诊断更偏向商家整体经营结构和样本分布观察。`,
			},
			{
				title: "风险与潜力商品结构",
				content: `当前高风险样本数为 ${summary.highRiskCount || 0}，高潜力样本数为 ${summary.highPotentialCount || 0}。这说明商家内部既存在需要止损的问题商品，也存在值得加码运营的潜力商品。`,
			},
			{
				title: "行为标签分布解读",
				content: `当前重点行为标签主要包括 ${tagLabel}。从经营结构上看，这些标签反映出问题更多集中在转化承接和样本分层上，而不只是单一商品表现。`,
			},
			{
				title: "商家经营漏斗判断",
				content:
					summary.avgPayPerClick < 0.05
						? "从商家整体视角看，当前点击到支付之间仍存在较明显流失，说明商品矩阵在成交承接上不够均衡。建议从商品分层、流量分配和转化承接机制上统一优化。"
						: "当前商家整体支付转化相对稳定，但仍需注意不同商品之间是否存在结构性分化，避免整体均值掩盖局部问题。",
			},
			{
				title: "商家经营建议",
				content: "建议将商家内部商品按高风险、高潜力、稳定转化三类进行分层管理，分别制定止损、提升和放大策略，而不是对所有商品采用同一套运营动作。",
			},
			{
				title: "经营优先级",
				content: merchantActionPriority,
			},
		],
		recommendations: [
			"优先梳理高风险商品与高潜力商品的结构占比，明确商家内部问题集中区。",
			"针对高潜力商品单独配置流量和转化优化动作，逐步提升整体经营效率。",
			"持续跟踪商家整体行为标签分布变化，判断经营动作是否真的改善结构性问题。",
		],
		riskAlerts: [
			"当前诊断结果基于大模型生成，请结合真实经营动作进一步校验。",
			summary.highRiskCount > summary.highPotentialCount
				? "当前商家内部高风险样本占比较高，建议优先修复结构性问题后再做扩量。"
				: "当前商家具备一定潜力商品基础，但仍需警惕局部商品拖累整体经营表现。",
		],
	}
}

async function handleGenerateDiagnosis() {
	if (!canGenerateDiagnosis.value) {
		message("请先查询行为数据后再生成 AI 诊断", { type: "warning" })
		return
	}

	try {
		resetDiagnosis()
		diagnosisLoading.value = true
		const result = normalizeObject(await startUserBehaviorDiagnosisByFastApi(buildCompactDiagnosisPayload()))
		applyDiagnosisResult(result)
		diagnosisEnhancementTaskId.value = result?.enhancementTaskId || ""

		if (result?.enhancementStatus === "pending" && diagnosisEnhancementTaskId.value) {
			scheduleDiagnosisEnhancementPolling(diagnosisEnhancementTaskId.value)
			message("大模型生成中", { type: "success" })
			return
		}

		stopDiagnosisEnhancementPolling()
		message("AI 行为诊断生成成功", { type: "success" })
	} catch (error) {
		stopDiagnosisEnhancementPolling()
		message(error?.message || "AI 行为诊断生成失败", { type: "error" })
		diagnosis.llmStatus = "error"
	}
}

function renderPrimaryChart() {
	if (!primaryChartRef.value) {
		return
	}

	primaryChart ??= echarts.init(primaryChartRef.value)

	if (queryForm.viewType === "merchant") {
		const levelData = normalizeArray(summary.behaviorLevelBreakdown).length
			? normalizeArray(summary.behaviorLevelBreakdown)
			: deriveLevelBreakdownFromList(listData.value)

		primaryChart.setOption({
			tooltip: { trigger: "item" },
			xAxis: {
				type: "category",
				data: levelData.map((item) => item.label || item.name || "-"),
				axisLabel: { color: "#475569" },
			},
			yAxis: {
				type: "value",
				axisLabel: { color: "#475569" },
				splitLine: { lineStyle: { color: "#E2E8F0" } },
			},
			series: [
				{
					type: "bar",
					data: levelData.map((item) => normalizeNumber(item.value)),
					itemStyle: { color: "#2563EB", borderRadius: [8, 8, 0, 0] },
				},
			],
			grid: { left: 36, right: 12, top: 28, bottom: 36 },
		})
		return
	}

	const funnel = normalizeObject(summary.funnelOverview)
	const data = [
		{ name: "点击", value: normalizeNumber(funnel.clickCnt ?? summary.avgClickCnt) },
		{ name: "收藏", value: normalizeNumber(funnel.collectCnt) },
		{ name: "加购", value: normalizeNumber(funnel.cartCnt) },
		{ name: "支付", value: normalizeNumber(funnel.payCnt) },
	]

	primaryChart.setOption({
		tooltip: { trigger: "item" },
		series: [
			{
				type: "funnel",
				left: "10%",
				top: 20,
				bottom: 20,
				width: "80%",
				minSize: "20%",
				maxSize: "95%",
				sort: "descending",
				gap: 4,
				label: {
					show: true,
					position: "inside",
					formatter: "{b}  {c}",
				},
				data,
			},
		],
	})
}

function renderTagChart() {
	if (!tagChartRef.value) {
		return
	}

	tagChart ??= echarts.init(tagChartRef.value)
	const tagData = normalizeArray(summary.behaviorTagBreakdown).length
		? normalizeArray(summary.behaviorTagBreakdown)
		: deriveTagBreakdownFromList(listData.value)

	tagChart.setOption({
		tooltip: { trigger: "item" },
		legend: { bottom: 0 },
		series: [
			{
				type: "pie",
				radius: ["40%", "72%"],
				center: ["50%", "45%"],
				avoidLabelOverlap: true,
				label: {
					formatter: "{b}\n{d}%",
				},
				data: tagData.map((item) => ({
					name: item.label || item.name || "-",
					value: normalizeNumber(item.value),
				})),
			},
		],
	})
}
</script>

<style scoped lang="scss">
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

.behavior-page {
	max-width: 1480px;
	margin: 0 auto;

	.chart-card,
	.behavior-query-card,
	.diagnosis-panel,
	.summary-panel {
		border: 1px solid #e2e8f0;
		border-radius: 22px;
		box-shadow: 0 24px 52px rgba(15, 23, 42, 0.08);
	}

	.behavior-hero {
		margin-bottom: 16px;
		border-radius: 28px;
		background:
			radial-gradient(circle at top right, rgba(59, 130, 246, 0.2), transparent 32%),
			linear-gradient(135deg, #fff8f1 0%, #eef6ff 45%, #f8fafc 100%);
	}

	.behavior-hero-copy {
		display: flex;
		flex-direction: column;
		gap: 14px;
	}

	.behavior-hero-copy h1 {
		margin: 0;
		font-family: "Georgia", "Times New Roman", serif;
		font-size: clamp(34px, 2.2vw, 52px);
		line-height: 1.03;
		letter-spacing: -0.03em;
		color: #122033;
	}

	.behavior-hero-copy p {
		margin: 0;
		max-width: 860px;
		font-size: 15px;
		line-height: 1.9;
		color: #42536b;
	}

	.behavior-hero :deep(.emdmp-page-title),
	.behavior-hero :deep(.emdmp-page-description) {
		display: none;
	}

	.behavior-query-form {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 18px 20px;
		align-items: start;
	}

	.behavior-query-view-row {
		display: flex;
	}

	.behavior-query-form-grid {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 18px 20px;
		align-items: start;
	}

	.behavior-query-field,
	.behavior-query-actions {
		margin-bottom: 0;
	}

	.behavior-query-field--view {
		grid-column: 1 / -1;
		margin-bottom: 0;
	}

	.behavior-query-field--compact {
		grid-column: 1 / -1;
	}

	.behavior-query-field--wide {
		grid-column: span 1;
	}

	.behavior-query-actions {
		grid-column: 1 / -1;
		margin-bottom: 0;
	}

	.behavior-query-view-row :deep(.el-form-item__content) {
		width: auto;
	}

	.behavior-query-form-grid :deep(.el-form-item__content) {
		width: 100%;
	}

	.behavior-query-form-grid :deep(.el-input),
	.behavior-query-form-grid :deep(.el-select),
	.behavior-query-form-grid :deep(.el-date-editor.el-input) {
		width: 100%;
	}

	.behavior-query-form :deep(.el-form-item__content) {
		width: 100%;
	}

	.behavior-query-form :deep(.el-input),
	.behavior-query-form :deep(.el-select),
	.behavior-query-form :deep(.el-date-editor.el-input) {
		width: 100%;
	}

	.behavior-query-actions :deep(.el-form-item__content) {
		display: flex;
		flex-wrap: wrap;
		gap: 12px;
		align-items: center;
	}

	.summary-card {
		display: flex;
		flex-direction: column;
		gap: 12px;
		min-height: 168px;
		padding: 4px 2px;
	}

	.summary-label {
		font-size: 12px;
		font-weight: 700;
		letter-spacing: 0.12em;
		text-transform: uppercase;
		color: #475569;
	}

	.summary-value {
		font-family: "Georgia", "Times New Roman", serif;
		font-size: clamp(42px, 2.6vw, 58px);
		line-height: 1;
		font-weight: 800;
		color: #0f172a;
	}

	.summary-meta {
		font-size: 14px;
		line-height: 1.7;
		color: #94a3b8;
	}

	.chart-box {
		height: 320px;
	}

	.table-toolbar-text {
		color: #64748b;
		font-size: 14px;
	}

	.title-cell {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.title-cell__main {
		color: #0f172a;
		font-weight: 700;
		line-height: 1.5;
	}

	.title-cell__sub,
	.placeholder-text {
		color: #94a3b8;
		font-size: 13px;
	}

	.tags-cell {
		display: flex;
		flex-wrap: wrap;
		gap: 8px;
		align-items: center;
	}

	.diagnosis-content {
		display: flex;
		flex-direction: column;
		gap: 16px;
	}

	.diagnosis-title {
		margin: 0;
		font-family: "Georgia", "Times New Roman", serif;
		font-size: 34px;
		color: #0f172a;
	}

	.diagnosis-summary {
		margin: 0;
		padding: 18px 20px;
		border-radius: 18px;
		background: #f8fafc;
		color: #475569;
		line-height: 1.8;
	}

	.diagnosis-sections {
		display: flex;
		flex-direction: column;
		gap: 14px;
	}

	.diagnosis-sections section {
		padding: 18px 20px;
		border-radius: 18px;
		background: linear-gradient(180deg, rgba(248, 250, 252, 0.98), rgba(241, 245, 249, 0.95));
		border: 1px solid #e2e8f0;
	}

	.diagnosis-sections h4 {
		margin: 0 0 10px;
		font-size: 17px;
		color: #0f172a;
	}

	.diagnosis-sections p {
		margin: 0;
		color: #475569;
		line-height: 1.85;
	}

	.diagnosis-side {
		display: flex;
		flex-direction: column;
		gap: 14px;
	}

	.side-block {
		padding: 16px 18px;
		border-radius: 18px;
		border: 1px solid #e2e8f0;
		background: #f8fafc;
	}

	.side-block__label {
		margin-bottom: 10px;
		font-size: 14px;
		font-weight: 700;
		color: #64748b;
	}

	.side-block__value {
		font-size: 22px;
		font-weight: 800;
		color: #0f172a;
	}

	.list-block {
		display: flex;
		flex-wrap: wrap;
		gap: 8px;
	}

	.risk-list {
		padding-left: 18px;
		margin: 0;
		color: #475569;
		line-height: 1.8;
	}
}

@media (max-width: 992px) {
	.behavior-page {
		.chart-box {
			height: 280px;
		}

		.summary-value {
			font-size: 40px;
		}
	}
}

@media (max-width: 768px) {
	.behavior-page {
		.behavior-query-form {
			grid-template-columns: minmax(0, 1fr);
		}

		.behavior-query-form-grid {
			grid-template-columns: minmax(0, 1fr);
		}
	}
}
</style>


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
