<template>
  <div
    class="absolute left-0 right-0 top-0 h-20 flex justify-between flex-items-center px-25 <sm:px-8"
  >
    <div class="flex flex-items-center">
      <img
        v-if="model.icon"
        :src="model.icon"
        class="max-h-24px"
        :alt="model.name"
      />
      <i v-else class="i-kp-logo" style="font-size: 24px" />
      <div class="ml-4 text-5">
        <span class="ml-1 dark:color-#fff"> {{ model.name }}</span>
      </div>
    </div>
    <div class="flex flex-items-center">
    </div>
  </div>
</template>

<script setup>
import { initialState } from "@@/initialState";

defineOptions({
  name: "LoginTop",
});
const model = initialState
</script>
