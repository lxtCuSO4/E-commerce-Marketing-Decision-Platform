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
				label="1天点击量"
				prop="clickCnt1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天点击用户数"
				prop="clickUv1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickUv1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天人均点击量"
				prop="clickAvg1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickAvg1D"> </el-input>
			</el-form-item>
			<el-form-item
				label="1天点击是否为零"
				prop="clickIsZero1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickIsZero1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天点击量"
				prop="clickCnt3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天点击用户数"
				prop="clickUv3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickUv3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天人均点击量"
				prop="clickAvg3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickAvg3D"> </el-input>
			</el-form-item>
			<el-form-item
				label="3天点击是否为零"
				prop="clickIsZero3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickIsZero3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天点击量"
				prop="clickCnt7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天点击用户数"
				prop="clickUv7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickUv7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天人均点击量"
				prop="clickAvg7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickAvg7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天点击是否为零"
				prop="clickIsZero7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickIsZero7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天点击量"
				prop="clickCnt14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天点击用户数"
				prop="clickUv14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickUv14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天人均点击量"
				prop="clickAvg14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickAvg14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天点击是否为零"
				prop="clickIsZero14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickIsZero14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天点击量"
				prop="clickCnt30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCnt30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天点击用户数"
				prop="clickUv30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickUv30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天人均点击量"
				prop="clickAvg30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickAvg30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天点击是否为零"
				prop="clickIsZero30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickIsZero30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天收藏量"
				prop="collectCnt1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天收藏用户数"
				prop="collectUv1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectUv1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天人均收藏量"
				prop="collectAvg1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectAvg1D"> </el-input>
			</el-form-item>
			<el-form-item
				label="1天收藏是否为零"
				prop="collectIsZero1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectIsZero1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天收藏量"
				prop="collectCnt3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天收藏用户数"
				prop="collectUv3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectUv3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天人均收藏量"
				prop="collectAvg3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectAvg3D"> </el-input>
			</el-form-item>
			<el-form-item
				label="3天收藏是否为零"
				prop="collectIsZero3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectIsZero3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天收藏量"
				prop="collectCnt7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天收藏用户数"
				prop="collectUv7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectUv7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天人均收藏量"
				prop="collectAvg7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectAvg7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天收藏是否为零"
				prop="collectIsZero7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectIsZero7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天收藏量"
				prop="collectCnt14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天收藏用户数"
				prop="collectUv14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectUv14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天人均收藏量"
				prop="collectAvg14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectAvg14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天收藏是否为零"
				prop="collectIsZero14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectIsZero14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天收藏量"
				prop="collectCnt30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectCnt30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天收藏用户数"
				prop="collectUv30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectUv30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天人均收藏量"
				prop="collectAvg30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectAvg30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天收藏是否为零"
				prop="collectIsZero30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.collectIsZero30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天加购量"
				prop="cartCnt1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天加购用户数"
				prop="cartUv1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartUv1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天人均加购量"
				prop="cartAvg1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartAvg1D"> </el-input>
			</el-form-item>
			<el-form-item
				label="1天加购是否为零"
				prop="cartIsZero1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartIsZero1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天加购量"
				prop="cartCnt3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天加购用户数"
				prop="cartUv3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartUv3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天人均加购量"
				prop="cartAvg3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartAvg3D"> </el-input>
			</el-form-item>
			<el-form-item
				label="3天加购是否为零"
				prop="cartIsZero3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartIsZero3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天加购量"
				prop="cartCnt7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天加购用户数"
				prop="cartUv7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartUv7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天人均加购量"
				prop="cartAvg7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartAvg7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天加购是否为零"
				prop="cartIsZero7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartIsZero7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天加购量"
				prop="cartCnt14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天加购用户数"
				prop="cartUv14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartUv14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天人均加购量"
				prop="cartAvg14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartAvg14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天加购是否为零"
				prop="cartIsZero14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartIsZero14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天加购量"
				prop="cartCnt30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCnt30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天加购用户数"
				prop="cartUv30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartUv30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天人均加购量"
				prop="cartAvg30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartAvg30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天加购是否为零"
				prop="cartIsZero30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartIsZero30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天支付量"
				prop="payCnt1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天支付用户数"
				prop="payUv1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payUv1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="1天人均支付量"
				prop="payAvg1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payAvg1D"> </el-input>
			</el-form-item>
			<el-form-item
				label="1天支付是否为零"
				prop="payIsZero1D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payIsZero1D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天支付量"
				prop="payCnt3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天支付用户数"
				prop="payUv3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payUv3D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="3天人均支付量"
				prop="payAvg3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payAvg3D"> </el-input>
			</el-form-item>
			<el-form-item
				label="3天支付是否为零"
				prop="payIsZero3D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payIsZero3D">
				</el-input-number>
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
				label="7天支付用户数"
				prop="payUv7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payUv7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天人均支付量"
				prop="payAvg7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payAvg7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天支付是否为零"
				prop="payIsZero7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payIsZero7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天支付量"
				prop="payCnt14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCnt14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天支付用户数"
				prop="payUv14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payUv14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天人均支付量"
				prop="payAvg14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payAvg14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天支付是否为零"
				prop="payIsZero14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payIsZero14D">
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
			<el-form-item
				label="30天支付用户数"
				prop="payUv30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payUv30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天人均支付量"
				prop="payAvg30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payAvg30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天支付是否为零"
				prop="payIsZero30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payIsZero30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="前7天点击量"
				prop="clickCntPrev7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCntPrev7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="前7天支付量"
				prop="payCntPrev7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCntPrev7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="前7天加购量"
				prop="cartCntPrev7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCntPrev7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="前14天点击量"
				prop="clickCntPrev14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCntPrev14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="前14天支付量"
				prop="payCntPrev14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCntPrev14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天支付点击率"
				prop="payPerClick7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payPerClick7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天加购点击率"
				prop="cartPerClick7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.cartPerClick7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天收藏点击率"
				prop="collectPerClick7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.collectPerClick7D">
				</el-input>
			</el-form-item>
			<el-form-item
				label="7天支付用户点击用户率"
				prop="payUvPerClickUv7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payUvPerClickUv7D">
				</el-input>
			</el-form-item>
			<el-form-item
				label="3天与7天支付比例"
				prop="payRatio3DTo7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payRatio3DTo7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天与14天支付比例"
				prop="payRatio7DTo14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payRatio7DTo14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天点击量变化"
				prop="clickCntDelta7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCntDelta7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天支付量变化"
				prop="payCntDelta7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCntDelta7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天加购量变化"
				prop="cartCntDelta7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cartCntDelta7D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天支付量变化"
				prop="payCntDelta14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payCntDelta14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="14天点击量变化"
				prop="clickCntDelta14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.clickCntDelta14D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="7天支付均值"
				prop="payMean7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMean7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天支付均值"
				prop="payMean14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMean14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天支付均值"
				prop="payMean30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMean30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天支付标准差"
				prop="payStd7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payStd7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天支付标准差"
				prop="payStd14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payStd14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天支付标准差"
				prop="payStd30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payStd30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天支付最大值"
				prop="payMax7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMax7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天支付最大值"
				prop="payMax14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMax14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天支付最大值"
				prop="payMax30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.payMax30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天点击均值"
				prop="clickMean7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickMean7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天点击均值"
				prop="clickMean14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickMean14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天点击均值"
				prop="clickMean30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickMean30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="7天点击标准差"
				prop="clickStd7D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickStd7D"> </el-input>
			</el-form-item>
			<el-form-item
				label="14天点击标准差"
				prop="clickStd14D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickStd14D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天点击标准差"
				prop="clickStd30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input :clearable="true" v-model="form.clickStd30D"> </el-input>
			</el-form-item>
			<el-form-item
				label="30天有支付天数"
				prop="payActiveDays30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.payActiveDays30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="30天活跃天数"
				prop="activeDays30D"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.activeDays30D">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="距离上次点击天数"
				prop="daysSinceLastClick"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.daysSinceLastClick">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="距离上次支付天数"
				prop="daysSinceLastPay"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.daysSinceLastPay">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="累计活跃天数"
				prop="cumulativeActiveDays"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cumulativeActiveDays">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="累计支付天数"
				prop="cumulativePayDays"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.cumulativePayDays">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="商品上架天数"
				prop="itemAgeDays"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.itemAgeDays">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="星期几"
				prop="dayOfWeek"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.dayOfWeek">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="是否周末"
				prop="isWeekend"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.isWeekend">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="当月第几天"
				prop="dayOfMonth"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.dayOfMonth">
				</el-input-number>
			</el-form-item>
			<el-form-item
				label="月份"
				prop="month"
				data-grid-span="1"
				:rules="[required]"
			>
				<el-input-number :clearable="true" v-model="form.month">
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
form.recTmallSalesForecastFeature ||= {}
</script>
