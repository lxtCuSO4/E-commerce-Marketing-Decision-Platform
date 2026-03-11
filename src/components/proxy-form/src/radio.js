import { ElRadio as _ElRadio } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";

export const Radio = connect(
  _ElRadio,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElRadio, { ...attrs, disabled: true }, slots);
  })
);
