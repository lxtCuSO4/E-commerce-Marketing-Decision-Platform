<template>
  <div
    class="login-container relative h-full w-full flex flex-justify-center flex-items-center bg-center-top bg-no-repeat dark:bg-#101628"
  >
    <Top />
    <el-card
      class="z-1 w-100 <sm:w-83 !rounded-4% !border-none !bg-transparent"
    >
      <h3
        class="mt-6 flex-x-center text-24px text-primary font-500"
        type="primary"
      >
        {{ $t("login.login") }}
      </h3>
      <el-form
        ref="formRef"
        :model="baseForm"
        :show-message="false"
        :rules="formRules"
        class="mt-6"
        autocomplete="off"
        size="large"
        @validate="validate"
      >
        <el-form-item prop="username">
          <el-input
            v-model="baseForm.username"
            :placeholder="$t('login.usernamePlaceholder')"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="baseForm.password"
            show-password
            autocomplete="new-password"
            :placeholder="$t('login.passwordPlaceholder')"
          />
        </el-form-item>
        <el-form-item prop="captchaValue">
          <el-input
            v-model="baseForm.captchaValue"
            class="captcha"
            :placeholder="$t('login.verifyCode')"
          >
            <template #append>
              <Captcha
                ref="codeRef"
                v-model="baseForm.uuid"
                class="h-full w-full"
              />
            </template>
          </el-input>
        </el-form-item>
        <div
          v-if="validErrmsg"
          class="el-alert el-alert--error is-light justify-center !mb-16px"
        >
          {{ validErrmsg }}
        </div>
        <el-form-item>
          <el-button
            class="w-full"
            type="primary"
            :loading="loading"
            @click="doLogin(false)"
          >
            {{ $t("login.login") }}
          </el-button>
        </el-form-item>
        <el-form-item v-if="ldap">
          <el-button
            :loading="loading"
            @click="doLogin(true)"
            class="w-full"
          >
            {{ $t("login.ldap") }}</el-button
          >
        </el-form-item>
      </el-form>
    </el-card>
    <Bottom />
  </div>
</template>
<script setup>
import { ref, computed, unref } from "vue";
import { defineRouteMeta, useLogin, Captcha, useGet } from "@kesplus/kesplus";
import Top from "./components/top.vue";
import Bottom from "./components/bottom.vue";
const formRef = ref();
const errs = ref({});
const codeRef = ref();
defineRouteMeta({
  layout: {
    navigation: null,
  },
});
defineOptions({
  name: "CustomerLoginPage",
});
const { baseForm, formRules, loading, doLogin, ldap, error } = useLogin(
  formRef,
  codeRef
);
const validate = (prop, isValid, message) => {
  if (!isValid) {
    errs.value[prop] = message;
  } else {
    delete errs.value[prop];
  }
};
const validErrmsg = computed(() => {
  const keys = Object.keys(errs.value);
  if (keys.length) {
    return errs.value[keys.at(keys.length - 1)];
  }

  if (unref(error)) {
    return unref(error);
  }
  return false;
});
</script>

<style lang="scss" scoped>
.login-container {
  background-image: url("/src/images/background.svg");
}
.captcha :deep(.el-input-group__append) {
  padding: 0;
}
</style>
