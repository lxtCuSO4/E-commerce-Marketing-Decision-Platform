import { defineConfig } from "unocss";
import fs from "node:fs/promises";
import { cwd } from "process";
import { join } from "path";
import presetIcons from "@unocss/preset-icons";
import presetUno from "@unocss/preset-uno";
export default defineConfig({
  presets: [
    presetUno(),
    presetIcons({
      collections: {
        kp: {
          bg: () =>
            fs.readFile(join(cwd(), "./src/images/background.svg"), "utf-8"),

          logo: () => fs.readFile(join(cwd(), "./src/icons/logo.svg"), "utf-8"),

          language: () =>
            fs.readFile(join(cwd(), "./src/icons/language.svg"), "utf-8"),
        },
      },
    }),
  ],
  shortcuts: {
    "flex-y-center": "flex items-center",
    "flex-x-center": "flex flex-justify-center",
  },
  theme: {
    colors: {
      primary: "var(--el-color-primary)",
      danger: "var(--el-color-danger)",
      error: "var(--el-color-error)",
      "bg-dark": "var(--el-color-white)",
    },
  },
});
