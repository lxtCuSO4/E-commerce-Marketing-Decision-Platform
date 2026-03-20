<template>
	<KBlock :bordered="true">
		<KFormGrid :maxColumns="2" :columnGap="32" :strictAutoFit="true">
			<el-form-item
				label="源商品ID"
				prop="sourceItemId"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.sourceItemId"> </el-input>
			</el-form-item>
			<el-form-item
				label="相似商品ID"
				prop="similarItemId"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.similarItemId"> </el-input>
			</el-form-item>
			<el-form-item
				label="相似度分数"
				prop="similarityScore"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.similarityScore">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="排名序号"
				prop="rankNo"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.rankNo">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="商品类目"
				prop="category"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.category"> </el-input>
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
form.recTmallItemSimilarity ||= {}
</script>
