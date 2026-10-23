import test from "node:test"
import assert from "node:assert/strict"

import {
	readOnlinePredictionSnapshot,
	saveOnlinePredictionSnapshot,
} from "./online-prediction-cache.js"

function createMemoryStorage() {
	const store = new Map()
	return {
		getItem(key) {
			return store.has(key) ? store.get(key) : null
		},
		setItem(key, value) {
			store.set(key, value)
		},
		removeItem(key) {
			store.delete(key)
		},
	}
}

test("saveOnlinePredictionSnapshot stores and restores a snapshot", () => {
	const storage = createMemoryStorage()
	const snapshot = {
		itemId: 1001,
		predPayD1: 11,
		predPayD7: 17,
		pred7DPay: 98,
	}

	const key = saveOnlinePredictionSnapshot(snapshot, storage)
	const restored = readOnlinePredictionSnapshot(key, storage)

	assert.ok(key)
	assert.equal(restored.itemId, 1001)
	assert.equal(restored.predPayD1, 11)
	assert.equal(restored.pred7DPay, 98)
})

test("readOnlinePredictionSnapshot returns null when key is missing", () => {
	const storage = createMemoryStorage()
	assert.equal(readOnlinePredictionSnapshot("missing-key", storage), null)
})
