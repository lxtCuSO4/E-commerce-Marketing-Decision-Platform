export function getNextSelectedPredictionRow(currentRow, clickedRow) {
	if (!clickedRow) {
		return null
	}

	return currentRow?.id === clickedRow.id ? null : clickedRow
}
