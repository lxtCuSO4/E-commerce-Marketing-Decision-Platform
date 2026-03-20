<template>
	<KPage class="overview-page">
		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12">
				<el-card shadow="never">
					<div class="summary-card">
						<div class="summary-label">高优先用户数</div>
						<div class="summary-value">{{ summary.highPriorityUserCount ?? 0 }}</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12">
				<el-card shadow="never">
					<div class="summary-card">
						<div class="summary-label">中优先用户数</div>
						<div class="summary-value">{{ summary.mediumPriorityUserCount ?? 0 }}</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never">
					<template #header>商家标签分布</template>
					<div ref="merchantChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="12">
				<el-card shadow="never">
					<template #header>任务分组分布</template>
					<div ref="taskChartRef" class="chart-box"></div>
				</el-card>
			</el-col>
		</el-row>

		<el-card shadow="never">
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
	handleCurrentPageChange,
	fetchData,
} = usePageModel({
	queryForm: {},
	pageSize: PAGE_SIZE,
	fetch: async (_pager) => {
		const result = await getMerchantDiagnosticsApi({
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

function renderPieChart(chartRef, chartInstance, title, data) {
	if (!chartRef.value) {
		return chartInstance
	}

	const chart = chartInstance || echarts.init(chartRef.value)
	const seriesData = normalizeArray(data)

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
		)
	} catch (error) {
		message(error?.message || "总览数据加载失败", { type: "error" })
	}
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
	padding: 16px;
}

.summary-card {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.summary-label {
	font-size: 14px;
	color: #64748b;
}

.summary-value {
	font-size: 32px;
	font-weight: 700;
	color: #0f172a;
}

.chart-box {
	width: 100%;
	height: 320px;
}
</style>
