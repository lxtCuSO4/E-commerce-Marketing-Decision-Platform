import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElColorPicker as _ElColorPicker } from "element-plus";

export const ColorPicker = connect(
  _ElColorPicker,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElColorPicker, { ...attrs, disabled: true }, slots);
  })
);
