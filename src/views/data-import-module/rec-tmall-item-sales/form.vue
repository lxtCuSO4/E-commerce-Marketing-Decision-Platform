<template>
	<div class="emdmp-form-shell">
		<KDialogForm class="emdmp-form-dialog">
			<el-form
				ref="formRef"
				:model="form"
				labelPosition="right"
				label-width="120"
			>
				<KPage class="emdmp-form-page" min-height="100" :no-padding="true">
					<KSection>
						<RecTmallItemSalesComponent :span="12"> </RecTmallItemSalesComponent>
					</KSection>
				</KPage>
			</el-form>
		</KDialogForm>
	</div>
</template>
<script setup>
import { ref, toRef } from "vue"
import { useDialogForm, message, useDialogContext } from "@kesplus/kesplus"
import { addApi, updateApi, detailApi } from "./utils/rec-tmall-item-sales-api"
import RecTmallItemSalesComponent from "./components/rec-tmall-item-sales.vue"
defineOptions({
	inheritAttrs: false,
})
const props = defineProps({
	id: { type: String },
	readPretty: { type: Boolean },
	row: { type: Object, default: () => ({}) },
})

const formRef = ref()
const { form, reset, submit, closeDialog } = useDialogForm({
	id: toRef(props, "id"),
	formRef,
	default: Object.assign(
		{
			itemId: "",
			clickCnt: "",
			collectCnt: "",
			cartCnt: "",
			payCnt: "",
			lastActionTime: "",
		},
		{ ...props.row },
	),
	fetchById: async (id) => {
		return await detailApi({ id })
	},
	save: async (model) => {
		const res = model.id ? await updateApi(model) : await addApi(model)
		Object.assign(form, res)
		message(model.id ? "更新成功" : "新增成功", { type: "success" })
		await closeDialog()

		return res
	},
})
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
