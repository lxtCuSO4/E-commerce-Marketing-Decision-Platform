import { Comment } from "vue";
import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElButton as _ElButton } from "element-plus";

export const Button = connect(
  _ElButton,
  mapProps({
    disabled: true,
  }),
  mapReadPretty(() => h(Comment))
);
