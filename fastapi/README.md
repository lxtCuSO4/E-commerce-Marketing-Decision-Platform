# EMDMP AI 网关

完整恢复命令见根目录 README。使用 Python 3.11 创建虚拟环境、安装 `requirements.txt`，复制 `.env.example` 为 `.env` 并填写个人配置，执行 `python main.py`。默认监听 `0.0.0.0:54903`。

## API 来源与配置

启动前设置进程环境变量 `EMDMP_API_SOURCE`：`bundle` 优先根模型包，`fastapi` 强制回退实现，默认 `auto` 根据文件修改时间选择（同时间选 fallback）。`start_server.bat` 也可加载当前目录 `.env` 后启动 uvicorn。

| 配置项 | 用途 |
| --- | --- |
| `OPENAI_BASE_URL`、`OPENAI_API_KEY`、`OPENAI_MODEL` | OpenAI 兼容服务地址、凭据、模型名 |
| `OPENAI_TIMEOUT_SECONDS`、`OPENAI_MAX_RETRIES` | 通用超时和重试，部分业务另有限制 |
| `OPENAI_HEALTHCHECK_PATH` | 健康检查路径，默认 `/models` |
| `KINGBASE_HOST`、`KINGBASE_PORT`、`KINGBASE_DATABASE`、`KINGBASE_USER`、`KINGBASE_PASSWORD` | 商品问答只读查询连接 |
| `KINGBASE_CONNECT_TIMEOUT_SECONDS` | 数据库连接超时 |
| `SALES_FORECAST_MODEL_FILE` | 可选，自定义模型 Python 入口，建议绝对路径 |
| `FASTAPI_HOST`、`FASTAPI_PORT` | 监听配置 |
| `FASTAPI_CORS_ALLOW_ORIGINS` | 额外来源，逗号分隔，与默认来源合并 |
| `FASTAPI_CORS_ALLOW_ORIGIN_REGEX` | 覆盖默认来源匹配表达式 |

模型路径留空时自动查找配套模型。真实凭据不应提交。数据库 SQL 内的 LLM 配置独立于 FastAPI `.env`。

## 接口

以下路径统一加 `/api/EMDMPAI`：

| 方法 | 路径 |
| --- | --- |
| GET | `/health` |
| POST | `/recommend-items` |
| POST | `/generate-report` |
| POST | `/generate-report-pdf` |
| POST | `/generate-report/start` |
| GET | `/generate-report/tasks/{task_id}` |
| POST | `/generate-marketing-copy` |
| POST | `/competitor-analysis` |
| POST | `/competitor-analysis/start` |
| GET | `/competitor-analysis/tasks/{task_id}` |
| POST | `/product-qa/chat` |
| GET | `/product-qa/hot-questions` |
| POST | `/sales-forecast/predict` |
| POST | `/generate-user-behavior-diagnosis` |
| POST | `/generate-user-behavior-diagnosis/start` |
| GET | `/generate-user-behavior-diagnosis/tasks/{task_id}` |

本地 FastAPI 额外提供 `/api/EMDMP/sales-forecast/predict` 兼容入口，其他 AI 路由仍用 `/api/EMDMPAI`。`/` 返回服务信息，`/docs` 提供 OpenAPI 文档。

云端托管由 `models/EMDMP/apis/apis.json` 和平台加载规则决定。销量预测的 `Model` 适配器在模型包中，不能推断其他模块也具备相同托管能力。

## 文件和运行限制

- PDF：项目根目录 `report_generated`，URL `/files/<filename>.pdf`，运行时自动创建。
- 部署模型：`models/EMDMP/models`；回退模型：`fastapi/apps/EMDMPAI/models`。先在根目录执行 `git lfs pull` 与 `git lfs fsck`。
- 两套 API 有部署适配差异，不能按逐字一致的镜像覆盖。
- 异步任务存于进程内存，重启后不保留。

## 测试

```powershell
.\.venv\Scripts\python.exe -m unittest discover -s tests -p 'test_*.py'
.\.venv\Scripts\python.exe -m py_compile main.py
```

两套业务 API 可分别在新进程中设置 `EMDMP_API_SOURCE=bundle` 和 `fastapi` 验证；加载器自己的测试应使用默认 `auto`，因为它检查时间选择规则。

`test_llm*.py` 是历史手工联调脚本，会访问真实模型服务，不属于上述离线单元测试。

归档验证环境的完整 Python 依赖快照见 `requirements-archive-lock.txt`；需尽量复现当时环境时可使用 `pip install -r requirements-archive-lock.txt`。该快照记录 Windows/Python 3.11 环境，不承诺所有系统均适用。
