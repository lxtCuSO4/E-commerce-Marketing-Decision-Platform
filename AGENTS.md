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
- AI 能力链路通常不是纯前端任务，常涉及：
  - 页面交互与状态管理
  - `src/app.jsx` 中的菜单、白名单与路由挂载
  - `src/views/ai-module/utils/fastapi-url.js` 中的 FastAPI 地址解析
  - 金仓业务接口
  - FastAPI `/api/EMDMPAI/*` 接口
  - `fastapi/.env` 中的模型、数据库与服务配置
  - `fastapi/apps/EMDMPAI/generated` 下的 PDF 等生成文件
  - `fastapi/apps/EMDMPAI/models` 下的预测模型文件

## 2. 关键入口与目录职责

### 2.1 前端

- 运行时入口、菜单、路由配置：`src/app.jsx`
- 构建配置：`.kesplus.js`
- 通用布局运行时工具：`src/utils/layout-runtime.js`
- 页面主目录：`src/views`
- AI 页面目录：`src/views/ai-module`
- AI 通用工具：
  - `src/views/ai-module/utils/fastapi-url.js`
- 公共样式：`src/global.scss`

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
- 用户行为分析：
  - `src/views/ai-module/user-behavior-analysis/index.vue`
  - `src/views/ai-module/user-behavior-analysis/utils/user-behavior-analysis-api.js`

### 2.3 后端

- FastAPI 服务入口：`fastapi/main.py`
- 后端接口实现目录：`fastapi/apps/EMDMPAI/apis`
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
- 接口清单：`fastapi/apps/EMDMPAI/apis/apis.json`
- 生成文件目录：`fastapi/apps/EMDMPAI/generated`
- 模型目录：`fastapi/apps/EMDMPAI/models`
- 日志目录：`fastapi/apps/EMDMPAI/logs`
- 本地虚拟环境：`fastapi/.venv`
- 环境变量文件：`fastapi/.env`
- 环境变量示例：`fastapi/.env.example`
- 测试目录：`fastapi/tests`

### 2.4 可改与慎改区域

- 常规需求通常落在：
  - `src/views/...`
  - `src/app.jsx`
  - `src/views/ai-module/utils/...`
  - `fastapi/apps/EMDMPAI/apis/...`
  - `fastapi/main.py`
  - `fastapi/tests/...`
- 谨慎处理以下内容：
  - `fastapi/.env`
  - `fastapi/.venv`
  - `fastapi/apps/EMDMPAI/generated`
  - `fastapi/apps/EMDMPAI/logs`
  - `fastapi/apps/EMDMPAI/models`
  - `.kesplus` 下的缓存、SQL 产物、会话文件
- 除非任务明确要求，不要清理或重置用户已有生成文件、本地环境、模型文件或临时数据。

## 3. 当前 AI 模块现状

### 3.1 智能推荐与报告

- 页面入口：`/ai-module/intelligent-recommendation-report`
- 菜单、白名单、路由都挂在 `src/app.jsx`
- 当前页面链路：
  - 推荐候选查询：走业务接口 `/AiModule/itemRecommendationCandidates`
  - 商业报告预览：前端调用 FastAPI `POST /api/EMDMPAI/generate-report`
  - PDF 下载：前端调用 FastAPI `POST /api/EMDMPAI/generate-report-pdf`
  - 营销文案生成：前端调用 FastAPI `POST /api/EMDMPAI/generate-marketing-copy`
- 当前页面工具层包含单选控制逻辑与对应测试：
  - `single-selection.js`
  - `single-selection.test.mjs`
- 页面中已有模型生成 loading 提示，文案统一为 `大模型生成中`
- 营销文案已集成在页面内，不是独立子页面

### 3.2 竞品智能分析

- 页面入口：`/ai-module/ai-competitor-analysis`
- 菜单、白名单、路由都挂在 `src/app.jsx`
- 当前页面链路：
  - 先按商品标题关键字搜索主商品候选
  - 用户选定主商品后，基于 `itemId` 拉取竞品相似度
  - 再补齐商品基础信息、销量、预测趋势
  - 页面先展示本地规则分析
  - 用户点击 `AI 深度解读` 后再调用 FastAPI
- 当前数据来源：
  - `/DataImportModule/item`
  - `/DataImportModule/itemSimilarity`
  - `/DataImportModule/itemSales`
  - `/SalesPredictModule/salesForecastFeature`
  - `/SalesPredictModule/salesForecastPredictions`
- 当前 AI 深度解读接口：
  - `POST /api/EMDMPAI/competitor-analysis`
- 页面已有 fallback：
  - AI 失败时仍会展示本地规则分析
  - 不会整块空白
- 如果再次出现图谱图例或规则文案乱码，优先检查 `ai-competitor-analysis-helpers.js`

### 3.3 商品问答助手

- 页面入口：`/ai-module/ai-product-qa`
- 菜单、白名单、路由都挂在 `src/app.jsx`
- 当前页面是单栏聊天窗口，风格接近 ChatGPT
- 当前页面只展示聊天正文，不单独展示命中模块、命中表、SQL 摘要等调试信息
- 当前后端链路不是纯模型闲聊，而是：
  1. 前端发送自然语言问题到 FastAPI
  2. FastAPI 识别问题意图和锚点
  3. FastAPI 根据白名单模板生成只读 SQL
  4. 直接连接金仓数据库查数
  5. 基于查询结果返回自然语言回答
- 当前问答接口：
  - `POST /api/EMDMPAI/product-qa/chat`
  - `GET /api/EMDMPAI/product-qa/hot-questions`
- 当前仍未完成的重要能力：
  - `这个商品 / 这款商品 / 它 / 该商品` 自动承接上一轮商品上下文
  - 如果要做这项，优先在当前会话内传递最近一轮命中的商品锚点，不要跨刷新持久化

### 3.4 用户行为分析

- 页面入口：`/ai-module/user-behavior-analysis`
- 菜单、白名单、路由都挂在 `src/app.jsx`
- 页面支持两种视角：
  - 商品视角
  - 商家视角
- 当前页面能力：
  - 查询行为诊断列表
  - 查询行为概览汇总
  - 展示漏斗图或行为层级图
  - 展示行为标签分布
  - 从当前结果集或勾选记录生成 AI 行为诊断
- 当前数据来源：
  - `/AiModule/userBehaviorAnalysisSummaryV2`
  - `/AiModule/userBehaviorAnalysisByPageV2`
  - 兜底时回退到 `/AiModule/itemRecommendationCandidates`
- 当前 FastAPI 链路：
  - `POST /api/EMDMPAI/generate-user-behavior-diagnosis`
  - `POST /api/EMDMPAI/generate-user-behavior-diagnosis/start`
  - `GET /api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{taskId}`
- 当前前端行为：
  - 先回显规则诊断结果
  - 如果增强任务进入异步轮询，则继续等待大模型润色结果
  - 若大模型失败，则保留 fallback 诊断，不置空页面

## 4. FastAPI 当前接口与运行方式

### 4.1 当前已注册接口

- `GET /api/EMDMPAI/health`
- `POST /api/EMDMPAI/recommend-items`
- `POST /api/EMDMPAI/generate-report`
- `POST /api/EMDMPAI/generate-report-pdf`
- `POST /api/EMDMPAI/generate-marketing-copy`
- `POST /api/EMDMPAI/competitor-analysis`
- `POST /api/EMDMPAI/product-qa/chat`
- `GET /api/EMDMPAI/product-qa/hot-questions`
- `POST /api/EMDMPAI/sales-forecast/predict`
- `POST /api/EMDMPAI/generate-user-behavior-diagnosis`
- `POST /api/EMDMPAI/generate-user-behavior-diagnosis/start`
- `GET /api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{taskId}`

### 4.2 路由注册

- 所有 AI 路由都在 `fastapi/main.py` 中集中注册
- 当前已注册的 router：
  - `recommend_router`
  - `report_router`
  - `marketing_copy_router`
  - `competitor_analysis_router`
  - `product_qa_router`
  - `sales_forecast_router`
  - `user_behavior_diagnosis_router`

### 4.3 FastAPI 端口、静态文件与地址解析

- 默认端口：`54903`
- 默认 host：`0.0.0.0`
- 当前已启用 `CORSMiddleware`
- 当前挂载了静态文件目录：
  - 路径：`/files`
  - 实际目录：`fastapi/apps/EMDMPAI/generated`
- 前端默认通过 `src/views/ai-module/utils/fastapi-url.js` 解析 FastAPI 地址
- 当前默认基地址不是拼 `window.location.hostname`，而是：
  - 先读 `globalThis.__EMDMP_FASTAPI_BASE_URL`
  - 再读 `globalThis.__KESPLUS_FASTAPI_BASE_URL`
  - 都没有时回退到 `http://fastapi:54903`
- 如果前端提示接口 `404`，优先怀疑正在运行的 FastAPI 进程不是最新代码
- 如果前端提示连接拒绝，优先检查 `54903` 或容器内 `fastapi` 服务是否可达

## 5. FastAPI 详细说明

### 5.1 模型配置

- 配置来源：`fastapi/.env`
- 示例模板：`fastapi/.env.example`
- 当前项目约定的关键变量：
  - `OPENAI_PROVIDER`
  - `OPENAI_BASE_URL`
  - `OPENAI_API_KEY`
  - `OPENAI_MODEL`
  - `OPENAI_TIMEOUT_SECONDS`
  - `OPENAI_MAX_RETRIES`
  - `OPENAI_HEALTHCHECK_PATH`
  - `FASTAPI_HOST`
  - `FASTAPI_PORT`
- 本地模型或兼容层客户端封装在：
  - `fastapi/apps/EMDMPAI/apis/llm_client.py`

### 5.2 数据库配置

- 商品问答助手当前已接入金仓数据库直查能力
- 关键变量来自 `fastapi/.env`：
  - `KINGBASE_HOST`
  - `KINGBASE_PORT`
  - `KINGBASE_DATABASE`
  - `KINGBASE_USER`
  - `KINGBASE_PASSWORD`
  - `KINGBASE_CONNECT_TIMEOUT_SECONDS`
- 当前数据库依赖：
  - `psycopg2-binary==2.9.10`

### 5.3 预测模型与相关依赖

- 销量预测 FastAPI 推理接口位于：
  - `fastapi/apps/EMDMPAI/apis/sales_forecast_api.py`
- 模型运行时封装位于：
  - `fastapi/apps/EMDMPAI/apis/sales_forecast_runtime.py`
- 模型文件目录：
  - `fastapi/apps/EMDMPAI/models`
- 当前与预测相关的依赖包括：
  - `joblib==1.4.2`
  - `pandas==2.2.3`
  - `lightgbm==4.5.0`
  - `scikit-learn==1.5.2`

### 5.4 生成文件与 PDF

- 报告 PDF 输出在：
  - `fastapi/apps/EMDMPAI/generated`
- 这些文件通常是历史生成产物，不应无故删除
- 如果任务涉及 PDF 下载链路：
  - 同时检查生成文件是否落盘
  - 同时检查 `/files/...` 访问路径

## 6. 当前前后端联动关系

### 6.1 `src/app.jsx`

- 当前 `src/app.jsx` 不只是入口文件，也是 AI 模块与部分业务页面的真实挂载点
- 当前已经在这里补入：
  - AI 模块菜单
  - 运营中心菜单
  - AI 模块 4 个页面路由
  - 商品基础信息详情页与表单页路由
  - 销量预测详情页路由
- 该文件历史上存在中文乱码迹象，涉及中文菜单或标题时只做最小修复

### 6.2 变更 AI 页面时的最小联动面

- 页面组件：`src/views/ai-module/...`
- 工具层：对应 `utils/*-api.js`
- FastAPI 地址解析：`src/views/ai-module/utils/fastapi-url.js`
- 路由挂载与白名单：`src/app.jsx`
- 对应 FastAPI 接口：`fastapi/apps/EMDMPAI/apis/...`

## 7. 当前测试与依赖现状

### 7.1 前端

- 根目录常用命令：
  - `npm run dev`
  - `npm run build`
  - `npm run test`
- 当前最可靠的最低验证仍然是：
  - `npm run build`
- 当前仓库内已存在若干前端轻量测试文件：
  - `src/views/ai-module/intelligent-recommendation-report/utils/single-selection.test.mjs`
  - `src/views/ai-module/utils/fastapi-url.test.mjs`
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/utils/*.test.mjs`

### 7.2 后端

- `fastapi/requirements.txt` 当前至少包含：
  - `fastapi==0.115.8`
  - `uvicorn==0.34.0`
  - `openai==1.66.3`
  - `python-dotenv==1.0.1`
  - `reportlab==4.3.1`
  - `httpx==0.28.1`
  - `psycopg2-binary==2.9.10`
  - `joblib==1.4.2`
  - `pandas==2.2.3`
  - `lightgbm==4.5.0`
  - `scikit-learn==1.5.2`
- 当前测试文件至少包含：
  - `fastapi/tests/test_competitor_analysis_api.py`
  - `fastapi/tests/test_marketing_copy_api.py`
  - `fastapi/tests/test_product_qa_api.py`
  - `fastapi/tests/test_report_api.py`
  - `fastapi/tests/test_sales_forecast_api.py`
  - `fastapi/tests/test_user_behavior_diagnosis_api.py`

### 7.3 后端常用验证命令

在 `fastapi` 目录执行：

```powershell
.venv\Scripts\activate
python main.py
python -m unittest discover -s tests -p "test_*.py"
python -m py_compile main.py
```

如果只改某个模块，优先运行最小范围验证，例如：

```powershell
python -m unittest tests.test_product_qa_api
python -m unittest tests.test_sales_forecast_api
python -m unittest tests.test_user_behavior_diagnosis_api
python -m py_compile main.py apps\EMDMPAI\apis\product_qa_api.py
```

## 8. 开发规则

### 8.1 先读现状，再改代码

- 修改前先判断任务涉及前端、后端还是二者联动
- 不要只改页面不看接口，也不要只改接口不看前端入参与返回结构
- 涉及 AI 报告、营销文案、竞品分析、商品问答、用户行为分析、PDF 输出、销量预测时，默认这是前后端联动任务

### 8.2 保护已有未提交内容

- 当前仓库长期处于非干净状态，未提交内容很多，尤其集中在：
  - `.kesplus`
  - `fastapi`
  - `src/views/ai-module`
- 永远先看 `git status`，理解已有改动后再动手
- 不要覆盖、回滚、重排或格式化与你任务无关的改动
- 不要使用破坏性命令，例如：
  - `git reset --hard`
  - `git checkout -- <file>`
  - 批量删除未跟踪目录

### 8.3 保持最小改动

- 优先沿用现有目录结构、命名方式与 API 工具层
- 不要因为“更规范”而擅自改造项目分层或引入新框架
- 不要假设项目有 CI、lint 或完整单测体系；只有仓库中真实存在时才引用

### 8.4 AI 相关联动检查

- 变更 `src/views/ai-module` 页面时，同时检查：
  - `src/app.jsx` 中菜单、白名单、路由是否同步
  - 前端请求路径、参数名、返回结构是否与 FastAPI 一致
  - loading、状态文案、fallback 展示是否仍匹配
  - `fastapi-url.js` 的地址解析是否仍适配当前运行环境
- 变更 FastAPI AI 接口时，同时检查：
  - `fastapi/main.py` 中是否已注册 router
  - `fastapi/apps/EMDMPAI/apis/apis.json` 是否需要同步
  - `fastapi/.env` 中依赖配置是否仍匹配
  - `generated` 文件输出路径与前端访问路径是否仍正确
  - 若涉及预测接口，`models` 目录和模型加载逻辑是否仍兼容

### 8.5 编码与乱码风险

- 本项目部分文件历史上出现过中文乱码，尤其是：
  - `src/app.jsx`
  - `fastapi/main.py`
  - `fastapi/apps/EMDMPAI/apis/product_qa_api.py`
  - `fastapi/apps/EMDMPAI/apis/user_behavior_diagnosis_api.py`
  - 若干 AI 页面与工具文件
- 涉及中文文案时，优先做最小范围修正
- 若任务不是专门修复编码问题，不要顺手大面积批量转码整个项目

## 9. 当前工作区注意事项

- `git status` 当前条目很多，且包含大量 `.venv`、`.kesplus`、`generated` 产物
- 不要因为工作区脏就擅自清理以下目录：
  - `fastapi/.venv`
  - `fastapi/apps/EMDMPAI/generated`
  - `fastapi/apps/EMDMPAI/logs`
  - `fastapi/apps/EMDMPAI/models`
  - `.kesplus`
- `fastapi/apps/EMDMPAI/generated` 下已经存在多份 PDF 文件，这些通常是历史测试产物，不应无故删除

## 10. 推荐工作顺序

1. 阅读相关目录与入口文件。
2. 查看 `git status`，识别已有未提交改动。
3. 仅在必要范围内修改代码。
4. 运行与任务强相关的最小验证。
5. 汇报改动内容、验证结果、未验证风险。

## 11. 汇报要求

- 优先说明：
  - 改了什么
  - 为什么改
  - 做了哪些验证
  - 哪些内容因为环境或范围限制未验证
- 若发现任务被现有脏工作区、环境变量缺失、编码异常、旧 FastAPI 进程、数据库连接失败、模型文件缺失或接口不一致阻塞，要明确指出，不要假装完成

## 12. 快速判断表

- 如果任务提到菜单、访问入口、页面挂载：先看 `src/app.jsx`
- 如果任务提到智能推荐与报告：前端页面、前端 API 工具层、FastAPI `report_api.py` 和 `marketing_copy_api.py` 都要看
- 如果任务提到竞品智能分析：页面、`ai-competitor-analysis-api.js`、`ai-competitor-analysis-helpers.js`、`competitor_analysis_api.py` 都要看
- 如果任务提到商品问答助手：页面、`ai-product-qa-api.js`、`product_qa_api.py`、`fastapi/.env` 里的金仓配置都要看
- 如果任务提到用户行为分析：页面、`user-behavior-analysis-api.js`、`user_behavior_diagnosis_api.py`、业务侧 `userBehaviorAnalysis*V2` 接口都要看
- 如果任务提到销量预测在线推理：重点看 `sales_forecast_api.py`、`sales_forecast_runtime.py`、`fastapi/apps/EMDMPAI/models`
- 如果任务提到模型不可用、接口超时、健康检查失败：重点看
  - `fastapi/main.py`
  - `fastapi/apps/EMDMPAI/apis/llm_client.py`
  - `fastapi/.env`
  - 当前运行中的 FastAPI 是否为最新代码
- 如果任务提到问答助手查不到数据：重点看
  - `product_qa_api.py` 的锚点识别
  - `KINGBASE_*` 配置
  - 数据库名是否正确
  - 当前 FastAPI 是否已安装 `psycopg2-binary`
- 如果任务提到依赖安装：先确认当前机器可用的是 `npm`、`pnpm` 还是 Python `.venv`
