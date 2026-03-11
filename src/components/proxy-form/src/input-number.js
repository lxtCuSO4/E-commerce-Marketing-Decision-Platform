import {
  connect,
  mapProps,
  mapReadPretty,
} from "@@/plugin-platform/utils/bridge";
import { ElInputNumber as _ElInputNumber } from "element-plus";

export const InputNumber = connect(
  _ElInputNumber,
  mapProps(
    {
      readonly: true,
      disabled: true,
    },
    (props) => {
      return {
        controlsPosition: "right",
        valueOnClear: null,
        "model-value": props.modelValue === "" ? null : props.modelValue,
      };
    }
  ),
  mapReadPretty((_, { attrs }) => attrs.modelValue ?? attrs["model-value"])
);
