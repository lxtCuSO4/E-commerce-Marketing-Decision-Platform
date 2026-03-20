<template>
	<KBlock :bordered="true">
		<KFormGrid :maxColumns="2" :columnGap="32" :strictAutoFit="true">
			<el-form-item
				label="商品ID"
				prop="itemId"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.itemId"> </el-input>
			</el-form-item>
			<el-form-item
				label="锚定日期"
				prop="anchorDate"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-date-picker :clearable="true" v-model="form.anchorDate" type="date">
				</el-date-picker>
			</el-form-item>
			<el-form-item
				label="商品类目"
				prop="category"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.category"> </el-input>
			</el-form-item>
			<el-form-item
				label="品牌ID"
				prop="brandId"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.brandId"> </el-input>
			</el-form-item>
			<el-form-item
				label="商家ID"
				prop="sellerId"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.sellerId"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天支付量"
				prop="payCnt7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天支付量"
				prop="payCnt30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt30D">
				</el-input-number>
			</el-form-item>
		</KFormGrid>
	</KBlock>
</template>
<script setup>
import { ref, toRef, watchEffect } from "vue"
import {
	useDialogFormContext,
	required,
	email as mail,
	phone as phoneNumber,
	lengthValidate,
} from "@kesplus/kesplus"
defineOptions({
	typeMark: "Block",
})
const props = defineProps({
	id: { type: String },
})
const { form, submit, reset, fetchById } = useDialogFormContext()
form.recSalesForecastPredictions ||= {}
</script>
