# Kesplus 业务路由恢复清单

本仓库包含 SQL 函数与部分 `.krsf` REST 定义，**没有完整导出当前运行环境的业务路由、菜单、权限和数据源注册元数据**。下表根据前端调用与 `.kfun` 函数签名整理，供恢复时手动注册；不代表已在全新 Kesplus 环境验证导入。

路径是 `appPrefix: true` 之前的业务路径，部署时还需应用实际的应用前缀、认证与权限。参数映射规则需在对应 Kesplus 工具中配置，不能仅把 `.kfun` 文件复制到磁盘后期待 REST 自动出现。

## AI 路由

SQL 函数主目录为 `.kesplus/sql/智能分析/函数`，schema 为 `AiModule`。另一个 `AI智能分析` 目录中保留了历史实现，同名函数应先比较后选择，不应无序覆盖；当前恢复优先参考 `智能分析` 中的代理函数和 V2 分析函数。

| 方法 | 业务路径 | 数据库函数 | 参数来源 |
| --- | --- | --- | --- |
| GET | `/AiModule/itemRecommendationCandidates` | `getItemRecommendationCandidates` | 查询参数：keyword、anchor_date、page_index、page_size |
| GET | `/AiModule/itemRecommendationByAI` | `getItemRecommendationByAI` | 同上 |
| POST | `/AiModule/generateBusinessReportByAIWithItems` | `generateBusinessReportByAIWithItems` | 请求体：keyword、item_ids、anchor_date、report_type、items |
| GET | `/AiModule/userBehaviorAnalysisSummaryV2` | `getUserBehaviorAnalysisSummaryV2` | 查询参数：view_type、keyword、item_id、seller_id、category、anchor_date、window_days、behavior_tag |
| GET | `/AiModule/userBehaviorAnalysisByPageV2` | `getUserBehaviorAnalysisByPageV2` | 同上，加 page_index、page_size |
| POST | `/AiModule/productQaChatProxy` | `productQaChatProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/generateReportPreviewProxy` | `generateReportPreviewProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/startGenerateReportProxy` | `startGenerateReportProxy` | 请求体 payload（JSON） |
| GET | `/AiModule/getGenerateReportTaskProxy` | `getGenerateReportTaskProxy` | 查询参数 task_id |
| POST | `/AiModule/generateReportPdfProxy` | `generateReportPdfProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/generateMarketingCopyProxy` | `generateMarketingCopyProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/generateCompetitorAnalysisProxy` | `generateCompetitorAnalysisProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/startCompetitorAnalysisProxy` | `startCompetitorAnalysisProxy` | 请求体 payload（JSON） |
| GET | `/AiModule/getCompetitorAnalysisTaskProxy` | `getCompetitorAnalysisTaskProxy` | 查询参数 task_id |
| POST | `/AiModule/generateUserBehaviorDiagnosisProxy` | `generateUserBehaviorDiagnosisProxy` | 请求体 payload（JSON） |
| POST | `/AiModule/startGenerateUserBehaviorDiagnosisProxy` | `startGenerateUserBehaviorDiagnosisProxy` | 请求体 payload（JSON） |
| GET | `/AiModule/getGenerateUserBehaviorDiagnosisTaskProxy` | `getGenerateUserBehaviorDiagnosisTaskProxy` | 查询参数 task_id |

异步状态调用同时发送 `taskId` 和 `task_id`，数据库参数绑定应使用 `task_id`。其他查询参数若前端采用 camelCase，需映射到函数签名的 snake_case，例如 `anchorDate → anchor_date`、`pageIndex → page_index`、`viewType → view_type`，以页面组装请求和实际函数签名为准。

`payload` 必须作为 JSON 对象传入，不能重复编码成字符串。商品问答 payload 内的 `__EMDMP_B64__:` 文本是现有传输协议，代理应原样转发。

## 销量预测

| 方法 | 业务路径 | 数据库函数 | 参数映射 |
| --- | --- | --- | --- |
| POST | `/SalesPredictModule/predictSalesForecastOnline` | `SalesPredictModule.predictSalesForecastOnline` | itemId/item_id → item_id；anchorDate/anchor_date → anchor_date；horizonDays/horizon_days → horizon_days；featureData/feature_data → feature_data（JSON） |

文件位于 `.kesplus/sql/销售预测/函数/predictSalesForecastOnline(...).kfun`。当前 SQL 代理目标是 `http://fastapi:54903/api/EMDMP/sales-forecast/predict`；本地 FastAPI 和平台托管的路由契约应分别核对。

## 依赖和验证顺序

1. 先恢复业务表、数据、模块 schema 和函数依赖，再注册上述 REST 接口。
2. 保留 `callLlmHttp` 等函数依赖；安装环境应具备相应 HTTP 调用能力，配置正确的服务网络和超时。
3. 验证常规数据接口：`/DataImportModule/item`、`itemSales`、`itemSimilarity`，以及 `/SalesPredictModule/salesForecastFeature`、`salesForecastPredictions`、`salesForecastPredictionDetail`。对应 `.krsf`、表与包定义应通过 Kesplus 工具导入或按缺失情况重建。
4. 先请求候选列表，再使用单个商品验证代理、预测和异步任务状态，最后验证前端完整流程。
5. 运营模块的菜单、权限、数据源和业务 REST 同样依赖平台状态；本清单只补齐已识别缺少注册导出的 AI 与在线预测路由，不能替代完整平台备份。
