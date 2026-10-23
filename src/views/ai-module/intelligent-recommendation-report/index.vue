<template>
	<KPage class="emdmp-shell emdmp-shell--wide emdmp-query-page ai-report-page">
		<div class="emdmp-page-hero ai-hero">
			<div>
				<p class="emdmp-page-kicker">AI Intelligence</p>
				<h1 class="emdmp-page-title">智能推荐与报告</h1>
				<p class="emdmp-page-description">
					基于商品标题关键字、销量、点击与近周期行为特征生成推荐排序，并支持一键输出商业分析报告。
				</p>
			</div>
		</div>

		<el-row :gutter="16" class="m-b-16px">
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">匹配商品数</div>
						<div class="summary-value">{{ summary.matchedItemCount }}</div>
						<div class="summary-meta">当前关键字和日期条件下进入推荐评估的商品规模</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">平均推荐度</div>
						<div class="summary-value">{{ formatScore(summary.avgRecommendationScore) }}</div>
						<div class="summary-meta">当前查询结果集全量的综合推荐分均值</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">高推荐商品数</div>
						<div class="summary-value">{{ summary.highRecommendationCount }}</div>
						<div class="summary-meta">当前查询结果集全量中处于高推荐层级的商品数量</div>
					</div>
				</el-card>
			</el-col>
			<el-col :xs="24" :sm="12" :lg="6">
				<el-card shadow="never" class="summary-panel">
					<div class="summary-card">
						<div class="summary-label">报告状态</div>
						<div class="summary-value summary-value--status">{{ previewStatusLabel }}</div>
						<div class="summary-meta">
							{{ summary.message || "支持基于当前结果集或勾选商品生成商业分析报告" }}
						</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

		<el-card shadow="never" class="ai-query-card m-b-16px">
			<el-form class="emdmp-query-form" :model="queryForm" @submit.prevent>
				<el-form-item label="商品标题关键字">
					<el-input
						v-model="queryForm.keyword"
						clearable
						placeholder="请输入商品标题关键字"
						@keyup.enter="handleSearch"
					/>
				</el-form-item>
				<el-form-item label="锚定日期">
					<el-date-picker
						v-model="queryForm.anchorDate"
						type="date"
						value-format="YYYY-MM-DD"
						clearable
						placeholder="请选择锚定日期"
					/>
				</el-form-item>
				<el-form-item label="报告类型">
					<el-select v-model="queryForm.reportType" placeholder="请选择报告类型">
						<el-option label="经营分析" value="business" />
						<el-option label="运营分析" value="operation" />
						<el-option label="选品分析" value="selection" />
					</el-select>
				</el-form-item>
				<el-form-item class="emdmp-query-actions">
					<el-button type="primary" :loading="loading" @click="handleSearch">查询推荐</el-button>
					<el-button @click="handleReset">重置</el-button>
					<el-button
						type="success"
						:loading="reportLoading"
						:disabled="!canGenerateReport"
						@click="handleGenerateReport"
					>
						生成商业分析报告
					</el-button>
					<el-button
						type="warning"
						plain
						:loading="marketingCopyLoading"
						:disabled="!canGenerateMarketingCopy"
						@click="handleGenerateMarketingCopy"
					>
						生成营销文案
					</el-button>
				</el-form-item>
			</el-form>
		</el-card>

		<KTableBar
			v-if="hasSearched"
			class="emdmp-table-panel ai-table-panel"
			title="AI 智能推荐结果"
			:columns="columns"
			@refresh="fetchData"
		>
			<template #title>
				<div class="table-toolbar-text">
					{{
						selectedRows.length
							? "已选中 1 个商品，将仅基于该商品生成商业分析报告与营销文案"
							: "请先勾选 1 个商品，再生成商业分析报告或营销文案"
					}}
				</div>
			</template>
			<template #default="{ size, dynamicColumns }">
				<KTable
					ref="tableRef"
					border
					row-key="itemId"
					align-whole="center"
					show-overflow-tooltip
					table-layout="auto"
					:loading="loading"
					:size="size"
					:data="listData"
					:columns="dynamicColumns"
					:pagination="tablePagination"
					:paginationSmall="false"
					@page-current-change="handleCurrentPageChange"
					@select="handleSelect"
					@select-all="handleSelectAll"
					@selection-change="handleSelectionChange"
				>
					<template #title="{ row }">
						<div class="title-cell">
							<div class="title-cell__main">{{ row.title || "-" }}</div>
							<div class="title-cell__sub">商品ID：{{ row.itemId }}</div>
						</div>
					</template>
					<template #recommendationLevel="{ row }">
						<el-tag
							:type="getRecommendationTagType(row.recommendationLevel)"
							size="small"
							effect="light"
						>
							{{ row.recommendationLevel || "-" }}
						</el-tag>
					</template>
				</KTable>
			</template>
		</KTableBar>
		<el-card v-else shadow="never" class="ai-table-panel ai-table-panel--placeholder">
			<el-empty description="请先输入条件并点击查询推荐，再查看 AI 推荐列表" />
		</el-card>

		<el-row :gutter="16" class="m-t-16px" align="top">
			<el-col :xs="24" :lg="14">
				<el-card shadow="never" class="report-panel m-b-16px">
					<template #header>
						<div class="card-header-with-status">
							<span>AI 商业分析摘要</span>
							<div v-if="isReportGenerating" class="llm-generating-indicator">
								<span class="llm-generating-indicator__dot"></span>
								<span>大模型生成中</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowReportContent" class="report-content">
						<h3 class="report-title">{{ reportData.reportTitle || "AI 商业分析报告" }}</h3>
						<p class="report-summary">{{ reportData.summary || "暂无摘要" }}</p>
						<div v-if="reportSections.length" class="report-sections">
							<section v-for="(section, index) in reportSections" :key="`${section.title || 'section'}-${index}`">
								<h4>{{ section.title || `分析章节 ${index + 1}` }}</h4>
								<p>{{ section.content || section.text || "-" }}</p>
							</section>
						</div>
					</div>
					<el-empty v-else-if="isReportGenerating" description="大模型生成中" />
					<el-empty v-else description="查询商品后即可生成 AI 商业分析报告" />
				</el-card>
				<el-card shadow="never" class="report-panel marketing-copy-panel">
					<template #header>
						<div class="marketing-copy-panel__header card-header-with-status">
							<span>营销文案生成</span>
							<div class="marketing-copy-panel__header-right">
								<div v-if="marketingCopyLoading" class="llm-generating-indicator">
									<span class="llm-generating-indicator__dot"></span>
									<span>大模型生成中</span>
								</div>
								<span class="marketing-copy-panel__meta">仅支持当前选中的 1 个商品</span>
							</div>
						</div>
					</template>
					<div v-if="shouldShowMarketingCopyContent" class="marketing-copy-content">
						<p class="marketing-copy-summary">{{ marketingCopyData.summary }}</p>
						<div class="marketing-copy-status">文案状态：{{ marketingCopyStatusLabel }}</div>
						<div
							v-for="item in marketingCopyItems"
							:key="item.itemId || item.title"
							class="marketing-copy-card"
						>
							<div class="marketing-copy-card__top">
								<div>
									<div class="marketing-copy-card__title">{{ item.title || "-" }}</div>
									<div class="marketing-copy-card__sub">商品ID：{{ item.itemId || "-" }}</div>
								</div>
								<el-button link type="primary" @click="handleCopyMarketingItem(item)">
									复制整组文案
								</el-button>
							</div>
							<div class="marketing-copy-section">
								<div class="marketing-copy-section__label">标题优化建议</div>
								<ul>
									<li v-for="(headline, index) in item.headlineOptions" :key="`headline-${item.itemId}-${index}`">
										{{ headline }}
									</li>
								</ul>
							</div>
							<div class="marketing-copy-section">
								<div class="marketing-copy-section__label">核心卖点摘要</div>
								<div class="report-tags">
									<el-tag
										v-for="(point, index) in item.sellingPoints"
										:key="`point-${item.itemId}-${index}`"
										size="small"
										effect="plain"
									>
										{{ point }}
									</el-tag>
								</div>
							</div>
							<div class="marketing-copy-section">
								<div class="marketing-copy-section__label">短推广文案</div>
								<ul>
									<li v-for="(copy, index) in item.shortPromotions" :key="`promo-${item.itemId}-${index}`">
										{{ copy }}
									</li>
								</ul>
							</div>
						</div>
					</div>
					<el-empty v-else-if="marketingCopyLoading" description="大模型生成中" />
					<el-empty
						v-else-if="selectedRows.length === 0"
						description="请先勾选 1 个商品，再生成营销文案"
					/>
					<el-empty v-else description="点击'生成营销文案'后展示商品卖点文案" />
				</el-card>
			</el-col>
			<el-col :xs="24" :lg="10">
				<el-card shadow="never" class="report-panel" v-loading="reportLoading">
					<template #header>报告与建议</template>
					<div class="report-side">
						<div class="report-side__block">
							<div class="report-side__label">当前报告类型</div>
							<div class="report-side__value">{{ reportTypeLabel }}</div>
						</div>
						<div class="report-side__block">
							<div class="report-side__label">本次纳入商品数</div>
							<div class="report-side__value">{{ reportItemCount }}</div>
						</div>
						<div class="report-side__block">
							<div class="report-side__label">模型状态</div>
							<div class="report-side__value">{{ llmStatusLabel }}</div>
						</div>
						<div class="report-side__block">
							<div class="report-side__label">运营建议</div>
							<div class="report-tags">
								<el-tag
									v-for="(item, index) in reportRecommendations"
									:key="`${item}-${index}`"
									size="small"
									effect="plain"
								>
									{{ item }}
								</el-tag>
								<span v-if="!reportRecommendations.length">生成报告后展示</span>
							</div>
						</div>
						<el-button
							type="primary"
							plain
							class="report-download-btn"
							:loading="reportPdfLoading"
							:disabled="!canGenerateReport"
							@click="handleDownloadReport"
						>
							下载 PDF 报告
						</el-button>
					</div>
				</el-card>
			</el-col>
		</el-row>
	</KPage>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from "vue"
import { defineRouteMeta, message, usePageModel } from "@kesplus/kesplus"
import {
	generateBusinessReportPdfByFastApi,
	generateMarketingCopyByAIApi,
	getBusinessReportEnhancementStatusByFastApi,
	getItemRecommendationCandidatesApi,
	resolveFastAPIUrl,
	startBusinessReportPreviewByFastApi,
} from "./utils/intelligent-recommendation-report-api"
import { buildReportPdfBlob } from "./utils/report-pdf-browser.js"
import {
	resolveReportDownloadUrl,
	startBrowserDownloadFromBlob,
	startBrowserDownloadFromUrl,
} from "./utils/report-download.js"
import {
	isSingleSelectionReady,
	normalizeSingleSelectedRows,
	resolveSingleSelectTarget,
} from "./utils/single-selection.js"
import {
	normalizeMarketingCopyResponsePayload,
	normalizeReportResponsePayload,
} from "./utils/report-response-normalizer.js"

defineRouteMeta({
	title: "智能推荐与报告",
})

const PAGE_SIZE = 10

const summary = reactive({
	matchedItemCount: 0,
	avgRecommendationScore: 0,
	highRecommendationCount: 0,
	reportReady: false,
	llmStatus: "idle",
	message: "",
})

const reportData = reactive({
	reportTitle: "",
	summary: "",
	analysisSections: [],
	recommendations: [],
	pdfDownloadUrl: "",
	riskAlerts: [],
	actionItems: [],
	pdfReady: false,
	pdfMode: "",
	pdfMessage: "",
})

const reportLoading = ref(false)
const reportPdfLoading = ref(false)
const reportRequestSnapshot = ref(null)
const reportEnhancementTaskId = ref("")
const reportEnhancementLoading = ref(false)
const marketingCopyLoading = ref(false)
const selectedRows = ref([])
const tableRef = ref(null)
const hasSearched = ref(false)
const marketingCopyData = reactive({
	summary: "",
	copies: [],
	llmStatus: "idle",
})
let syncingSingleSelection = false
let reportEnhancementTimer = null

const columns = [
	{
		label: "",
		type: "selection",
		align: "center",
		width: "48px",
		showOverflowTooltip: false,
	},
	{ label: "商品标题", prop: "title", align: "left", "min-width": "260px", slot: "title" },
	{ label: "类目", prop: "category", align: "center", "min-width": "140px" },
	{ label: "商家ID", prop: "sellerId", align: "center", "min-width": "110px" },
	{ label: "销量", prop: "payCnt", align: "center", "min-width": "100px" },
	{ label: "点击数", prop: "clickCnt", align: "center", "min-width": "100px" },
	{ label: "近7日点击", prop: "clickCnt7D", align: "center", "min-width": "110px" },
	{ label: "推荐度", prop: "recommendationScore", align: "center", "min-width": "110px" },
	{
		label: "推荐等级",
		prop: "recommendationLevel",
		align: "center",
		"min-width": "120px",
		slot: "recommendationLevel",
	},
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
		keyword: "",
		anchorDate: "",
		reportType: "business",
	},
	pageSize: PAGE_SIZE,
	fetch: async (_pager) => {
		try {
			const result = await getItemRecommendationCandidatesApi({
				keyword: queryForm.keyword || undefined,
				anchorDate: queryForm.anchorDate || undefined,
				pageIndex: _pager.currentPage,
				pageSize: _pager.pageSize,
				anchor_date: queryForm.anchorDate || undefined,
				page_index: _pager.currentPage,
				page_size: _pager.pageSize,
			})

			return normalizeRecommendationResult(result)
		} catch (error) {
			applySummary({
				matchedItemCount: 0,
				avgRecommendationScore: 0,
				highRecommendationCount: 0,
				llmStatus: "error",
				message: error?.message || "推荐结果加载失败，请稍后重试",
			})
			message(error?.message || "推荐结果加载失败，请稍后重试", { type: "error" })
			return {
				totalElements: 0,
				content: [],
			}
		}
	},
})

const tablePagination = computed(() => ({
	...pagination,
	pageSize: pagination.pageSize,
	pageSizes: [PAGE_SIZE],
	layout: "total, prev, pager, next, jumper",
}))

const reportSections = computed(() => normalizeArray(reportData.analysisSections))
const reportRecommendations = computed(() =>
	normalizeArray(reportData.recommendations)
		.map((item) => (typeof item === "string" ? item : item?.content || item?.text || item?.title || ""))
		.filter(Boolean),
)
const reportRiskAlerts = computed(() =>
	normalizeArray(reportData.riskAlerts)
		.map((item) => (typeof item === "string" ? item : item?.content || item?.text || item?.title || ""))
		.filter(Boolean),
)
const reportActionItems = computed(() =>
	normalizeArray(reportData.actionItems)
		.map((item, index) => {
			if (typeof item === "string") {
				return item
			}

			const title = item?.title || `行动项${index + 1}`
			const content = item?.content || item?.text || item?.summary || ""
			return content ? `${title}：${content}` : title
		})
		.filter(Boolean),
)
const marketingCopyItems = computed(() =>
	normalizeArray(marketingCopyData.copies).map((item) => ({
		itemId: item?.itemId ?? null,
		title: item?.title || "",
		headlineOptions: normalizeArray(item?.headlineOptions)
			.map((value) => (typeof value === "string" ? value : value?.content || value?.text || ""))
			.filter(Boolean),
		sellingPoints: normalizeArray(item?.sellingPoints)
			.map((value) => (typeof value === "string" ? value : value?.content || value?.text || ""))
			.filter(Boolean),
		shortPromotions: normalizeArray(item?.shortPromotions)
			.map((value) => (typeof value === "string" ? value : value?.content || value?.text || ""))
			.filter(Boolean),
	})),
)
const hasReportPreview = computed(() =>
	Boolean(
		reportData.summary ||
		reportSections.value.length ||
		reportRecommendations.value.length ||
		reportRiskAlerts.value.length ||
		reportActionItems.value.length,
	),
)
const isReportGenerating = computed(
	() => reportLoading.value || reportEnhancementLoading.value || summary.llmStatus === "pending",
)
const shouldShowReportContent = computed(() => !isReportGenerating.value && hasReportPreview.value)
const shouldShowMarketingCopyContent = computed(
	() =>
		!marketingCopyLoading.value &&
		Boolean(marketingCopyData.summary || marketingCopyItems.value.length),
)
const reportTypeLabel = computed(() => {
	const labelMap = {
		business: "经营分析",
		operation: "运营分析",
		selection: "选品分析",
	}
	return labelMap[queryForm.reportType] || "经营分析"
})
const reportGenerationStatusLabel = computed(() => {
	if (isReportGenerating.value) {
		return "大模型生成中"
	}

	if (!hasReportPreview.value) {
		return "待生成"
	}

	if (summary.llmStatus === "success") {
		return "大模型生成结果已生成"
	}

	return "基于大模型生成"
})
const llmStatusLabel = computed(() => {
	const labelMap = {
		idle: "待调用",
		pending: "大模型生成中",
		database: "查询未调用模型",
		empty: "无候选数据",
		success: "基于大模型生成",
		fallback: "基于大模型生成",
		error: "调用失败",
	}
	return labelMap[summary.llmStatus] || "未知状态"
})
const marketingCopyStatusLabel = computed(() => {
	const labelMap = {
		idle: "待生成",
		success: "基于大模型生成",
		fallback: "基于大模型生成",
		error: "生成失败",
	}
	return labelMap[marketingCopyData.llmStatus] || "待生成"
})
const reportStatusLabel = computed(() => (reportData.pdfDownloadUrl ? "已生成" : "待生成"))
const reportItemCount = computed(() => (hasSearched.value ? selectedRows.value.length : 0))
const canGenerateReport = computed(
	() => hasSearched.value && isSingleSelectionReady(selectedRows.value) && getReportItems().length > 0,
)
const canGenerateMarketingCopy = computed(
	() => hasSearched.value && isSingleSelectionReady(selectedRows.value),
)
const previewStatusLabel = computed(() => reportGenerationStatusLabel.value)

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

function normalizeObject(value) {
	if (Array.isArray(value)) {
		return value[0] || {}
	}

	if (typeof value === "string" && value) {
		try {
			const parsed = JSON.parse(value)
			return Array.isArray(parsed) ? parsed[0] || {} : parsed || {}
		} catch (error) {
			return {}
		}
	}

	return value || {}
}

function normalizeRecommendationResult(result) {
	if (typeof result === "string" && result) {
		try {
			return normalizeRecommendationResult(JSON.parse(result))
		} catch (error) {
			return {
				totalElements: 0,
				content: [],
			}
		}
	}

	const content = normalizeArray(result?.content)
	const summaryRow = normalizeObject(result?.summary)

	resetReport()
	resetMarketingCopy()

	applySummary({
		matchedItemCount: Number(summaryRow.matchedItemCount ?? result?.totalElements ?? 0),
		avgRecommendationScore: Number(summaryRow.avgRecommendationScore ?? 0),
		highRecommendationCount: Number(summaryRow.highRecommendationCount ?? 0),
		reportReady: Boolean(summaryRow.reportReady ?? false),
		llmStatus: summaryRow.llmStatus ?? (content.length ? "database" : "empty"),
		message: summaryRow.message ?? "当前查询基于数据库匹配、销量、点击与近周期特征排序",
	})

	applySelectedRows([])
	clearTableSelection()

	return {
		totalElements: Number(result?.totalElements ?? content.length ?? 0),
		content,
	}
}

function normalizeReportResponse(result) {
	const fallbackReport = buildReportDraft(getReportItems())
	const row = normalizeReportResponsePayload(result, fallbackReport)
	reportData.reportTitle = row.reportTitle || "AI 商业分析报告"
	reportData.summary = row.summary || ""
	reportData.analysisSections = normalizeArray(row.analysisSections)
	reportData.recommendations = normalizeArray(row.recommendations)
	reportData.riskAlerts = normalizeArray(row.riskAlerts)
	reportData.actionItems = normalizeArray(row.actionItems)
	reportData.pdfDownloadUrl = row.pdfDownloadUrl || ""
	reportData.pdfReady = Boolean(row.pdfReady || row.pdfDownloadUrl)
	reportData.pdfMode = row.pdfMode || ""
	reportData.pdfMessage = row.pdfMessage || ""
	summary.reportReady = Boolean(
		reportData.summary ||
		reportData.analysisSections.length ||
		reportData.recommendations.length ||
		reportData.riskAlerts.length ||
		reportData.actionItems.length,
	)
	summary.llmStatus = row.llmStatus || "success"
}

function applySummary(values = {}) {
	Object.assign(summary, {
		matchedItemCount: 0,
		avgRecommendationScore: 0,
		highRecommendationCount: 0,
		reportReady: false,
		llmStatus: "idle",
		message: "",
		...values,
	})
}

function formatScore(value) {
	const score = Number(value ?? 0)
	return Number.isFinite(score) ? score.toFixed(2) : "0.00"
}

function handleSelectionChange(rows) {
	if (syncingSingleSelection) {
		return
	}

	const normalizedRows = normalizeSingleSelectedRows(rows)
	const nextSelectedRow = normalizedRows[0] || null
	const currentSelectedRow = selectedRows.value[0] || null

	if ((Array.isArray(rows) ? rows.length : 0) !== normalizedRows.length) {
		syncSingleSelection(nextSelectedRow)
		return
	}

	if ((nextSelectedRow?.itemId ?? null) !== (currentSelectedRow?.itemId ?? null)) {
		applySelectedRows(normalizedRows)
	}
}

function handleSelect(selection, row) {
	syncSingleSelection(resolveSingleSelectTarget(selection, row))
}

function handleSelectAll(selection) {
	syncSingleSelection(normalizeSingleSelectedRows(selection)[0] || null)
}

function applySelectedRows(rows) {
	stopReportEnhancementPolling()
	selectedRows.value = rows
	resetReport()
	resetMarketingCopy()
}

function clearTableSelection() {
	const tableInstance = tableRef.value?.getTableRef?.()
	tableInstance?.clearSelection?.()
}

function syncSingleSelection(row) {
	const tableInstance = tableRef.value?.getTableRef?.()
	if (!tableInstance) {
		applySelectedRows(row ? [row] : [])
		return
	}

	syncingSingleSelection = true
	tableInstance.clearSelection()
	if (row) {
		tableInstance.toggleRowSelection(row, true)
	}
	applySelectedRows(row ? [row] : [])
	nextTick(() => {
		syncingSingleSelection = false
	})
}

function getRecommendationTagType(level) {
	const value = String(level ?? "")
	if (value.includes("高")) {
		return "danger"
	}
	if (value.includes("中")) {
		return "warning"
	}
	return "info"
}

function getReportItemIds() {
	return selectedRows.value
		.map((item) => Number(item?.itemId))
		.filter((item) => Number.isFinite(item))
}

function getReportItems() {
	return selectedRows.value
		.map((item) => ({
			itemId: Number(item?.itemId) || null,
			title: item?.title || "",
			category: item?.category || "",
			sellerId: item?.sellerId ?? "",
			clickCnt: Number(item?.clickCnt ?? 0),
			payCnt: Number(item?.payCnt ?? 0),
			clickCnt7D: Number(item?.clickCnt7D ?? 0),
			clickUv7D: Number(item?.clickUv7D ?? 0),
			payPerClick7D: Number(item?.payPerClick7D ?? 0),
			recommendationScore: Number(item?.recommendationScore ?? 0),
			recommendationLevel: item?.recommendationLevel || "",
			recommendationReason: item?.recommendationReason || "",
		}))
		.filter((item) => item.itemId)
}

function getMarketingCopyItems() {
	return selectedRows.value
		.map((item) => ({
			itemId: Number(item?.itemId) || null,
			title: item?.title || "",
			category: item?.category || "",
			sellerId: item?.sellerId ?? "",
			clickCnt: Number(item?.clickCnt ?? 0),
			payCnt: Number(item?.payCnt ?? 0),
			clickCnt7D: Number(item?.clickCnt7D ?? 0),
			clickUv7D: Number(item?.clickUv7D ?? 0),
			payPerClick7D: Number(item?.payPerClick7D ?? 0),
			recommendationScore: Number(item?.recommendationScore ?? 0),
			recommendationLevel: item?.recommendationLevel || "",
			recommendationReason: item?.recommendationReason || "",
		}))
		.filter((item) => item.itemId)
}

function buildReportDraft(items = []) {
	const primaryItem = items[0] || {}
	const recommendationScore = Number(primaryItem?.recommendationScore ?? 0).toFixed(2)
	const payPerClick = Number(primaryItem?.payPerClick7D ?? 0)
	const conversionRate = (payPerClick * 100).toFixed(2)
	const clickCnt = Number(primaryItem?.clickCnt ?? 0)
	const payCnt = Number(primaryItem?.payCnt ?? 0)
	const clickUv7D = Number(primaryItem?.clickUv7D ?? 0)
	const recommendationLevel = primaryItem?.recommendationLevel || "待评估"
	const recommendationReason =
		primaryItem?.recommendationReason || "当前可基于销量、点击与转化表现进行经营判断。"
	const conversionLabel =
		payPerClick >= 0.05 ? "表现较好" : payPerClick >= 0.02 ? "表现一般" : "表现偏低"
	const optimizationPriority =
		payPerClick < 0.02
			? "第一优先级：修复点击到支付的转化链路；第二优先级：优化主图与详情页卖点表达；第三优先级：持续跟踪近7日趋势变化。"
			: "第一优先级：保持当前推荐优势并放大卖点；第二优先级：监控流量质量与承接效率；第三优先级：持续优化高点击商品的转化稳定性。"

	return {
		reportTitle: `${primaryItem?.title || "目标商品"}AI商业分析报告`,
		summary: `当前分析对象为「${primaryItem?.title || "目标商品"}」，推荐等级为${recommendationLevel}（推荐分${recommendationScore}）。当前累计销量${payCnt}、点击${clickCnt}，近7日支付转化率${conversionRate}%，整体判断为${conversionLabel}，建议重点关注流量质量与转化承接。`,
		analysisSections: [
			{
				title: "商品概况",
				content: `当前分析对象为 1 个商品，商品标题为「${primaryItem?.title || "-"}」，商品ID 为 ${primaryItem?.itemId || "-"}，类目为 ${primaryItem?.category || "-"}，商家为 ${primaryItem?.sellerId || "-"}。`,
			},
			{
				title: "核心指标摘要",
				content: `从当前样本看，该商品推荐分为 ${recommendationScore}，累计销量 ${payCnt}，累计点击 ${clickCnt}，近7日点击UV 为 ${clickUv7D}，近7日支付转化率为 ${conversionRate}%。整体上属于${recommendationLevel}商品。`,
			},
			{
				title: "推荐逻辑分析",
				content: `当前推荐判断主要基于销量、点击、近7日行为和支付转化等特征综合形成。系统给出的推荐原因是：${recommendationReason}`,
			},
			{
				title: "转化问题诊断",
				content:
					payPerClick < 0.02
						? "当前点击已经形成一定曝光，但支付转化率偏低，说明用户已进入商品页但成交承接偏弱。建议优先检查主图、详情页、价格表达、评价与信任感信息。"
						: "当前支付转化率处于相对可接受水平，说明商品具备一定成交承接能力。后续应重点保持稳定性，并继续优化高点击流量的转化效率。",
			},
			{
				title: "运营优化建议",
				content: "建议优先围绕标题卖点、主图表达、详情页信息密度、用户信任建立和转化链路进行优化，同时持续跟踪近7日行为波动，判断优化动作是否真正提升支付效率。",
			},
			{
				title: "执行优先级",
				content: optimizationPriority,
			},
		],
		recommendations: [
			"优先检查点击高但支付偏低的商品，聚焦主图、详情页、价格和评价体系。",
			"结合推荐原因持续优化商品标题与核心卖点表达。",
			"对高推荐商品优先安排流量承接与转化提升动作。",
			"持续跟踪近7日点击UV与支付转化率变化，验证优化是否生效。",
		],
	}
}

function buildMarketingCopyDraft(items = []) {
	return {
		copies: items.map((item) => ({
			itemId: item.itemId,
			title: item.title,
			headlineOptions: [
				`${item.title} 热门推荐`,
				`${item.recommendationLevel || "重点关注"}商品：${item.title}`,
			],
			sellingPoints: [
				item.recommendationReason || "结合当前推荐结果提炼卖点表达。",
				`累计支付${item.payCnt}次，近7日支付转化率${(Number(item.payPerClick7D ?? 0) * 100).toFixed(2)}%。`,
			],
			shortPromotions: [
				`${item.title} 当前表现${item.recommendationLevel || "稳定"}，适合重点展示。`,
				`结合点击与支付表现，建议优先突出核心卖点与转化承诺。`,
			],
		})),
	}
}

function buildCompactReportDraft(items = []) {
	const draft = buildReportDraft(items)
	return {
		reportTitle: draft.reportTitle || "",
		summary: draft.summary || "",
		recommendations: normalizeArray(draft.recommendations).slice(0, 3),
	}
}

function buildCompactMarketingCopyDraft(items = []) {
	const draft = buildMarketingCopyDraft(items)
	return {
		summary: draft.summary || "",
		copies: normalizeArray(draft.copies).map((item) => ({
			itemId: item?.itemId ?? null,
			title: item?.title || "",
			headlineOptions: normalizeArray(item?.headlineOptions).slice(0, 2),
			shortPromotions: normalizeArray(item?.shortPromotions).slice(0, 2),
		})),
	}
}

function buildReportRequestPayload() {
	const itemIds = getReportItemIds()
	const items = getReportItems()

	return {
		keyword: queryForm.keyword || "",
		anchorDate: queryForm.anchorDate || undefined,
		reportType: queryForm.reportType || "business",
		itemIds,
		items,
		reportDraft: buildCompactReportDraft(items),
	}
}

function resetReport() {
	stopReportEnhancementPolling()
	reportData.reportTitle = ""
	reportData.summary = ""
	reportData.analysisSections = []
	reportData.recommendations = []
	reportData.riskAlerts = []
	reportData.actionItems = []
	reportData.pdfDownloadUrl = ""
	reportData.pdfReady = false
	reportData.pdfMode = ""
	reportData.pdfMessage = ""
	reportRequestSnapshot.value = null
	reportEnhancementTaskId.value = ""
	summary.reportReady = false
}

function stopReportEnhancementPolling() {
	reportEnhancementLoading.value = false
	if (reportEnhancementTimer) {
		clearTimeout(reportEnhancementTimer)
		reportEnhancementTimer = null
	}
}

function scheduleReportEnhancementPolling(taskId, delay = 2000) {
	if (!taskId) {
		return
	}

	reportEnhancementLoading.value = true
	reportEnhancementTimer = setTimeout(() => {
		void pollReportEnhancement(taskId)
	}, delay)
}

async function pollReportEnhancement(taskId) {
	if (!taskId || reportEnhancementTaskId.value !== taskId) {
		return
	}

	try {
		const result = await getBusinessReportEnhancementStatusByFastApi(taskId)
		if (reportEnhancementTaskId.value !== taskId) {
			return
		}

		const enhancementStatus = result?.enhancementStatus || "pending"
		if (enhancementStatus === "pending") {
			scheduleReportEnhancementPolling(taskId)
			return
		}

		stopReportEnhancementPolling()

		if (enhancementStatus === "completed") {
			normalizeReportResponse(result)
			if (result?.llmStatus === "success") {
				message("大模型生成结果已更新", { type: "success" })
				return
			}

			message(result?.message || "AI 分析结果暂未完整返回，当前已展示分析内容", { type: "warning" })
			return
		}

		if (enhancementStatus === "failed") {
			normalizeReportResponse(result)
			message(result?.message || "AI 分析结果暂未完整返回，当前已展示分析内容", { type: "warning" })
		}
	} catch (error) {
		if (reportEnhancementTaskId.value !== taskId) {
			return
		}

		stopReportEnhancementPolling()
		message(error?.message || "报告生成状态获取失败，当前保留规则报告", { type: "warning" })
	}
}

function resetMarketingCopy() {
	marketingCopyData.summary = ""
	marketingCopyData.copies = []
	marketingCopyData.llmStatus = "idle"
}

function normalizeMarketingCopyResponse(result) {
	const fallbackDraft = buildMarketingCopyDraft(getMarketingCopyItems())
	const row = normalizeMarketingCopyResponsePayload(result, fallbackDraft)
	marketingCopyData.summary = row.summary || ""
	marketingCopyData.copies = normalizeArray(row.copies)
	marketingCopyData.llmStatus =
		row.llmStatus || (marketingCopyData.copies.length ? "success" : "error")
}

function handleSearch() {
	queryForm.keyword = String(queryForm.keyword ?? "").trim()
	hasSearched.value = true
	resetReport()
	resetMarketingCopy()
	resetPage({ pageSize: PAGE_SIZE })
}

function handleReset() {
	Object.assign(queryForm, {
		keyword: "",
		anchorDate: "",
		reportType: "business",
	})
	hasSearched.value = false
	applySelectedRows([])
	clearTableSelection()
	applySummary()
	resetPage({ pageSize: PAGE_SIZE })
}

async function handleGenerateReport() {
	const payload = buildReportRequestPayload()

	if (!payload.itemIds.length || !payload.items.length) {
		message("请先勾选 1 个商品后再生成商业分析报告", { type: "warning" })
		return
	}

	reportLoading.value = true
	try {
		resetReport()
		summary.llmStatus = "pending"
		reportRequestSnapshot.value = payload
		const result = await startBusinessReportPreviewByFastApi(payload)
		reportEnhancementTaskId.value = result?.enhancementTaskId || ""
		if (result?.enhancementStatus === "pending" && reportEnhancementTaskId.value) {
			scheduleReportEnhancementPolling(reportEnhancementTaskId.value)
			message("大模型生成中", { type: "success" })
			return
		}

		normalizeReportResponse(result)
		message("商业分析报告生成成功", { type: "success" })
	} catch (error) {
		summary.llmStatus = "error"
		resetReport()
		message(error?.message || "商业分析报告生成失败，请稍后重试", { type: "error" })
	} finally {
		reportLoading.value = false
	}
}

function buildMarketingCopyPlainText(item) {
	const headlineText = normalizeArray(item?.headlineOptions)
		.map((value) => `- ${value}`)
		.join("\n")
	const sellingPointText = normalizeArray(item?.sellingPoints)
		.map((value) => `- ${value}`)
		.join("\n")
	const promotionText = normalizeArray(item?.shortPromotions)
		.map((value) => `- ${value}`)
		.join("\n")

	return [
		`商品：${item?.title || "-"}`,
		`商品ID：${item?.itemId || "-"}`,
		"",
		"标题优化建议：",
		headlineText || "-",
		"",
		"核心卖点摘要：",
		sellingPointText || "-",
		"",
		"短推广文案：",
		promotionText || "-",
	]
		.filter(Boolean)
		.join("\n")
}

async function handleCopyMarketingItem(item) {
	const text = buildMarketingCopyPlainText(item)
	if (!text) {
		message("当前没有可复制的营销文案", { type: "warning" })
		return
	}

	try {
		if (navigator?.clipboard?.writeText) {
			await navigator.clipboard.writeText(text)
			message("营销文案已复制", { type: "success" })
			return
		}
		throw new Error("clipboard unavailable")
	} catch (error) {
		const textArea = document.createElement("textarea")
		textArea.value = text
		document.body.appendChild(textArea)
		textArea.select()
		document.execCommand("copy")
		document.body.removeChild(textArea)
		message("营销文案已复制", { type: "success" })
	}
}

async function handleGenerateMarketingCopy() {
	if (!selectedRows.value.length) {
		message("请先勾选 1 个商品后再生成营销文案", { type: "warning" })
		return
	}

	const items = getMarketingCopyItems()
	if (!items.length) {
		message("当前勾选商品缺少有效数据，无法生成营销文案", { type: "warning" })
		return
	}

	marketingCopyLoading.value = true
	try {
		resetMarketingCopy()
		const result = await generateMarketingCopyByAIApi({
			keyword: queryForm.keyword || "",
			anchorDate: queryForm.anchorDate || undefined,
			anchor_date: queryForm.anchorDate || undefined,
			items,
			copyDraft: buildCompactMarketingCopyDraft(items),
		})
		normalizeMarketingCopyResponse(result)
		message("营销文案生成成功", { type: "success" })
	} catch (error) {
		resetMarketingCopy()
		marketingCopyData.llmStatus = "error"
		message(error?.message || "营销文案生成失败，请稍后重试", { type: "error" })
	} finally {
		marketingCopyLoading.value = false
	}
}

async function handleDownloadReport() {
	const payload = {
		...(reportRequestSnapshot.value || buildReportRequestPayload()),
		enhancementTaskId: reportEnhancementTaskId.value || undefined,
	}

	if (!payload.itemIds?.length || !payload.items?.length) {
		message("当前没有可下载的 PDF 报告", { type: "warning" })
		return
	}

	reportPdfLoading.value = true
	try {
		reportRequestSnapshot.value = payload
		const result = await generateBusinessReportPdfByFastApi(payload)
		const fallbackReport = buildReportDraft(getReportItems())
		const row = normalizeReportResponsePayload(result, fallbackReport)
		normalizeReportResponse(result)

		if ((row.pdfMode || reportData.pdfMode) === "browser" || !(row.pdfDownloadUrl || reportData.pdfDownloadUrl)) {
			const pdfBlob = buildReportPdfBlob({
				reportTitle: row.reportTitle || reportData.reportTitle,
				summary: row.summary || reportData.summary,
				analysisSections: normalizeArray(row.analysisSections?.length ? row.analysisSections : reportData.analysisSections),
				recommendations: normalizeArray(row.recommendations?.length ? row.recommendations : reportData.recommendations),
				riskAlerts: normalizeArray(row.riskAlerts?.length ? row.riskAlerts : reportData.riskAlerts),
				actionItems: normalizeArray(row.actionItems?.length ? row.actionItems : reportData.actionItems),
			})
			startBrowserDownloadFromBlob(pdfBlob, "emdmp-ai-report.pdf")
			message(row.pdfMessage || "PDF 报告已生成并开始下载", { type: "success" })
			return
		}

		const downloadUrl = resolveReportDownloadUrl(row.pdfDownloadUrl || reportData.pdfDownloadUrl, resolveFastAPIUrl)
		await startBrowserDownloadFromUrl(downloadUrl)
		message("PDF 报告已开始下载", { type: "success" })
	} catch (error) {
		if (!hasReportPreview.value) {
			summary.llmStatus = "error"
		}
		message(error?.message || "PDF 报告生成失败，请稍后重试", { type: "error" })
	} finally {
		reportPdfLoading.value = false
	}
}

onMounted(() => {
	fetchData()
})

onBeforeUnmount(() => {
	stopReportEnhancementPolling()
})
</script>

<style scoped lang="scss">
.ai-report-page {
	display: flex;
	flex-direction: column;
	gap: 0;
}

.ai-hero {
	margin-bottom: 16px;
	background:
		linear-gradient(140deg, rgba(255, 255, 255, 0.95), rgba(243, 247, 255, 0.9) 52%, rgba(255, 248, 242, 0.92)),
		radial-gradient(circle at top left, rgba(201, 21, 30, 0.16), transparent 28%);
}

.summary-panel,
.ai-query-card,
.ai-table-panel,
.report-panel {
	border: 1px solid rgba(148, 163, 184, 0.16);
	box-shadow: 0 24px 52px rgba(15, 23, 42, 0.08);
}

.ai-table-panel--placeholder :deep(.el-card__body) {
	padding: 28px 20px;
}

.summary-card {
	display: flex;
	flex-direction: column;
	gap: 10px;
	min-height: 136px;
	padding: 6px 2px;
}

.summary-label {
	font-size: 12px;
	font-weight: 700;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: #6b7b92;
}

.summary-value {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: clamp(36px, 2.2vw, 52px);
	font-weight: 700;
	line-height: 1.1;
	color: #0f172a;
}

.summary-value--status {
	font-size: 24px;
}

.summary-meta {
	font-size: 13px;
	line-height: 1.7;
	color: #94a3b8;
}

.card-header-with-status {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
}

.table-toolbar-text {
	font-size: 13px;
	color: #64748b;
}

.title-cell {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.title-cell__main {
	font-weight: 600;
	color: #0f172a;
	white-space: normal;
	word-break: break-word;
}

.title-cell__sub {
	font-size: 12px;
	color: #94a3b8;
}

.report-content {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.report-title {
	font-family: "Georgia", "Times New Roman", serif;
	font-size: 28px;
	font-weight: 700;
	color: #0f172a;
}

.report-summary {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

.report-sections {
	display: flex;
	flex-direction: column;
	gap: 14px;
}

.report-sections section {
	padding: 16px 18px;
	border-radius: 18px;
	background:
		linear-gradient(180deg, rgba(248, 250, 252, 0.96), rgba(255, 255, 255, 0.92));
	border: 1px solid rgba(148, 163, 184, 0.14);
}

.report-sections h4 {
	margin-bottom: 8px;
	font-size: 15px;
	font-weight: 700;
	color: #0f172a;
}

.report-sections p {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

.report-side {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.report-side__block {
	padding: 16px 18px;
	border-radius: 18px;
	background:
		linear-gradient(180deg, rgba(248, 250, 252, 0.96), rgba(255, 255, 255, 0.92));
	border: 1px solid rgba(148, 163, 184, 0.14);
}

.report-side__label {
	font-size: 13px;
	color: #64748b;
	margin-bottom: 8px;
}

.report-side__value {
	font-size: 18px;
	font-weight: 700;
	color: #0f172a;
}

.report-tags {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.report-download-btn {
	align-self: flex-start;
}

.marketing-copy-panel__header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 12px;
}

.marketing-copy-panel__header-right {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	justify-content: flex-end;
	gap: 12px;
}

.marketing-copy-panel__meta {
	font-size: 12px;
	color: #94a3b8;
}

.llm-generating-indicator {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	font-size: 13px;
	font-weight: 600;
	color: #2563eb;
	white-space: nowrap;
}

.llm-generating-indicator__dot {
	width: 10px;
	height: 10px;
	border-radius: 999px;
	background: #3b82f6;
	box-shadow: 0 0 0 6px rgba(59, 130, 246, 0.12);
	animation: llm-generating-pulse 1.6s ease-in-out infinite;
}

@keyframes llm-generating-pulse {
	0%,
	100% {
		transform: scale(0.95);
		opacity: 0.85;
	}

	50% {
		transform: scale(1.08);
		opacity: 1;
	}
}

.marketing-copy-content {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.marketing-copy-summary {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

.marketing-copy-status {
	font-size: 13px;
	color: #64748b;
}

.marketing-copy-card {
	display: flex;
	flex-direction: column;
	gap: 14px;
	padding: 18px;
	border-radius: 20px;
	border: 1px solid rgba(148, 163, 184, 0.14);
	background:
		radial-gradient(circle at top, rgba(245, 158, 11, 0.1), transparent 42%),
		linear-gradient(180deg, rgba(255, 251, 235, 0.94) 0%, rgba(255, 247, 237, 0.94) 100%);
}

.marketing-copy-card__top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
}

.marketing-copy-card__title {
	font-size: 16px;
	font-weight: 700;
	color: #0f172a;
}

.marketing-copy-card__sub {
	margin-top: 6px;
	font-size: 12px;
	color: #94a3b8;
}

.marketing-copy-section {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.marketing-copy-section__label {
	font-size: 13px;
	font-weight: 700;
	color: #7c2d12;
}

.marketing-copy-section ul {
	padding-left: 18px;
}

.marketing-copy-section li {
	font-size: 14px;
	line-height: 1.8;
	color: #475569;
}

@media (max-width: 1200px) {
	.summary-card {
		min-height: auto;
	}
}

@media (max-width: 768px) {
	.marketing-copy-card__top,
	.marketing-copy-panel__header {
		flex-direction: column;
		align-items: flex-start;
	}
}
</style>
