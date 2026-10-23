<template>
	<KQueryList class="emdmp-shell emdmp-query-page">
		<KQueryTable class="emdmp-query-panel">
			<div class="emdmp-page-hero item-base-hero">
				<div>
					<p class="emdmp-page-kicker">Data Import Atlas</p>
					<h1 class="emdmp-page-title">商品基础信息库</h1>
					<p class="emdmp-page-description">
						以卡片化方式浏览商品基础数据、封面图与关键属性，让数据导入结果更适合展示、巡检与快速维护。
					</p>
					<div class="item-base-hero-copy">
						<h1>商品基础信息档案馆</h1>
						<p>
							把商品底表、封面图和关键属性整理成一组可快速浏览的数据藏品，让导入结果更适合展示、巡检与后续维护。
						</p>
					</div>
				</div>
			</div>
			<el-form class="emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="商品信息" prop="keyword">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品ID或商品标题"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
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

			<el-card shadow="never" class="emdmp-card-panel" v-loading="loading">
				<template #header>
					<div class="emdmp-card-panel__header">
						<div class="emdmp-card-panel__title">商品基础信息</div>
						<div class="emdmp-card-panel__actions">
							<el-select
								v-model="sortValue"
								class="emdmp-sort-select"
								placeholder="选择排序"
								clearable
								@change="handleSortChange"
							>
								<el-option
									v-for="item in sortOptions"
									:key="item.value"
									:label="item.label"
									:value="item.value"
								/>
							</el-select>
							<el-button plain @click="fetchData">刷新</el-button>
						</div>
					</div>
				</template>

				<div v-if="listData.length" class="emdmp-card-grid">
					<article
						v-for="row in listData"
						:key="row.id"
						class="emdmp-item-card"
						role="button"
						tabindex="0"
						@click="handleDetailRedirect(row)"
						@keyup.enter="handleDetailRedirect(row)"
					>
						<div class="emdmp-item-card__media">
							<img
								v-if="resolveImageUrl(row.pictUrl)"
								:src="resolveImageUrl(row.pictUrl)"
								:alt="row.titleClean || row.title || row.itemId || '商品图片'"
								class="emdmp-item-card__image"
							/>
							<div v-else class="emdmp-item-card__image-empty">
								<el-empty description="暂无商品图片" :image-size="72" />
							</div>
						</div>

						<div class="emdmp-item-card__body">
							<h3 class="emdmp-item-card__title">
								{{ row.titleClean || row.title || "未命名商品" }}
							</h3>
							<div class="emdmp-item-card__meta">
								<span class="emdmp-item-card__meta-label">商品ID</span>
								<span>{{ row.itemId || "-" }}</span>
							</div>
							<div class="emdmp-item-card__meta">
								<span class="emdmp-item-card__meta-label">商品类目</span>
								<span>{{ row.category || "-" }}</span>
							</div>
							<div class="emdmp-item-card__meta">
								<span class="emdmp-item-card__meta-label">品牌ID</span>
								<span>{{ row.brandId || "-" }}</span>
							</div>
							<div class="emdmp-item-card__meta">
								<span class="emdmp-item-card__meta-label">卖家ID</span>
								<span>{{ row.sellerId || "-" }}</span>
							</div>
						</div>

						<div class="emdmp-item-card__footer">
							<el-button
								v-access="'dataImportModule:recTmallItemBase:edit'"
								link
								type="primary"
								:icon="useRenderIcon('EditPen')"
								@click.stop="handleEditRedirect(row)"
							>
								编辑
							</el-button>
							<el-button
								v-access="'dataImportModule:recTmallItemBase:del'"
								link
								type="danger"
								:icon="useRenderIcon('Delete')"
								@click.stop="handleDelete(row.id, handleDeleteRefresh)"
							>
								删除
							</el-button>
						</div>
					</article>
				</div>
				<el-empty v-else description="暂无商品数据" />

				<div class="emdmp-pagination">
					<el-pagination
						background
						layout="total, sizes, prev, pager, next, jumper"
						:current-page="pagination.currentPage"
						:page-size="pagination.pageSize"
						:page-sizes="[12, 24, 48]"
						:total="pagination.total ?? pagination.totalElements ?? 0"
						@size-change="handlePageSizeChange"
						@current-change="handleCurrentPageChange"
					/>
				</div>
			</el-card>
		</KQueryTable>
	</KQueryList>
</template>

<script setup>
import { computed, onBeforeMount, ref } from "vue"
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
const sortValue = ref("")

const sortOptions = [
	{ label: "商品ID 升序", value: "itemId:ascending" },
	{ label: "商品ID 降序", value: "itemId:descending" },
	{ label: "商品标题 升序", value: "title:ascending" },
	{ label: "商品标题 降序", value: "title:descending" },
	{ label: "商品类目 升序", value: "category:ascending" },
	{ label: "商品类目 降序", value: "category:descending" },
	{ label: "品牌ID 升序", value: "brandId:ascending" },
	{ label: "品牌ID 降序", value: "brandId:descending" },
	{ label: "卖家ID 升序", value: "sellerId:ascending" },
	{ label: "卖家ID 降序", value: "sellerId:descending" },
]

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
	pageSize: 12,
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
			const startIndex = (_pager.currentPage - 1) * _pager.pageSize
			const pageContent = content.slice(startIndex, startIndex + _pager.pageSize)

			if (content.length === 0) {
				message("没有查询到结果", { type: "warning" })
			}

			return {
				totalElements: content.length,
				content: pageContent,
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

const normalizedTotal = computed(
	() => pagination.total ?? pagination.totalElements ?? 0,
)

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
	sortValue.value = ""
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
	resetPage()
}

function handleSortChange(value) {
	if (!value) {
		queryForm.orderColumns = ""
		fetchData()
		return
	}

	const [prop, order] = String(value).split(":")
	queryForm.orderColumns = getSortChangeStr({ prop, order })
	fetchData()
}

function resolveImageUrl(value) {
	if (!value) {
		return ""
	}

	const text = String(value).trim()

	if (!text) {
		return ""
	}

	const srcMatch = text.match(/src\s*=\s*["']([^"']+)["']/i)
	if (srcMatch?.[1]) {
		return srcMatch[1]
	}

	return text
}

onBeforeMount(fetchData)
</script>

<style scoped lang="scss">
.item-base-hero {
	margin-bottom: 18px;
	background:
		linear-gradient(145deg, rgba(255, 255, 255, 0.95), rgba(247, 250, 255, 0.9) 54%, rgba(255, 248, 244, 0.92)),
		radial-gradient(circle at top left, rgba(245, 158, 11, 0.12), transparent 28%),
		radial-gradient(circle at 84% 18%, rgba(59, 130, 246, 0.12), transparent 26%);
}

:deep(.item-base-hero .emdmp-page-title),
:deep(.item-base-hero .emdmp-page-description) {
	position: absolute;
	width: 1px;
	height: 1px;
	padding: 0;
	margin: -1px;
	overflow: hidden;
	clip: rect(0, 0, 0, 0);
	white-space: nowrap;
	border: 0;
}

.item-base-hero-copy {
	display: flex;
	flex-direction: column;
	gap: 14px;
	max-width: 760px;
}

.item-base-hero-copy h1 {
	margin: 0;
	font-family: "Georgia", "Times New Roman", serif;
	font-size: clamp(38px, 4vw, 62px);
	line-height: 1.04;
	font-weight: 700;
	letter-spacing: -0.04em;
	color: #0f172a;
	text-wrap: balance;
}

.item-base-hero-copy p {
	margin: 0;
	max-width: 660px;
	font-size: 15px;
	line-height: 1.85;
	color: #526277;
}

.emdmp-card-panel {
	border-radius: 16px;
}

.emdmp-card-panel__header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	flex-wrap: wrap;
}

.emdmp-card-panel__title {
	font-size: 18px;
	font-weight: 700;
	color: #1f2937;
}

.emdmp-card-panel__actions {
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: wrap;
}

.emdmp-sort-select {
	width: 180px;
}

.emdmp-card-grid {
	display: grid;
	grid-template-columns: repeat(4, minmax(0, 1fr));
	gap: 16px;
}

.emdmp-item-card {
	display: flex;
	flex-direction: column;
	min-width: 0;
	height: 100%;
	border: 1px solid rgba(148, 163, 184, 0.16);
	border-radius: 24px;
	background:
		linear-gradient(180deg, rgba(255, 255, 255, 0.98) 0%, rgba(246, 249, 253, 0.96) 100%);
	cursor: pointer;
	overflow: hidden;
	transition:
		transform 0.2s ease,
		box-shadow 0.2s ease,
		border-color 0.2s ease;
}

.emdmp-item-card:hover {
	transform: translateY(-6px);
	border-color: rgba(201, 21, 30, 0.22);
	box-shadow: 0 24px 48px rgba(15, 23, 42, 0.12);
}

.emdmp-item-card__media {
	aspect-ratio: 1 / 1;
	background:
		radial-gradient(circle at top left, rgba(191, 219, 254, 0.8), transparent 45%),
		linear-gradient(180deg, #f8fbff 0%, #eef4ff 100%);
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 16px;
}

.emdmp-item-card__image {
	width: 100%;
	height: 100%;
	object-fit: contain;
	display: block;
}

.emdmp-item-card__image-empty {
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.emdmp-item-card__body {
	display: flex;
	flex-direction: column;
	gap: 10px;
	padding: 18px 18px 12px;
}

.emdmp-item-card__title {
	margin: 0;
	font-family: "Georgia", "Times New Roman", serif;
	font-size: 20px;
	line-height: 1.6;
	font-weight: 700;
	color: #111827;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	-webkit-line-clamp: 2;
	overflow: hidden;
	min-height: 48px;
}

.emdmp-item-card__meta {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
	font-size: 13px;
	line-height: 1.5;
	color: #4b5563;
}

.emdmp-item-card__meta-label {
	flex: 0 0 auto;
	color: #8a98ab;
	font-size: 11px;
	letter-spacing: 0.1em;
	text-transform: uppercase;
}

.emdmp-item-card__footer {
	margin-top: auto;
	padding: 0 16px 16px;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 12px;
}

.emdmp-pagination {
	display: flex;
	justify-content: flex-end;
	padding-top: 20px;
}

@media (max-width: 1399px) {
	.emdmp-card-grid {
		grid-template-columns: repeat(3, minmax(0, 1fr));
	}
}

@media (max-width: 991px) {
	.emdmp-card-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media (max-width: 767px) {
	.emdmp-card-panel__actions,
	.emdmp-pagination {
		width: 100%;
		justify-content: flex-start;
	}

	.emdmp-sort-select {
		width: 100%;
	}

	.emdmp-card-grid {
		grid-template-columns: 1fr;
	}
}
</style>
