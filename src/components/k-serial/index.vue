<script lang="jsx">
import { KSerial } from "@kesplus/design-components";
import {
  connect,
  mapProps,
  mapReadPretty,
} from "@@/plugin-platform/utils/bridge";


export default connect(
  KSerial,
  mapProps({}),
  mapReadPretty((_, { attrs }) => attrs.modelValue)
);
</script>
