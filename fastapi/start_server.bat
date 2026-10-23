@echo off
setlocal

if exist .env (
  for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if not "%%A"=="" if not "%%A:~0,1%"=="#" set %%A=%%B
  )
)

if "%FASTAPI_HOST%"=="" set FASTAPI_HOST=0.0.0.0
if "%FASTAPI_PORT%"=="" set FASTAPI_PORT=54903

python -m uvicorn main:app --host %FASTAPI_HOST% --port %FASTAPI_PORT%
