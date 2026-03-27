<template>
	<KQueryList class="emdmp-shell emdmp-query-page">
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
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>

			<KTableBar class="emdmp-table-panel" title="销量预测结果" :columns="columns" @refresh="fetchData">
				<template #buttons>
					<el-button
						plain
						v-access="'salesPredictModule:recSalesForecastPredictions:add'"
						type="primary"
						:icon="useRenderIcon('Plus')"
						@click="
							() =>
								handleEdit({ title: '新增销量预测结果', effect: fetchData })
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
						<template #operation="{ row }">
							<el-button
								class="!m-0"
								link
								type="primary"
								:size="size"
								@click="() => handleVisualDetailRedirect(row)"
							>
								查看可视化详情
							</el-button>
							<el-button
								v-access="'salesPredictModule:recSalesForecastPredictions:edit'"
								class="!m-0"
								link
								type="primary"
								:size="size"
								:icon="useRenderIcon('EditPen')"
								@click="
									() =>
										handleEdit({
											id: row.id,
											title: '编辑销量预测结果',
											row,
											effect: fetchData,
										})
								"
							>
								编辑
							</el-button>
							<el-button
								v-access="'salesPredictModule:recSalesForecastPredictions:del'"
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
	message,
} from "@kesplus/kesplus"
import { useRouter } from "@@/core/coreExports"
import {
	pageApi,
	getSalesForecastPredictionsByParamsApi,
} from "./utils/rec-sales-forecast-predictions-api"
import { handleEdit, handleView, handleDelete } from "./utils/hooks"
import dayjs from "dayjs"

defineOptions({
	handleEdit,
	handleView,
})

defineRouteMeta({
	title: "销量预测结果",
})

const router = useRouter()
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
			const result = await getSalesForecastPredictionsByParamsApi({
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
		access.hasAccess("salesPredictModule:recSalesForecastPredictions:detail"),
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

function handleVisualDetailRedirect(row) {
	router.push(
		`/sales-predict-module/rec-sales-forecast-predictions/detail?id=${row.id}`,
	)
}

const columns = [
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
		formatter: (row, column, cellValue) =>
			cellValue ? dayjs(cellValue).format("YYYY-MM-DD") : "-",
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
		label: "最近7天支付次数",
		prop: "payCnt7D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "最近30天支付次数",
		prop: "payCnt30D",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "操作",
		width: 280,
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
