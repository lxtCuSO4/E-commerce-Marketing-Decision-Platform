import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElAutocomplete as _ElAutocomplete } from "element-plus";

export const Autocomplete = connect(
  _ElAutocomplete,
  mapProps(
    {
      disabled: true,
    },
    () => {
      return { clearable: true };
    }
  ),
  mapReadPretty((_, { attrs, slots }) => {
    return h(_ElAutocomplete, { ...attrs, disabled: true }, slots);
  })
);
