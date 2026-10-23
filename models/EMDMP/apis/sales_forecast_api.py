import importlib.util
import logging
import uuid
from pathlib import Path
from typing import Any

from fastapi import APIRouter
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

try:
	from .sales_forecast_runtime import (
		SalesForecastModelInvalidError,
		SalesForecastModelNotReadyError,
		get_model_file_path,
		run_sales_forecast,
	)
except ImportError:
	from sales_forecast_runtime import (
		SalesForecastModelInvalidError,
		SalesForecastModelNotReadyError,
		get_model_file_path,
		run_sales_forecast,
	)


router = APIRouter()
DEFAULT_MODEL_PATH = "models/sales_forecast_lightgbm.pkl"


class SalesForecastPredictRequest(BaseModel):
	itemId: int | str
	anchorDate: str
	horizonDays: int = Field(default=7, ge=1, le=30)
	featureData: dict[str, Any] = Field(default_factory=dict)


def _coerce_payload(payload: Any) -> dict[str, Any]:
	if isinstance(payload, dict):
		return payload
	if hasattr(payload, "model_dump"):
		return payload.model_dump()
	if hasattr(payload, "dict"):
		return payload.dict()
	return dict(payload)


def _load_predict_callable(model_file: Path):
	module_name = f"emdmp_sales_forecast_bundle_{uuid.uuid4().hex}"
	spec = importlib.util.spec_from_file_location(module_name, model_file)
	if spec is None or spec.loader is None:
		raise SalesForecastModelInvalidError(f"Unable to load model module from {model_file}")

	module = importlib.util.module_from_spec(spec)
	spec.loader.exec_module(module)
	predict = getattr(module, "predict", None)
	if not callable(predict):
		raise SalesForecastModelInvalidError(
			f"Model file {model_file} must expose a callable predict(payload) function"
		)
	return predict


class Model:
	"""Platform-managed sales forecast adapter for the models bundle.

	Local FastAPI still uses the `router` below. Cloud bundle hosting can
	instantiate this `Model` class in the same way as the official DemoAPP.
	"""

	def __init__(
		self,
		model_config: dict[str, Any] | None = None,
		app_dir: str | None = None,
		logger: logging.Logger | None = None,
	):
		self.model_config = model_config or {}
		self.app_dir = Path(app_dir).resolve() if app_dir else Path(__file__).resolve().parents[1]
		self.logger = logger or logging.getLogger("emdmp.sales_forecast.bundle")
		self._predict_callable = None
		self._model_file_path = self._resolve_python_model_file()

	def _resolve_configured_model_path(self) -> Path:
		configured = (
			str(
				self.model_config.get("path")
				or self.model_config.get("model_path")
				or DEFAULT_MODEL_PATH
			)
			.strip()
		)
		configured_path = Path(configured)
		if configured_path.is_absolute():
			return configured_path
		return (self.app_dir / configured_path).resolve()

	def _resolve_python_model_file(self) -> Path:
		configured_model_path = self._resolve_configured_model_path()
		derived_bundle_file = configured_model_path.parent / "sales_forecast_model.py"
		if derived_bundle_file.exists():
			return derived_bundle_file

		default_bundle_file = Path(__file__).resolve().parent.parent / "models" / "sales_forecast_model.py"
		if default_bundle_file.exists():
			return default_bundle_file

		return derived_bundle_file

	async def initialize(self):
		if not self._model_file_path.exists():
			raise SalesForecastModelNotReadyError(str(self._model_file_path))

		self._predict_callable = _load_predict_callable(self._model_file_path)
		self.logger.info("sales forecast bundle model initialized from %s", self._model_file_path)
		return self

	def _predict(self, payload: Any) -> dict[str, Any]:
		if self._predict_callable is None:
			raise SalesForecastModelInvalidError("Sales forecast bundle model has not been initialized")

		result = self._predict_callable(_coerce_payload(payload))
		if not isinstance(result, dict):
			raise SalesForecastModelInvalidError("Sales forecast bundle model must return a JSON object")
		return result

	def predict(self, payload: Any) -> dict[str, Any]:
		return self._predict(payload)

	def sales_forecast_predict(self, payload: Any) -> dict[str, Any]:
		return self._predict(payload)

	async def cleanup(self):
		self._predict_callable = None


@router.post("/sales-forecast/predict")
async def sales_forecast_predict(payload: SalesForecastPredictRequest):
	try:
		result = run_sales_forecast(payload.model_dump())
	except SalesForecastModelNotReadyError as exc:
		return JSONResponse(
			status_code=503,
			content={
				"success": False,
				"errorCode": "model_not_ready",
				"message": "Sales forecast model file is not ready",
				"modelPath": exc.model_path,
				"expectedEntry": "predict(payload)",
			},
		)
	except SalesForecastModelInvalidError as exc:
		return JSONResponse(
			status_code=500,
			content={
				"success": False,
				"errorCode": "model_invalid",
				"message": str(exc),
				"modelPath": str(get_model_file_path()),
			},
		)

	result["success"] = True
	return result
