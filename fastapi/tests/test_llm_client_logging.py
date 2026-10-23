import io
import os
import sys
import unittest
from contextlib import redirect_stdout
from pathlib import Path


FASTAPI_DIR = Path(__file__).resolve().parents[1]
PROJECT_ROOT = FASTAPI_DIR.parent
MODELS_PACKAGE_ROOT = PROJECT_ROOT / "models"

if str(FASTAPI_DIR) not in sys.path:
	sys.path.insert(0, str(FASTAPI_DIR))
if str(MODELS_PACKAGE_ROOT) not in sys.path:
	sys.path.insert(0, str(MODELS_PACKAGE_ROOT))


class LlmClientLoggingTestCase(unittest.TestCase):
	def test_root_models_llm_client_logs_bundle_source(self):
		from EMDMP.apis import llm_client

		original_base_url = os.environ.get("OPENAI_BASE_URL")
		original_model = os.environ.get("OPENAI_MODEL")
		original_provider = os.environ.get("OPENAI_PROVIDER")

		os.environ["OPENAI_BASE_URL"] = "https://example.invalid/v1"
		os.environ["OPENAI_MODEL"] = "test-model"
		os.environ["OPENAI_PROVIDER"] = "test-provider"

		try:
			with io.StringIO() as buffer, redirect_stdout(buffer):
				client = llm_client.get_client()
				output = buffer.getvalue()
		finally:
			if original_base_url is None:
				os.environ.pop("OPENAI_BASE_URL", None)
			else:
				os.environ["OPENAI_BASE_URL"] = original_base_url
			if original_model is None:
				os.environ.pop("OPENAI_MODEL", None)
			else:
				os.environ["OPENAI_MODEL"] = original_model
			if original_provider is None:
				os.environ.pop("OPENAI_PROVIDER", None)
			else:
				os.environ["OPENAI_PROVIDER"] = original_provider

		self.assertIsNotNone(client)
		self.assertIn("[LLM_CLIENT]", output)
		self.assertIn("event=create_client", output)
		self.assertIn("source=root_models_bundle", output)
		self.assertIn("base_url=https://example.invalid/v1", output)
		self.assertIn("model=test-model", output)
		self.assertIn("provider=test-provider", output)

	def test_fastapi_llm_client_logs_fallback_source(self):
		from apps.EMDMPAI.apis import llm_client

		original_base_url = os.environ.get("OPENAI_BASE_URL")
		original_model = os.environ.get("OPENAI_MODEL")
		original_provider = os.environ.get("OPENAI_PROVIDER")

		os.environ["OPENAI_BASE_URL"] = "https://fallback.invalid/v1"
		os.environ["OPENAI_MODEL"] = "fallback-model"
		os.environ["OPENAI_PROVIDER"] = "fallback-provider"

		try:
			with io.StringIO() as buffer, redirect_stdout(buffer):
				client = llm_client.get_client()
				output = buffer.getvalue()
		finally:
			if original_base_url is None:
				os.environ.pop("OPENAI_BASE_URL", None)
			else:
				os.environ["OPENAI_BASE_URL"] = original_base_url
			if original_model is None:
				os.environ.pop("OPENAI_MODEL", None)
			else:
				os.environ["OPENAI_MODEL"] = original_model
			if original_provider is None:
				os.environ.pop("OPENAI_PROVIDER", None)
			else:
				os.environ["OPENAI_PROVIDER"] = original_provider

		self.assertIsNotNone(client)
		self.assertIn("[LLM_CLIENT]", output)
		self.assertIn("event=create_client", output)
		self.assertIn("source=fastapi_fallback", output)
		self.assertIn("base_url=https://fallback.invalid/v1", output)
		self.assertIn("model=fallback-model", output)
		self.assertIn("provider=fallback-provider", output)


if __name__ == "__main__":
	unittest.main()
