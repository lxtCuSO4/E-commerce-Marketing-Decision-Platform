<!-- eslint-disable vue/no-v-html -->
<template>
  <div
    class="absolute bottom-0 left-0 right-0 h-20 flex justify-between flex-items-center px-25 <sm:px-8"
  >
    <div class="w-full text-center dark:color-#fff" v-html="copyRight"></div>
  </div>
</template>

<script setup>
import { computed } from "vue";
import { initialState } from "@@/initialState";

defineOptions({
  name: "LoginBottom",
});
const model = initialState
const copyRight = computed(() => {
  return model.copyright || "Copy Right © 中电科金仓（北京）科技股份有限公司";
});
</script>
