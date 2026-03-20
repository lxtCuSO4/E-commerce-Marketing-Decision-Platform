<template>
	<KPage class="item-detail-page">
		<div class="m-b-16px">
			<el-button @click="handleBack">返回</el-button>
		</div>

		<el-row :gutter="24">
			<el-col :xs="24" :lg="12">
				<el-card shadow="never" class="m-b-16px">
					<template #header>商品图片</template>
					<div class="detail-image-wrap">
						<img
							v-if="form.pictUrl"
							:src="form.pictUrl"
							:alt="form.titleClean || form.itemId || '商品图片'"
							class="detail-image"
						/>
						<el-empty v-else description="暂无商品图片" />
					</div>
				</el-card>

				<el-card shadow="never">
					<template #header>销售情况</template>
					<div class="chart-toolbar">
						<el-radio-group v-model="activeTrendKey" @change="handleTrendChange">
							<el-radio-button
								v-for="option in trendOptions"
								:key="option.value"
								:label="option.value"
							>
								{{ option.label }}
							</el-radio-button>
						</el-radio-group>
					</div>
					<div class="chart-panel">
						<div
							v-if="salesTrendData.labels.length > 0"
							ref="chartRef"
							class="chart-canvas"
						></div>
						<div v-else class="chart-placeholder">暂无销售趋势数据</div>
					</div>
				</el-card>
			</el-col>

			<el-col :xs="24" :lg="12">
				<el-card shadow="never">
					<template #header>商品信息</template>
					<el-descriptions :column="1" border>
						<el-descriptions-item label="商品ID">
							{{ form.itemId || "-" }}
						</el-descriptions-item>
						<el-descriptions-item label="商品标题">
							{{ form.titleClean || "-" }}
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
						<el-descriptions-item label="最近30天点击次数">
							{{ formatMetric(featureData.clickCnt30D) }}
						</el-descriptions-item>
						<el-descriptions-item label="最近30天收藏次数">
							{{ formatMetric(featureData.collectCnt30D) }}
						</el-descriptions-item>
						<el-descriptions-item label="最近30天加购次数">
							{{ formatMetric(featureData.cartCnt30D) }}
						</el-descriptions-item>
						<el-descriptions-item label="最近30天支付次数">
							{{ formatMetric(featureData.payCnt30D) }}
						</el-descriptions-item>
						<el-descriptions-item label="商品上架至今的天数">
							{{ formatMetric(featureData.itemAgeDays) }}
						</el-descriptions-item>
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
import { message } from "@kesplus/kesplus"
import { useRoute, useRouter } from "@@/core/coreExports"
import {
	detailApi,
	getLatestSalesForecastFeatureApi,
} from "./utils/rec-tmall-item-base-api"

const props = defineProps({
	id: { type: String, default: "" },
})

const route = useRoute()
const router = useRouter()
const currentId = computed(() => props.id || route.query?.id || "")

const chartRef = ref(null)
const activeTrendKey = ref("payCnt30D")
let chartInstance = null

const trendOptions = [
	{ value: "clickCnt30D", label: "点击", title: "最近30天点击次数" },
	{ value: "cartCnt30D", label: "加购", title: "最近30天加购次数" },
	{ value: "payCnt30D", label: "支付", title: "最近30天支付次数" },
	{ value: "collectCnt30D", label: "收藏", title: "最近30天收藏次数" },
]

const form = reactive({
	id: "",
	itemId: "",
	title: "",
	titleClean: "",
	titleTokens: "",
	pictUrl: "",
	category: "",
	brandId: "",
	sellerId: "",
})

const salesTrendData = reactive({
	labels: [],
	clickCnt30D: [],
	collectCnt30D: [],
	cartCnt30D: [],
	payCnt30D: [],
})

const featureData = reactive({
	anchorDate: "",
	clickCnt30D: "",
	collectCnt30D: "",
	cartCnt30D: "",
	payCnt30D: "",
	itemAgeDays: "",
})

function formatMetric(value) {
	return value === null || value === undefined || value === "" ? "-" : value
}

function compareAnchorDateAsc(a, b) {
	const timeA = a?.anchorDate ? new Date(a.anchorDate).getTime() : 0
	const timeB = b?.anchorDate ? new Date(b.anchorDate).getTime() : 0
	return timeA - timeB
}

function compareAnchorDateDesc(a, b) {
	const timeA = a?.anchorDate ? new Date(a.anchorDate).getTime() : 0
	const timeB = b?.anchorDate ? new Date(b.anchorDate).getTime() : 0
	return timeB - timeA
}

function resetFeatureData() {
	Object.assign(featureData, {
		anchorDate: "",
		clickCnt30D: "",
		collectCnt30D: "",
		cartCnt30D: "",
		payCnt30D: "",
		itemAgeDays: "",
	})
}

function resetSalesTrendData() {
	salesTrendData.labels = []
	salesTrendData.clickCnt30D = []
	salesTrendData.collectCnt30D = []
	salesTrendData.cartCnt30D = []
	salesTrendData.payCnt30D = []
}

function disposeChart() {
	if (chartInstance) {
		chartInstance.dispose()
		chartInstance = null
	}
}

function getActiveTrendOption() {
	return (
		trendOptions.find((option) => option.value === activeTrendKey.value) ||
		trendOptions[0]
	)
}

function renderChart() {
	if (!chartRef.value || salesTrendData.labels.length === 0) return

	if (!chartInstance) {
		chartInstance = echarts.init(chartRef.value)
	}

	const activeTrend = getActiveTrendOption()
	const seriesData = salesTrendData[activeTrend.value] || []

	chartInstance.setOption({
		color: ["#3b82f6"],
		tooltip: {
			trigger: "axis",
		},
		grid: {
			left: 48,
			right: 24,
			top: 36,
			bottom: 48,
		},
		xAxis: {
			type: "category",
			boundaryGap: false,
			data: salesTrendData.labels,
		},
		yAxis: {
			type: "value",
		},
		series: [
			{
				name: activeTrend.title,
				type: "line",
				smooth: true,
				data: seriesData,
				showSymbol: seriesData.length <= 1,
			},
		],
	})
}

function handleTrendChange() {
	nextTick(() => {
		renderChart()
	})
}

function handleResize() {
	if (chartInstance) {
		chartInstance.resize()
	}
}

async function fetchForecastData(itemId) {
	resetFeatureData()
	resetSalesTrendData()
	disposeChart()

	if (!itemId) return

	const result = await getLatestSalesForecastFeatureApi({
		itemId,
		item_id: itemId,
	})

	const rows = Array.isArray(result) ? result.slice() : []

	if (rows.length === 0) {
		return
	}

	const ascRows = rows.slice().sort(compareAnchorDateAsc)
	salesTrendData.labels = ascRows.map((item) => item.anchorDate || "-")
	salesTrendData.clickCnt30D = ascRows.map((item) => item.clickCnt30D ?? 0)
	salesTrendData.collectCnt30D = ascRows.map((item) => item.collectCnt30D ?? 0)
	salesTrendData.cartCnt30D = ascRows.map((item) => item.cartCnt30D ?? 0)
	salesTrendData.payCnt30D = ascRows.map((item) => item.payCnt30D ?? 0)

	const latest = rows.slice().sort(compareAnchorDateDesc)[0] || {}
	Object.assign(featureData, {
		anchorDate: latest.anchorDate || "",
		clickCnt30D: latest.clickCnt30D ?? "",
		collectCnt30D: latest.collectCnt30D ?? "",
		cartCnt30D: latest.cartCnt30D ?? "",
		payCnt30D: latest.payCnt30D ?? "",
		itemAgeDays: latest.itemAgeDays ?? "",
	})

	await nextTick()
	renderChart()
}

async function fetchDetail() {
	if (!currentId.value) {
		message("缺少商品详情ID", { type: "warning" })
		return
	}

	const res = await detailApi({ id: currentId.value })
	Object.assign(form, res || {})
	await fetchForecastData(form.itemId)
}

function handleBack() {
	router.push("/data-import-module/rec-tmall-item-base")
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
.item-detail-page {
	padding: 16px;
}

.detail-image-wrap {
	min-height: 320px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fafafa;
	border-radius: 8px;
	overflow: hidden;
}

.detail-image {
	display: block;
	max-width: 100%;
	max-height: 420px;
	object-fit: contain;
}

.chart-toolbar {
	margin-bottom: 12px;
	display: flex;
	justify-content: center;
}

.chart-panel {
	min-height: 320px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(180deg, #f8fafc 0%, #eef2f7 100%);
	border-radius: 8px;
}

.chart-canvas {
	width: 100%;
	height: 320px;
}

.chart-placeholder {
	color: #64748b;
	font-size: 14px;
}
</style>
