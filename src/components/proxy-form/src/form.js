import {
  defineComponent,
  h,
  inject,
  mergeProps,
  provide,
  computed,
  ref,
} from "vue";
import { ElForm as _ElForm } from "element-plus";
import { useProcessStore } from "@kesplus/workflow";
import { CONTROLL_SYSBOL } from "@@/plugin-platform/utils/bridge";

const WRAPPER_SYMBOL = Symbol("el-form");
// const CONTROLL_SYSBOL = Symbol("el-form-item");
export const Form = defineComponent(
  (props, { slots, attrs, expose }) => {
    const { workflow, options } = useProcessStore() || {};
    const componentRef = ref();
    expose(
      new Proxy(
        {},
        {
          get(_, key) {
            return componentRef.value?.[key];
          },
          has(_, key) {
            return key in (componentRef.value ?? {});
          },
        }
      )
    );
    if (!workflow) {
      provide(CONTROLL_SYSBOL, false);
      return () => h(_ElForm, { ref: componentRef, ...attrs, ...props }, slots);
    }

    provide(WRAPPER_SYMBOL, true);

    const isSubForm = inject(WRAPPER_SYMBOL, false);

    if (isSubForm) {
      provide(CONTROLL_SYSBOL, false);
      return () => h(_ElForm, { ref: componentRef, ...attrs, ...props }, slots);
    }
    if (attrs?.mode === "plain") {
      provide(CONTROLL_SYSBOL, false);
    } else {
      provide(CONTROLL_SYSBOL, true);
    }

    if (options?.disabled !== undefined) {
      return () =>
        h(
          _ElForm,
          {
            ref: componentRef,
            ...attrs,
            ...props,
            disabled: options?.disabled,
          },
          slots
        );
    }
    const formReadOnlyRef = computed(() => {
      if (attrs.disabled !== undefined) {
        return attrs.disabled;
      }
      if (workflow?.status === void 0) return;
      return workflow?.formReadOnly.value || workflow?.status === 1;
    });
    return () => {
      const mergedProps = mergeProps(props, {
        disabled: formReadOnlyRef.value,
      });
      return h(_ElForm, { ref: componentRef, ...attrs, ...mergedProps }, slots);
    };
  },
  {
    name: "ProxyElForm",
    inheritAttrs: true,
    props: _ElForm.props,
    slots: _ElForm.slots,
    emits: _ElForm.emits,
    expose: _ElForm.expose,
  }
);
