export function getNextSingleSelectedRow(currentRow, clickedRow, getRowKey = defaultGetRowKey) {
	if (!clickedRow) {
		return null
	}

	const currentKey = getRowKey(currentRow)
	const clickedKey = getRowKey(clickedRow)
	if (!clickedKey) {
		return null
	}

	return currentKey === clickedKey ? null : clickedRow
}

function defaultGetRowKey(row) {
	if (!row || typeof row !== "object") {
		return ""
	}

	return String(row.rowKey ?? row.itemId ?? row.sellerId ?? "").trim()
}
