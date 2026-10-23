<template>
	<KPage class="sales-forecast-route-redirect">
		<el-result
			icon="info"
			title="页面已迁移"
			sub-title="正在跳转到“天猫销售预测信息”页面"
		>
			<template #extra>
				<el-button type="primary" @click="redirectToFeaturePage">
					立即前往
				</el-button>
			</template>
		</el-result>
	</KPage>
</template>

<script setup>
import { onBeforeMount } from "vue"
import { defineRouteMeta } from "@kesplus/kesplus"
import { useRouter } from "@@/core/coreExports"

defineRouteMeta({
	title: "销售预测结果",
})

const router = useRouter()

function redirectToFeaturePage() {
	router.replace("/sales-predict-module/rec-tmall-sales-forecast-feature")
}

onBeforeMount(() => {
	redirectToFeaturePage()
})
</script>

<style scoped lang="scss">
.sales-forecast-route-redirect {
	display: flex;
	align-items: center;
	justify-content: center;
	min-height: 320px;
}
</style>
