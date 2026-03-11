import { renderSlot, Comment } from "vue";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElCheckbox as _ElCheckbox } from "element-plus";

export const Checkbox = connect(
  _ElCheckbox,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    const modelValue = attrs.modelValue ?? attrs["model-value"];
    if (modelValue == attrs.label) return h(renderSlot(slots, "default"));
    return h(Comment);
  })
);
