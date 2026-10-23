import importlib
import os
import sys
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


FASTAPI_DIR = Path(__file__).resolve().parents[1]
if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))


class MainCorsTestCase(unittest.TestCase):
	def _load_main_module(self, cors_env: str | None = None):
		module_name = "main"
		previous = os.environ.get("FASTAPI_CORS_ALLOW_ORIGINS")
		try:
			if cors_env is None:
				os.environ.pop("FASTAPI_CORS_ALLOW_ORIGINS", None)
			else:
				os.environ["FASTAPI_CORS_ALLOW_ORIGINS"] = cors_env

			if module_name in sys.modules:
				del sys.modules[module_name]

			return importlib.import_module(module_name)
		finally:
			if previous is None:
				os.environ.pop("FASTAPI_CORS_ALLOW_ORIGINS", None)
			else:
				os.environ["FASTAPI_CORS_ALLOW_ORIGINS"] = previous

	def _preflight(self, app, origin: str):
		client = TestClient(app)
		return client.options(
			"/api/EMDMPAI/health",
			headers={
				"Origin": origin,
				"Access-Control-Request-Method": "GET",
				"Access-Control-Request-Headers": "content-type,kes-token",
			},
		)

	def test_preflight_allows_deployed_origin(self):
		main = self._load_main_module()

		response = self._preflight(main.app, "http://139.196.38.53:9011")

		self.assertEqual(response.status_code, 200)
		self.assertEqual(
			response.headers.get("access-control-allow-origin"),
			"http://139.196.38.53:9011",
		)

	def test_preflight_allows_localhost_development_origin(self):
		main = self._load_main_module()

		response = self._preflight(main.app, "http://localhost:5173")

		self.assertEqual(response.status_code, 200)
		self.assertEqual(
			response.headers.get("access-control-allow-origin"),
			"http://localhost:5173",
		)

	def test_preflight_allows_fastapi_hostname_origin(self):
		main = self._load_main_module()

		response = self._preflight(main.app, "http://fastapi:9011")

		self.assertEqual(response.status_code, 200)
		self.assertEqual(
			response.headers.get("access-control-allow-origin"),
			"http://fastapi:9011",
		)

	def test_preflight_allows_private_lan_origin(self):
		main = self._load_main_module()

		response = self._preflight(main.app, "http://192.168.1.25:9011")

		self.assertEqual(response.status_code, 200)
		self.assertEqual(
			response.headers.get("access-control-allow-origin"),
			"http://192.168.1.25:9011",
		)

	def test_preflight_rejects_unknown_origin(self):
		main = self._load_main_module()

		response = self._preflight(main.app, "https://example.com")

		self.assertNotEqual(
			response.headers.get("access-control-allow-origin"),
			"https://example.com",
		)

	def test_preflight_allows_configured_extra_origin(self):
		main = self._load_main_module("https://api.example.com, https://app.example.com")

		response = self._preflight(main.app, "https://app.example.com")

		self.assertEqual(response.status_code, 200)
		self.assertEqual(
			response.headers.get("access-control-allow-origin"),
			"https://app.example.com",
		)


if __name__ == "__main__":
	unittest.main()
