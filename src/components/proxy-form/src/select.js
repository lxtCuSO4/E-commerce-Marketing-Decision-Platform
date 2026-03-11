import { h, renderSlot } from "vue";
import { ElOption, ElSpace, ElTag, ElSelect as _ElSelect } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { flattedChildren } from "element-plus/es/utils/vue/vnode";

export const Select = connect(
  _ElSelect,
  mapProps(
    {
      disabled: true,
    },
    (props) => Object.assign(props, { clearable: true })
  ),
  mapReadPretty((_, { attrs, slots }) => {
    const children = flattedChildren(renderSlot(slots, "default"));
    const labelMap = children.reduce((buffer, child) => {
      const { label, value } = child.props ?? {};
      if (!label || !value) return buffer;
      buffer[value] = label;
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
