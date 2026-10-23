# EMDMP 云端模型托管设计说明

## 目标

在不影响本地开发与调试方式的前提下，让云端部署收敛到 `DemoAPP` 的平台托管模型模式。

- 本地模式继续通过 `python fastapi/main.py` 启动，并提供 `/api/EMDMPAI/*`
- 云端模式不再依赖独立的 `fastapi/main.py`
- 云端模式统一通过平台托管的 `models/EMDMP/apis/*` 暴露 `/api/EMDMP/*`

## 当前现状

- 本地 FastAPI 入口在 `fastapi/main.py`，它会动态加载 `models/EMDMP/apis` 下的接口模块，并统一挂载到 `/api/EMDMPAI`
- 云端使用的 Kesplus SQL 代理函数位于 `.kesplus/sql/**`，当前主要转发到 `http://fastapi:54903/api/EMDMPAI/...`，部分函数还会回退探测 `http://fastapi:54903/api/EMDMP/...`
- `models/EMDMP/apis/sales_forecast_api.py` 当前已经同时具备两类入口：
  - 给本地 FastAPI 使用的 `router`
  - 给平台托管模型使用的 `Model`

## 采用方案

采用“本地和云端职责彻底分离”的方案。

### 本地模式

- 保留 `fastapi/main.py`，继续用于开发者本地启动、页面联调和 FastAPI 单元测试
- 保留 `/api/EMDMPAI/*` 作为本地运行时契约
- 不要求本地去模拟平台托管模型运行方式

### 云端模式

- 将 `models/EMDMP/apis/*` 视为云端唯一运行入口
- 将 Kesplus 云端代理函数统一改为直接调用 `/api/EMDMP/*`
- 去掉云端对 `/api/EMDMPAI/*` 和独立 FastAPI 网关的依赖

## 本次范围

本次改动保持最小范围，只先解决销量预测链路。

- 重点目标：销量预测云端访问链路
- 保持本地 FastAPI 行为不变
- 不重构其他 AI 模块
- 不删除 `fastapi/main.py`

## 实施思路

1. 修改 Kesplus 销量预测代理函数，只保留 `http://fastapi:54903/api/EMDMP/sales-forecast/predict`
2. 去掉当前依赖 `/api/EMDMPAI/*` 的 fallback 或双探测逻辑
3. 增加或调整测试，锁定双模式边界：
   - 本地 FastAPI 仍然暴露 `/api/EMDMPAI/sales-forecast/predict`
   - 云端模型包入口仍然由 `models/EMDMP/apis/sales_forecast_api.py` 提供 `Model`
   - Kesplus 云端代理定义不再指向 `/api/EMDMPAI/*`

## 异常处理原则

- 本地异常继续通过现有 FastAPI 响应结构返回
- 云端异常继续由 Kesplus 代理函数向上返回，但只反映 `/api/EMDMP/*` 这一条链路
- 不再保留“本地契约和云端契约自动互相兜底”的隐式 fallback

## 风险

- 如果云端平台实际上还没有把 `models/EMDMP/apis/apis.json` 注册成 `/api/EMDMP/*`，那么切换后会稳定失败，而不会再被 fallback 掩盖
- 其他 AI 代理函数目前可能仍依赖 `/api/EMDMPAI/*`；本说明本次只承诺先收敛销量预测，除非后续明确扩大范围

## 验证方式

- 运行针对 FastAPI 的最小单元测试，确认本地路由仍然注册在 `/api/EMDMPAI/sales-forecast/predict`
- 运行或补充针对模型包 `Model` 入口的测试，确认平台托管模式仍可加载
- 为 Kesplus 销量预测代理函数增加回归校验，确保其定义中不再使用 `/api/EMDMPAI/*`
- 明确汇报所有无法在本地直接验证的云端前提
