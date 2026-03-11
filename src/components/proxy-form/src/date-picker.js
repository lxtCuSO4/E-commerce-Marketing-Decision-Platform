import { connect, mapProps, mapReadPretty } from "@@/plugin-platform/utils/bridge";
import { ElDatePicker as _ElDatePicker, dayjs } from "element-plus";

export const DatePicker = connect(
  _ElDatePicker,
  mapProps(
    {
      readonly: true,
      disabled: true,
    },
    (props) => {
      const callback = {
        clearable: true,
        valueFormat: "YYYY-MM-DD HH:mm:ss",
      };
      // 选择结束日期的时候默认选择到时间终点
      if (props.type?.includes?.("range")) {
        Object.assign(callback, {
          defaultTime: [
            new Date(2000, 1, 1, 0, 0, 0),
            new Date(2000, 1, 1, 23, 59, 59),
          ],
        });
      }
      return callback;
    }
  ),
  mapReadPretty((_, { attrs }) => {
    const dateType = (attrs.type ?? "date") + "";
    const formatMap = {
      year: "YYYY",
      month: "YYYY-MM",
      monthrange: "YYYY-MM",
      date: "YYYY-MM-DD",
      daterange: "YYYY-MM-DD",
      dates: "YYYY-MM-DD",
      datetime: "YYYY-MM-DD HH:mm:ss",
      week: "YYYY-MM-DD",
      datetimerange: "YYYY-MM-DD HH:mm:ss",
    };
    let modelValue = attrs.modelValue ?? attrs["model-value"];
    modelValue = [modelValue].flat(Infinity).filter(Boolean);
    const isDateRange = dateType.includes("range");
    return modelValue
      .map((date) => dayjs(date).format(formatMap[dateType]))
      .join(isDateRange ? " - " : "");
  })
);
