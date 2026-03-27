<template>
	<KQueryList class="emdmp-shell emdmp-shell--wide emdmp-query-page user-operations-page">
		<div class="emdmp-page-hero user-operations-hero">
			<div>
				<p class="emdmp-page-kicker">Operations Center</p>
				<h1 class="emdmp-page-title">用户运营与召回</h1>
				<p class="emdmp-page-description">
					围绕复购评分、用户分群、任务分组与建议动作建立“总览 + 分布 + 明细”的运营分析视图。
				</p>
			</div>
		</div>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel" v-loading="summaryLoading">
					<div class="summary-card">
						<div class="summary-label">用户总数</div>
						<div class="summary-value">{{ summary.totalUserCount ?? 0 }}</div>
						<div class="summary-meta">当前筛选条件下进入召回分析的人群规模</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel" v-loading="summaryLoading">
					<div class="summary-card">
						<div class="summary-label">高优先用户数</div>
						<div class="summary-value">{{ summary.highPriorityUserCount ?? 0 }}</div>
						<div class="summary-meta">适合优先跟进和快速触达的重点人群</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel" v-loading="summaryLoading">
					<div class="summary-card">
						<div class="summary-label">中优先用户数</div>
						<div class="summary-value">{{ summary.mediumPriorityUserCount ?? 0 }}</div>
						<div class="summary-meta">适合持续培育、内容触达和活动唤醒的人群</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel" v-loading="summaryLoading">
					<div class="summary-card">
						<div class="summary-label">平均复购分</div>
						<div class="summary-value">{{ formatAverageScore(summary.avgRepurchaseScore) }}</div>
						<div class="summary-meta">衡量筛选用户群整体复购倾向的核心指标</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card" v-loading="summaryLoading">
					<template #header>优先级分布</template>
					<div ref="priorityChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card" v-loading="summaryLoading">
					<template #header>用户分群分布</template>
					<div ref="segmentChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card" v-loading="summaryLoading">
					<template #header>任务分组分布</template>
					<div ref="taskGroupChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="overview-chart-card" v-loading="summaryLoading">
					<template #header>建议动作分布</template>
					<div ref="actionChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
		</el-row>

		<KQueryTable class="emdmp-query-panel user-operations-panel">
			<el-form class="query-form emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="用户ID">
					<el-input
						v-model="queryForm.userId"
						clearable
						placeholder="请输入用户ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="商家ID">
					<el-input
						v-model="queryForm.merchantId"
						clearable
						placeholder="请输入商家ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="优先级">
					<el-input
						v-model="queryForm.priorityLevel"
						clearable
						placeholder="请输入优先级"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="用户分群">
					<el-input
						v-model="queryForm.segmentName"
						clearable
						placeholder="请输入分群名称"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="任务分组">
					<el-input
						v-model="queryForm.taskGroup"
						clearable
						placeholder="请输入任务分组"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>

			<KTableBar class="emdmp-table-panel" title="用户运营与召回明细" :columns="columns" @refresh="fetchData">
				<template #default="{ size, dynamicColumns }">
					<KTable
						border
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
						<template #topReasons="{ row }">
							<div class="tag-cell">
								<template v-if="toDisplayItems(row.topReasons).length">
									<el-tag
										v-for="item in toDisplayItems(row.topReasons)"
										:key="`reason-${row.userId}-${row.merchantId}-${item}`"
										size="small"
										effect="plain"
									>
										{{ item }}
									</el-tag>
								</template>
								<span v-else>-</span>
							</div>
						</template>
						<template #reasonTags="{ row }">
							<div class="tag-cell">
								<template v-if="toDisplayItems(row.reasonTags).length">
									<el-tag
										v-for="item in toDisplayItems(row.reasonTags)"
										:key="`tag-${row.userId}-${row.merchantId}-${item}`"
										size="small"
										effect="plain"
										type="success"
									>
										{{ item }}
									</el-tag>
								</template>
								<span v-else>-</span>
							</div>
						</template>
					</KTable>
				</template>
			</KTableBar>
		</KQueryTable>
	</KQueryList>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from "vue"
import * as echarts from "echarts"
import { defineRouteMeta, message, usePageModel } from "@kesplus/kesplus"
import {
	getUserOperationsRecallApi,
	getUserOperationsRecallSummaryApi,
} from "./utils/user-operations-recall-api"

defineRouteMeta({
	title: "用户运营与召回",
})

const PAGE_SIZE = 20
const pendingSearchFeedback = ref(false)
const summaryLoading = ref(false)

const priorityChartRef = ref(null)
const segmentChartRef = ref(null)
const taskGroupChartRef = ref(null)
const actionChartRef = ref(null)

let priorityChart = null
let segmentChart = null
let taskGroupChart = null
let actionChart = null

const PRIORITY_LABEL_MAP = {
	high: "high（高优先）",
	high_priority: "high_priority（高优先）",
	medium: "medium（中优先）",
	medium_priority: "medium_priority（中优先）",
	low: "low（低优先）",
	low_priority: "low_priority（低优先）",
}

const TASK_GROUP_LABEL_MAP = {
	observe: "observe（观察）",
	content_nurture: "content_nurture（内容培育）",
	coupon_followup: "coupon_followup（优惠券跟进）",
	today_high_priority: "today_high_priority（今日高优先）",
}

const ACTION_LABEL_MAP = {
	send_coupon: "send_coupon（发券触达）",
	content_touch: "content_touch（内容触达）",
	event_reminder: "event_reminder（活动提醒）",
	phone_followup: "phone_followup（电话跟进）",
}

const summary = reactive({
	totalUserCount: 0,
	highPriorityUserCount: 0,
	mediumPriorityUserCount: 0,
	avgRepurchaseScore: 0,
	priorityBreakdown: [],
	segmentBreakdown: [],
	taskGroupBreakdown: [],
	recommendedActionBreakdown: [],
})

const columns = [
	{ label: "用户ID", prop: "userId", align: "center", "min-width": "120px" },
	{ label: "商家ID", prop: "merchantId", align: "center", "min-width": "120px" },
	{ label: "复购分", prop: "repurchaseScore", align: "center", "min-width": "120px" },
	{ label: "风险等级", prop: "riskLevel", align: "center", "min-width": "120px" },
	{ label: "优先级", prop: "priorityLevel", align: "center", "min-width": "120px" },
	{ label: "商家内排序", prop: "scoreRankInMerchant", align: "center", "min-width": "120px" },
	{ label: "核心原因", prop: "topReasons", align: "center", "min-width": "220px", slot: "topReasons" },
	{ label: "分群ID", prop: "segmentId", align: "center", "min-width": "120px" },
	{ label: "分群名称", prop: "segmentName", align: "center", "min-width": "140px" },
	{ label: "建议动作", prop: "recommendedAction", align: "center", "min-width": "160px" },
	{ label: "召回原因", prop: "reasonTags", align: "center", "min-width": "220px", slot: "reasonTags" },
	{ label: "任务分组", prop: "taskGroup", align: "center", "min-width": "140px" },
]

const {
	queryForm,
	loading,
	listData,
	pagination,
	resetPage,
	handleCurrentPageChange,
	fetchData,
} = usePageModel({
	queryForm: {
		userId: "",
		merchantId: "",
		priorityLevel: "",
		segmentName: "",
		taskGroup: "",
	},
	pageSize: PAGE_SIZE,
	fetch: async (_pager) => {
		try {
			const result = await getUserOperationsRecallApi({
				userId: queryForm.userId || undefined,
				user_id: queryForm.userId || undefined,
				merchantId: queryForm.merchantId || undefined,
				merchant_id: queryForm.merchantId || undefined,
				priorityLevel: queryForm.priorityLevel || undefined,
				priority_level: queryForm.priorityLevel || undefined,
				segmentName: queryForm.segmentName || undefined,
				segment_name: queryForm.segmentName || undefined,
				taskGroup: queryForm.taskGroup || undefined,
				task_group: queryForm.taskGroup || undefined,
				pageIndex: _pager.currentPage,
				pageSize: _pager.pageSize,
				page_index: _pager.currentPage,
				page_size: _pager.pageSize,
			})

			const normalized = normalizePagedResult(result)

			if (
				pendingSearchFeedback.value &&
				hasActiveFilters() &&
				normalized.totalElements === 0
			) {
				message("没有查询到符合条件的数据", { type: "warning" })
			}

			return normalized
		} catch (error) {
			message(error?.message || "明细数据加载失败，请稍后重试", { type: "error" })
			return {
				totalElements: 0,
				content: [],
			}
		} finally {
			pendingSearchFeedback.value = false
		}
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

function normalizeQuery() {
	queryForm.userId = String(queryForm.userId ?? "").trim()
	queryForm.merchantId = String(queryForm.merchantId ?? "").trim()
	queryForm.priorityLevel = String(queryForm.priorityLevel ?? "").trim()
	queryForm.segmentName = String(queryForm.segmentName ?? "").trim()
	queryForm.taskGroup = String(queryForm.taskGroup ?? "").trim()
}

function hasActiveFilters() {
	return Boolean(
		queryForm.userId ||
			queryForm.merchantId ||
			queryForm.priorityLevel ||
			queryForm.segmentName ||
			queryForm.taskGroup,
	)
}

function toDisplayItems(value) {
	if (Array.isArray(value)) {
		return value.filter(Boolean).map((item) => String(item).trim()).filter(Boolean)
	}

	if (typeof value === "string" && value) {
		const parsed = normalizeArray(value)
		if (parsed.length) {
			return parsed
				.filter(Boolean)
				.map((item) => String(item).trim())
				.filter(Boolean)
		}

		return value
			.split(/[，,|/]+/)
			.map((item) => item.trim())
			.filter(Boolean)
	}

	return []
}

function formatAverageScore(value) {
	const numberValue = Number(value ?? 0)
	return Number.isFinite(numberValue) ? numberValue.toFixed(4) : "0.0000"
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
	if (priorityChart) {
		priorityChart.dispose()
		priorityChart = null
	}
	if (segmentChart) {
		segmentChart.dispose()
		segmentChart = null
	}
	if (taskGroupChart) {
		taskGroupChart.dispose()
		taskGroupChart = null
	}
	if (actionChart) {
		actionChart.dispose()
		actionChart = null
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
	priorityChart?.resize()
	segmentChart?.resize()
	taskGroupChart?.resize()
	actionChart?.resize()
}

async function renderCharts() {
	await nextTick()

	priorityChart = renderPieChart(
		priorityChartRef,
		priorityChart,
		"优先级分布",
		summary.priorityBreakdown,
		PRIORITY_LABEL_MAP,
	)
	segmentChart = renderPieChart(
		segmentChartRef,
		segmentChart,
		"用户分群分布",
		summary.segmentBreakdown,
	)
	taskGroupChart = renderPieChart(
		taskGroupChartRef,
		taskGroupChart,
		"任务分组分布",
		summary.taskGroupBreakdown,
		TASK_GROUP_LABEL_MAP,
	)
	actionChart = renderPieChart(
		actionChartRef,
		actionChart,
		"建议动作分布",
		summary.recommendedActionBreakdown,
		ACTION_LABEL_MAP,
	)
}

async function fetchSummaryData() {
	summaryLoading.value = true
	try {
		const result = await getUserOperationsRecallSummaryApi({
			userId: queryForm.userId || undefined,
			user_id: queryForm.userId || undefined,
			merchantId: queryForm.merchantId || undefined,
			merchant_id: queryForm.merchantId || undefined,
			priorityLevel: queryForm.priorityLevel || undefined,
			priority_level: queryForm.priorityLevel || undefined,
			segmentName: queryForm.segmentName || undefined,
			segment_name: queryForm.segmentName || undefined,
			taskGroup: queryForm.taskGroup || undefined,
			task_group: queryForm.taskGroup || undefined,
		})

		const row = normalizeObject(result)

		Object.assign(summary, {
			totalUserCount: Number(row.totalUserCount ?? 0),
			highPriorityUserCount: Number(row.highPriorityUserCount ?? 0),
			mediumPriorityUserCount: Number(row.mediumPriorityUserCount ?? 0),
			avgRepurchaseScore: Number(row.avgRepurchaseScore ?? 0),
			priorityBreakdown: normalizeArray(row.priorityBreakdown),
			segmentBreakdown: normalizeArray(row.segmentBreakdown),
			taskGroupBreakdown: normalizeArray(row.taskGroupBreakdown),
			recommendedActionBreakdown: normalizeArray(row.recommendedActionBreakdown),
		})
	} catch (error) {
		Object.assign(summary, {
			totalUserCount: 0,
			highPriorityUserCount: 0,
			mediumPriorityUserCount: 0,
			avgRepurchaseScore: 0,
			priorityBreakdown: [],
			segmentBreakdown: [],
			taskGroupBreakdown: [],
			recommendedActionBreakdown: [],
		})
		message(error?.message || "总览数据加载失败，请稍后重试", { type: "error" })
	} finally {
		summaryLoading.value = false
		await renderCharts()
	}
}

async function handleSearch() {
	normalizeQuery()
	pendingSearchFeedback.value = true
	await fetchSummaryData()
	resetPage({ pageSize: PAGE_SIZE })
}

async function handleReset() {
	Object.assign(queryForm, {
		userId: "",
		merchantId: "",
		priorityLevel: "",
		segmentName: "",
		taskGroup: "",
	})
	pendingSearchFeedback.value = false
	await fetchSummaryData()
	resetPage({ pageSize: PAGE_SIZE })
}

onMounted(async () => {
	await fetchSummaryData()
	await fetchData()
	window.addEventListener("resize", handleResize)
})

onBeforeUnmount(() => {
	window.removeEventListener("resize", handleResize)
	disposeCharts()
})
</script>

<style scoped lang="scss">
.user-operations-page {
	display: flex;
	flex-direction: column;
	gap: 0;
	height: auto;
	min-height: var(--kesplus-page-content-height);
	overflow: visible;
}

.user-operations-page :deep(.k-design-page-min-height-helper),
.user-operations-page :deep(.k-design-page-content),
.user-operations-page :deep(.k-design-page-main) {
	height: auto;
	min-height: 0;
	overflow: visible;
}

.user-operations-page :deep(.k-query-table),
.user-operations-page :deep(.k-query-table .k-design-section-block-wrapper),
.user-operations-page :deep(.k-query-table .kesplus-table-bar) {
	height: auto;
	min-height: 0;
	overflow-y: visible;
}

.user-operations-page :deep(.k-query-table) {
	flex: none;
	overflow-x: auto;
}

.user-operations-page :deep(.kesplus-pagination) {
	flex-wrap: wrap;
}

.user-operations-hero {
	margin-bottom: 16px;
}

.summary-panel,
.overview-chart-card,
.user-operations-panel {
	border: 1px solid rgba(148, 163, 184, 0.16);
	box-shadow: 0 18px 40px rgba(15, 23, 42, 0.06);
}

.summary-card {
	display: flex;
	flex-direction: column;
	gap: 10px;
	min-height: 136px;
}

.summary-label {
	font-size: 14px;
	color: #64748b;
}

.summary-value {
	font-size: 32px;
	font-weight: 700;
	line-height: 1;
	color: #0f172a;
}

.summary-meta {
	font-size: 13px;
	line-height: 1.7;
	color: #94a3b8;
}

.chart-box {
	width: 100%;
	height: 320px;
}

.query-form {
	padding-bottom: 8px;
}

.tag-cell {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	justify-content: center;
}

:deep(.tag-cell .el-tag) {
	max-width: 100%;
	margin: 0;
}

@media (max-width: 1200px) {
	.summary-card {
		min-height: auto;
	}

	.chart-box {
		height: 300px;
	}
}
@media (max-width: 768px) {
	.chart-box {
		height: 280px;
	}
}
</style>
