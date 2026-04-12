# EMDMP 页面功能说明

本文档用于说明当前项目中各页面的主要功能、入口路径和使用场景。

它与 `AGENTS.md` 的区别是：

- `AGENTS.md`：面向 coding agent 的协作与开发说明
- `PAGE_FUNCTIONS.md`：面向产品、开发、测试、实施或演示人员的页面功能总览

## 1. 页面总览

当前项目页面主要分为 5 个模块：

- 登录模块：`src/views/login`
- 数据导入模块：`src/views/data-import-module`
- 销量预测模块：`src/views/sales-predict-module`
- AI 模块：`src/views/ai-module`
- 运营中心模块：`src/views/b-operations-module`

## 2. 登录模块

### 2.1 登录页

- 页面文件：`src/views/login/index.vue`
- 主要功能：
  - 用户登录系统
  - 进入 Kesplus 主应用
- 使用场景：
  - 系统入口页
  - 账号认证与进入工作台

## 3. 数据导入模块

### 3.1 商品基础信息页

- 页面文件：`src/views/data-import-module/rec-tmall-item-base/index.vue`
- 主要功能：
  - 查询商品基础信息
  - 以卡片流形式展示商品
  - 展示商品图片、标题、商品 ID、类目、品牌、卖家等核心信息
  - 支持分页、筛选、编辑、删除
  - 点击商品卡片进入详情页
- 页面特点：
  - 已从传统表格改为偏电商风格的商品卡片展示
  - 默认每页展示 12 张卡片

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
- 使用场景：
  - 为 AI 分析、竞品分析与销量预测提供原始销量数据

### 3.5 商品销量信息表单页

- 页面文件：`src/views/data-import-module/rec-tmall-item-sales/form.vue`
- 主要功能：
  - 编辑商品销量记录

### 3.6 商品相似度信息页

- 页面文件：`src/views/data-import-module/rec-tmall-item-similarity/index.vue`
- 主要功能：
  - 查询商品相似度数据
  - 维护商品之间的相似关系
- 使用场景：
  - 为竞品分析、推荐分析提供相似度基础数据

### 3.7 商品相似度表单页

- 页面文件：`src/views/data-import-module/rec-tmall-item-similarity/form.vue`
- 主要功能：
  - 编辑商品相似度记录

## 4. 销量预测模块

### 4.1 销量预测特征页

- 页面文件：`src/views/sales-predict-module/rec-tmall-sales-forecast-feature/index.vue`
- 主要功能：
  - 展示销量预测所使用的特征数据
  - 支持查询、筛选与维护
- 使用场景：
  - 查看模型输入特征
  - 为 AI 分析与趋势判断提供解释基础

### 4.2 销量预测特征表单页

- 页面文件：`src/views/sales-predict-module/rec-tmall-sales-forecast-feature/form.vue`
- 主要功能：
  - 维护销量预测特征数据

### 4.3 销量预测结果页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/index.vue`
- 主要功能：
  - 查询销量预测结果
  - 展示商品未来销量或支付趋势相关结果
- 使用场景：
  - 进行商品未来趋势判断
  - 为推荐分析、竞品分析与 AI 问答提供预测依据

### 4.4 销量预测结果详情页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/detail.vue`
- 访问路径：`/sales-predict-module/rec-sales-forecast-predictions/detail?id=<id>`
- 页面性质：隐藏页
- 主要功能：
  - 用更可视化的方式查看单条预测结果

### 4.5 销量预测结果表单页

- 页面文件：`src/views/sales-predict-module/rec-sales-forecast-predictions/form.vue`
- 主要功能：
  - 维护销量预测结果记录

## 5. AI 模块

### 5.1 智能推荐与报告

- 页面文件：`src/views/ai-module/intelligent-recommendation-report/index.vue`
- 访问路径：`/ai-module/intelligent-recommendation-report`
- 页面定位：
  - 从推荐候选到报告产出的综合分析页
- 主要功能：
  - 根据关键字查询推荐候选商品
  - 选择商品作为分析对象
  - 生成商业分析报告预览
  - 下载 PDF 报告
  - 生成营销文案
- 页面结构：
  - 推荐候选查询区
  - 商品选择区
  - AI 分析摘要区
  - 报告与建议区
  - 营销文案区
- 当前链路：
  - 候选商品：业务接口 `/AiModule/itemRecommendationCandidates`
  - 报告预览：`POST /api/EMDMPAI/generate-report`
  - PDF 下载：`POST /api/EMDMPAI/generate-report-pdf`
  - 营销文案：`POST /api/EMDMPAI/generate-marketing-copy`
- 当前特点：
  - 报告预览和 PDF 生成已拆开
  - 页面内有统一的 `大模型生成中` 提示
  - 营销文案已内嵌，不是独立子页

### 5.2 竞品智能分析

- 页面文件：`src/views/ai-module/ai-competitor-analysis/index.vue`
- 访问路径：`/ai-module/ai-competitor-analysis`
- 页面定位：
  - 围绕主商品与竞品关系展开的对比分析页
- 主要功能：
  - 根据标题关键字搜索主商品
  - 基于 `itemId` 拉取竞品相似度
  - 展示竞品关系图谱
  - 展示销量、趋势与规则分析
  - 触发 AI 深度解读
- 当前链路：
  - 基础数据走业务接口
  - AI 深度解读走 `POST /api/EMDMPAI/competitor-analysis`
- 当前特点：
  - 先展示规则分析，后触发 AI 深度分析
  - AI 失败时不会整块空白

### 5.3 商品问答助手

- 页面文件：`src/views/ai-module/ai-product-qa/index.vue`
- 访问路径：`/ai-module/ai-product-qa`
- 页面定位：
  - 面向业务数据问答的聊天助手
- 主要功能：
  - 自然语言提问
  - 基于业务数据返回分析结论
  - 热门问题推荐
- 当前链路：
  - 问答：`POST /api/EMDMPAI/product-qa/chat`
  - 热门问题：`GET /api/EMDMPAI/product-qa/hot-questions`
- 页面特点：
  - 前端只展示聊天正文
  - 后端仍保留结构化调试信息供扩展使用

### 5.4 用户行为分析

- 页面文件：`src/views/ai-module/user-behavior-analysis/index.vue`
- 访问路径：`/ai-module/user-behavior-analysis`
- 页面定位：
  - 以商品视角或商家视角查看点击、收藏、加购、支付等行为链路，并生成 AI 诊断
- 主要功能：
  - 切换商品视角或商家视角
  - 按关键字、商品 ID、商家 ID、类目、锚定日期、时间窗口、行为标签进行筛选
  - 展示行为概览指标卡
  - 展示漏斗图或行为层级分布图
  - 展示行为标签分布
  - 查看行为诊断列表
  - 对当前结果集或勾选记录生成 AI 诊断
- 当前链路：
  - 汇总：`/AiModule/userBehaviorAnalysisSummaryV2`
  - 列表：`/AiModule/userBehaviorAnalysisByPageV2`
  - 兜底：`/AiModule/itemRecommendationCandidates`
  - AI 诊断：`POST /api/EMDMPAI/generate-user-behavior-diagnosis/start`
  - 诊断轮询：`GET /api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{taskId}`
- 当前特点：
  - 先显示规则诊断，再异步增强为大模型润色结果
  - 大模型失败时回退到规则诊断
  - 页面右侧会显示模型状态、建议动作与风险提示

## 6. 运营中心模块

### 6.1 运营总览与商家诊断

- 页面文件：`src/views/b-operations-module/overview-merchant-diagnostics/index.vue`
- 访问路径：`/b-operations-module/overview-merchant-diagnostics`
- 主要功能：
  - 查看运营总览
  - 分析商家诊断相关指标
- 使用场景：
  - 运营观察
  - 商家经营状态判断

### 6.2 用户运营与召回

- 页面文件：`src/views/b-operations-module/user-operations-recall/index.vue`
- 访问路径：`/b-operations-module/user-operations-recall`
- 主要功能：
  - 查看用户运营与召回相关数据
- 使用场景：
  - 用户分层运营
  - 召回与精细化运营

## 7. 当前已挂载但非菜单主入口页面

这些页面通常不会直接出现在菜单中，但已在运行时路由中挂载：

- 商品基础信息详情页：
  - `src/views/data-import-module/rec-tmall-item-base/detail.vue`
- 商品基础信息表单页：
  - `src/views/data-import-module/rec-tmall-item-base/form.vue`
- 销量预测结果详情页：
  - `src/views/sales-predict-module/rec-sales-forecast-predictions/detail.vue`

## 8. 页面与后端联动提示

- AI 页面统一通过 `src/views/ai-module/utils/fastapi-url.js` 解析 FastAPI 地址
- 默认优先读取运行时注入的：
  - `__EMDMP_FASTAPI_BASE_URL`
  - `__KESPLUS_FASTAPI_BASE_URL`
- 未注入时回退到：
  - `http://fastapi:54903`
- 如果页面能打开但 AI 功能报错，优先检查：
  - FastAPI 服务是否启动
  - `.env` 配置是否完整
  - 当前运行的 FastAPI 是否是最新代码

## 9. 文档维护建议

当项目出现以下变化时，应同步更新本文档：

- 新增页面
- 页面更名或迁移目录
- 页面主功能发生明显变化
- 页面与 FastAPI 的联动链路发生变化
- 新增隐藏页、详情页、表单页或特殊入口页
