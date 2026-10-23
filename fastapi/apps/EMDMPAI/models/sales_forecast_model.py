import json
import re
from pathlib import Path

import joblib
import pandas as pd


MODEL_DIR = Path(__file__).resolve().parent
MODEL_FILE = MODEL_DIR / "sales_forecast_lightgbm.pkl"
FEATURE_COLUMNS_FILE = MODEL_DIR / "sales_forecast_feature_columns.json"
CATEGORICAL_COLUMNS_FILE = MODEL_DIR / "sales_forecast_categorical_columns.json"
MODEL_BUNDLE = None
FEATURE_COLUMNS = None
CATEGORICAL_COLUMNS = None


def _camel_to_snake(name: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", "_", str(name)).lower()


def _normalize_payload(payload: dict) -> dict:
    feature_data = payload.get("featureData") or {}
    normalized = {}

    for source in (feature_data, payload):
        for key, value in source.items():
            normalized[key] = value
            normalized[_camel_to_snake(key)] = value

    if "item_id" not in normalized and payload.get("itemId") is not None:
        normalized["item_id"] = payload["itemId"]
    if "anchor_date" not in normalized and payload.get("anchorDate"):
        normalized["anchor_date"] = payload["anchorDate"]

    return normalized


def _load_metadata():
    global MODEL_BUNDLE, FEATURE_COLUMNS, CATEGORICAL_COLUMNS

    if MODEL_BUNDLE is None:
        MODEL_BUNDLE = joblib.load(MODEL_FILE)

    if FEATURE_COLUMNS is None:
        FEATURE_COLUMNS = json.loads(FEATURE_COLUMNS_FILE.read_text(encoding="utf-8"))

    if CATEGORICAL_COLUMNS is None:
        CATEGORICAL_COLUMNS = json.loads(CATEGORICAL_COLUMNS_FILE.read_text(encoding="utf-8"))


def _build_frame(payload: dict) -> pd.DataFrame:
    normalized = _normalize_payload(payload)
    row = {}

    for column in FEATURE_COLUMNS:
        value = normalized.get(column)
        if value is None and column in CATEGORICAL_COLUMNS:
            value = "UNKNOWN"
        elif value is None:
            value = 0
        row[column] = value

    frame = pd.DataFrame([row])
    for column in CATEGORICAL_COLUMNS:
        frame[column] = frame[column].fillna("UNKNOWN").astype(str).replace("", "UNKNOWN").astype("category")

    numeric_columns = [column for column in FEATURE_COLUMNS if column not in CATEGORICAL_COLUMNS]
    for column in numeric_columns:
        frame[column] = pd.to_numeric(frame[column], errors="coerce").fillna(0)

    return frame


def predict(payload: dict):
    _load_metadata()
    frame = _build_frame(payload)
    models = MODEL_BUNDLE.get("models") or {}
    horizon_days = min(int(payload.get("horizonDays") or 7), 7)
    predictions = []

    for index in range(1, horizon_days + 1):
        model = models.get(f"d{index}")
        if model is None or not hasattr(model, "predict"):
            raise ValueError(f"Missing model for horizon d{index}")
        value = float(model.predict(frame)[0])
        predictions.append(max(value, 0.0))

    return {
        "predictions": predictions,
        "modelVersion": "commercepredict-lightgbm",
        "modelLabel": "Sales Forecast LightGBM",
    }
