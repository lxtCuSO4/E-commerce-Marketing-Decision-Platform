<template>
	<KPage class="emdmp-shell emdmp-shell--wide overview-page">
		<div class="emdmp-page-hero">
			<div>
				<p class="emdmp-page-kicker">Operations Center</p>
				<h1 class="emdmp-page-title">运营总览与商家诊断</h1>
				<p class="emdmp-page-description">
					以用户优先级、商家标签和任务分组为主线，建立从总览到明细的运营诊断视图。
				</p>
			</div>
		</div>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">高优先用户数</div>
						<div class="summary-value">{{ summary.highPriorityUserCount ?? 0 }}</div>
						<div class="summary-meta">追踪需要优先召回和重点跟进的用户规模</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">中优先用户数</div>
						<div class="summary-value">{{ summary.mediumPriorityUserCount ?? 0 }}</div>
						<div class="summary-meta">用于持续培育与内容触达的中段人群池</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card">
					<template #header>商家标签分布</template>
					<div ref="merchantChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card">
					<template #header>任务分组分布</template>
					<div ref="taskChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
		</el-row>

		<el-card shadow="never" class="overview-search-card">
			<el-form class="overview-search-form" :model="searchForm" inline @submit.prevent>
				<el-form-item label="商家ID">
					<el-input
						v-model="searchForm.merchantId"
						clearable
						placeholder="请输入商家ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>
		</el-card>

		<el-card shadow="never" class="overview-table-card">
			<template #header>商家诊断列表</template>
			<KTable
				border
				row-key="merchantId"
				align-whole="center"
				show-overflow-tooltip
				table-layout="auto"
				:loading="loading"
				:data="listData"
				:columns="columns"
				:pagination="tablePagination"
				@page-current-change="handleCurrentPageChange"
			/>
		</el-card>
	</KPage>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from "vue"
import * as echarts from "echarts"
import { defineRouteMeta, message, usePageModel } from "@kesplus/kesplus"
import {
	getOverviewSummaryApi,
	getMerchantDiagnosticsApi,
} from "./utils/overview-merchant-diagnostics-api"

defineRouteMeta({
	title: "运营总览与商家诊断",
})

const PAGE_SIZE = 20

const merchantChartRef = ref(null)
const taskChartRef = ref(null)

let merchantChart = null
let taskChart = null

const summary = reactive({
	highPriorityUserCount: 0,
	mediumPriorityUserCount: 0,
	merchantTagBreakdown: [],
	taskGroupBreakdown: [],
})

const searchForm = reactive({
	merchantId: "",
})

const TASK_GROUP_LABEL_MAP = {
	observe: "observe（观察）",
	content_nurture: "content_nurture（内容培育）",
	coupon_followup: "coupon_followup（优惠券跟进）",
	today_high_priority: "today_high_priority（今日高优先）",
}

const columns = [
	{ label: "商家ID", prop: "merchantId", align: "center", "min-width": "140px" },
	{ label: "商家买家数", prop: "merchantBuyerCount", align: "center", "min-width": "120px" },
	{ label: "平均复购分", prop: "avgRepurchaseScore", align: "center", "min-width": "120px" },
	{ label: "高优先用户数", prop: "highPriorityUserCount", align: "center", "min-width": "140px" },
	{ label: "风险用户数", prop: "riskUserCount", align: "center", "min-width": "120px" },
	{ label: "商家标签", prop: "merchantTag", align: "center", "min-width": "140px" },
]

const {
	loading,
	listData,
	pagination,
	resetPage,
	handleCurrentPageChange,
	fetchData,
} = usePageModel({
	queryForm: {},
	pageSize: PAGE_SIZE,
	fetch: async (_pager) => {
		const result = await getMerchantDiagnosticsApi({
			merchantId: searchForm.merchantId || undefined,
			merchant_id: searchForm.merchantId || undefined,
			pageIndex: _pager.currentPage,
			pageSize: _pager.pageSize,
			page_index: _pager.currentPage,
			page_size: _pager.pageSize,
		})

		return normalizePagedResult(result)
	},
})

const tablePagination = computed(() => ({
	...pagination,
	pageSize: pagination.pageSize,
	pageSizes: [PAGE_SIZE],
	layout: "total, prev, pager, next, jumper",
}))

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

function normalizeObject(result) {
	if (Array.isArray(result)) {
		return result[0] || {}
	}

	if (typeof result === "string" && result) {
		try {
			const parsed = JSON.parse(result)
			return Array.isArray(parsed) ? parsed[0] || {} : parsed || {}
		} catch (error) {
			return {}
		}
	}

	return result || {}
}

function normalizePagedResult(result) {
	if (typeof result === "string" && result) {
		try {
			return normalizePagedResult(JSON.parse(result))
		} catch (error) {
			return {
				totalElements: 0,
				content: [],
			}
		}
	}

	if (Array.isArray(result)) {
		return {
			totalElements: result.length,
			content: result,
		}
	}

	const content = normalizeArray(result?.content)

	return {
		totalElements: Number(result?.totalElements ?? content.length ?? 0),
		content,
	}
}

function normalizeSearch() {
	searchForm.merchantId = String(searchForm.merchantId ?? "").trim()
}

function formatChartName(name, labelMap = {}) {
	const normalized = String(name ?? "").trim()
	if (!normalized) {
		return "未标注"
	}

	return labelMap[normalized] || labelMap[normalized.toLowerCase()] || normalized
}

function mapChartData(data, labelMap = {}) {
	return normalizeArray(data).map((item) => ({
		...item,
		name: formatChartName(item?.name, labelMap),
	}))
}

function disposeCharts() {
	if (merchantChart) {
		merchantChart.dispose()
		merchantChart = null
	}

	if (taskChart) {
		taskChart.dispose()
		taskChart = null
	}
}

function renderPieChart(chartRef, chartInstance, title, data, labelMap = {}) {
	if (!chartRef.value) {
		return chartInstance
	}

	const chart = chartInstance || echarts.init(chartRef.value)
	const seriesData = mapChartData(data, labelMap)

	chart.setOption({
		tooltip: {
			trigger: "item",
		},
		legend: {
			bottom: 0,
		},
		graphic: seriesData.length
			? []
			: [
					{
						type: "text",
						left: "center",
						top: "middle",
						style: {
							text: "暂无数据",
							fill: "#94a3b8",
							fontSize: 14,
						},
					},
			  ],
		series: [
			{
				name: title,
				type: "pie",
				radius: ["40%", "70%"],
				avoidLabelOverlap: false,
				label: {
					show: true,
					formatter: "{b}: {c}",
				},
				data: seriesData,
			},
		],
	})

	return chart
}

function handleResize() {
	merchantChart?.resize()
	taskChart?.resize()
}

async function fetchSummaryData() {
	try {
		const overviewResult = await getOverviewSummaryApi()
		const overviewRow = normalizeObject(overviewResult)

		Object.assign(summary, {
			highPriorityUserCount: overviewRow.highPriorityUserCount ?? 0,
			mediumPriorityUserCount: overviewRow.mediumPriorityUserCount ?? 0,
			merchantTagBreakdown: normalizeArray(overviewRow.merchantTagBreakdown),
			taskGroupBreakdown: normalizeArray(overviewRow.taskGroupBreakdown),
		})

		await nextTick()
		merchantChart = renderPieChart(
			merchantChartRef,
			merchantChart,
			"商家标签分布",
			summary.merchantTagBreakdown,
		)
		taskChart = renderPieChart(
			taskChartRef,
			taskChart,
			"任务分组分布",
			summary.taskGroupBreakdown,
			TASK_GROUP_LABEL_MAP,
		)
	} catch (error) {
		message(error?.message || "总览数据加载失败", { type: "error" })
	}
}

function handleSearch() {
	normalizeSearch()
	resetPage({ pageSize: PAGE_SIZE })
}

function handleReset() {
	searchForm.merchantId = ""
	resetPage({ pageSize: PAGE_SIZE })
}

onMounted(() => {
	fetchSummaryData()
	fetchData()
	window.addEventListener("resize", handleResize)
})

onBeforeUnmount(() => {
	window.removeEventListener("resize", handleResize)
	disposeCharts()
})
</script>

<style scoped lang="scss">
.overview-page {
	display: flex;
	flex-direction: column;
	gap: 18px;
}

.summary-card {
	display: flex;
	flex-direction: column;
	gap: 10px;
	min-height: 176px;
	justify-content: center;
	padding: 6px 4px;
}

.summary-panel,
.overview-chart-card,
.overview-table-card,
.overview-search-card {
	border: 1px solid rgba(15, 23, 42, 0.08);
	border-radius: 18px;
	box-shadow: 0 16px 36px rgba(15, 23, 42, 0.07);
}

.summary-panel {
	background:
		radial-gradient(circle at top left, rgba(201, 21, 30, 0.12), transparent 34%),
		linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(247, 249, 252, 0.96));
}

.summary-label {
	font-size: 13px;
	font-weight: 700;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: #7b8798;
}

.summary-value {
	font-size: clamp(38px, 2.2vw, 56px);
	font-weight: 700;
	line-height: 1;
	color: #0f172a;
}

.summary-meta {
	font-size: 13px;
	line-height: 1.7;
	color: #5b6779;
	max-width: 280px;
}

.chart-box {
	width: 100%;
	height: 360px;
}

.overview-search-form {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 12px;
}

.overview-search-form :deep(.el-form-item) {
	margin-bottom: 0;
}

.overview-search-form :deep(.el-input) {
	width: 260px;
}

:deep(.overview-chart-card .el-card__header),
:deep(.overview-table-card .el-card__header) {
	padding-bottom: 0;
	border-bottom: 0;
	font-size: 16px;
	font-weight: 700;
}

@media (max-width: 768px) {
	.chart-box {
		height: 300px;
	}

	.overview-search-form :deep(.el-input) {
		width: 100%;
	}
}
</style>
