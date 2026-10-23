<template>
	<KQueryList class="emdmp-shell emdmp-shell--wide emdmp-query-page">
		<KQueryTable class="emdmp-query-panel">
			<el-form class="emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="商品ID" prop="itemId">
					<el-input
						v-model="queryForm.itemId"
						clearable
						placeholder="请输入商品ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="锚定日期" prop="anchorDate">
					<el-date-picker
						v-model="queryForm.anchorDate"
						clearable
						type="date"
						value-format="YYYY-MM-DD"
						placeholder="请选择锚定日期"
						@change="normalizeQuery"
					/>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button type="success" :loading="predicting" @click="handleOnlinePredict">
						在线预测
					</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>

			<el-card v-if="onlinePrediction" class="sales-forecast-online-card" shadow="never">
				<template #header>
					<div class="sales-forecast-online-header">
						<div>
							<div class="sales-forecast-online-title">在线预测结果</div>
							<div class="sales-forecast-online-subtitle">
								模型来源：{{ onlinePrediction.modelLabel || "Sales Forecast Python Model" }}
								<span v-if="onlinePrediction.modelVersion">
									· {{ onlinePrediction.modelVersion }}
								</span>
							</div>
						</div>
						<el-tag type="success">实时调用</el-tag>
					</div>
				</template>

				<el-descriptions :column="3" border class="sales-forecast-online-summary">
					<el-descriptions-item label="商品ID">
						{{ onlinePrediction.itemId || "-" }}
					</el-descriptions-item>
					<el-descriptions-item label="锚定日期">
						{{ formatDate(onlinePrediction.anchorDate) }}
					</el-descriptions-item>
					<el-descriptions-item label="预测天数">
						{{ onlinePrediction.horizonDays || 7 }}
					</el-descriptions-item>
				</el-descriptions>

				<div class="sales-forecast-online-grid">
					<div
						v-for="metric in onlinePredictionMetrics"
						:key="metric.label"
						class="sales-forecast-online-metric"
					>
						<span class="sales-forecast-online-metric-label">{{ metric.label }}</span>
						<strong class="sales-forecast-online-metric-value">{{ metric.value }}</strong>
					</div>
				</div>
				<div class="sales-forecast-online-actions">
					<el-button type="primary" plain @click="handleOnlineVisualDetailRedirect">
						查看可视化详情
					</el-button>
				</div>
			</el-card>

			<KTableBar
				class="emdmp-table-panel"
				title="天猫销售预测信息"
				:columns="columns"
				@refresh="fetchData"
			>
				<template #buttons>
					<el-button
						plain
						v-access="'salesPredictModule:recTmallSalesForecastFeature:add'"
						type="primary"
						:icon="useRenderIcon('Plus')"
						@click="
							() =>
								handleEdit({ title: '新增天猫销售预测信息', effect: fetchData })
						"
					>
						新增
					</el-button>
				</template>
				<template #default="{ size, dynamicColumns }">
					<KTable
						border
						row-key="id"
						align-whole="center"
						show-overflow-tooltip
						table-layout="auto"
						:loading="loading"
						:size="size"
						:data="listData"
						:columns="dynamicColumns"
						:pagination="isSearchMode ? false : pagination"
						:paginationSmall="size === 'small' ? true : false"
						@sort-change="handelSortChange"
						@page-size-change="handlePageSizeChange"
						@page-current-change="handleCurrentPageChange"
						@row-click="(...v) => $emit('rowClick', ...v)"
					>
						<template #predictionSelection="{ row }">
							<el-checkbox
								:model-value="selectedPredictionRow?.id === row.id"
								@change="handlePredictionSelectionToggle(row)"
							/>
						</template>
						<template #operation="{ row }">
							<el-button
								v-access="'salesPredictModule:recTmallSalesForecastFeature:edit'"
								class="!m-0"
								link
								type="primary"
								:size="size"
								:icon="useRenderIcon('EditPen')"
								@click="
									() =>
										handleEdit({
											id: row.id,
											title: '编辑天猫销售预测信息',
											row,
											effect: fetchData,
										})
								"
							>
								编辑
							</el-button>
							<el-button
								v-access="'salesPredictModule:recTmallSalesForecastFeature:del'"
								class="!m-0"
								link
								type="danger"
								:size="size"
								:icon="useRenderIcon('Delete')"
								@click="() => handleDelete(row.id, fetchData)"
							>
								删除
							</el-button>
						</template>
					</KTable>
				</template>
			</KTableBar>
		</KQueryTable>
	</KQueryList>
</template>

<script setup>
import { computed, nextTick, onBeforeMount, ref, watch } from "vue"
import {
	defineRouteMeta,
	usePageModel,
	getSortChangeStr,
	message,
} from "@kesplus/kesplus"
import { useRouter } from "@@/core/coreExports"
import {
	pageApi,
	getSalesForecastFeatureByParamsApi,
} from "./utils/rec-tmall-sales-forecast-feature-api"
import { predictSalesForecastOnlineApi } from "../rec-sales-forecast-predictions/utils/rec-sales-forecast-predictions-api"
import {
	buildDisplayedPredictionMetrics,
	formatPredictionMetric,
} from "../rec-sales-forecast-predictions/utils/prediction-detail-state"
import { handleEdit, handleView, handleDelete } from "./utils/hooks"
import { saveOnlinePredictionSnapshot } from "../rec-sales-forecast-predictions/utils/online-prediction-cache"
import { getNextSelectedPredictionRow } from "../rec-sales-forecast-predictions/utils/single-prediction-selection"
import dayjs from "dayjs"

defineOptions({
	handleEdit,
	handleView,
})

defineRouteMeta({
	title: "天猫销售预测信息",
})

const router = useRouter()
const isSearchMode = ref(false)
const predicting = ref(false)
const onlinePrediction = ref(null)
const latestOnlinePredictionSnapshot = ref(null)
const selectedPredictionRow = ref(null)

const {
	queryForm,
	resetForm,
	loading,
	listData,
	pagination,
	resetPage,
	handlePageSizeChange,
	handleCurrentPageChange,
	fetchData,
} = usePageModel({
	queryForm: {
		itemId: "",
		anchorDate: "",
		anchorDateText: "",
		orderColumns: "",
	},
	pageSize: 10,
	fetch: async (_pager) => {
		if (isSearchMode.value) {
			const result = await getSalesForecastFeatureByParamsApi({
				itemId: queryForm.itemId || undefined,
				item_id: queryForm.itemId || undefined,
				anchorDate: queryForm.anchorDateText || undefined,
				anchor_date: queryForm.anchorDateText || undefined,
			})

			const content = Array.isArray(result) ? result : []

			if (content.length === 0) {
				message("没有查询到结果", { type: "warning" })
			}

			return {
				totalElements: content.length,
				content,
			}
		}

		const res = await pageApi({
			...queryForm,
			pageIndex: _pager.currentPage,
			pageSize: _pager.pageSize,
		})

		return {
			totalElements: res?.totalElements ?? 0,
			content: res?.content || [],
		}
	},
	hasPermission: () =>
		access.hasAccess("salesPredictModule:recTmallSalesForecastFeature:detail"),
})

const onlinePredictionMetrics = computed(() => {
	if (!onlinePrediction.value) {
		return []
	}
	return buildDisplayedPredictionMetrics(onlinePrediction.value)
})

function formatMetric(value) {
	return formatPredictionMetric(value)
}

function formatDate(value) {
	return value ? dayjs(value).format("YYYY-MM-DD") : "-"
}

function buildOnlinePredictionSnapshot(featureRow, result) {
	return {
		resultSource: "online_prediction",
		itemId: result?.itemId ?? featureRow?.itemId ?? queryForm.itemId ?? "",
		anchorDate:
			result?.anchorDate ?? featureRow?.anchorDate ?? queryForm.anchorDateText ?? "",
		category: featureRow?.category ?? "",
		brandId: featureRow?.brandId ?? "",
		sellerId: featureRow?.sellerId ?? "",
		payCnt7D: featureRow?.payCnt7D ?? "",
		payCnt30D: featureRow?.payCnt30D ?? "",
		predPayD1: result?.predPayD1 ?? "",
		predPayD2: result?.predPayD2 ?? "",
		predPayD3: result?.predPayD3 ?? "",
		predPayD4: result?.predPayD4 ?? "",
		predPayD5: result?.predPayD5 ?? "",
		predPayD6: result?.predPayD6 ?? "",
		predPayD7: result?.predPayD7 ?? "",
		pred7DPay: result?.pred7DPay ?? "",
		horizonDays: result?.horizonDays ?? 7,
		modelLabel: result?.modelLabel ?? "",
		modelVersion: result?.modelVersion ?? "",
	}
}

function normalizeQuery() {
	queryForm.itemId = String(queryForm.itemId ?? "").trim()
	queryForm.anchorDateText = queryForm.anchorDate || ""
}

function clearPredictionSelection() {
	selectedPredictionRow.value = null
}

function buildSelectedPredictionParams(row = selectedPredictionRow.value) {
	if (!row) {
		return null
	}

	const itemId = row.itemId ?? ""
	const anchorDate = row.anchorDate
		? dayjs(row.anchorDate).format("YYYY-MM-DD")
		: ""

	if (!itemId || !anchorDate) {
		return null
	}

	return {
		itemId: String(itemId),
		anchorDate,
	}
}

function validateOnlinePredictSelection() {
	if (!selectedPredictionRow.value) {
		message("请先勾选一条商品记录，再执行在线预测", { type: "warning" })
		return null
	}

	const params = buildSelectedPredictionParams()
	if (!params) {
		message("当前勾选记录缺少商品ID或锚定日期，无法执行在线预测", {
			type: "warning",
		})
		return null
	}

	return params
}

function handleSearch() {
	normalizeQuery()

	if (!queryForm.itemId && !queryForm.anchorDateText) {
		message("请输入商品ID或锚定日期", { type: "warning" })
		return
	}

	isSearchMode.value = true
	resetPage()
}

async function handleOnlinePredict() {
	const selectedParams = validateOnlinePredictSelection()
	if (!selectedParams) {
		return
	}

	predicting.value = true

	try {
		const featureRow = selectedPredictionRow.value
		const result = await predictSalesForecastOnlineApi({
			itemId: selectedParams.itemId,
			anchorDate: selectedParams.anchorDate,
			horizonDays: 7,
			featureData: featureRow ?? {},
		})

		if (!result?.success) {
			message(result?.message || "在线预测失败，请检查模型文件是否已放到指定目录", {
				type: "error",
			})
			return
		}

		onlinePrediction.value = result
		latestOnlinePredictionSnapshot.value = buildOnlinePredictionSnapshot(
			featureRow,
			result,
		)
		message("在线预测完成", { type: "success" })
	} catch (error) {
		message(error?.message || "在线预测失败", { type: "error" })
	} finally {
		predicting.value = false
	}
}

function handleReset() {
	isSearchMode.value = false
	onlinePrediction.value = null
	latestOnlinePredictionSnapshot.value = null
	resetForm()
	clearPredictionSelection()
}

const columns = [
	{
		label: "",
		slot: "predictionSelection",
		width: "52px",
		align: "center",
		showOverflowTooltip: false,
	},

	//  {
	//    label: "",
	//    type: "selection",
	//    align: "center",
	//    width: "28px",
	//    showOverflowTooltip: false,
	//  },
	//   {
	//     label: "序号",
	//     type: "index",
	//     width: 60,
	//   },

	{
		label: "商品ID",
		prop: "itemId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "锚定日期",
		prop: "anchorDate",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue, index) => {
			return cellValue ? dayjs(cellValue).format("YYYY-MM-DD") : "-"
		},
	},
	{
		label: "商品类目",
		prop: "category",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "品牌ID",
		prop: "brandId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "商家ID",
		prop: "sellerId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "1天点击量",
		prop: "clickCnt1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天点击用户数",
		prop: "clickUv1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天人均点击量",
		prop: "clickAvg1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "1天点击是否为零",
		prop: "clickIsZero1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天点击量",
		prop: "clickCnt3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天点击用户数",
		prop: "clickUv3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天人均点击量",
		prop: "clickAvg3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "3天点击是否为零",
		prop: "clickIsZero3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天点击量",
		prop: "clickCnt7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天点击用户数",
		prop: "clickUv7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天人均点击量",
		prop: "clickAvg7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天点击是否为零",
		prop: "clickIsZero7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天点击量",
		prop: "clickCnt14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天点击用户数",
		prop: "clickUv14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天人均点击量",
		prop: "clickAvg14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天点击是否为零",
		prop: "clickIsZero14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天点击量",
		prop: "clickCnt30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天点击用户数",
		prop: "clickUv30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天人均点击量",
		prop: "clickAvg30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天点击是否为零",
		prop: "clickIsZero30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天收藏量",
		prop: "collectCnt1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天收藏用户数",
		prop: "collectUv1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天人均收藏量",
		prop: "collectAvg1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "1天收藏是否为零",
		prop: "collectIsZero1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天收藏量",
		prop: "collectCnt3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天收藏用户数",
		prop: "collectUv3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天人均收藏量",
		prop: "collectAvg3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "3天收藏是否为零",
		prop: "collectIsZero3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天收藏量",
		prop: "collectCnt7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天收藏用户数",
		prop: "collectUv7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天人均收藏量",
		prop: "collectAvg7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天收藏是否为零",
		prop: "collectIsZero7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天收藏量",
		prop: "collectCnt14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天收藏用户数",
		prop: "collectUv14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天人均收藏量",
		prop: "collectAvg14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天收藏是否为零",
		prop: "collectIsZero14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天收藏量",
		prop: "collectCnt30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天收藏用户数",
		prop: "collectUv30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天人均收藏量",
		prop: "collectAvg30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天收藏是否为零",
		prop: "collectIsZero30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天加购量",
		prop: "cartCnt1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天加购用户数",
		prop: "cartUv1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天人均加购量",
		prop: "cartAvg1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "1天加购是否为零",
		prop: "cartIsZero1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天加购量",
		prop: "cartCnt3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天加购用户数",
		prop: "cartUv3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天人均加购量",
		prop: "cartAvg3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "3天加购是否为零",
		prop: "cartIsZero3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天加购量",
		prop: "cartCnt7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天加购用户数",
		prop: "cartUv7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天人均加购量",
		prop: "cartAvg7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天加购是否为零",
		prop: "cartIsZero7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天加购量",
		prop: "cartCnt14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天加购用户数",
		prop: "cartUv14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天人均加购量",
		prop: "cartAvg14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天加购是否为零",
		prop: "cartIsZero14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天加购量",
		prop: "cartCnt30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天加购用户数",
		prop: "cartUv30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天人均加购量",
		prop: "cartAvg30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天加购是否为零",
		prop: "cartIsZero30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天支付量",
		prop: "payCnt1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天支付用户数",
		prop: "payUv1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "1天人均支付量",
		prop: "payAvg1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "1天支付是否为零",
		prop: "payIsZero1D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天支付量",
		prop: "payCnt3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天支付用户数",
		prop: "payUv3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "3天人均支付量",
		prop: "payAvg3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "3天支付是否为零",
		prop: "payIsZero3D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天支付量",
		prop: "payCnt7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天支付用户数",
		prop: "payUv7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天人均支付量",
		prop: "payAvg7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天支付是否为零",
		prop: "payIsZero7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天支付量",
		prop: "payCnt14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天支付用户数",
		prop: "payUv14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天人均支付量",
		prop: "payAvg14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天支付是否为零",
		prop: "payIsZero14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天支付量",
		prop: "payCnt30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天支付用户数",
		prop: "payUv30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天人均支付量",
		prop: "payAvg30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天支付是否为零",
		prop: "payIsZero30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "前7天点击量",
		prop: "clickCntPrev7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "前7天支付量",
		prop: "payCntPrev7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "前7天加购量",
		prop: "cartCntPrev7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "前14天点击量",
		prop: "clickCntPrev14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "前14天支付量",
		prop: "payCntPrev14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天支付点击率",
		prop: "payPerClick7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天加购点击率",
		prop: "cartPerClick7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天收藏点击率",
		prop: "collectPerClick7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天支付用户点击用户率",
		prop: "payUvPerClickUv7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "3天与7天支付比例",
		prop: "payRatio3DTo7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天与14天支付比例",
		prop: "payRatio7DTo14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天点击量变化",
		prop: "clickCntDelta7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天支付量变化",
		prop: "payCntDelta7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天加购量变化",
		prop: "cartCntDelta7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天支付量变化",
		prop: "payCntDelta14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "14天点击量变化",
		prop: "clickCntDelta14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "7天支付均值",
		prop: "payMean7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天支付均值",
		prop: "payMean14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天支付均值",
		prop: "payMean30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天支付标准差",
		prop: "payStd7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天支付标准差",
		prop: "payStd14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天支付标准差",
		prop: "payStd30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天支付最大值",
		prop: "payMax7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天支付最大值",
		prop: "payMax14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天支付最大值",
		prop: "payMax30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天点击均值",
		prop: "clickMean7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天点击均值",
		prop: "clickMean14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天点击均值",
		prop: "clickMean30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "7天点击标准差",
		prop: "clickStd7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "14天点击标准差",
		prop: "clickStd14D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天点击标准差",
		prop: "clickStd30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "30天有支付天数",
		prop: "payActiveDays30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "30天活跃天数",
		prop: "activeDays30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "距离上次点击天数",
		prop: "daysSinceLastClick",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "距离上次支付天数",
		prop: "daysSinceLastPay",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "累计活跃天数",
		prop: "cumulativeActiveDays",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "累计支付天数",
		prop: "cumulativePayDays",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "商品上架天数",
		prop: "itemAgeDays",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "星期几",
		prop: "dayOfWeek",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "是否周末",
		prop: "isWeekend",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "当月第几天",
		prop: "dayOfMonth",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "月份",
		prop: "month",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		// 使用 numeral 库对数据进行格式化
		formatter:
			// (row, column, cellValue, index) => { return typeof(cellValue) === "number"? numeral(cellValue).format("0,0"): cellValue}
			(row, column, cellValue, index) => cellValue,
	},
	{
		label: "操作",
		width: 230,
		align: "center",
		fixed: "right",
		slot: "operation",
		showOverflowTooltip: false,
	},
].filter(Boolean)

function handlePredictionSelectionToggle(row) {
	selectedPredictionRow.value = getNextSelectedPredictionRow(
		selectedPredictionRow.value,
		row,
	)
}

function handleOnlineVisualDetailRedirect() {
	if (!latestOnlinePredictionSnapshot.value) {
		message("请先完成在线预测，再查看可视化详情", { type: "warning" })
		return
	}

	const predictionKey = saveOnlinePredictionSnapshot(latestOnlinePredictionSnapshot.value)
	if (!predictionKey) {
		message("在线预测结果暂存失败，请重试", { type: "error" })
		return
	}

	router.push(
		`/sales-predict-module/rec-sales-forecast-predictions/detail?predictionKey=${predictionKey}`,
	)
}

const handelSortChange = ({ prop, order }) => {
	queryForm.orderColumns = getSortChangeStr({ prop, order })
	fetchData()
}

async function loadTableData() {
	await fetchData()
	await nextTick()
	clearPredictionSelection()
}

watch(
	listData,
	async () => {
		await nextTick()
		clearPredictionSelection()
	},
	{ flush: "post" },
)

onBeforeMount(loadTableData)
</script>

<style scoped lang="scss">
.sales-forecast-online-card {
	margin-bottom: 18px;
	border: 1px solid rgba(59, 130, 246, 0.16);
	background:
		linear-gradient(180deg, rgba(248, 250, 252, 0.98), rgba(239, 246, 255, 0.96)),
		radial-gradient(circle at top right, rgba(59, 130, 246, 0.12), transparent 28%);
}

.sales-forecast-online-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
}

.sales-forecast-online-title {
	font-size: 18px;
	font-weight: 600;
	color: #0f172a;
}

.sales-forecast-online-subtitle {
	margin-top: 4px;
	font-size: 13px;
	color: #64748b;
}

.sales-forecast-online-summary {
	margin-bottom: 18px;
}

.sales-forecast-online-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(110px, 1fr));
	gap: 12px;
}

.sales-forecast-online-actions {
	display: flex;
	justify-content: flex-end;
	margin-top: 16px;
}

.sales-forecast-online-metric {
	display: flex;
	flex-direction: column;
	gap: 8px;
	padding: 14px 16px;
	border-radius: 16px;
	background: rgba(255, 255, 255, 0.82);
	border: 1px solid rgba(148, 163, 184, 0.16);
}

.sales-forecast-online-metric-label {
	font-size: 12px;
	letter-spacing: 0.04em;
	color: #64748b;
}

.sales-forecast-online-metric-value {
	font-size: 22px;
	line-height: 1;
	color: #0f172a;
}
</style>
