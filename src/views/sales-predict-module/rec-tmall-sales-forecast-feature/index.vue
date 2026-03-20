<template>
	<KQueryList>
		<KQueryTable>
			<el-form :model="queryForm" inline @submit.prevent>
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
				<el-form-item>
					<el-button  type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>

			<KTableBar
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
						height="100%"
						:data="listData"
						:columns="dynamicColumns"
						:pagination="isSearchMode ? false : pagination"
						:paginationSmall="size === 'small' ? true : false"
						@sort-change="handelSortChange"
						@page-size-change="handlePageSizeChange"
						@page-current-change="handleCurrentPageChange"
						@row-click="(...v) => $emit('rowClick', ...v)"
					>
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
import { onBeforeMount, ref } from "vue"
import {
	defineRouteMeta,
	usePageModel,
	getSortChangeStr,
	numeral,
	KFilePreviewer,
	message,
} from "@kesplus/kesplus"
import {
	pageApi,
	getSalesForecastFeatureByParamsApi,
} from "./utils/rec-tmall-sales-forecast-feature-api"
import { handleEdit, handleView, handleDelete } from "./utils/hooks"
import dayjs from "dayjs"

defineOptions({
	handleEdit,
	handleView,
})

defineRouteMeta({
	title: "天猫销售预测信息",
})

const isSearchMode = ref(false)

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

function normalizeQuery() {
	queryForm.itemId = String(queryForm.itemId ?? "").trim()
	queryForm.anchorDateText = queryForm.anchorDate || ""
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

function handleReset() {
	isSearchMode.value = false
	resetForm()
}

const columns = [

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
const handelSortChange = ({ prop, order }) => {
	queryForm.orderColumns = getSortChangeStr({ prop, order })
	fetchData()
}
onBeforeMount(fetchData)
</script>
