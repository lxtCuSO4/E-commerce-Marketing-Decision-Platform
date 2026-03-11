import { ElSwitch as _ElSwitch } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";

export const Switch = connect(
  _ElSwitch,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElSwitch, { ...attrs, disabled: true }, slots);
  })
);
