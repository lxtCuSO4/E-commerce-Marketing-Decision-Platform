import { Comment, h, renderSlot } from "vue";
import { ElRadioGroup as _ElRadioGroup } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { flattedChildren } from "element-plus/es/utils/vue/vnode";

export const RadioGroup = connect(
  _ElRadioGroup,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs, slots }) => {
    const children = flattedChildren(renderSlot(slots, "default"));
    let modelValue = attrs.modelValue ?? attrs["model-value"];
    const radio = children.find((child) => {
      return child.props.label === modelValue;
    });
    return h(radio?.children?.default ?? radio ?? Comment, {
      modelValue: radio?.props.label,
    });
  })
);
