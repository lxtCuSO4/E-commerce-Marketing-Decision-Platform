<template>
	<KPage class="prediction-detail-page emdmp-shell emdmp-detail-page">
		<div class="emdmp-detail-toolbar">
			<el-button @click="handleBack">返回</el-button>
		</div>

		<el-row :gutter="24">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="emdmp-surface-card">
					<template #header>未来7天支付预测</template>
					<div class="chart-panel">
						<div
							v-if="chartData.values.some((item) => item !== null)"
							ref="chartRef"
							class="chart-canvas"
						></div>
						<div v-else class="chart-placeholder">暂无可视化数据</div>
					</div>
				</el-card>
			</el-col>

			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="emdmp-surface-card">
					<template #header>预测结果信息</template>
					<el-descriptions :column="1" border>
						<el-descriptions-item label="商品ID">
							{{ form.itemId || "-" }}
						</el-descriptions-item>
						<el-descriptions-item label="锚定日期">
							{{ formatDate(form.anchorDate) }}
						</el-descriptions-item>
						<el-descriptions-item label="商品类目">
							{{ form.category || "-" }}
						</el-descriptions-item>
						<el-descriptions-item label="品牌ID">
							{{ form.brandId || "-" }}
						</el-descriptions-item>
						<el-descriptions-item label="商家ID">
							{{ form.sellerId || "-" }}
						</el-descriptions-item>
						<el-descriptions-item label="最近7天支付次数">
							{{ formatMetric(form.payCnt7D) }}
						</el-descriptions-item>
						<el-descriptions-item label="最近30天支付次数">
							{{ formatMetric(form.payCnt30D) }}
						</el-descriptions-item>
						<template v-if="hasOnlinePredictionData">
<el-descriptions-item label="预测第1天支付次数">
							{{ formatMetric(form.predPayD1) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第2天支付次数">
							{{ formatMetric(form.predPayD2) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第3天支付次数">
							{{ formatMetric(form.predPayD3) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第4天支付次数">
							{{ formatMetric(form.predPayD4) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第5天支付次数">
							{{ formatMetric(form.predPayD5) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第6天支付次数">
							{{ formatMetric(form.predPayD6) }}
						</el-descriptions-item>
						<el-descriptions-item label="预测第7天支付次数">
							{{ formatMetric(form.predPayD7) }}
						</el-descriptions-item>
						<el-descriptions-item label="未来7天预测支付总量">
							{{ formatMetric(form.pred7DPay) }}
						</el-descriptions-item>
						</template>
					</el-descriptions>
				</el-card>
			</el-col>
		</el-row>
	</KPage>
</template>

<script setup>
import {
	computed,
	nextTick,
	onBeforeMount,
	onBeforeUnmount,
	reactive,
	ref,
} from "vue"
import * as echarts from "echarts"
import dayjs from "dayjs"
import { message } from "@kesplus/kesplus"
import { useRoute, useRouter } from "@@/core/coreExports"
import { getSalesForecastPredictionDetailApi } from "./utils/rec-sales-forecast-predictions-api"
import { readOnlinePredictionSnapshot } from "./utils/online-prediction-cache"
import {
	buildDisplayedPredictionMetrics,
	formatPredictionMetric,
} from "./utils/prediction-detail-state"

const props = defineProps({
	id: { type: String, default: "" },
	predictionKey: { type: String, default: "" },
})

const route = useRoute()
const router = useRouter()
const currentId = computed(() => props.id || route.query?.id || "")
const currentPredictionKey = computed(
	() => props.predictionKey || route.query?.predictionKey || "",
)
const hasOnlinePredictionData = computed(() =>
	chartData.values.some((item) => item !== null),
)

const chartRef = ref(null)
let chartInstance = null

const form = reactive({
	id: "",
	itemId: "",
	anchorDate: "",
	category: "",
	brandId: "",
	sellerId: "",
	payCnt7D: "",
	payCnt30D: "",
	predPayD1: "",
	predPayD2: "",
	predPayD3: "",
	predPayD4: "",
	predPayD5: "",
	predPayD6: "",
	predPayD7: "",
	pred7DPay: "",
})

const chartData = reactive({
	labels: ["D1", "D2", "D3", "D4", "D5", "D6", "D7"],
	values: [],
})

function formatMetric(value) {
	return formatPredictionMetric(value)
}

function formatChartValue(value) {
	if (value === null || value === undefined || value === "") {
		return null
	}

	const numericValue = Number(value)
	return Number.isFinite(numericValue) ? Number(numericValue.toFixed(2)) : null
}

function formatDate(value) {
	return value ? dayjs(value).format("YYYY-MM-DD") : "-"
}

function disposeChart() {
	if (chartInstance) {
		chartInstance.dispose()
		chartInstance = null
	}
}

function handleResize() {
	if (chartInstance) {
		chartInstance.resize()
	}
}

function renderChart() {
	if (!chartRef.value || chartData.values.length === 0) return

	if (!chartInstance) {
		chartInstance = echarts.init(chartRef.value)
	}

	chartInstance.setOption({
		color: ["#2563eb"],
		tooltip: {
			trigger: "axis",
			valueFormatter: (value) => formatMetric(value),
		},
		grid: {
			left: 48,
			right: 24,
			top: 36,
			bottom: 40,
		},
		xAxis: {
			type: "category",
			boundaryGap: false,
			data: chartData.labels,
		},
		yAxis: {
			type: "value",
		},
		series: [
			{
				name: "未来7天支付预测",
				type: "line",
				smooth: true,
				data: chartData.values,
				showSymbol: true,
			},
		],
	})
}

function applyDetailRow(row, includePredictionData) {
	const displayedPredictionMetrics = includePredictionData
		? buildDisplayedPredictionMetrics(row)
		: []
	const displayedPredictionTotal =
		displayedPredictionMetrics[displayedPredictionMetrics.length - 1]?.value ?? ""

	Object.assign(form, {
		id: row.id ?? "",
		itemId: row.itemId ?? "",
		anchorDate: row.anchorDate ?? "",
		category: row.category ?? "",
		brandId: row.brandId ?? "",
		sellerId: row.sellerId ?? "",
		payCnt7D: row.payCnt7D ?? "",
		payCnt30D: row.payCnt30D ?? "",
		predPayD1: includePredictionData ? row.predPayD1 ?? "" : "",
		predPayD2: includePredictionData ? row.predPayD2 ?? "" : "",
		predPayD3: includePredictionData ? row.predPayD3 ?? "" : "",
		predPayD4: includePredictionData ? row.predPayD4 ?? "" : "",
		predPayD5: includePredictionData ? row.predPayD5 ?? "" : "",
		predPayD6: includePredictionData ? row.predPayD6 ?? "" : "",
		predPayD7: includePredictionData ? row.predPayD7 ?? "" : "",
		pred7DPay: includePredictionData ? displayedPredictionTotal : row.pred7DPay ?? "",
	})

	chartData.values = includePredictionData
		? [
				formatChartValue(row.predPayD1),
				formatChartValue(row.predPayD2),
				formatChartValue(row.predPayD3),
				formatChartValue(row.predPayD4),
				formatChartValue(row.predPayD5),
				formatChartValue(row.predPayD6),
				formatChartValue(row.predPayD7),
			]
		: [null, null, null, null, null, null, null]
}

async function fetchDetail() {
	const onlineSnapshot = readOnlinePredictionSnapshot(currentPredictionKey.value)
	if (onlineSnapshot) {
		applyDetailRow(onlineSnapshot, true)
		await nextTick()
		renderChart()
		return
	}

	if (!currentId.value) {
		message("缺少可视化详情所需的预测结果", { type: "warning" })
		return
	}

	const result = await getSalesForecastPredictionDetailApi({
		id: currentId.value,
	})

	const row = Array.isArray(result) ? result[0] || {} : result || {}
	applyDetailRow(row, false)

	await nextTick()
	renderChart()
}

function handleBack() {
	router.push("/sales-predict-module/rec-sales-forecast-predictions")
}

onBeforeMount(() => {
	fetchDetail()
	window.addEventListener("resize", handleResize)
})

onBeforeUnmount(() => {
	window.removeEventListener("resize", handleResize)
	disposeChart()
})
</script>

<style lang="scss" scoped>
.prediction-detail-page {
	padding-bottom: 6px;
}

:deep(.prediction-detail-page .emdmp-detail-toolbar) {
	background:
		linear-gradient(145deg, rgba(255, 255, 255, 0.94), rgba(241, 248, 255, 0.88) 56%, rgba(255, 247, 243, 0.9)),
		radial-gradient(circle at top left, rgba(37, 99, 235, 0.15), transparent 30%);
}

:deep(.prediction-detail-page .el-card__header) {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: 24px;
}

.chart-panel {
	min-height: clamp(300px, 28vw, 420px);
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 18px 12px;
	background:
		radial-gradient(circle at top, rgba(37, 99, 235, 0.16), transparent 52%),
		linear-gradient(180deg, #f8fafc 0%, #edf2f7 100%);
	border-radius: 22px;
}

.chart-canvas {
	width: 100%;
	height: clamp(300px, 28vw, 420px);
}

.chart-placeholder {
	color: #64748b;
	font-size: 14px;
	letter-spacing: 0.02em;
}
</style>
