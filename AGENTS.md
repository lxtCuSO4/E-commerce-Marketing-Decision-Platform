# EMDMP 项目协作手册

本文件面向进入 `EMDMP` 仓库执行任务的 coding agent。目标是让代理基于当前仓库真实状态开展工作，优先做最小、安全、可验证的改动，并避免误伤已有未提交内容。

## 1. 项目概览

- 本仓库是双栈项目：
  - 前端主应用：`Vue 3 + Vite + Kesplus`
  - 后端 AI 网关：`FastAPI`
- 当前主要业务模块：
  - 登录：`src/views/login`
  - 数据导入：`src/views/data-import-module`
  - 销量预测：`src/views/sales-predict-module`
  - AI 模块：`src/views/ai-module`
  - 运营分析：`src/views/b-operations-module`
- 当前 AI 模块已落地 4 个页面：
  - `src/views/ai-module/intelligent-recommendation-report`
  - `src/views/ai-module/ai-competitor-analysis`
  - `src/views/ai-module/ai-product-qa`
  - `src/views/ai-module/user-behavior-analysis`
- 当前项目的 AI 能力不是纯前端能力，而是前端页面、Kesplus 业务接口、FastAPI 网关、模型包和数据库能力协同完成。

## 2. 关键入口与目录职责

### 2.1 前端

- 运行时入口、菜单、白名单、补丁路由：`src/app.jsx`
- 菜单与侧栏工具：`src/utils/layout-runtime.js`
- 全局样式：`src/global.scss`
- AI 地址解析：`src/views/ai-module/utils/fastapi-url.js`
- 页面主目录：`src/views`

### 2.2 AI 页面与工具层

- 智能推荐与报告：
  - `src/views/ai-module/intelligent-recommendation-report/index.vue`
  - `src/views/ai-module/intelligent-recommendation-report/utils/intelligent-recommendation-report-api.js`
  - `src/views/ai-module/intelligent-recommendation-report/utils/single-selection.js`
- 竞品智能分析：
  - `src/views/ai-module/ai-competitor-analysis/index.vue`
  - `src/views/ai-module/ai-competitor-analysis/utils/ai-competitor-analysis-api.js`
  - `src/views/ai-module/ai-competitor-analysis/utils/ai-competitor-analysis-helpers.js`
- 商品问答助手：
  - `src/views/ai-module/ai-product-qa/index.vue`
  - `src/views/ai-module/ai-product-qa/utils/ai-product-qa-api.js`
  - `src/views/ai-module/ai-product-qa/utils/chat-experience.js`
  - `src/views/ai-module/ai-product-qa/utils/product-qa-retry.js`
- 用户行为分析：
  - `src/views/ai-module/user-behavior-analysis/index.vue`
  - `src/views/ai-module/user-behavior-analysis/utils/user-behavior-analysis-api.js`
  - `src/views/ai-module/user-behavior-analysis/utils/single-selection.js`
- AI 通用工具：
  - `src/views/ai-module/utils/fastapi-url.js`
  - `src/views/ai-module/utils/ai-response-normalizer.js`

### 2.3 后端

- FastAPI 服务入口：`fastapi/main.py`
- FastAPI 回退接口目录：`fastapi/apps/EMDMPAI/apis`
- 当前核心接口文件：
  - `fastapi/apps/EMDMPAI/apis/recommend_api.py`
  - `fastapi/apps/EMDMPAI/apis/report_api.py`
  - `fastapi/apps/EMDMPAI/apis/marketing_copy_api.py`
  - `fastapi/apps/EMDMPAI/apis/competitor_analysis_api.py`
  - `fastapi/apps/EMDMPAI/apis/product_qa_api.py`
  - `fastapi/apps/EMDMPAI/apis/sales_forecast_api.py`
  - `fastapi/apps/EMDMPAI/apis/sales_forecast_runtime.py`
  - `fastapi/apps/EMDMPAI/apis/user_behavior_diagnosis_api.py`
  - `fastapi/apps/EMDMPAI/apis/llm_client.py`
- 本地测试目录：`fastapi/tests`
- 环境变量文件：`fastapi/.env`
- 环境变量示例：`fastapi/.env.example`
- 本地虚拟环境：`fastapi/.venv`

### 2.4 模型包与部署镜像

- 当前项目根目录下存在模型包目录：`models/EMDMP`
- 当前模型包内的运行态接口目录：`models/EMDMP/apis`
- 当前模型包内的销量预测模型目录：`models/EMDMP/models`
- 当前模型包接口清单：`models/EMDMP/apis/apis.json`
- `fastapi/main.py` 的 `EMDMP_API_SOURCE=auto` 会比较模型包和 fallback 文件修改时间，同时间或 fallback 更新时选择 fallback；显式设置 `bundle` 或 `fastapi` 可固定来源。恢复项目时应在启动前通过进程环境变量设置来源。

### 2.5 生成物与慎改区域

- 报告与 PDF 当前静态目录：`report_generated`
- 谨慎处理以下内容：
  - `fastapi/.env`
  - `fastapi/.venv`
  - `report_generated`
  - `fastapi/apps/EMDMPAI/logs`
  - `fastapi/apps/EMDMPAI/models`
  - `models/EMDMP/models`
  - `.kesplus`
- 除非任务明确要求，不要清理模型文件、生成文件、虚拟环境、缓存或用户本地数据。

## 3. 当前前端页面结构

### 3.1 登录

- 登录页：`src/views/login/index.vue`

### 3.2 数据导入模块

- 商品基础信息：
  - 列表页：`src/views/data-import-module/rec-tmall-item-base/index.vue`
  - 详情页：`src/views/data-import-module/rec-tmall-item-base/detail.vue`
  - 表单页：`src/views/data-import-module/rec-tmall-item-base/form.vue`
- 商品销量信息：
  - 列表页：`src/views/data-import-module/rec-tmall-item-sales/index.vue`
  - 表单页：`src/views/data-import-module/rec-tmall-item-sales/form.vue`
- 商品相似度信息：
  - 列表页：`src/views/data-import-module/rec-tmall-item-similarity/index.vue`
  - 表单页：`src/views/data-import-module/rec-tmall-item-similarity/form.vue`

### 3.3 销量预测模块

- 预测特征页：
  - `src/views/sales-predict-module/rec-tmall-sales-forecast-feature/index.vue`
  - `src/views/sales-predict-module/rec-tmall-sales-forecast-feature/form.vue`
- 预测结果页：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/index.vue`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/detail.vue`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/form.vue`
- 预测结果工具层：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/rec-sales-forecast-predictions-api.js`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/online-prediction-cache.js`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/prediction-detail-state.js`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/single-prediction-selection.js`

### 3.4 AI 模块

- 智能推荐与报告：`/ai-module/intelligent-recommendation-report`
- 竞品智能分析：`/ai-module/ai-competitor-analysis`
- 商品问答助手：`/ai-module/ai-product-qa`
- 用户行为分析：`/ai-module/user-behavior-analysis`

### 3.5 运营分析模块

- 运营总览与商家诊断：`/b-operations-module/overview-merchant-diagnostics`
- 用户运营与召回：`/b-operations-module/user-operations-recall`

## 4. 当前 AI 模块现状

### 4.1 智能推荐与报告

- 页面入口：`/ai-module/intelligent-recommendation-report`
- 推荐候选查询：走业务接口 `/AiModule/itemRecommendationCandidates`
- 当前 FastAPI 相关接口：
  - `POST /api/EMDMPAI/generate-report`
  - `POST /api/EMDMPAI/generate-report-pdf`
  - `POST /api/EMDMPAI/generate-report/start`
  - `GET /api/EMDMPAI/generate-report/tasks/{task_id}`
  - `POST /api/EMDMPAI/generate-marketing-copy`
- 页面工具层包含单选控制逻辑与测试：
  - `single-selection.js`
  - `single-selection.test.mjs`

### 4.2 竞品智能分析

- 页面入口：`/ai-module/ai-competitor-analysis`
- 当前数据来源：
  - `/DataImportModule/item`
  - `/DataImportModule/itemSimilarity`
  - `/DataImportModule/itemSales`
  - `/SalesPredictModule/salesForecastFeature`
  - `/SalesPredictModule/salesForecastPredictions`
- 当前 FastAPI 接口：
  - `POST /api/EMDMPAI/competitor-analysis`
  - `POST /api/EMDMPAI/competitor-analysis/start`
  - `GET /api/EMDMPAI/competitor-analysis/tasks/{task_id}`
- 页面保留本地规则分析与 AI 失败 fallback，不会整块空白。

### 4.3 商品问答助手

- 页面入口：`/ai-module/ai-product-qa`
- 当前页面为单栏聊天窗口。
- 当前调用链路：
  - 先走业务代理 `/AiModule/productQaChatProxy`
  - 当前聊天页面没有接入直连自动重试；代理失败时显示回退提示。后端仍提供 `POST /api/EMDMPAI/product-qa/chat`。
  - 当前前端热门问题工具返回空列表，由页面采用本地预设问题；后端仍提供 `GET /api/EMDMPAI/product-qa/hot-questions`。
- 当前前端传输层会对问题文本、会话消息和商品上下文做 Base64 编码，避免中文在代理链路中损坏。
- 当前后端链路包含意图识别、锚点识别、只读 SQL 构造、数据库查询与自然语言回答。

### 4.4 用户行为分析

- 页面入口：`/ai-module/user-behavior-analysis`
- 当前支持两种视角：
  - 商品视角
  - 商家视角
- 当前业务接口：
  - `/AiModule/userBehaviorAnalysisSummaryV2`
  - `/AiModule/userBehaviorAnalysisByPageV2`
  - 兜底：`/AiModule/itemRecommendationCandidates`
- 当前增强诊断链路优先走业务代理：
  - `/AiModule/generateUserBehaviorDiagnosisProxy`
  - `/AiModule/startGenerateUserBehaviorDiagnosisProxy`
  - `/AiModule/getGenerateUserBehaviorDiagnosisTaskProxy`
- 对应 FastAPI 接口：
  - `POST /api/EMDMPAI/generate-user-behavior-diagnosis`
  - `POST /api/EMDMPAI/generate-user-behavior-diagnosis/start`
  - `GET /api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}`

## 5. FastAPI 当前运行方式

### 5.1 路由注册

- 所有 AI 路由都在 `fastapi/main.py` 中集中注册。
- 当前已注册的 router：
  - `competitor_analysis_router`
  - `marketing_copy_router`
  - `product_qa_router`
  - `recommend_router`
  - `report_router`
  - `sales_forecast_router`
  - `user_behavior_diagnosis_router`

### 5.2 当前已注册接口

- `GET /api/EMDMPAI/health`
- `POST /api/EMDMPAI/recommend-items`
- `POST /api/EMDMPAI/generate-report`
- `POST /api/EMDMPAI/generate-report-pdf`
- `POST /api/EMDMPAI/generate-report/start`
- `GET /api/EMDMPAI/generate-report/tasks/{task_id}`
- `POST /api/EMDMPAI/generate-marketing-copy`
- `POST /api/EMDMPAI/competitor-analysis`
- `POST /api/EMDMPAI/competitor-analysis/start`
- `GET /api/EMDMPAI/competitor-analysis/tasks/{task_id}`
- `POST /api/EMDMPAI/product-qa/chat`
- `GET /api/EMDMPAI/product-qa/hot-questions`
- `POST /api/EMDMPAI/sales-forecast/predict`
- `POST /api/EMDMPAI/generate-user-behavior-diagnosis`
- `POST /api/EMDMPAI/generate-user-behavior-diagnosis/start`
- `GET /api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}`

### 5.3 FastAPI 端口、跨域与静态目录

- 默认 host：`0.0.0.0`
- 默认 port：`54903`
- 当前启用了 `CORSMiddleware`
- 默认允许的跨域来源至少包括：
  - `http://139.196.38.53:9011`
  - `http://localhost:5173`
  - `http://127.0.0.1:5173`
  - `http://localhost:9011`
  - `http://127.0.0.1:9011`
- 当前挂载了静态文件目录：
  - 路径：`/files`
  - 实际目录：`report_generated`

### 5.4 前端 FastAPI 地址解析

- 当前 `src/views/ai-module/utils/fastapi-url.js` 的解析顺序为：
  1. `globalThis.__EMDMP_FASTAPI_BASE_URL`
  2. `globalThis.__KESPLUS_FASTAPI_BASE_URL`
  3. 使用当前浏览器的 `protocol + hostname + :54903`
  4. 默认回退 `http://127.0.0.1:54903`
- 当前实现不是直接使用 `window.location.origin`，也不是默认回退到 `http://fastapi:54903`。

## 6. 模型、销量预测与部署路径

- 销量预测对外接口：`POST /api/EMDMPAI/sales-forecast/predict`
- 运行时入口优先位于：`models/EMDMP/apis/sales_forecast_runtime.py`
- 当前优先加载的模型文件位于：
  - `models/EMDMP/models/sales_forecast_model.py`
  - `models/EMDMP/models/sales_forecast_lightgbm.pkl`
  - `models/EMDMP/models/sales_forecast_feature_columns.json`
  - `models/EMDMP/models/sales_forecast_categorical_columns.json`
- 若模型包缺少对应文件，才回退到：
  - `fastapi/apps/EMDMPAI/apis/sales_forecast_runtime.py`
  - `fastapi/apps/EMDMPAI/models/...`

## 7. 当前测试与验证入口

### 7.1 前端

- 常用命令：
  - `npm run dev`
  - `npm run build`
  - `npm run test`
- 当前可见的 AI 相关轻量测试包括：
  - `src/views/ai-module/intelligent-recommendation-report/utils/intelligent-recommendation-report-api.test.mjs`
  - `src/views/ai-module/intelligent-recommendation-report/utils/single-selection.test.mjs`
  - `src/views/ai-module/ai-competitor-analysis/utils/ai-competitor-analysis-api.test.mjs`
  - `src/views/ai-module/ai-competitor-analysis/utils/ai-competitor-analysis-helpers.test.mjs`
  - `src/views/ai-module/ai-product-qa/utils/ai-product-qa-api.test.mjs`
  - `src/views/ai-module/ai-product-qa/utils/chat-experience.test.mjs`
  - `src/views/ai-module/user-behavior-analysis/utils/single-selection.test.mjs`
  - `src/views/ai-module/user-behavior-analysis/utils/user-behavior-analysis-api.test.mjs`
  - `src/views/ai-module/utils/ai-response-normalizer.test.mjs`
  - `src/views/ai-module/utils/fastapi-path-prefix.test.mjs`
  - `src/views/ai-module/utils/fastapi-url.test.mjs`
  - `src/views/ai-module/utils/model-proxy-routes.test.mjs`
- 当前销量预测页面轻量测试包括：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/online-prediction-cache.test.mjs`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/prediction-detail-state.test.mjs`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/rec-sales-forecast-predictions-api.test.mjs`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/single-prediction-selection.test.mjs`

### 7.2 后端

- 常用命令：
  - `python main.py`
  - `python -m unittest discover -s tests -p "test_*.py"`
  - `python -m py_compile main.py`
- 当前测试至少包括：
  - `test_competitor_analysis_api.py`
  - `test_llm_client_logging.py`
  - `test_main_api_loader.py`
  - `test_main_cors.py`
  - `test_main_prefix.py`
  - `test_marketing_copy_api.py`
  - `test_models_bundle_imports.py`
  - `test_product_qa_api.py`
  - `test_report_api.py`
  - `test_sales_forecast_api.py`
  - `test_sales_forecast_kesplus_proxy.py`
  - `test_user_behavior_diagnosis_api.py`

## 8. 开发规则

### 8.1 先读现状，再改代码

- 修改前先判断任务涉及前端、后端还是二者联动。
- 不要只改页面不看接口，也不要只改接口不看前端调用方式。
- 涉及 AI 报告、营销文案、竞品分析、商品问答、用户行为分析、销量预测时，默认这是前后端联动任务。

### 8.2 保护已有未提交内容

- 当前仓库长期处于脏工作区状态。
- 永远先看 `git status`，理解已有改动后再动手。
- 不要覆盖、回滚、重排或格式化与你任务无关的改动。
- 不要使用破坏性命令，例如：
  - `git reset --hard`
  - `git checkout -- <file>`
  - 批量删除未跟踪目录

### 8.3 保持最小改动

- 优先沿用现有目录结构、命名方式与 API 工具层。
- 不要因为“更规范”而擅自重构整个项目。
- 如果只是更新文档，优先同步真实现状，不要顺手改业务实现。

### 8.4 AI 相关联动检查

- 变更 `src/views/ai-module` 页面时，同时检查：
  - `src/app.jsx`
  - 对应 `utils/*-api.js`
  - `src/views/ai-module/utils/fastapi-url.js`
  - 对应 FastAPI 接口文件
- 变更 FastAPI AI 接口时，同时检查：
  - `fastapi/main.py`
  - `models/EMDMP/apis/apis.json`
  - `models/EMDMP/apis` 与 `fastapi/apps/EMDMPAI/apis` 的镜像关系
  - `report_generated` 输出目录与 `/files/...` 访问路径
  - 若涉及预测接口，`models/EMDMP/models` 与 fallback 模型目录是否仍兼容

### 8.5 编码与乱码风险

- 项目中部分文件历史上出现过中文乱码。
- 处理中文文案、菜单标题、异常信息时，优先做最小范围修复。
- 若任务不是专门修复编码问题，不要顺手批量转码整个仓库。

## 9. 推荐工作顺序

1. 阅读相关目录与入口文件。
2. 查看 `git status`，识别已有未提交改动。
3. 仅在必要范围内修改代码或文档。
4. 运行与任务强相关的最小验证。
5. 汇报改动内容、验证结果、未验证风险。

## 10. 汇报要求

- 优先说明：
  - 改了什么
  - 为什么改
  - 做了哪些验证
  - 哪些内容因为环境或范围限制未验证
- 若发现任务被脏工作区、环境变量缺失、旧 FastAPI 进程、数据库连接失败、模型文件缺失、接口不一致或编码异常阻塞，要明确指出，不要假装完成。

## 11. 快速判断表

- 如果任务提到菜单、访问入口、页面挂载：先看 `src/app.jsx`
- 如果任务提到智能推荐与报告：前端页面、工具层、`report_api.py`、`marketing_copy_api.py` 都要看
- 如果任务提到竞品智能分析：页面、`ai-competitor-analysis-api.js`、`ai-competitor-analysis-helpers.js`、`competitor_analysis_api.py` 都要看
- 如果任务提到商品问答助手：页面、`ai-product-qa-api.js`、`product_qa_api.py`、`llm_client.py`、金仓配置都要看
- 如果任务提到用户行为分析：页面、`user-behavior-analysis-api.js`、`user_behavior_diagnosis_api.py`、业务代理接口都要看
- 如果任务提到销量预测在线推理：重点看 `rec-sales-forecast-predictions` 页面工具层、`sales_forecast_api.py`、`sales_forecast_runtime.py`、`models/EMDMP/models`
- 如果任务提到模型包或部署包：重点看 `models/EMDMP/apis`、`models/EMDMP/models`、`fastapi/main.py` 的动态加载逻辑
