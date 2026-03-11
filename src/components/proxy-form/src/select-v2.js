import { h } from "vue";
import { ElSelectV2 as _ElSelectV2, ElSpace, ElTag } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";

export const SelectV2 = connect(
  _ElSelectV2,
  mapProps({ disabled: true }, (props) =>
    Object.assign(props, { clearable: true })
  ),
  mapReadPretty((_, { attrs }) => {
    const options = attrs.options ?? [];
    const labelMap = options.reduce((buffer, option) => {
      buffer[option.value] = option.label;
      return buffer;
    }, {});
    const modelValue = attrs.modelValue ?? attrs["model-value"];
    let selected = [modelValue].flat(Infinity).filter(Boolean);
    if (attrs.multile && typeof modelValue === "string") {
      selected = modelValue.split(",");
    }
    return h(
      ElSpace,
      { wrap: true },
      {
        default: () =>
          selected.map((value) => {
            return h(
              ElTag,
              { type: "info" },
              { default: () => labelMap[value] }
            );
          }),
      }
    );
  })
);
