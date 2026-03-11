import { ElTimeSelect as _ElTimeSelect } from "element-plus";
import {
  connect,
  mapProps,
  mapReadPretty,
} from "@@/plugin-platform/utils/bridge";

export const TimeSelect = connect(
  _ElTimeSelect,
  mapProps({ readonly: true, dsiabled: true }, (props) =>
    Object.assign(props, { clearable: true })
  ),
  mapReadPretty((_, { attrs }) => {
    const modelValue = attrs.modelValue ?? attrs["model-value"];
    return modelValue;
  })
);
