import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElCascader as _ElCascader } from "element-plus";

export const Cascader = connect(
  _ElCascader,
  mapProps(
    {
      disabled: true,
    },
    // @ts-ignore
    () => {
      return { clearable: true };
    }
  ),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElCascader, { ...attrs, disabled: true }, slots);
  })
);
