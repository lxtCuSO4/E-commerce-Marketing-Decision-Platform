import { ElMessageBox } from "element-plus"
import { h, ref, reactive } from "vue"
import {
	addDialog,
	closeDialog,
	useDialogSelectContext,
} from "@kesplus/kesplus"
import { deleteApi } from "./rec-tmall-item-base-api"
import FormComponent from "../form.vue"
import { DialogManager } from "@@/plugin-layout/views/dialog/dialog-manager"
/**
 *
 * @param {Object} editOptions
 * @param {String} editOptions.title
 * @param {String} [editOptions.id]
 * @param {()=>void} [editOptions.effect]
 */
export function handleEdit(editOptions) {
	const editRef = ref()
	const optProxy = reactive(editOptions)
	const dialog = addDialog({
		effect: optProxy.effect,
		title: optProxy.title,
		props: optProxy,
		width: "61.8%",

		footerButtons: [
			{
				label: "重置",
				type: "info",
				btnClick: () => editRef.value.reset(),
			},
			{
				label: "保存",
				type: "primary",
				btnClick: () => {
					editRef.value.submit().then(() => {
						closeDialog(dialog)
					})
				},
			},
		],

		contentRenderer: () =>
			h(FormComponent, Object.assign({ ref: editRef }, {})),
	})
}
export function handleWorkflowEdit(formOptions, workflowOptions) {
	const {
		row: { processId, id } = {},
		title = "流程表单",
		effect = () => {},
	} = formOptions ?? {}
	const {
		formCode = "rec-tmall-item-base",
		notUse = false,
		mode = "window",
	} = workflowOptions ?? {}
	DialogManager.openDialog({
		mode,
		title,
		formCode,
		notUse,
		component: "/src/views/data-import-module/rec-tmall-item-base/form.vue",
		props: {
			id,
		},
		processId,
		buttons: [
			{
				text: "暂存",
				action: "draft",
			},
		],
		effect,
	})
}
/**
 *
 * @param {string|string[]} ids
 * @param {()=>void} [effect]
 * @returns
 */
export async function handleDelete(ids, effect) {
	const callback = await ElMessageBox.confirm("确认删除？", "删除", {
		showCancelButton: true,
	})
	if (callback !== "confirm") return
	const deleteId = Array.isArray(ids) ? ids.join(",") : ids
	await deleteApi({ ids: deleteId })
	effect?.()
}
/**
 *
 * @param {Object} editOptions
 * @param {String} editOptions.title
 * @param {String} [editOptions.id]
 * @param {()=>void} [editOptions.effect]
 */
export function handleView(editOptions) {
	const viewRef = ref()
	addDialog({
		title: editOptions.title,
		props: editOptions,
		width: "61.8%",
		contentRenderer: () => h(FormComponent, { ref: viewRef }),
	})
}
/**
 * 打开弹窗
 * @param {*} editOptions
 * @example
 * ```ts
 * handleSelect({
 *  default: [].reduce((buffer, item) => {
 *    buffer.set(item.id, item)
 *    return buffer
 *  }, new Map()),
 *  queryForm: {},
 *  multiple: true,
 *  title: "请选择",
 *  effect: (data) => {}
 * })
 * ```
 */
export function handleSelect(editOptions) {
	const { onConfirm, renderer } = useDialogSelectContext(editOptions)
	const dialog = addDialog({
		component: "el-dialog",
		title: editOptions.title,
		props: editOptions,
		width: "90%",
		contentRenderer: renderer(import("../index.vue"), {
			style: { "--kesplus-page-content-height": "65vh" },
		}),
		footerButtons: [
			{
				label: "关闭",
				btnClick: () => {
					closeDialog(dialog)
				},
			},
			{
				label: "确定",
				type: "primary",
				btnClick: onConfirm(async (data) => {
					await editOptions.effect(data)
					closeDialog(dialog)
				}),
			},
		],
	})
}
