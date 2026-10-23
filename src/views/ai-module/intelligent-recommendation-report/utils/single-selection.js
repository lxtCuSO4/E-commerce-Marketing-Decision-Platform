export function normalizeSingleSelectedRows(rows) {
	if (!Array.isArray(rows) || rows.length === 0) {
		return []
	}

	const lastSelectedRow = rows.at(-1)
	return lastSelectedRow ? [lastSelectedRow] : []
}

export function isSingleSelectionReady(rows) {
	return Array.isArray(rows) && rows.length === 1
}

export function resolveSingleSelectTarget(selection, toggledRow) {
	if (!toggledRow) {
		return null
	}

	const normalizedItemId = String(toggledRow?.itemId ?? "").trim()
	if (!normalizedItemId) {
		return null
	}

	const isStillSelected = Array.isArray(selection) && selection.some(
		(item) => String(item?.itemId ?? "").trim() === normalizedItemId,
	)

	return isStillSelected ? toggledRow : null
}
