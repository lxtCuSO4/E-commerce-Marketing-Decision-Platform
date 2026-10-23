# Sales Forecast Model Directory

Place the sales forecast Python model file here as:

`fastapi/apps/EMDMPAI/models/sales_forecast_model.py`

You can start by copying:

`fastapi/apps/EMDMPAI/models/sales_forecast_model.example.py`

Current imported sales forecast model artifacts:

- `sales_forecast_lightgbm.pkl`
- `sales_forecast_feature_columns.json`
- `sales_forecast_categorical_columns.json`

This runtime is intentionally separate from the LLM integration in `fastapi/apps/EMDMPAI/apis/llm_client.py`.

Required entrypoint:

```python
def predict(payload: dict) -> dict | list:
    ...
```

Supported return shapes:

```python
[11, 12, 13, 14, 15, 16, 17]
```

or

```python
{
    "predictions": [11, 12, 13, 14, 15, 16, 17],
    "modelVersion": "v1",
    "modelLabel": "My Forecast Model",
}
```

The incoming `payload` contains:

- `itemId`
- `anchorDate`
- `horizonDays`
- `featureData`

The current `sales_forecast_model.py` wrapper already adapts the imported LightGBM model to this contract.
