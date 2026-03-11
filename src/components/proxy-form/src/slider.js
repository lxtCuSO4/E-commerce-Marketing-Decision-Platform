import { ElSlider as _ElSlider } from "element-plus";
import { connect, mapProps } from "@@/plugin-platform/utils/bridge";

export const Slider = connect(
  _ElSlider,
  mapProps({
    disabled: true
  })
);
