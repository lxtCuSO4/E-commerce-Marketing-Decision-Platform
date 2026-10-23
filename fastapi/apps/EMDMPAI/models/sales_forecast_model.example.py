def predict(payload: dict):
	feature_data = payload.get("featureData") or {}
	base_value = float(feature_data.get("payCnt7D") or 0)
	step = max(base_value / 14 if base_value else 1, 1)
	horizon_days = int(payload.get("horizonDays") or 7)

	predictions = [round(base_value + step * index, 2) for index in range(1, horizon_days + 1)]

	return {
		"predictions": predictions,
		"modelVersion": "example-template",
		"modelLabel": "Sales Forecast Example Model",
	}
