from typing import Any

from fastapi import APIRouter
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from .sales_forecast_runtime import (
	SalesForecastModelInvalidError,
	SalesForecastModelNotReadyError,
	get_model_file_path,
	run_sales_forecast,
)


router = APIRouter()


class SalesForecastPredictRequest(BaseModel):
	itemId: int | str
	anchorDate: str
	horizonDays: int = Field(default=7, ge=1, le=30)
	featureData: dict[str, Any] = Field(default_factory=dict)


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
