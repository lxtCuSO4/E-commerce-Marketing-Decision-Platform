<template>
	<div
		:class="[
			'emdmp-form-shell',
			{ 'emdmp-form-shell--page': isPageMode },
		]"
	>
		<KDialogForm
			:class="[
				'emdmp-form-dialog',
				{ 'emdmp-form-dialog--page': isPageMode },
			]"
		>
			<el-form
				ref="formRef"
				:model="form"
				labelPosition="right"
				label-width="102"
			>
				<KPage
					:class="[
						'emdmp-form-page',
						{ 'emdmp-form-page--page': isPageMode },
					]"
					min-height="100"
					:no-padding="true"
				>
					<KSection>
						<RecTmallItemBaseComponent :span="12" />
					</KSection>
				</KPage>
			</el-form>
		</KDialogForm>
		<div v-if="isPageMode" class="emdmp-form-footer">
			<el-button @click="handleBack">返回</el-button>
			<el-button type="info" @click="reset">重置</el-button>
			<el-button type="primary" :loading="loading" @click="() => submit()"
				>保存</el-button
			>
		</div>
	</div>
</template>
<script setup>
import { computed, ref } from "vue"
import { useDialogForm, message, useDialogContext } from "@kesplus/kesplus"
import { useRoute, useRouter } from "@@/core/coreExports"
import { addApi, updateApi, detailApi } from "./utils/rec-tmall-item-base-api"
import RecTmallItemBaseComponent from "./components/rec-tmall-item-base.vue"

defineOptions({
	inheritAttrs: false,
})

const props = defineProps({
	id: { type: String },
	readPretty: { type: Boolean },
	row: { type: Object, default: () => ({}) },
})

const route = useRoute()
const router = useRouter()
const dialogContext = useDialogContext()
const isPageMode = computed(
	() => route.path === "/data-import-module/rec-tmall-item-base/form",
)
const currentId = computed(() => props.id || route.query?.id || "")

const formRef = ref()
const { form, reset, submit, closeDialog, loading } = useDialogForm({
	id: currentId,
	formRef,
	default: Object.assign(
		{
			itemId: "",
			title: "",
			titleClean: "",
			titleTokens: "",
			pictUrl: "",
			category: "",
			brandId: "",
			sellerId: "",
		},
		{ ...props.row },
	),
	fetchById: async (id) => {
		return await detailApi({ id })
	},
	save: async (model) => {
		const res = model.id ? await updateApi(model) : await addApi(model)
		Object.assign(form, res)
		message(model.id ? "鏇存柊鎴愬姛" : "鏂板鎴愬姛", { type: "success" })
		if (isPageMode.value) {
			await router.push("/data-import-module/rec-tmall-item-base")
		} else {
			await closeDialog()
		}
		return res
	},
})

function handleBack() {
	if (dialogContext?.mode) {
		closeDialog()
		return
	}
	router.push("/data-import-module/rec-tmall-item-base")
}

defineExpose({ submit, reset, closeDialog })
</script>
<style lang="scss" scoped>
:deep(.k-design-block) {
	--page-block-corner: var(--emdmp-panel-radius);
}
:deep(.k-design-page-main > .kingbase-design-form-grid) {
	row-gap: 16px !important;
}
:deep(.k-design-text-h6) {
	font-weight: 700;
}
/**
:deep(.el-form-item__label) {
display: inline-block;
text-align: justify;
text-align-last: justify;
}
:deep(.el-form-item.is-required .el-form-item__label::after) {
position: absolute;
}*/
</style>
