<template>
	<KDialogForm>
		<el-form
			ref="formRef"
			:model="form"
			labelPosition="right"
			label-width="198"
		>
			<KPage min-height="100" :no-padding="true">
				<KSection>
					<RecTmallSalesForecastFeatureComponent :span="12">
					</RecTmallSalesForecastFeatureComponent>
				</KSection>
			</KPage>
		</el-form>
	</KDialogForm>
</template>
<script setup>
import { ref, toRef } from "vue"
import { useDialogForm, message, useDialogContext } from "@kesplus/kesplus"
import {
	addApi,
	updateApi,
	detailApi,
} from "./utils/rec-tmall-sales-forecast-feature-api"
import RecTmallSalesForecastFeatureComponent from "./components/rec-tmall-sales-forecast-feature.vue"
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
			anchorDate: "",
			category: "",
			brandId: "",
			sellerId: "",
			clickCnt1D: "",
			clickUv1D: "",
			clickAvg1D: "",
			clickIsZero1D: "",
			clickCnt3D: "",
			clickUv3D: "",
			clickAvg3D: "",
			clickIsZero3D: "",
			clickCnt7D: "",
			clickUv7D: "",
			clickAvg7D: "",
			clickIsZero7D: "",
			clickCnt14D: "",
			clickUv14D: "",
			clickAvg14D: "",
			clickIsZero14D: "",
			clickCnt30D: "",
			clickUv30D: "",
			clickAvg30D: "",
			clickIsZero30D: "",
			collectCnt1D: "",
			collectUv1D: "",
			collectAvg1D: "",
			collectIsZero1D: "",
			collectCnt3D: "",
			collectUv3D: "",
			collectAvg3D: "",
			collectIsZero3D: "",
			collectCnt7D: "",
			collectUv7D: "",
			collectAvg7D: "",
			collectIsZero7D: "",
			collectCnt14D: "",
			collectUv14D: "",
			collectAvg14D: "",
			collectIsZero14D: "",
			collectCnt30D: "",
			collectUv30D: "",
			collectAvg30D: "",
			collectIsZero30D: "",
			cartCnt1D: "",
			cartUv1D: "",
			cartAvg1D: "",
			cartIsZero1D: "",
			cartCnt3D: "",
			cartUv3D: "",
			cartAvg3D: "",
			cartIsZero3D: "",
			cartCnt7D: "",
			cartUv7D: "",
			cartAvg7D: "",
			cartIsZero7D: "",
			cartCnt14D: "",
			cartUv14D: "",
			cartAvg14D: "",
			cartIsZero14D: "",
			cartCnt30D: "",
			cartUv30D: "",
			cartAvg30D: "",
			cartIsZero30D: "",
			payCnt1D: "",
			payUv1D: "",
			payAvg1D: "",
			payIsZero1D: "",
			payCnt3D: "",
			payUv3D: "",
			payAvg3D: "",
			payIsZero3D: "",
			payCnt7D: "",
			payUv7D: "",
			payAvg7D: "",
			payIsZero7D: "",
			payCnt14D: "",
			payUv14D: "",
			payAvg14D: "",
			payIsZero14D: "",
			payCnt30D: "",
			payUv30D: "",
			payAvg30D: "",
			payIsZero30D: "",
			clickCntPrev7D: "",
			payCntPrev7D: "",
			cartCntPrev7D: "",
			clickCntPrev14D: "",
			payCntPrev14D: "",
			payPerClick7D: "",
			cartPerClick7D: "",
			collectPerClick7D: "",
			payUvPerClickUv7D: "",
			payRatio3DTo7D: "",
			payRatio7DTo14D: "",
			clickCntDelta7D: "",
			payCntDelta7D: "",
			cartCntDelta7D: "",
			payCntDelta14D: "",
			clickCntDelta14D: "",
			payMean7D: "",
			payMean14D: "",
			payMean30D: "",
			payStd7D: "",
			payStd14D: "",
			payStd30D: "",
			payMax7D: "",
			payMax14D: "",
			payMax30D: "",
			clickMean7D: "",
			clickMean14D: "",
			clickMean30D: "",
			clickStd7D: "",
			clickStd14D: "",
			clickStd30D: "",
			payActiveDays30D: "",
			activeDays30D: "",
			daysSinceLastClick: "",
			daysSinceLastPay: "",
			cumulativeActiveDays: "",
			cumulativePayDays: "",
			itemAgeDays: "",
			dayOfWeek: "",
			isWeekend: "",
			dayOfMonth: "",
			month: "",
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
	--page-block-corner: 2px;
}
:deep(.k-design-page-main > .kingbase-design-form-grid) {
	row-gap: 8px !important;
}
:deep(.k-design-text-h6) {
	font-weight: 600;
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
