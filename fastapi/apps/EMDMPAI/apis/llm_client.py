from pathlib import Path
import os
from typing import Any

import httpx
from openai import OpenAI


def get_llm_source() -> str:
    module_path = Path(__file__).resolve()
    if "models" in module_path.parts and "EMDMP" in module_path.parts:
        return "root_models_bundle"
    return "fastapi_fallback"


def log_llm_event(event: str) -> None:
    print(
        f"[LLM_CLIENT] event={event} source={get_llm_source()} "
        f"path={Path(__file__).resolve()} provider={get_llm_provider()} "
        f"model={get_llm_model()} base_url={get_llm_base_url()} "
        f"timeout={get_llm_timeout()} max_retries={get_llm_max_retries()}"
    )


def get_llm_base_url() -> str:
    return os.getenv("OPENAI_BASE_URL", "https://api.siliconflow.cn/v1").rstrip("/")


def get_llm_api_key() -> str:
    return os.getenv("OPENAI_API_KEY", "")


def get_llm_model() -> str:
    return os.getenv("OPENAI_MODEL", "Qwen/Qwen3-8B")


def get_llm_timeout() -> float:
    return float(os.getenv("OPENAI_TIMEOUT_SECONDS", "30"))


def get_llm_max_retries() -> int:
    return int(os.getenv("OPENAI_MAX_RETRIES", "2"))


def get_llm_provider() -> str:
    return os.getenv("OPENAI_PROVIDER", "openai-compatible")


def get_client() -> OpenAI:
    log_llm_event("create_client")
    return OpenAI(
        api_key=get_llm_api_key(),
        base_url=get_llm_base_url(),
        timeout=get_llm_timeout(),
        max_retries=get_llm_max_retries(),
    )


async def probe_llm() -> dict[str, Any]:
    base_url = get_llm_base_url()
    health_path = os.getenv("OPENAI_HEALTHCHECK_PATH", "/models")
    if not health_path.startswith("/"):
        health_path = f"/{health_path}"

    api_key = get_llm_api_key()
    model_name = get_llm_model()
    provider = get_llm_provider()

    if not api_key:
        return {
            "success": False,
            "provider": provider,
            "model": model_name,
            "baseUrl": base_url,
            "message": "OPENAI_API_KEY is empty",
            "details": "Please configure the cloud model API key in .env",
        }

    url = f"{base_url}{health_path}"
    headers = {"Authorization": f"Bearer {api_key}"}

    try:
        async with httpx.AsyncClient(timeout=min(get_llm_timeout(), 15.0)) as client:
            response = await client.get(url, headers=headers)
            response.raise_for_status()

        return {
            "success": True,
            "provider": provider,
            "model": model_name,
            "baseUrl": base_url,
            "message": "Cloud LLM endpoint is reachable",
            "details": None,
        }
    except Exception as exc:  # noqa: BLE001
        return {
            "success": False,
            "provider": provider,
            "model": model_name,
            "baseUrl": base_url,
            "message": "Cloud LLM endpoint is not reachable",
            "details": str(exc),
        }
