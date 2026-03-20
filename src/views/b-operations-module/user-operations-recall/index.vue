<template>
	<KQueryList>
		<KQueryTable>
			<el-form class="query-form" :model="queryForm" inline @submit.prevent>
				<el-form-item label="用户ID">
					<el-input
						v-model="queryForm.userId"
						clearable
						placeholder="请输入用户ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="商家ID">
					<el-input
						v-model="queryForm.merchantId"
						clearable
						placeholder="请输入商家ID"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="优先级">
					<el-input
						v-model="queryForm.priorityLevel"
						clearable
						placeholder="请输入优先级"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="用户分群">
					<el-input
						v-model="queryForm.segmentName"
						clearable
						placeholder="请输入分群名称"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="任务分组">
					<el-input
						v-model="queryForm.taskGroup"
						clearable
						placeholder="请输入任务分组"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleSearch">查询</el-button>
					<el-button @click="handleReset">重置</el-button>
				</el-form-item>
			</el-form>

			<KTableBar title="用户运营与召回" :columns="columns" @refresh="fetchData">
				<template #default="{ size, dynamicColumns }">
					<KTable
						border
						align-whole="center"
						show-overflow-tooltip
						table-layout="auto"
						:loading="loading"
						:size="size"
						height="100%"
						:data="listData"
						:columns="dynamicColumns"
						:pagination="tablePagination"
						:paginationSmall="false"
						@page-current-change="handleCurrentPageChange"
					>
						<template #topReasons="{ row }">
							{{ formatText(row.topReasons) }}
						</template>
						<template #reasonTags="{ row }">
							{{ formatText(row.reasonTags) }}
						</template>
					</KTable>
				</template>
			</KTableBar>
		</KQueryTable>
	</KQueryList>
</template>

<script setup>
import { computed, onMounted, ref } from "vue"
import { defineRouteMeta, message, usePageModel } from "@kesplus/kesplus"
import { getUserOperationsRecallApi } from "./utils/user-operations-recall-api"

defineRouteMeta({
	title: "用户运营与召回",
})

const PAGE_SIZE = 20
const pendingSearchFeedback = ref(false)

const columns = [
	{ label: "用户ID", prop: "userId", align: "center", "min-width": "120px" },
	{ label: "商家ID", prop: "merchantId", align: "center", "min-width": "120px" },
	{ label: "复购分", prop: "repurchaseScore", align: "center", "min-width": "120px" },
	{ label: "风险等级", prop: "riskLevel", align: "center", "min-width": "120px" },
	{ label: "优先级", prop: "priorityLevel", align: "center", "min-width": "120px" },
	{ label: "商家内排序", prop: "scoreRankInMerchant", align: "center", "min-width": "120px" },
	{ label: "核心原因", prop: "topReasons", align: "center", "min-width": "220px", slot: "topReasons" },
	{ label: "分群ID", prop: "segmentId", align: "center", "min-width": "120px" },
	{ label: "分群名称", prop: "segmentName", align: "center", "min-width": "140px" },
	{ label: "建议动作", prop: "recommendedAction", align: "center", "min-width": "160px" },
	{ label: "召回原因", prop: "reasonTags", align: "center", "min-width": "220px", slot: "reasonTags" },
	{ label: "任务分组", prop: "taskGroup", align: "center", "min-width": "140px" },
]

const {
	queryForm,
	loading,
	listData,
	pagination,
	resetPage,
	handleCurrentPageChange,
	fetchData,
} = usePageModel({
	queryForm: {
		userId: "",
		merchantId: "",
		priorityLevel: "",
		segmentName: "",
		taskGroup: "",
	},
	pageSize: PAGE_SIZE,
	fetch: async (_pager) => {
		try {
			const result = await getUserOperationsRecallApi({
				userId: queryForm.userId || undefined,
				user_id: queryForm.userId || undefined,
				merchantId: queryForm.merchantId || undefined,
				merchant_id: queryForm.merchantId || undefined,
				priorityLevel: queryForm.priorityLevel || undefined,
				priority_level: queryForm.priorityLevel || undefined,
				segmentName: queryForm.segmentName || undefined,
				segment_name: queryForm.segmentName || undefined,
				taskGroup: queryForm.taskGroup || undefined,
				task_group: queryForm.taskGroup || undefined,
				pageIndex: _pager.currentPage,
				pageSize: _pager.pageSize,
				page_index: _pager.currentPage,
				page_size: _pager.pageSize,
			})

			const normalized = normalizePagedResult(result)

			if (
				pendingSearchFeedback.value &&
				hasActiveFilters() &&
				normalized.totalElements === 0
			) {
				message("没有查询到符合条件的数据", { type: "warning" })
			}

			return normalized
		} catch (error) {
			message(error?.message || "查询失败，请稍后重试", { type: "error" })
			return {
				totalElements: 0,
				content: [],
			}
		} finally {
			pendingSearchFeedback.value = false
		}
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

function normalizeQuery() {
	queryForm.userId = String(queryForm.userId ?? "").trim()
	queryForm.merchantId = String(queryForm.merchantId ?? "").trim()
	queryForm.priorityLevel = String(queryForm.priorityLevel ?? "").trim()
	queryForm.segmentName = String(queryForm.segmentName ?? "").trim()
	queryForm.taskGroup = String(queryForm.taskGroup ?? "").trim()
}

function hasActiveFilters() {
	return Boolean(
		queryForm.userId ||
			queryForm.merchantId ||
			queryForm.priorityLevel ||
			queryForm.segmentName ||
			queryForm.taskGroup,
	)
}

function formatText(value) {
	if (Array.isArray(value)) {
		return value.length ? value.join(" / ") : "-"
	}

	if (typeof value === "string" && value) {
		const parsed = normalizeArray(value)
		return parsed.length ? parsed.join(" / ") : value
	}

	return value === null || value === undefined || value === "" ? "-" : value
}

function handleSearch() {
	normalizeQuery()
	pendingSearchFeedback.value = true
	resetPage({ pageSize: PAGE_SIZE })
}

function handleReset() {
	Object.assign(queryForm, {
		userId: "",
		merchantId: "",
		priorityLevel: "",
		segmentName: "",
		taskGroup: "",
	})
	pendingSearchFeedback.value = false
	resetPage({ pageSize: PAGE_SIZE })
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
.query-form {
	padding-bottom: 8px;
}
</style>
