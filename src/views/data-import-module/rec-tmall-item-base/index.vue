<template>
	<KQueryList>
		<KQueryTable>
			<el-form :model="queryForm" inline @submit.prevent>
				<el-form-item label="商品信息" prop="keyword">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品ID或商品标题"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
					<el-button
						plain
						v-access="'dataImportModule:recTmallItemBase:add'"
						type="primary"
						:icon="useRenderIcon('Plus')"
						@click="handleCreate"
					>
						新增
					</el-button>
				</el-form-item>
			</el-form>
			<KTableBar title="商品基础信息表" :columns="columns" @refresh="fetchData">
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
								class="!m-0"
								link
								type="primary"
								:size="size"
								@click="() => handleDetailRedirect(row)"
							>
								商品详情
							</el-button>
							<el-button
								
								class="!m-0"
								link
								type="primary"
								:size="size"
								:icon="useRenderIcon('EditPen')"
								@click="() => handleEditRedirect(row)"
							>
								编辑
							</el-button>
							<el-button
								
								class="!m-0"
								link
								type="danger"
								:size="size"
								:icon="useRenderIcon('Delete')"
								@click="() => handleDelete(row.id, handleDeleteRefresh)"
							>
								删除
							</el-button>
						</template>

						<template #title="{ row }">
							<div v-html="row.title"></div>
						</template>

						<template #titleClean="{ row }">
							<div v-html="row.titleClean"></div>
						</template>

						<template #titleTokens="{ row }">
							<div v-html="row.titleTokens"></div>
						</template>

						<template #pictUrl="{ row }">
							<div v-html="row.pictUrl"></div>
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
	getItemByParamsApi,
	pageApi,
} from "./utils/rec-tmall-item-base-api"
import { handleView, handleDelete } from "./utils/hooks"

defineOptions({
	handleView,
})

defineRouteMeta({
	title: "商品基础信息表",
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
		keyword: "",
		itemId: "",
		title: "",
		orderColumns: "",
	},
	pageSize: 10,
	fetch: async (_pager) => {
		if (isSearchMode.value) {
			const keyword = String(queryForm.keyword ?? "").trim()
			const isNumericKeyword = /^\d+$/.test(keyword)

			const result = await getItemByParamsApi({
				title: !isNumericKeyword ? queryForm.title || undefined : undefined,
				itemId: isNumericKeyword ? queryForm.itemId || undefined : undefined,
				item_id: isNumericKeyword ? queryForm.itemId || undefined : undefined,
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
			orderColumns: queryForm.orderColumns,
			pageIndex: _pager.currentPage,
			pageSize: _pager.pageSize,
		})

		return {
			totalElements: res?.totalElements ?? 0,
			content: res?.content || [],
		}
	},
	hasPermission: () =>
		access.hasAccess("dataImportModule:recTmallItemBase:detail"),
})

function normalizeKeywordQuery() {
	const keyword = String(queryForm.keyword ?? "").trim()

	queryForm.keyword = keyword
	queryForm.itemId = ""
	queryForm.title = ""

	if (!keyword) {
		return
	}

	if (/^\d+$/.test(keyword)) {
		queryForm.itemId = keyword
		return
	}

	queryForm.title = keyword
}

function handleSearch() {
	normalizeKeywordQuery()

	if (!queryForm.itemId && !queryForm.title) {
		message("请输入商品ID或商品标题", { type: "warning" })
		return
	}

	isSearchMode.value = true
	resetPage()
}

function handleReset() {
	isSearchMode.value = false
	resetForm()
}

function handleCreate() {
	router.push("/data-import-module/rec-tmall-item-base/form")
}

function handleDetailRedirect(row) {
	router.push(`/data-import-module/rec-tmall-item-base/detail?id=${row.id}`)
}

function handleEditRedirect(row) {
	router.push(`/data-import-module/rec-tmall-item-base/form?id=${row.id}`)
}

function handleDeleteRefresh() {
	isSearchMode.value = false
	resetForm()
	resetPage()
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
		label: "商品标题",
		prop: "title",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		slot: "title",
	},
	{
		label: "清洗后标题",
		prop: "titleClean",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		slot: "titleClean",
	},
	{
		label: "标题分词",
		prop: "titleTokens",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		slot: "titleTokens",
	},
	{
		label: "图片URL",
		prop: "pictUrl",
		align: "center",
		"min-width": "150px",
		sortable: "custom",
		slot: "pictUrl",
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
