# 智策引擎：电商营销决策平台（EMDMP）

EMDMP 基于 Vue 3、Kesplus、FastAPI 和 LightGBM，提供商品管理、销量预测、AI 经营分析与运营管理。此仓库保存最终源码、数据库定义、运行模型及恢复说明。

## 功能与目录

| 模块 | 内容 | 目录 |
| --- | --- | --- |
| 数据导入 | 商品基础信息、销量、相似度 | `src/views/data-import-module` |
| 销量预测 | 特征查询、在线预测、结果详情 | `src/views/sales-predict-module` |
| AI 智能分析 | 推荐与报告、竞品分析、商品问答、用户行为诊断 | `src/views/ai-module` |
| 运营中心 | 运营总览、商家诊断、用户运营与召回 | `src/views/b-operations-module` |
| 业务与数据库 | Kesplus 函数、REST 定义、表结构 | `.kesplus` |
| AI 网关 | API 注册、回退实现、测试 | `fastapi` |
| 部署模型包 | 平台适配接口、模型与特征配置 | `models/EMDMP` |
| 最小部署示例 | 仅销量预测的托管适配示例 | `examples/EMDMPForecastMini` |

前端菜单入口在 `src/app.jsx`，公共样式在 `src/global.scss`。页面索引见 [PAGE_FUNCTIONS.md](PAGE_FUNCTIONS.md)，协作约定见 [AGENTS.md](AGENTS.md)。

## 架构和恢复前提

```text
Vue / Kesplus 页面
  ├─ Kesplus 业务 API → Kingbase 数据库
  └─ Kesplus AI 代理 / FastAPI 直连
       ├─ 规则分析、只读数据查询、异步任务
       ├─ OpenAI 兼容的云端 LLM
       └─ LightGBM 销量模型
```

完整业务需要 Kesplus 3.2、Kingbase、业务数据与自行配置的模型服务凭据。仓库包含表定义和业务函数，**不包含业务数据库数据备份、云端实例、训练数据或训练流水线**。

## 1. 获取源码和模型

模型以仓库根目录的 `models.zip` 保存，通过 Git LFS 传输。此文件原样来自用户提供的压缩包（77,677,505 字节）。

```powershell
git lfs install
git clone -c core.longpaths=true https://github.com/lxtCuSO4/E-commerce-Marketing-Decision-Platform.git
cd E-commerce-Marketing-Decision-Platform
git lfs pull
git lfs fsck
Get-FileHash .\models.zip -Algorithm SHA256
```

仅下载 GitHub 源码 ZIP 时，`models.zip` 可能是 LFS 指针；请通过上述步骤获取完整压缩包后再解压。

ZIP 的 SHA-256：

```text
bf3dbde2a3d6fbd5e484ec980e1edb9ab90d70ed4b56914daba1038cb9e0edc7
```

压缩包包含独立的销量预测托管接口及 LightGBM 模型；它的 API 清单只有销量预测。可解压到独立目录后按 Kesplus 平台要求导入 `models/EMDMP`。**不要将 ZIP 直接解压覆盖本仓库根目录，否则会覆盖完整 AI 模块的接口清单和预测适配器。**

恢复完整项目的模型文件时，仅复制模型二进制：

```powershell
Expand-Archive -LiteralPath .\models.zip -DestinationPath .\.model-package
$archiveModel = '.\.model-package\models\EMDMP\models\sales_forecast_lightgbm.pkl'
Copy-Item -LiteralPath $archiveModel -Destination .\models\EMDMP\models\sales_forecast_lightgbm.pkl
Copy-Item -LiteralPath $archiveModel -Destination .\fastapi\apps\EMDMPAI\models\sales_forecast_lightgbm.pkl
Copy-Item -LiteralPath $archiveModel -Destination .\examples\EMDMPForecastMini\models\EMDMPForecastMini\models\sales_forecast_lightgbm.pkl
Get-FileHash -LiteralPath $archiveModel -Algorithm SHA256
```

解压后的模型大小 256,735,957 字节，SHA-256：

```text
4ce13c5a91ef81029f1833e9b91b2efaa9f2a9555fed90817869602994acd55f
```

单独的 `.pkl` 文件不再纳入版本控制。校验清单见 [docs/model-artifacts.json](docs/model-artifacts.json)。

## 2. 恢复业务服务和数据库

1. 安装并启动 Kesplus 3.2 与兼容的 Kingbase 环境。
2. 在 Kesplus 中打开 `EMDMP.ksp`，按自己的服务地址修改连接配置并重新登录。
3. 通过 Kesplus 工具导入/同步 `.kesplus/initDB/ddl/table/*.tbl`、`.kesplus/sql` 的函数与 REST 定义。`.tbl` 是带 SQL 的 JSON 元数据，不能直接作为普通 SQL 执行。
4. 按依赖建立模块、菜单、权限和数据源，导入合法取得的业务数据。平台初始化脚本在 `.kesplus/db-init-sql`，应通过匹配的平台工具使用。
5. AI 与在线预测 REST 注册元数据未完整导出，须按 [业务路由恢复清单](docs/KESPLUS_ROUTES.md) 手动注册，不能仅靠已有 `.krsf` 恢复全部接口。
6. 核对 `/DataImportModule`、`/SalesPredictModule`、`/AiModule` 和运营接口。

代理函数中的 `http://fastapi:54903` 是部署服务名；Kesplus 所在环境须能解析并访问它，本地部署应配置可达地址。

`callLlmChatCompletions` 的密钥已替换为部署占位符。使用数据库直连 LLM 链路时，须在部署环境单独配置凭据；它不会自动读取 FastAPI `.env`。请勿提交实际凭据。

## 3. 启动前端

归档验证环境为 Node.js 22.16.0、npm 10.9.2。仓库保留 `pnpm-lock.yaml`，建议通过 pnpm 安装。

```powershell
pnpm install --frozen-lockfile
npm run dev
```

`npm run build` 输出到 `dist`。安装环境须能访问 Kesplus 组件包源；仓库不包含 `node_modules`。Windows 下首次克隆启用 `core.longpaths=true`，以保留参数名较长的 SQL 文件。

## 4. 启动 AI 网关

后端验证环境为 Python 3.11.7。

```powershell
cd fastapi
py -3.11 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
Copy-Item .env.example .env
# 编辑 .env，填写自己的模型服务及数据库配置
$env:EMDMP_API_SOURCE = 'bundle'
.\.venv\Scripts\python.exe main.py
```

默认监听 `0.0.0.0:54903`，文档为 `http://127.0.0.1:54903/docs`。`GET /api/EMDMPAI/health` 会检查外部模型服务连通性。

在启动前通过进程环境设置 `EMDMP_API_SOURCE`：

| 值 | 加载行为 |
| --- | --- |
| `bundle` | 优先 `models/EMDMP/apis`，缺文件时回退 |
| `fastapi` | 强制 `fastapi/apps/EMDMPAI/apis` |
| `auto`（默认） | 比较两套文件修改时间，fallback 更新或时间相同时选 fallback |

两套实现保留导入方式、路径定位与平台 `Model` 入口的差异。克隆会改变修改时间，建议显式指定来源。

前端直连地址依次读取 `globalThis.__EMDMP_FASTAPI_BASE_URL`、`globalThis.__KESPLUS_FASTAPI_BASE_URL`、浏览器协议与主机名加端口 `54903`，最后回退 `http://127.0.0.1:54903`。大部分 AI 生成请求经 Kesplus 代理，重试方式以页面工具层为准。

完整接口和配置见 [fastapi/README.md](fastapi/README.md)。PDF 输出位于运行时创建的 `report_generated`，通过 `/files/<文件名>.pdf` 访问。

## 5. 验证

在项目根目录执行：

```powershell
npm test
npm run build
cd fastapi
.\.venv\Scripts\python.exe -m unittest discover -s tests -p 'test_*.py'
.\.venv\Scripts\python.exe -m py_compile main.py
```

`npm test` 使用 Node 内置测试运行器执行 `src` 下 `.test.mjs`。后端测试主要模拟外部依赖，不能替代真实数据库与云端联调。归档结果和保留范围见 [docs/ARCHIVE.md](docs/ARCHIVE.md)。

## 维护说明

- 环境模板为 `fastapi/.env.example`；实际 `.env`、会话、日志、虚拟环境和生成报告不纳入 Git。
- 历史设计和计划位于 `docs/superpowers`；当前行为以源码、测试和本说明为准。
- 项目依赖商业平台与第三方组件；仓库未额外授予这些组件的使用或分发许可。
