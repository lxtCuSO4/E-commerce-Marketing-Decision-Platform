<template>
  <div class="page">
    <KDashboard />
  </div>
</template>

<script setup>
import { defineRouteMeta } from "@kesplus/kesplus";
import KDashboard from "@@/plugin-platform/components/dashboard/index.vue";

defineOptions({
  name: "UserHome",
});

defineRouteMeta({
  name: "home",
  title: "工作台",
  isKeepAlive: true,
  icon: "HomeFilled",
  isAffix: true,
});

</script>

<style>
.page {
  height: 1000px;
}
</style>
