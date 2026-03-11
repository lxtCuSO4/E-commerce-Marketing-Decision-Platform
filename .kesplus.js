import { defineBuildConfig } from "@kesplus/kesplus";
/**
 * 定义KES Plus 配置
 * @type { import "@kesplus/kesplus".PluginBuildConfig }
 */
const buildConfig = {
  define: {
    __DEV__: true,
    __APP_PLACEHOLDER__: "--",
  },
  request: { timeout: 1e10 },
  title: "kesplus",
  router: {
    mode: "hash",
  },
  access: {
    roles: {
      admin: ["*"],
    },
  },
};

export default defineBuildConfig(buildConfig);
