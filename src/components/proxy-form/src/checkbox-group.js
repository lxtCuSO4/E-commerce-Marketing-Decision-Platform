import { h, renderSlot } from "vue";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import {
  ElCheckboxGroup as _ElCheckboxGroup,
  ElSpace,
  ElTag,
} from "element-plus";
import { flattedChildren } from "element-plus/es/utils/vue/vnode";

export const CheckboxGroup = connect(
  _ElCheckboxGroup,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    const children = flattedChildren(renderSlot(slots, "default"));
    const labelMap = children.reduce((buffer, child) => {
      const { label } = child.props ?? {};
      if (!label) return;
      buffer[label] = child.children?.default ?? child.children;
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
              { default: () => h(labelMap?.[value]) }
            );
          }),
      }
    );
  })
);
