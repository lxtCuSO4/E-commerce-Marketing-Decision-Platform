import importlib.util
import sys
import tempfile
import unittest
import uuid
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]
MODELS_APIS_DIR = PROJECT_ROOT / "models" / "EMDMP" / "apis"


def _load_module_from_path(module_path: Path):
	module_name = f"emdmp_models_bundle_{module_path.stem}_{uuid.uuid4().hex}"
	spec = importlib.util.spec_from_file_location(module_name, module_path)
	if spec is None or spec.loader is None:
		raise AssertionError(f"Unable to create import spec for {module_path}")

	module = importlib.util.module_from_spec(spec)
	original_sys_path = list(sys.path)
	sys.path.insert(0, str(module_path.parent))
	try:
		spec.loader.exec_module(module)
	finally:
		sys.path[:] = original_sys_path

	return module


class ModelsBundleImportTestCase(unittest.TestCase):
	def test_root_models_recommend_api_can_be_loaded_directly(self):
		module = _load_module_from_path(MODELS_APIS_DIR / "recommend_api.py")
		self.assertTrue(hasattr(module, "router"))

	def test_root_models_sales_forecast_api_can_be_loaded_directly(self):
		module = _load_module_from_path(MODELS_APIS_DIR / "sales_forecast_api.py")
		self.assertTrue(hasattr(module, "router"))

	def test_root_models_sales_forecast_api_exposes_platform_model_adapter(self):
		module = _load_module_from_path(MODELS_APIS_DIR / "sales_forecast_api.py")
		self.assertTrue(hasattr(module, "Model"))

		with tempfile.TemporaryDirectory() as temp_dir:
			app_dir = Path(temp_dir)
			models_dir = app_dir / "models"
			models_dir.mkdir(parents=True, exist_ok=True)
			(models_dir / "sales_forecast_lightgbm.pkl").write_bytes(b"placeholder")
			(models_dir / "sales_forecast_model.py").write_text(
				"def predict(payload):\n"
				"    return {'predictions': [1, 2, 3, 4, 5, 6, 7], 'modelLabel': 'Bundle Model'}\n",
				encoding="utf-8",
			)

			model = module.Model(
				model_config={"path": "models/sales_forecast_lightgbm.pkl"},
				app_dir=str(app_dir),
			)

			import asyncio
			asyncio.run(model.initialize())
			result = model.sales_forecast_predict(
				{"itemId": 1, "anchorDate": "2026-04-18", "horizonDays": 7, "featureData": {}}
			)
			asyncio.run(model.cleanup())

		self.assertEqual(result["predictions"], [1, 2, 3, 4, 5, 6, 7])
		self.assertEqual(result["modelLabel"], "Bundle Model")


if __name__ == "__main__":
	unittest.main()
