<template>
  <div class="user-center">
    {{ initialState.name }}
  </div>
</template>

<script setup>
import { initialState } from "@@/initialState";
</script>

<style lang="sass">
.user-center {
  text-align: right;
}
</style>
