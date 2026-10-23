import importlib.util
import os
import uuid
from pathlib import Path
from typing import Any


BASE_DIR = Path(__file__).resolve().parents[3]
DEFAULT_MODEL_FILE = BASE_DIR / "apps" / "EMDMPAI" / "models" / "sales_forecast_model.py"
ROOT_MODELS_MODEL_FILE = BASE_DIR.parent / "models" / "EMDMP" / "models" / "sales_forecast_model.py"


def log_model_resolution(source: str, model_file: Path) -> None:
	print(f"[SALES_FORECAST_MODEL] source={source} path={model_file}")


def resolve_default_model_file_path(source_file: Path | None = None) -> Path:
	module_file = (source_file or Path(__file__)).resolve()
	root_models_path = module_file.parents[4] / "models" / "EMDMP" / "models" / "sales_forecast_model.py"
	if root_models_path.exists():
		log_model_resolution("root_models", root_models_path)
		return root_models_path

	deployed_model_path = module_file.parent.parent / "models" / "sales_forecast_model.py"
	if deployed_model_path.exists():
		log_model_resolution("deployed_bundle", deployed_model_path)
		return deployed_model_path

	if ROOT_MODELS_MODEL_FILE.exists():
		log_model_resolution("root_models_constant", ROOT_MODELS_MODEL_FILE)
		return ROOT_MODELS_MODEL_FILE

	log_model_resolution("fastapi_fallback", DEFAULT_MODEL_FILE)
	return DEFAULT_MODEL_FILE


class SalesForecastModelNotReadyError(RuntimeError):
	def __init__(self, model_path: str):
		super().__init__("sales forecast model file is not ready")
		self.model_path = model_path


class SalesForecastModelInvalidError(RuntimeError):
	def __init__(self, message: str):
		super().__init__(message)


def get_model_file_path() -> Path:
	configured_path = os.getenv("SALES_FORECAST_MODEL_FILE", "").strip()
	return Path(configured_path) if configured_path else resolve_default_model_file_path()


def _safe_float(value: Any, default: float = 0.0) -> float:
	try:
		if value is None or value == "":
			return default
		return float(value)
	except Exception:  # noqa: BLE001
		return default


def _load_model_module(model_file: Path):
	if not model_file.exists():
		raise SalesForecastModelNotReadyError(str(model_file))

	module_name = f"emdmp_sales_forecast_model_{uuid.uuid4().hex}"
	spec = importlib.util.spec_from_file_location(module_name, model_file)
	if spec is None or spec.loader is None:
		raise SalesForecastModelInvalidError(f"Unable to load model module from {model_file}")

	module = importlib.util.module_from_spec(spec)
	spec.loader.exec_module(module)
	return module


def _normalize_predictions(raw_result: Any, horizon_days: int) -> list[float]:
	if isinstance(raw_result, dict):
		if isinstance(raw_result.get("predictions"), list):
			values = raw_result["predictions"]
		elif isinstance(raw_result.get("values"), list):
			values = raw_result["values"]
		else:
			values = []
	elif isinstance(raw_result, list):
		values = raw_result
	else:
		values = []

	if len(values) < horizon_days:
		raise SalesForecastModelInvalidError(
			f"Model returned {len(values)} predictions, expected at least {horizon_days}"
		)

	return [_safe_float(value) for value in values[:horizon_days]]


def run_sales_forecast(payload: dict[str, Any]) -> dict[str, Any]:
	model_file = get_model_file_path()
	module = _load_model_module(model_file)
	predict = getattr(module, "predict", None)

	if not callable(predict):
		raise SalesForecastModelInvalidError(
			f"Model file {model_file} must expose a callable predict(payload) function"
		)

	raw_result = predict(payload)
	horizon_days = int(payload.get("horizonDays") or 7)
	predictions = _normalize_predictions(raw_result, horizon_days)

	model_version = ""
	model_label = ""
	if isinstance(raw_result, dict):
		model_version = str(raw_result.get("modelVersion") or raw_result.get("version") or "").strip()
		model_label = str(raw_result.get("modelLabel") or raw_result.get("label") or "").strip()

	response = {
		"itemId": payload.get("itemId"),
		"anchorDate": payload.get("anchorDate"),
		"horizonDays": horizon_days,
		"predictions": predictions,
		"pred7DPay": round(sum(predictions), 4),
		"featureSnapshot": payload.get("featureData") or {},
		"resultSource": "online_prediction",
		"llmStatus": "not_applicable",
		"modelPath": str(model_file),
		"modelVersion": model_version or "custom-python-model",
		"modelLabel": model_label or "Sales Forecast Python Model",
	}

	for index, value in enumerate(predictions, start=1):
		response[f"predPayD{index}"] = value

	return response
