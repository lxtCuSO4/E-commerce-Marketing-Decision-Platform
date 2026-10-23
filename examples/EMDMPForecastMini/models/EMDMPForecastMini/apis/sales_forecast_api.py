import json
import logging
import os
import re
from pathlib import Path
from typing import Any, Optional

import joblib
import pandas as pd


class Model:
    """Minimal platform-facing sales forecast model."""

    def __init__(
        self,
        model_config: Optional[dict[str, Any]] = None,
        app_dir: Optional[str] = None,
        logger: Optional[logging.Logger] = None,
    ):
        self.model_config = model_config or {}
        self.app_dir = Path(app_dir).resolve() if app_dir else Path(__file__).resolve().parents[1]
        self.logger = logger or logging.getLogger("emdmp_forecast_mini")
        self.model_bundle = None
        self.feature_columns: list[str] | None = None
        self.categorical_columns: list[str] | None = None

    def _get_model_path(self) -> Path:
        configured = (
            self.model_config.get("resolved_path")
            or self.model_config.get("path")
            or self.model_config.get("model_path")
            or "models/sales_forecast_lightgbm.pkl"
        )
        model_path = Path(str(configured))
        if model_path.is_absolute():
            return model_path
        return (self.app_dir / model_path).resolve()

    def _get_bundle_models_dir(self) -> Path:
        return self._get_model_path().resolve().parent

    def _load_metadata(self) -> None:
        if self.model_bundle is not None:
            return

        model_file = self._get_model_path()
        models_dir = self._get_bundle_models_dir()
        feature_columns_file = models_dir / "sales_forecast_feature_columns.json"
        categorical_columns_file = models_dir / "sales_forecast_categorical_columns.json"

        if not model_file.exists():
            raise FileNotFoundError(f"Model file not found: {model_file}")
        if not feature_columns_file.exists():
            raise FileNotFoundError(f"Feature columns file not found: {feature_columns_file}")
        if not categorical_columns_file.exists():
            raise FileNotFoundError(f"Categorical columns file not found: {categorical_columns_file}")

        self.model_bundle = joblib.load(model_file)
        self.feature_columns = json.loads(feature_columns_file.read_text(encoding="utf-8"))
        self.categorical_columns = json.loads(categorical_columns_file.read_text(encoding="utf-8"))

    @staticmethod
    def _camel_to_snake(name: str) -> str:
        return re.sub(r"(?<!^)(?=[A-Z])", "_", str(name)).lower()

    def _normalize_payload(self, payload: dict[str, Any]) -> dict[str, Any]:
        feature_data = payload.get("featureData") or payload.get("feature_data") or {}
        normalized: dict[str, Any] = {}

        for source in (feature_data, payload):
            if not isinstance(source, dict):
                continue
            for key, value in source.items():
                normalized[key] = value
                normalized[self._camel_to_snake(key)] = value

        if "item_id" not in normalized and payload.get("itemId") is not None:
            normalized["item_id"] = payload["itemId"]
        if "anchor_date" not in normalized and payload.get("anchorDate"):
            normalized["anchor_date"] = payload["anchorDate"]

        return normalized

    def _build_frame(self, payload: dict[str, Any]) -> pd.DataFrame:
        self._load_metadata()
        assert self.feature_columns is not None
        assert self.categorical_columns is not None

        normalized = self._normalize_payload(payload)
        row: dict[str, Any] = {}

        for column in self.feature_columns:
            value = normalized.get(column)
            if value is None and column in self.categorical_columns:
                value = "UNKNOWN"
            elif value is None:
                value = 0
            row[column] = value

        frame = pd.DataFrame([row])
        for column in self.categorical_columns:
            frame[column] = frame[column].fillna("UNKNOWN").astype(str).replace("", "UNKNOWN").astype("category")

        numeric_columns = [column for column in self.feature_columns if column not in self.categorical_columns]
        for column in numeric_columns:
            frame[column] = pd.to_numeric(frame[column], errors="coerce").fillna(0)

        return frame

    async def initialize(self):
        self.logger.info("Initializing sales forecast mini model")
        self._load_metadata()
        return self

    def predict(self, payload: dict[str, Any]) -> dict[str, Any]:
        self._load_metadata()
        assert self.model_bundle is not None

        frame = self._build_frame(payload)
        models = self.model_bundle.get("models") or {}
        horizon_days = min(int(payload.get("horizonDays") or payload.get("horizon_days") or 7), 7)
        predictions: list[float] = []

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

    async def cleanup(self):
        self.model_bundle = None
        self.feature_columns = None
        self.categorical_columns = None
