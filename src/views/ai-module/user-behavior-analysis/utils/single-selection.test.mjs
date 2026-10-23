import test from "node:test"
import assert from "node:assert/strict"

import { getNextSingleSelectedRow } from "./single-selection.js"

test("getNextSingleSelectedRow selects the clicked row when nothing is selected", () => {
	const row = { rowKey: "item-1", itemId: 1 }

	assert.deepEqual(getNextSingleSelectedRow(null, row), row)
})

test("getNextSingleSelectedRow replaces the previous row with the new row", () => {
	const previousRow = { rowKey: "item-1", itemId: 1 }
	const nextRow = { rowKey: "item-2", itemId: 2 }

	assert.deepEqual(getNextSingleSelectedRow(previousRow, nextRow), nextRow)
})

test("getNextSingleSelectedRow clears selection when clicking the same row again", () => {
	const row = { rowKey: "merchant-1", sellerId: 1 }

	assert.equal(getNextSingleSelectedRow(row, row), null)
})

test("getNextSingleSelectedRow returns null when the clicked row has no usable key", () => {
	assert.equal(getNextSingleSelectedRow({ rowKey: "item-1" }, {}), null)
	assert.equal(getNextSingleSelectedRow({ rowKey: "item-1" }, null), null)
})
