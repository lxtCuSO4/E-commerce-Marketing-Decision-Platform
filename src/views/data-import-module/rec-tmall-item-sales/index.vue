<template>
	<KQueryList class="emdmp-shell emdmp-query-page">
		<KQueryTable class="emdmp-query-panel">
			<el-form class="emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="商品ID" prop="keyword">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>
			<KTableBar class="emdmp-table-panel" title="商品销售信息表" :columns="columns" @refresh="fetchData">
				<template #buttons>
					<el-button
						plain
						v-access="'dataImportModule:recTmallItemSales:add'"
						type="primary"
						:icon="useRenderIcon('Plus')"
						@click="
							() => handleEdit({ title: '新增商品销售信息表', effect: fetchData })
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
								v-access="'dataImportModule:recTmallItemSales:edit'"
								class="!m-0"
								link
								type="primary"
								:size="size"
								:icon="useRenderIcon('EditPen')"
								@click="
									() =>
										handleEdit({
											id: row.id,
											title: '编辑商品销售信息表',
											row,
											effect: fetchData,
										})
								"
							>
								编辑
							</el-button>
							<el-button
								v-access="'dataImportModule:recTmallItemSales:del'"
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
import { defineRouteMeta, usePageModel, getSortChangeStr, message } from "@kesplus/kesplus"
import { pageApi, getItemSalesByItemIdApi } from "./utils/rec-tmall-item-sales-api"
import { handleEdit, handleView, handleDelete } from "./utils/hooks"

defineOptions({
	handleEdit,
	handleView,
})

defineRouteMeta({
	title: "商品销售信息表",
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
		keyword: "",
		itemId: "",
		orderColumns: "",
	},
	pageSize: 10,
	fetch: async (_pager) => {
		if (isSearchMode.value) {
			const result = await getItemSalesByItemIdApi({
				itemId: queryForm.itemId || undefined,
				item_id: queryForm.itemId || undefined,
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
	hasPermission: () => access.hasAccess("dataImportModule:recTmallItemSales:detail"),
})

function normalizeKeywordQuery() {
	const keyword = String(queryForm.keyword ?? "").trim()

	queryForm.keyword = keyword
	queryForm.itemId = keyword
}

function handleSearch() {
	normalizeKeywordQuery()

	if (!queryForm.itemId) {
		message("请输入商品ID", { type: "warning" })
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
	{
		label: "商品ID",
		prop: "itemId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "点击量",
		prop: "clickCnt",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "收藏量",
		prop: "collectCnt",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "加购量",
		prop: "cartCnt",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "支付量",
		prop: "payCnt",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "最后行为时间",
		prop: "lastActionTime",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
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
