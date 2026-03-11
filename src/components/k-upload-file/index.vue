<script lang="jsx">
import UploadFile from "@@/plugin-platform/components/k-upload-file/index.vue";
import {
  connect,
  mapProps,
  mapReadPretty,
} from "@@/plugin-platform/utils/bridge";

export default connect(
  UploadFile,
  mapProps({
    disabled: true,
  }),
  mapReadPretty((_, { attrs }) => {
    return (
      <UploadFile
        {...attrs}
        uploadType="readpretty"
      />
    );
  })
);
</script>
