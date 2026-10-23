import test from "node:test"
import assert from "node:assert/strict"

import { extractQuestionContext } from "./question-context.js"

test("extractQuestionContext picks up a seasonal title keyword from product ranking questions", () => {
	const result = extractQuestionContext("近期销量最高的秋装是哪件商品")

	assert.deepEqual(result, {
		itemId: "",
		category: "",
		title: "秋装",
	})
})

test("extractQuestionContext keeps explicit item id and category anchors", () => {
	const result = extractQuestionContext("商品ID 283638 的类目：男装 最近表现怎么样")

	assert.deepEqual(result, {
		itemId: "283638",
		category: "男装",
		title: "男装",
	})
})
