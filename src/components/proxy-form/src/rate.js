import { ElRate as _ElRate } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";

export const Rate = connect(
  _ElRate,
  mapProps(
    {
      disabled: true,
    },
    () => {
      return { clearable: true };
    }
  ),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElRate, { ...attrs, disabled: true }, slots);
  })
);
