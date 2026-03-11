import { defineRuntimeConfig } from "@kesplus/kesplus";

// 定义需要登录，但是不需要权限点的路由
export function defineAccessConfig(memo) {
  memo.ignoreAccess ??= []
  memo.ignoreAccess.push('/home');
  return memo;
}

export default defineRuntimeConfig({});

export function onAppCreated({ app }) { }
