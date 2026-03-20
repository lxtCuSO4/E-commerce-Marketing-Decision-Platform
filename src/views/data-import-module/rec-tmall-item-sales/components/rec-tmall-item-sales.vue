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
				label="点击量"
				prop="clickCnt"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="收藏量"
				prop="collectCnt"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="加购量"
				prop="cartCnt"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="支付量"
				prop="payCnt"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="最后行为时间"
				prop="lastActionTime"
				data-grid-span="1"
			>
				<el-input :clearable="true" v-model="form.lastActionTime"> </el-input>
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
form.recTmallItemSales ||= {}
</script>
