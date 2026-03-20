<template>
	<KQueryList>
		<KQueryTable>
			<el-form :model="queryForm" inline @submit.prevent>
				<el-form-item label="源商品ID" prop="sourceItemId">
					<el-input
						v-model="queryForm.sourceItemId"
						clearable
						placeholder="请输入源商品ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="相似商品ID" prop="similarItemId">
					<el-input
						v-model="queryForm.similarItemId"
						clearable
						placeholder="请输入相似商品ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>
			<KTableBar title="商品相似度表" :columns="columns" @refresh="fetchData">
				<template #buttons>
					<el-button
						plain
						v-access="'dataImportModule:recTmallItemSimilarity:add'"
						type="primary"
						:icon="useRenderIcon('Plus')"
						@click="
							() => handleEdit({ title: '新增商品相似度表', effect: fetchData })
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
								v-access="'dataImportModule:recTmallItemSimilarity:edit'"
								class="!m-0"
								link
								type="primary"
								:size="size"
								:icon="useRenderIcon('EditPen')"
								@click="
									() =>
										handleEdit({
											id: row.id,
											title: '编辑商品相似度表',
											row,
											effect: fetchData,
										})
								"
							>
								编辑
							</el-button>
							<el-button
								v-access="'dataImportModule:recTmallItemSimilarity:del'"
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
import { pageApi, getItemSimilarityByParamsApi } from "./utils/rec-tmall-item-similarity-api"
import { handleEdit, handleView, handleDelete } from "./utils/hooks"

defineOptions({
	handleEdit,
	handleView,
})

defineRouteMeta({
	title: "商品相似度表",
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
		sourceItemId: "",
		similarItemId: "",
		orderColumns: "",
	},
	pageSize: 10,
	fetch: async (_pager) => {
		if (isSearchMode.value) {
			const result = await getItemSimilarityByParamsApi({
				sourceItemId: queryForm.sourceItemId || undefined,
				source_item_id: queryForm.sourceItemId || undefined,
				similarItemId: queryForm.similarItemId || undefined,
				similar_item_id: queryForm.similarItemId || undefined,
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
		access.hasAccess("dataImportModule:recTmallItemSimilarity:detail"),
})

function normalizeQuery() {
	queryForm.sourceItemId = String(queryForm.sourceItemId ?? "").trim()
	queryForm.similarItemId = String(queryForm.similarItemId ?? "").trim()
}

function handleSearch() {
	normalizeQuery()

	if (!queryForm.sourceItemId) {
		message("请输入源商品ID", { type: "warning" })
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
		label: "源商品ID",
		prop: "sourceItemId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "相似商品ID",
		prop: "similarItemId",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
	},
	{
		label: "相似度分数",
		prop: "similarityScore",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "排名序号",
		prop: "rankNo",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		formatter: (row, column, cellValue) => cellValue,
	},
	{
		label: "商品类目",
		prop: "category",
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
