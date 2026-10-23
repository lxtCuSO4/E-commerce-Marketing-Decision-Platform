import io
import sys
import tempfile
import textwrap
import unittest
from contextlib import redirect_stdout
from pathlib import Path


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class MainApiLoaderTestCase(unittest.TestCase):
	def test_files_mount_uses_project_root_report_generated(self):
		from main import app

		files_mount = next(route for route in app.routes if getattr(route, "path", "") == "/files")
		expected_dir = FASTAPI_DIR.parent / "report_generated"
		self.assertEqual(Path(files_mount.app.directory), expected_dir)

	def test_import_api_module_prefers_root_models_bundle(self):
		from main import import_api_module

		with tempfile.TemporaryDirectory() as temp_dir:
			temp_root = Path(temp_dir)
			bundle_root = temp_root / "models"
			bundle_apis_dir = bundle_root / "TestBundle" / "apis"
			bundle_apis_dir.mkdir(parents=True, exist_ok=True)
			(bundle_apis_dir / "__init__.py").write_text("", encoding="utf-8")
			(bundle_apis_dir.parent / "__init__.py").write_text("", encoding="utf-8")
			(bundle_apis_dir / "sample_api.py").write_text(
				textwrap.dedent(
					"""
					SOURCE = "bundle"
					"""
				),
				encoding="utf-8",
			)

			with io.StringIO() as buffer, redirect_stdout(buffer):
				module = import_api_module(
					"sample_api",
					bundle_package_root=bundle_root,
					bundle_package_name="TestBundle",
					bundle_apis_dir=bundle_apis_dir,
				)
				output = buffer.getvalue()

		self.assertEqual(module.SOURCE, "bundle")
		self.assertIs(sys.modules["apps.EMDMPAI.apis.sample_api"], module)
		self.assertIn("[AI_API_LOADER]", output)
		self.assertIn("module=sample_api", output)
		self.assertIn("source=root_models_bundle", output)

	def test_import_api_module_falls_back_to_fastapi_package(self):
		from main import import_api_module

		with io.StringIO() as buffer, redirect_stdout(buffer):
			module = import_api_module(
				"sales_forecast_api",
				bundle_package_root=Path("__missing__"),
				bundle_package_name="MissingBundle",
				bundle_apis_dir=Path("__missing__"),
			)
			output = buffer.getvalue()

		self.assertTrue(hasattr(module, "router"))
		self.assertIn("[AI_API_LOADER]", output)
		self.assertIn("module=sales_forecast_api", output)
		self.assertIn("source=fastapi_fallback", output)

	def test_import_api_module_prefers_newer_fastapi_source_over_stale_bundle(self):
		from main import import_api_module

		with tempfile.TemporaryDirectory() as temp_dir:
			temp_root = Path(temp_dir)
			bundle_root = temp_root / "models"
			bundle_apis_dir = bundle_root / "TestBundle" / "apis"
			bundle_apis_dir.mkdir(parents=True, exist_ok=True)
			(bundle_apis_dir / "__init__.py").write_text("", encoding="utf-8")
			(bundle_apis_dir.parent / "__init__.py").write_text("", encoding="utf-8")

			fastapi_root = temp_root / "fastapi_src"
			fastapi_apis_dir = fastapi_root / "apps" / "EMDMPAI" / "apis"
			fastapi_apis_dir.mkdir(parents=True, exist_ok=True)
			(fastapi_root / "apps" / "__init__.py").write_text("", encoding="utf-8")
			(fastapi_root / "apps" / "EMDMPAI" / "__init__.py").write_text("", encoding="utf-8")
			(fastapi_apis_dir / "__init__.py").write_text("", encoding="utf-8")

			bundle_file = bundle_apis_dir / "sample_api.py"
			fastapi_file = fastapi_apis_dir / "sample_api.py"
			bundle_file.write_text('SOURCE = "bundle"\n', encoding="utf-8")
			fastapi_file.write_text('SOURCE = "fastapi"\n', encoding="utf-8")

			stale_timestamp = 1_700_000_000
			fresh_timestamp = stale_timestamp + 60
			bundle_file.touch()
			fastapi_file.touch()
			import os
			os.utime(bundle_file, (stale_timestamp, stale_timestamp))
			os.utime(fastapi_file, (fresh_timestamp, fresh_timestamp))

			original_sys_path = list(sys.path)
			sys.path.insert(0, str(fastapi_root))
			try:
				with io.StringIO() as buffer, redirect_stdout(buffer):
					module = import_api_module(
						"sample_api",
						bundle_package_root=bundle_root,
						bundle_package_name="TestBundle",
						bundle_apis_dir=bundle_apis_dir,
						fallback_module_path=fastapi_file,
					)
					output = buffer.getvalue()
			finally:
				sys.path[:] = original_sys_path
				sys.modules.pop("apps.EMDMPAI.apis.sample_api", None)
				sys.modules.pop("TestBundle.apis.sample_api", None)

		self.assertEqual(module.SOURCE, "fastapi")
		self.assertIn("source=fastapi_fallback", output)


if __name__ == "__main__":
	unittest.main()
