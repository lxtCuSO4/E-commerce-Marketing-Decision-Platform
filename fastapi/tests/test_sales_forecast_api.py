import io
import os
import sys
import tempfile
import textwrap
import unittest
from contextlib import redirect_stdout
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class SalesForecastApiTestCase(unittest.TestCase):
	def setUp(self):
		from main import app

		self.app = app
		self.payload = {
			"itemId": 1001,
			"anchorDate": "2026-04-11",
			"horizonDays": 7,
			"featureData": {
				"itemId": 1001,
				"anchorDate": "2026-04-11",
				"payCnt7D": 88,
				"payCnt30D": 326,
				"clickCnt7D": 1420,
			},
		}

	def test_sales_forecast_route_is_registered(self):
		paths = {route.path for route in self.app.routes}
		self.assertIn("/api/EMDMPAI/sales-forecast/predict", paths)
		self.assertIn("/api/EMDMP/sales-forecast/predict", paths)

	def test_predict_returns_model_not_ready_when_model_file_missing(self):
		missing_model_path = Path(tempfile.gettempdir()) / "emdmp_missing_sales_forecast_model.py"
		original_model_path = os.environ.get("SALES_FORECAST_MODEL_FILE")
		os.environ["SALES_FORECAST_MODEL_FILE"] = str(missing_model_path)

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMPAI/sales-forecast/predict", json=self.payload)
		finally:
			if original_model_path is None:
				os.environ.pop("SALES_FORECAST_MODEL_FILE", None)
			else:
				os.environ["SALES_FORECAST_MODEL_FILE"] = original_model_path

		self.assertEqual(response.status_code, 503)
		data = response.json()
		self.assertFalse(data["success"])
		self.assertEqual(data["errorCode"], "model_not_ready")
		self.assertIn("modelPath", data)
		self.assertEqual(data["modelPath"], str(missing_model_path))

	def test_legacy_prefix_predict_returns_model_not_ready_when_model_file_missing(self):
		missing_model_path = Path(tempfile.gettempdir()) / "emdmp_missing_sales_forecast_model.py"
		original_model_path = os.environ.get("SALES_FORECAST_MODEL_FILE")
		os.environ["SALES_FORECAST_MODEL_FILE"] = str(missing_model_path)

		try:
			client = TestClient(self.app)
			response = client.post("/api/EMDMP/sales-forecast/predict", json=self.payload)
		finally:
			if original_model_path is None:
				os.environ.pop("SALES_FORECAST_MODEL_FILE", None)
			else:
				os.environ["SALES_FORECAST_MODEL_FILE"] = original_model_path

		self.assertEqual(response.status_code, 503)
		data = response.json()
		self.assertFalse(data["success"])
		self.assertEqual(data["errorCode"], "model_not_ready")

	def test_predict_returns_prediction_when_model_file_exists(self):
		model_code = textwrap.dedent(
			"""
			def predict(payload):
			    return {
			        "predictions": [11, 12, 13, 14, 15, 16, 17],
			        "modelVersion": "test-model-v1",
			        "modelLabel": "Unit Test Model",
			    }
			"""
		)

		with tempfile.TemporaryDirectory() as temp_dir:
			model_path = Path(temp_dir) / "sales_forecast_model.py"
			model_path.write_text(model_code, encoding="utf-8")
			original_model_path = os.environ.get("SALES_FORECAST_MODEL_FILE")
			os.environ["SALES_FORECAST_MODEL_FILE"] = str(model_path)

			try:
				client = TestClient(self.app)
				response = client.post("/api/EMDMPAI/sales-forecast/predict", json=self.payload)
			finally:
				if original_model_path is None:
					os.environ.pop("SALES_FORECAST_MODEL_FILE", None)
				else:
					os.environ["SALES_FORECAST_MODEL_FILE"] = original_model_path

		self.assertEqual(response.status_code, 200)
		data = response.json()
		self.assertTrue(data["success"])
		self.assertEqual(data["llmStatus"], "not_applicable")
		self.assertEqual(data["resultSource"], "online_prediction")
		self.assertEqual(data["modelVersion"], "test-model-v1")
		self.assertEqual(data["predPayD1"], 11.0)
		self.assertEqual(data["predPayD7"], 17.0)
		self.assertEqual(data["pred7DPay"], 98.0)
		self.assertEqual(data["featureSnapshot"]["payCnt30D"], 326)

	def test_resolve_default_model_file_path_supports_bbs_package_layout(self):
		from apps.EMDMPAI.apis import sales_forecast_runtime

		with tempfile.TemporaryDirectory() as temp_dir:
			apis_dir = Path(temp_dir) / "models" / "EMDMP" / "apis"
			models_dir = Path(temp_dir) / "models" / "EMDMP" / "models"
			apis_dir.mkdir(parents=True, exist_ok=True)
			models_dir.mkdir(parents=True, exist_ok=True)
			expected_path = models_dir / "sales_forecast_model.py"
			expected_path.write_text("def predict(payload): return {'predictions': [1] * 7}", encoding="utf-8")

			resolved_path = sales_forecast_runtime.resolve_default_model_file_path(
				apis_dir / "sales_forecast_runtime.py"
			)

		self.assertEqual(resolved_path, expected_path)

	def test_resolve_default_model_file_path_prefers_root_models_directory(self):
		from apps.EMDMPAI.apis import sales_forecast_runtime

		with tempfile.TemporaryDirectory() as temp_dir:
			root_dir = Path(temp_dir)
			source_file = root_dir / "fastapi" / "apps" / "EMDMPAI" / "apis" / "sales_forecast_runtime.py"
			source_file.parent.mkdir(parents=True, exist_ok=True)
			source_file.write_text("# runtime placeholder", encoding="utf-8")

			root_models_dir = root_dir / "models" / "EMDMP" / "models"
			root_models_dir.mkdir(parents=True, exist_ok=True)
			expected_path = root_models_dir / "sales_forecast_model.py"
			expected_path.write_text("def predict(payload): return {'predictions': [1] * 7}", encoding="utf-8")

			fallback_models_dir = root_dir / "fastapi" / "apps" / "EMDMPAI" / "models"
			fallback_models_dir.mkdir(parents=True, exist_ok=True)
			(fallback_models_dir / "sales_forecast_model.py").write_text(
				"def predict(payload): return {'predictions': [2] * 7}",
				encoding="utf-8",
			)

			with io.StringIO() as buffer, redirect_stdout(buffer):
				resolved_path = sales_forecast_runtime.resolve_default_model_file_path(source_file)
				output = buffer.getvalue()

		self.assertEqual(resolved_path, expected_path)
		self.assertIn("[SALES_FORECAST_MODEL]", output)
		self.assertIn("source=root_models", output)
		self.assertIn(str(expected_path), output)

	def test_resolve_default_model_file_path_falls_back_to_fastapi_models_directory(self):
		from apps.EMDMPAI.apis import sales_forecast_runtime

		with tempfile.TemporaryDirectory() as temp_dir:
			root_dir = Path(temp_dir)
			source_file = root_dir / "fastapi" / "apps" / "EMDMPAI" / "apis" / "sales_forecast_runtime.py"
			source_file.parent.mkdir(parents=True, exist_ok=True)
			source_file.write_text("# runtime placeholder", encoding="utf-8")

			fallback_models_dir = root_dir / "fastapi" / "apps" / "EMDMPAI" / "models"
			fallback_models_dir.mkdir(parents=True, exist_ok=True)
			expected_path = fallback_models_dir / "sales_forecast_model.py"
			expected_path.write_text("def predict(payload): return {'predictions': [2] * 7}", encoding="utf-8")

			resolved_path = sales_forecast_runtime.resolve_default_model_file_path(source_file)

		self.assertEqual(resolved_path, expected_path)


if __name__ == "__main__":
	unittest.main()
