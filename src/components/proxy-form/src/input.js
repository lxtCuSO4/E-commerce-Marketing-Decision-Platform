import { ElText, ElInput as _ElInput } from "element-plus";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { renderSlot } from "vue";

export const Input = connect(
  _ElInput,
  mapProps(
    {
      readonly: true,
      disabled: true,
    },
    (props) => {
      return Object.assign(props, { clearable: true });
    }
  ),
  mapReadPretty((_, { attrs, slots }) => {
    const modelValue = attrs.modelValue ?? attrs["model-value"];
    return h(
      ElText,
      {},
      {
        default: () => {
          return [
            renderSlot(slots, "prefix"),
            modelValue,
            renderSlot(slots, "suffix"),
          ];
        },
      }
    );
  })
);
