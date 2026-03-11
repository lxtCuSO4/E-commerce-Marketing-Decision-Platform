import { ElTimePicker as _ElTimePicker } from "element-plus";
import {
  connect,
  mapProps,
  mapReadPretty,
} from "@@/plugin-platform/utils/bridge";

export const TimePicker = connect(
  _ElTimePicker,
  mapProps(
    {
      readonly: true,
      disabled: true,
    },
    (props) => Object.assign(props, { clearable: true })
  ),
  mapReadPretty((_, { attrs }) => {
    const modelValue = attrs.modelValue ?? attrs["model-value"];
    return modelValue;
  })
);
