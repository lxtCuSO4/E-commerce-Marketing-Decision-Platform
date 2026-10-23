import test from "node:test"
import assert from "node:assert/strict"

import {
	isSingleSelectionReady,
	normalizeSingleSelectedRows,
	resolveSingleSelectTarget,
} from "./single-selection.js"

test("normalizeSingleSelectedRows keeps an empty selection empty", () => {
	assert.deepEqual(normalizeSingleSelectedRows([]), [])
	assert.deepEqual(normalizeSingleSelectedRows(null), [])
})

test("normalizeSingleSelectedRows keeps the most recently selected row only", () => {
	const rows = [{ itemId: 1001 }, { itemId: 1002 }, { itemId: 1003 }]

	assert.deepEqual(normalizeSingleSelectedRows(rows), [{ itemId: 1003 }])
})

test("isSingleSelectionReady is true only when exactly one row is selected", () => {
	assert.equal(isSingleSelectionReady([]), false)
	assert.equal(isSingleSelectionReady([{ itemId: 1001 }]), true)
	assert.equal(isSingleSelectionReady([{ itemId: 1001 }, { itemId: 1002 }]), false)
})

test("resolveSingleSelectTarget keeps the toggled row when it is selected", () => {
	const firstRow = { itemId: 1001 }
	const secondRow = { itemId: 1002 }

	assert.deepEqual(
		resolveSingleSelectTarget([firstRow, secondRow], firstRow),
		firstRow,
	)
	assert.deepEqual(
		resolveSingleSelectTarget([firstRow, secondRow], secondRow),
		secondRow,
	)
})

test("resolveSingleSelectTarget returns null when the toggled row is cleared", () => {
	const firstRow = { itemId: 1001 }
	const secondRow = { itemId: 1002 }

	assert.equal(resolveSingleSelectTarget([firstRow], secondRow), null)
	assert.equal(resolveSingleSelectTarget([], firstRow), null)
})
