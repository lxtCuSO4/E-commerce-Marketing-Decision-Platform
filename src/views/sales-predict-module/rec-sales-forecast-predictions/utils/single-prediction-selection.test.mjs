import test from "node:test"
import assert from "node:assert/strict"

import { getNextSelectedPredictionRow } from "./single-prediction-selection.js"

test("getNextSelectedPredictionRow selects the clicked row when nothing is selected", () => {
	const row = { id: 1, itemId: 480807 }

	assert.deepEqual(getNextSelectedPredictionRow(null, row), row)
})

test("getNextSelectedPredictionRow replaces the previous row with the new row", () => {
	const previousRow = { id: 1, itemId: 480807 }
	const nextRow = { id: 2, itemId: 1053762 }

	assert.deepEqual(getNextSelectedPredictionRow(previousRow, nextRow), nextRow)
})

test("getNextSelectedPredictionRow clears selection when clicking the same row again", () => {
	const row = { id: 1, itemId: 480807 }

	assert.equal(getNextSelectedPredictionRow(row, row), null)
})

test("getNextSelectedPredictionRow returns null when clicked row is empty", () => {
	assert.equal(getNextSelectedPredictionRow({ id: 1 }, null), null)
})
