import importlib
import importlib.util
from pathlib import Path
import os
import sys

from dotenv import load_dotenv
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
import uvicorn


BASE_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = BASE_DIR.parent
MODELS_PACKAGE_ROOT = PROJECT_ROOT / "models"
MODELS_BUNDLE_PACKAGE = "EMDMP"
MODELS_BUNDLE_APIS_DIR = MODELS_PACKAGE_ROOT / MODELS_BUNDLE_PACKAGE / "apis"
DEFAULT_CORS_ALLOWED_ORIGINS = [
    "http://139.196.38.53:9011",
    "http://localhost:5173",
    "http://127.0.0.1:5173",
    "http://localhost:9011",
    "http://127.0.0.1:9011",
]
DEFAULT_CORS_ALLOWED_ORIGIN_REGEX = (
    r"^https?://("
    r"localhost"
    r"|127\.0\.0\.1"
    r"|0\.0\.0\.0"
    r"|fastapi"
    r"|10(?:\.\d{1,3}){3}"
    r"|172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2}"
    r"|192\.168(?:\.\d{1,3}){2}"
    r")(?::\d+)?$"
)


def get_cors_allowed_origins() -> list[str]:
    configured = os.getenv("FASTAPI_CORS_ALLOW_ORIGINS", "")
    origins = {
        origin.strip()
        for origin in configured.split(",")
        if origin and origin.strip()
    }
    origins.update(DEFAULT_CORS_ALLOWED_ORIGINS)
    return sorted(origins)


def get_cors_allowed_origin_regex() -> str:
    configured = os.getenv("FASTAPI_CORS_ALLOW_ORIGIN_REGEX", "").strip()
    return configured or DEFAULT_CORS_ALLOWED_ORIGIN_REGEX


def _load_module_from_path(module_key: str, module_path: Path):
    module_name = f"emdmp_runtime_{module_key}_{abs(hash(str(module_path)))}"
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    if spec is None or spec.loader is None:
        raise ImportError(f"Unable to create import spec for {module_path}")

    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    sys.modules[f"apps.EMDMPAI.apis.{module_key}"] = module
    return module


def _pick_api_source(bundle_module_path: Path, fallback_module_path: Path) -> str:
    preferred_source = os.getenv("EMDMP_API_SOURCE", "auto").strip().lower()
    if preferred_source == "bundle":
        return "bundle" if bundle_module_path.exists() else "fallback"
    if preferred_source == "fastapi":
        return "fallback"

    if bundle_module_path.exists() and fallback_module_path.exists():
        return (
            "fallback"
            if fallback_module_path.stat().st_mtime >= bundle_module_path.stat().st_mtime
            else "bundle"
        )

    return "bundle" if bundle_module_path.exists() else "fallback"


def import_api_module(
    module_name: str,
    bundle_package_root: Path = MODELS_PACKAGE_ROOT,
    bundle_package_name: str = MODELS_BUNDLE_PACKAGE,
    bundle_apis_dir: Path = MODELS_BUNDLE_APIS_DIR,
    fallback_module_path: Path | None = None,
):
    bundle_module_path = bundle_apis_dir / f"{module_name}.py"
    resolved_fallback_module_path = fallback_module_path or (
        BASE_DIR / "apps" / "EMDMPAI" / "apis" / f"{module_name}.py"
    )
    selected_source = _pick_api_source(bundle_module_path, resolved_fallback_module_path)

    if selected_source == "bundle" and bundle_module_path.exists():
        package_root_text = str(bundle_package_root)
        if package_root_text not in sys.path:
            sys.path.insert(0, package_root_text)
        module = importlib.import_module(f"{bundle_package_name}.apis.{module_name}")
        sys.modules[f"apps.EMDMPAI.apis.{module_name}"] = module
        print(
            f"[AI_API_LOADER] module={module_name} source=root_models_bundle "
            f"path={bundle_module_path}"
        )
        return module

    print(
        f"[AI_API_LOADER] module={module_name} source=fastapi_fallback "
        f"path={resolved_fallback_module_path}"
    )
    if fallback_module_path is not None:
        return _load_module_from_path(module_name, resolved_fallback_module_path)
    return importlib.import_module(f"apps.EMDMPAI.apis.{module_name}")


competitor_analysis_router = import_api_module("competitor_analysis_api").router
marketing_copy_router = import_api_module("marketing_copy_api").router
product_qa_router = import_api_module("product_qa_api").router
recommend_router = import_api_module("recommend_api").router
report_router = import_api_module("report_api").router
sales_forecast_router = import_api_module("sales_forecast_api").router
user_behavior_diagnosis_router = import_api_module("user_behavior_diagnosis_api").router

load_dotenv(BASE_DIR / ".env")

app = FastAPI(
    title="EMDMP AI Runtime",
    description="FastAPI gateway for local open-source LLM integration in EMDMP",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=get_cors_allowed_origins(),
    allow_origin_regex=get_cors_allowed_origin_regex(),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

generated_dir = PROJECT_ROOT / "report_generated"
generated_dir.mkdir(parents=True, exist_ok=True)

app.mount("/files", StaticFiles(directory=str(generated_dir)), name="files")

app.include_router(competitor_analysis_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(marketing_copy_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(product_qa_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(recommend_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(report_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(sales_forecast_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])
app.include_router(sales_forecast_router, prefix="/api/EMDMP", tags=["EMDMP"])
app.include_router(user_behavior_diagnosis_router, prefix="/api/EMDMPAI", tags=["EMDMPAI"])


@app.get("/")
async def root():
    return {
        "success": True,
        "service": "EMDMP AI Runtime",
        "model": os.getenv("OPENAI_MODEL", "qwen3:8b"),
    }


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    print(f"[ERROR] 请求验证失败: {exc.errors()}")
    body = await request.body()
    print(f"[ERROR] 请求体: {body.decode('utf-8', errors='ignore')[:1000]}")
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors(), "message": "请求参数验证失败"}
    )


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host=os.getenv("FASTAPI_HOST", "0.0.0.0"),
        port=int(os.getenv("FASTAPI_PORT", "54903")),
        reload=False,
    )
