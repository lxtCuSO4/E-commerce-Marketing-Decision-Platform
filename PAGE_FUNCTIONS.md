# EMDMP 页面功能说明

本文档用于说明当前项目中各页面的主要功能、入口路径和使用场景，便于产品、开发、测试、演示和项目材料整理时快速定位页面能力。

它与 `AGENTS.md` 的区别是：

- `AGENTS.md`：面向 coding agent 的协作与开发说明
- `PAGE_FUNCTIONS.md`：面向项目说明、演示讲解与页面功能梳理的总览

## 1. 页面总览

当前项目页面主要分为 5 个模块：

- 登录模块：`src/views/login`
- 数据导入模块：`src/views/data-import-module`
- 销量预测模块：`src/views/sales-predict-module`
- AI 模块：`src/views/ai-module`
- 运营分析模块：`src/views/b-operations-module`

## 2. 登录模块

### 2.1 登录页

- 页面文件：`src/views/login/index.vue`
- 主要功能：
  - 用户登录系统
  - 进入 Kesplus 主应用
- 使用场景：
  - 系统统一入口
  - 演示账号登录

## 3. 数据导入模块

### 3.1 商品基础信息页

- 页面文件：`src/views/data-import-module/rec-tmall-item-base/index.vue`
- 主要功能：
  - 查询商品基础信息
  - 以卡片形式展示商品图片、标题、类目、品牌、卖家等核心字段
  - 支持分页、搜索、维护、跳转详情
- 页面价值：
  - 为 AI 推荐、竞品分析、商品问答提供主数据基础

### 3.2 商品基础信息详情页

- 页面文件：`src/views/data-import-module/rec-tmall-item-base/detail.vue`
- 访问路径：`/data-import-module/rec-tmall-item-base/detail?id=<id>`
- 页面性质：隐藏页
- 主要功能：
  - 查看单个商品的完整基础信息

### 3.3 商品基础信息表单页

- 页面文件：`src/views/data-import-module/rec-tmall-item-base/form.vue`
- 访问路径：`/data-import-module/rec-tmall-item-base/form?id=<id>`
- 页面性质：隐藏页
- 主要功能：
  - 新建或编辑商品基础信息

### 3.4 商品销量信息页

- 页面文件：`src/views/data-import-module/rec-tmall-item-sales/index.vue`
- 主要功能：
  - 查询商品销量相关数据
  - 展示点击、支付等经营指标
  - 支持基础维护
- 页面价值：
  - 为竞品分析、销量预测、用户行为诊断提供原始经营数据

### 3.5 商品销量信息表单页

- 页面文件：`src/views/data-import-module/rec-tmall-item-sales/form.vue`
- 主要功能：
  - 编辑商品销量记录

### 3.6 商品相似度信息页

- 页面文件：`src/views/data-import-module/rec-tmall-item-similarity/index.vue`
- 主要功能：
  - 查询商品相似度数据
  - 维护商品之间的相似关系
- 页面价值：
  - 为竞品分析和推荐分析提供竞品候选基础

### 3.7 商品相似度表单页

- 页面文件：`src/views/data-import-module/rec-tmall-item-similarity/form.vue`
- 主要功能：
  - 编辑商品相似度记录

## 4. 销量预测模块

### 4.1 销量预测特征页

- 页面文件：`src/views/sales-predict-module/rec-tmall-sales-forecast-feature/index.vue`
- 主要功能：
  - 查看销量预测所需特征数据
  - 支持查询、筛选与维护
- 页面价值：
  - 展示模型输入基础，支撑结果解释

### 4.2 销量预测特征表单页

- 页面文件：`src/views/sales-predict-module/rec-tmall-sales-forecast-feature/form.vue`
- 主要功能：
  - 维护销量预测特征数据

### 4.3 销量预测结果页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/index.vue`
- 主要功能：
  - 查看历史预测结果
  - 调用业务接口查询预测结果与详情
  - 触发在线销量预测能力
  - 作为 AI 模块竞品分析和行为分析中的趋势参考来源
- 页面相关工具：
  - `rec-sales-forecast-predictions-api.js`
  - `online-prediction-cache.js`
  - `prediction-detail-state.js`
  - `single-prediction-selection.js`
- 页面价值：
  - 体现机器学习预测能力与业务决策支持能力

### 4.4 销量预测结果详情页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/detail.vue`
- 访问路径：`/sales-predict-module/rec-sales-forecast-predictions/detail?id=<id>`
- 页面性质：隐藏页
- 主要功能：
  - 以更可视化的方式查看单条预测结果

### 4.5 销量预测结果表单页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/form.vue`
- 主要功能：
  - 维护预测结果记录

## 5. AI 模块

### 5.1 智能推荐与报告

- 页面文件：`src/views/ai-module/intelligent-recommendation-report/index.vue`
- 访问路径：`/ai-module/intelligent-recommendation-report`
- 页面定位：
  - 从推荐候选到 AI 报告输出的综合分析页面
- 主要功能：
  - 根据关键字查询推荐候选商品
  - 选择商品作为分析对象
  - 生成商业分析报告预览
  - 导出 PDF 报告
  - 生成营销文案
  - 支持异步报告增强任务轮询
- 当前联动接口：
  - 业务接口：`/AiModule/itemRecommendationCandidates`
  - FastAPI：`/api/EMDMPAI/generate-report`
  - FastAPI：`/api/EMDMPAI/generate-report-pdf`
  - FastAPI：`/api/EMDMPAI/generate-marketing-copy`
  - FastAPI：`/api/EMDMPAI/generate-report/start`
  - FastAPI：`/api/EMDMPAI/generate-report/tasks/{task_id}`
- 演示价值：
  - 最能体现“AI 推荐 + 自动报告 + PDF 交付 + 营销文案生成”的综合能力

### 5.2 竞品智能分析

- 页面文件：`src/views/ai-module/ai-competitor-analysis/index.vue`
- 访问路径：`/ai-module/ai-competitor-analysis`
- 页面定位：
  - 围绕主商品与竞品关系展开的对比分析页面
- 主要功能：
  - 按标题关键字检索主商品
  - 基于 `itemId` 查询竞品相似度
  - 补齐商品基础信息、销量与预测趋势
  - 展示规则分析与竞品关系图谱
  - 触发 AI 深度解读
  - 支持异步 AI 增强任务轮询
- 当前联动接口：
  - 业务接口：`/DataImportModule/item`
  - 业务接口：`/DataImportModule/itemSimilarity`
  - 业务接口：`/DataImportModule/itemSales`
  - 业务接口：`/SalesPredictModule/salesForecastFeature`
  - 业务接口：`/SalesPredictModule/salesForecastPredictions`
  - FastAPI：`/api/EMDMPAI/competitor-analysis`
  - FastAPI：`/api/EMDMPAI/competitor-analysis/start`
  - FastAPI：`/api/EMDMPAI/competitor-analysis/tasks/{task_id}`
- 演示价值：
  - 体现“业务规则分析 + AI 深度分析 + 竞品图谱展示”的能力融合

### 5.3 商品问答助手

- 页面文件：`src/views/ai-module/ai-product-qa/index.vue`
- 访问路径：`/ai-module/ai-product-qa`
- 页面定位：
  - 面向商品与经营数据问答的聊天式助手
- 主要功能：
  - 自然语言提问
  - 热门问题推荐
  - 展示基于业务数据的分析回答
  - 通过业务代理获取回答，失败时显示回退提示；当前未接入直连自动重试
- 当前联动接口：
  - 业务代理：`/AiModule/productQaChatProxy`
  - FastAPI：`/api/EMDMPAI/product-qa/chat`
  - FastAPI：`/api/EMDMPAI/product-qa/hot-questions`
- 页面特点：
  - 前端主要呈现聊天正文
  - 后端承担意图识别、商品锚点识别、只读 SQL 生成与数据库查询
  - 传输层会对问题文本与上下文做编码，降低中文链路损坏风险
- 演示价值：
  - 体现“业务数据库 + LLM 问答”的智能分析能力

### 5.4 用户行为分析

- 页面文件：`src/views/ai-module/user-behavior-analysis/index.vue`
- 访问路径：`/ai-module/user-behavior-analysis`
- 页面定位：
  - 从商品视角或商家视角分析用户行为漏斗并生成 AI 诊断
- 主要功能：
  - 切换商品视角或商家视角
  - 依据多条件筛选行为数据
  - 展示行为概览卡片、漏斗图、行为层级图与标签分布
  - 基于当前结果集生成 AI 行为诊断
  - 通过业务代理触发异步增强并轮询任务状态
- 当前联动接口：
  - 业务接口：`/AiModule/userBehaviorAnalysisSummaryV2`
  - 业务接口：`/AiModule/userBehaviorAnalysisByPageV2`
  - 兜底接口：`/AiModule/itemRecommendationCandidates`
  - 业务代理：`/AiModule/generateUserBehaviorDiagnosisProxy`
  - 业务代理：`/AiModule/startGenerateUserBehaviorDiagnosisProxy`
  - 业务代理：`/AiModule/getGenerateUserBehaviorDiagnosisTaskProxy`
  - FastAPI：`/api/EMDMPAI/generate-user-behavior-diagnosis`
  - FastAPI：`/api/EMDMPAI/generate-user-behavior-diagnosis/start`
  - FastAPI：`/api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}`
- 演示价值：
  - 体现“规则诊断 + 异步 AI 增强 + 运营建议输出”的场景落地能力

## 6. 运营分析模块

### 6.1 运营总览与商家诊断

- 页面文件：`src/views/b-operations-module/overview-merchant-diagnostics/index.vue`
- 访问路径：`/b-operations-module/overview-merchant-diagnostics`
- 主要功能：
  - 查看运营总览指标
  - 查看商家经营诊断相关信息
- 使用场景：
  - 运营监控
  - 商家状态判断

### 6.2 用户运营与召回

- 页面文件：`src/views/b-operations-module/user-operations-recall/index.vue`
- 访问路径：`/b-operations-module/user-operations-recall`
- 主要功能：
  - 查看用户运营与召回相关数据
- 使用场景：
  - 用户分层运营
  - 用户召回与精细化运营

## 7. 当前已挂载但非菜单主入口页面

这些页面通常不会直接出现在菜单中，但已经在运行时路由中挂载：

- 商品基础信息详情页：
  - `src/views/data-import-module/rec-tmall-item-base/detail.vue`
- 商品基础信息表单页：
  - `src/views/data-import-module/rec-tmall-item-base/form.vue`
- 销量预测结果详情页：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/detail.vue`

## 8. 页面与后端联动提示

- AI 页面统一通过 `src/views/ai-module/utils/fastapi-url.js` 处理 FastAPI 地址。
- 当前地址解析优先级为：
  - `__EMDMP_FASTAPI_BASE_URL`
  - `__KESPLUS_FASTAPI_BASE_URL`
  - 当前浏览器 `protocol + hostname + :54903`
  - 默认 `http://127.0.0.1:54903`
- 当前 FastAPI 服务入口为 `fastapi/main.py`；`EMDMP_API_SOURCE=auto` 按修改时间选择模型包或 fallback，同时间选 fallback。启动前设置进程变量 `bundle` 或 `fastapi` 可固定来源。
- 当前报告与 PDF 静态文件目录为 `report_generated`，运行时通过 `/files/...` 暴露。
- 若页面能打开但 AI 功能报错，应优先检查：
  - FastAPI 服务是否启动
  - 当前运行中的 FastAPI 是否为最新代码
  - `models/EMDMP/apis` 是否与 `fastapi/main.py` 的加载逻辑匹配
  - `.env` 中模型与数据库配置是否完整

## 9. 建议重点展示页面

- 智能推荐与报告：
  - `src/views/ai-module/intelligent-recommendation-report/index.vue`
- 竞品智能分析：
  - `src/views/ai-module/ai-competitor-analysis/index.vue`
- 商品问答助手：
  - `src/views/ai-module/ai-product-qa/index.vue`
- 用户行为分析：
  - `src/views/ai-module/user-behavior-analysis/index.vue`
- 销量预测结果展示：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/index.vue`
- 商品基础数据页：
  - `src/views/data-import-module/rec-tmall-item-base/index.vue`
- 系统挂载与菜单入口：
  - `src/app.jsx`

## 10. 文档维护建议

当项目出现以下变化时，应同步更新本文档：

- 新增页面
- 页面更名或迁移目录
- 页面主功能发生明显变化
- 页面与 FastAPI 或业务代理的联动链路发生变化
- 新增隐藏页、详情页、表单页或特殊入口页
