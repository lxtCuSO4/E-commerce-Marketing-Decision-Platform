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
			<el-form-item label="商品标题" prop="title" data-grid-span="1">
				<KRtf
					:clearable="true"
					:modelValue="form.title ?? ''"
					@update:modelValue="(val) => (form.title = val)"
				>
				</KRtf>
			</el-form-item>
			<el-form-item label="清洗后标题" prop="titleClean" data-grid-span="1">
				<KRtf
					:clearable="true"
					:modelValue="form.titleClean ?? ''"
					@update:modelValue="(val) => (form.titleClean = val)"
				>
				</KRtf>
			</el-form-item>
			<el-form-item label="标题分词" prop="titleTokens" data-grid-span="1">
				<KRtf
					:clearable="true"
					:modelValue="form.titleTokens ?? ''"
					@update:modelValue="(val) => (form.titleTokens = val)"
				>
				</KRtf>
			</el-form-item>
			<el-form-item label="图片URL" prop="pictUrl" data-grid-span="1">
				<KRtf
					:clearable="true"
					:modelValue="form.pictUrl ?? ''"
					@update:modelValue="(val) => (form.pictUrl = val)"
				>
				</KRtf>
			</el-form-item>
			<el-form-item label="商品类目" prop="category" data-grid-span="1">
				<el-input :clearable="true" v-model="form.category"> </el-input>
			</el-form-item>
			<el-form-item label="品牌ID" prop="brandId" data-grid-span="1">
				<el-input :clearable="true" v-model="form.brandId"> </el-input>
			</el-form-item>
			<el-form-item label="商家ID" prop="sellerId" data-grid-span="1">
				<el-input :clearable="true" v-model="form.sellerId"> </el-input>
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
form.recTmallItemBase ||= {}
</script>
