<template>
  <KPage class="emdmp-shell emdmp-shell--wide qa-page">
    <section class="qa-topbar">
      <div>
        <p class="qa-topbar__eyebrow">Business Chat</p>
        <h1 class="qa-topbar__title">商品问答助手</h1>
      </div>
      <div class="qa-topbar__actions">
        <span class="qa-status" :class="`is-${latestAssistantStatus}`">
          <span class="qa-status__dot"></span>{{ currentStatusLabel }}
        </span>
        <el-button plain round @click="toggleSidebar">{{ sidebarCollapsed ? "展开辅助面板" : "收起辅助面板" }}</el-button>
        <el-button plain round @click="handleResetChat">新建会话</el-button>
      </div>
    </section>

    <section class="qa-shell">
      <div class="qa-main">
        <header class="qa-main__header">
          <div>
            <div class="qa-main__title">EMDMP Business Copilot</div>
            <div class="qa-main__sub">{{ chatLoading ? "正在整理回答与依据" : "支持多轮上下文、建议问题与依据回看" }}</div>
          </div>
          <button type="button" class="qa-link" @click="toggleSidebar">{{ sidebarCollapsed ? "查看辅助信息" : "隐藏辅助信息" }}</button>
        </header>

        <div ref="conversationRef" class="qa-stream" :class="{ 'is-empty': !messages.length }" @scroll="handleConversationScroll">
          <section v-if="!messages.length" class="qa-welcome">
            <div class="qa-chip-list">
              <button v-for="question in welcomeQuestions" :key="question" type="button" class="qa-chip qa-chip--action" @click="handleSuggestionSelect(question)">
                {{ question }}
              </button>
            </div>
          </section>

          <article v-for="item in renderedMessages" :key="item.id" class="qa-message" :class="`is-${item.role}`">
            <div class="qa-message__avatar">{{ item.role === "assistant" ? "AI" : "你" }}</div>
            <div class="qa-message__body">
              <div class="qa-message__meta">
                <strong>{{ item.role === "assistant" ? "商品问答助手" : "你的提问" }}</strong>
                <span v-if="item.role === 'assistant'">{{ item.isStreaming ? "正在生成中" : getFriendlyStatusLabel(item.llmStatus) }}</span>
              </div>

              <div class="qa-message__content">
                <template v-if="item.role === 'assistant' && item.blocks.length">
                  <template v-for="(block, index) in item.blocks" :key="`${item.id}-${index}`">
                    <p v-if="block.type === 'heading'" class="qa-block qa-block--heading">{{ block.text }}</p>
                    <ul v-else-if="block.type === 'list'" class="qa-block qa-block--list">
                      <li v-for="(entry, entryIndex) in block.items" :key="`${item.id}-${entryIndex}`">{{ entry }}</li>
                    </ul>
                    <p v-else class="qa-block">{{ block.text }}</p>
                  </template>
                </template>
                <p v-else class="qa-block">{{ item.displayedContent || item.content }}</p>

                <div v-if="item.role === 'assistant' && item.isStreaming" class="qa-streaming">
                  <span class="qa-streaming__dot"></span>继续生成中
                </div>
              </div>

              <div v-if="item.role === 'assistant'" class="qa-message__footer">
                <div class="qa-message__actions">
                  <button type="button" class="qa-link" @click="copyAssistantMessage(item)">复制回答</button>
                  <button type="button" class="qa-link" @click="handleRegenerate(item)">重新生成</button>
                  <button type="button" class="qa-link" @click="openEvidencePanel(item.id)">查看依据</button>
                </div>
              </div>
            </div>
          </article>
        </div>

        <div class="qa-composer-wrap">
          <div class="qa-composer">
            <el-input
              ref="questionInputRef"
              v-model="pendingQuestion"
              type="textarea"
              :autosize="{ minRows: 2, maxRows: 8 }"
              resize="none"
              placeholder="输入商品、商家、类目、时间范围或追问问题。Enter 发送，Shift + Enter 换行。"
              @keydown.enter.exact.prevent="handleSendQuestion"
            />
            <div class="qa-composer__footer">
              <div class="qa-composer__tips">
                <span>默认会带上最近 6 轮上下文。</span>
                <span>建议附带商品 ID、商家 ID、类目或时间范围。</span>
              </div>
              <div class="qa-composer__actions">
                <el-button plain round @click="handleResetChat">新建会话</el-button>
                <el-button v-if="streamingMessageId" plain round @click="handleStopStreaming">停止展示</el-button>
                <el-button type="primary" round :loading="chatLoading" @click="handleSendQuestion">发送</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="!sidebarCollapsed" class="qa-mask" @click="sidebarCollapsed = true"></div>
      <aside class="qa-sidebar" :class="{ 'is-collapsed': sidebarCollapsed }">
        <section class="qa-panel">
          <div class="qa-panel__header"><span>会话辅助面板</span><button type="button" class="qa-link" @click="sidebarCollapsed = true">收起</button></div>
          <div class="qa-stats">
            <div class="qa-stat"><span>当前状态</span><strong>{{ currentStatusLabel }}</strong></div>
            <div class="qa-stat"><span>消息数量</span><strong>{{ messages.length }}</strong></div>
            <div class="qa-stat qa-stat--wide"><span>会话 ID</span><strong class="qa-stat__mono">{{ sessionId }}</strong></div>
          </div>
        </section>

        <section class="qa-panel">
          <div class="qa-panel__header"><span>建议问题</span><button type="button" class="qa-link" @click="refreshSuggestedQuestions(latestQuestionContext)">{{ hotQuestionLoading ? "更新中" : "刷新" }}</button></div>
          <div class="qa-chip-list">
            <button v-for="question in suggestedQuestions" :key="question" type="button" class="qa-chip qa-chip--action" @click="handleSuggestionSelect(question)">
              {{ question }}
            </button>
          </div>
        </section>

        <section class="qa-panel">
          <div class="qa-panel__header"><span>分析依据</span><button type="button" class="qa-link" @click="evidenceExpanded = !evidenceExpanded">{{ evidenceExpanded ? "收起" : "展开" }}</button></div>
          <template v-if="selectedEvidenceMessage">
            <div class="qa-evidence-summary">
              <div class="qa-evidence-summary__label">{{ getFriendlyStatusLabel(selectedEvidenceMessage.llmStatus) }}</div>
              <div>{{ selectedEvidenceMessage.analysisSummary || "当前回答没有额外依据说明。" }}</div>
            </div>
            <template v-if="evidenceExpanded && hasSelectedAnalysisMeta">
              <div v-for="section in selectedAnalysisSections" :key="section.label" v-show="section.items.length" class="qa-evidence-block">
                <div class="qa-evidence-block__title">{{ section.label }}</div>
                <div class="qa-chip-list qa-chip-list--dense">
                  <span v-for="entry in section.items" :key="`${section.label}-${entry}`" class="qa-chip qa-chip--static">{{ entry }}</span>
                </div>
              </div>
              <div v-if="selectedAnalysisMeta.sqlPreview" class="qa-evidence-block">
                <div class="qa-evidence-block__title">SQL 预览</div>
                <pre class="qa-code">{{ selectedAnalysisMeta.sqlPreview }}</pre>
              </div>
            </template>
            <div v-else-if="evidenceExpanded" class="qa-empty-hint">当前回答没有更多可展开的分析依据。</div>
          </template>
          <div v-else class="qa-empty-hint">发送一条问题后，这里会显示最近回答的依据摘要、涉及模块和 SQL 预览。</div>
        </section>
      </aside>
    </section>
  </KPage>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from "vue"
import { defineRouteMeta, message } from "@kesplus/kesplus"
import { productQaChatApi, productQaHotQuestionsApi } from "./utils/ai-product-qa-api"
import { buildAnalysisSummary, buildStreamingFrames, formatAssistantBlocks, getFriendlyStatusLabel } from "./utils/chat-experience.js"
import { extractQuestionContext } from "./utils/question-context.js"

defineRouteMeta({ title: "商品问答助手" })

const fallbackQuestions = [
  "请先用一句话判断这款商品最近值不值得继续投放。",
  "商品 ID 1001 最近 30 天的支付表现和预测走势怎么样？",
  "商家 ID 4775 当前最值得优先关注哪些商品？",
  "最近 7 天女装类目的流量和转化有什么变化？",
]

const sessionId = ref(`qa-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`)
const chatLoading = ref(false)
const hotQuestionLoading = ref(false)
const pendingQuestion = ref("")
const messages = ref([])
const suggestedQuestions = ref([...fallbackQuestions])
const sidebarCollapsed = ref(true)
const evidenceExpanded = ref(false)
const autoScrollLocked = ref(false)
const streamingMessageId = ref("")
const selectedEvidenceMessageId = ref("")
const conversationRef = ref(null)
const questionInputRef = ref(null)
const streamRunId = ref(0)

const welcomeQuestions = computed(() => suggestedQuestions.value.slice(0, 4))
const latestAssistantMessage = computed(() => [...messages.value].reverse().find((item) => item.role === "assistant") || null)
const latestUserMessage = computed(() => [...messages.value].reverse().find((item) => item.role === "user") || null)
const latestQuestionContext = computed(() => extractQuestionContext(latestUserMessage.value?.content || ""))
const latestAssistantStatus = computed(() => (chatLoading.value || streamingMessageId.value ? "streaming" : String(latestAssistantMessage.value?.llmStatus || "idle")))
const currentStatusLabel = computed(() => (latestAssistantStatus.value === "streaming" ? "正在生成回答" : getFriendlyStatusLabel(latestAssistantStatus.value)))
const selectedEvidenceMessage = computed(() => messages.value.find((item) => item.id === selectedEvidenceMessageId.value) || latestAssistantMessage.value)
const selectedAnalysisMeta = computed(() => selectedEvidenceMessage.value?.analysisMeta || emptyMeta())
const hasSelectedAnalysisMeta = computed(() => Object.values(selectedAnalysisMeta.value).some((value) => (Array.isArray(value) ? value.length : Boolean(value))))
const selectedAnalysisSections = computed(() => {
  const meta = selectedAnalysisMeta.value
  return [
    { label: "涉及模块", items: meta.modules },
    { label: "涉及表", items: meta.tables },
    { label: "关键指标", items: meta.metrics },
    { label: "过滤条件", items: meta.filters },
    { label: "搜索到的信息", items: meta.highlights },
  ]
})
const renderedMessages = computed(() => messages.value.map((item) => ({ ...item, blocks: item.role === "assistant" ? formatAssistantBlocks(item.displayedContent || item.content) : [] })))

function emptyMeta() {
  return { modules: [], tables: [], metrics: [], filters: [], highlights: [], sqlPreview: "", rowCount: 0 }
}

function normalizeArray(value) {
  if (Array.isArray(value)) return value
  if (typeof value === "string" && value) {
    try {
      const parsed = JSON.parse(value)
      return Array.isArray(parsed) ? parsed : []
    } catch (error) {
      return []
    }
  }
  return []
}

function normalizeObject(value) {
  if (Array.isArray(value)) return value[0] || {}
  if (typeof value === "string" && value) {
    try {
      const parsed = JSON.parse(value)
      return Array.isArray(parsed) ? parsed[0] || {} : parsed || {}
    } catch (error) {
      return {}
    }
  }
  return value || {}
}

function normalizeAnalysisMeta(meta) {
  const normalized = normalizeObject(meta)
  return {
    modules: normalizeArray(normalized.modules).filter(Boolean),
    tables: normalizeArray(normalized.tables).filter(Boolean),
    metrics: normalizeArray(normalized.metrics).filter(Boolean),
    filters: normalizeArray(normalized.filters).filter(Boolean),
    highlights: normalizeArray(normalized.highlights).filter(Boolean),
    sqlPreview: String(normalized.sqlPreview || "").trim(),
    rowCount: Number(normalized.rowCount || 0),
  }
}

function countChineseCharacters(value) {
  return (String(value || "").match(/[\u4e00-\u9fff]/g) || []).length
}

function tryDecodeMojibake(value) {
  const text = String(value || "").trim()
  if (!text || !/\uFFFD|Ã[\u0080-\u00BF]/.test(text)) return text
  try {
    const bytes = Uint8Array.from(Array.from(text).map((char) => char.charCodeAt(0) & 0xff))
    const decoded = new TextDecoder("utf-8").decode(bytes).trim()
    return countChineseCharacters(decoded) >= countChineseCharacters(text) ? decoded : text
  } catch (error) {
    return text
  }
}

function normalizeQuestions(questions) {
function normalizeAssistantAnswerText(value) {
  return String(value || "")
    .replaceAll("命中的高表现商品", "搜索到的高表现商品")
    .replaceAll("命中的候选商品", "搜索到的候选商品")
    .replaceAll("命中样本", "搜索结果样本")
    .replaceAll("命中模块", "搜索到模块")
    .replaceAll("命中表", "搜索到表")
    .replace(/命中了\s*(\d+)\s*条/g, "搜索到 $1 条")
    .replace(/命中\s*(\d+)\s*行数据/g, "搜索到 $1 行数据")
    .replace(/未返回命中记录/g, "暂时没有搜索到记录")
}

  return Array.from(
    new Set(
      normalizeArray(questions)
        .map((item) => tryDecodeMojibake(item))
        .map((item) => item.replace(/\s+/g, " ").trim())
        .filter(Boolean)
    )
  ).slice(0, 6)
}

function createMessage(role, content, extra = {}) {
  return {
    id: extra.id || `${role}-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
    role,
    content: String(content || "").trim(),
    displayedContent: String(extra.displayedContent ?? content ?? "").trim(),
    analysisMeta: extra.analysisMeta || emptyMeta(),
    analysisSummary: String(extra.analysisSummary || ""),
    llmStatus: String(extra.llmStatus || "success"),
    isStreaming: Boolean(extra.isStreaming),
  }
}

function buildQuestionDraft(question, history = []) {
  const recentHistory = history
    .slice(-4)
    .map((item) => `${item.role === "assistant" ? "助手" : "用户"}：${item.content}`)
    .join("\n")

  return [
    `用户问题：${String(question || "").trim()}`,
    recentHistory ? `最近会话上下文：\n${recentHistory}` : "",
    "请基于大模型生成简洁、稳健、不臆测的回答；如果信息不足，请明确指出还需要补充商品ID、商家ID、类目或时间范围。",
  ]
    .filter(Boolean)
    .join("\n\n")
}

function setMessagePatch(messageId, patch) {
  messages.value = messages.value.map((item) => (item.id === messageId ? { ...item, ...patch } : item))
}

function buildChatPayload(question) {
  const currentContext = extractQuestionContext(question)
  const historyContext = latestQuestionContext.value || {}
  const itemContext = {
    itemId: currentContext.itemId || historyContext.itemId || "",
    category: currentContext.category || historyContext.category || "",
    title: currentContext.title || historyContext.title || "",
  }

  return {
    sessionId: sessionId.value,
    question,
    messages: messages.value.slice(-6).map((item) => ({ role: item.role, content: item.content })),
    draftAnswer: buildQuestionDraft(question, messages.value),
    itemContext,
    context: {},
  }
}

async function scrollConversationToBottom(force = false) {
  await nextTick()
  const element = conversationRef.value
  if (!element || (autoScrollLocked.value && !force)) return
  element.scrollTop = element.scrollHeight
}

function handleConversationScroll() {
  const element = conversationRef.value
  if (!element) return
  autoScrollLocked.value = element.scrollHeight - element.scrollTop - element.clientHeight > 96
}

function toggleSidebar() {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

async function refreshSuggestedQuestions(context = latestQuestionContext.value) {
  hotQuestionLoading.value = true
  try {
    const params = {}
    if (context?.itemId) params.itemId = context.itemId
    if (context?.title) params.title = context.title
    if (context?.category) params.category = context.category
    const result = normalizeObject(await productQaHotQuestionsApi(params))
    const questions = normalizeQuestions(result.questions)
    suggestedQuestions.value = questions.length ? questions : [...fallbackQuestions]
  } catch (error) {
    suggestedQuestions.value = [...fallbackQuestions]
  } finally {
    hotQuestionLoading.value = false
  }
}

function handleSuggestionSelect(question) {
  pendingQuestion.value = question
  nextTick(() => questionInputRef.value?.focus?.())
}

function handleResetChat() {
  streamRunId.value += 1
  streamingMessageId.value = ""
  selectedEvidenceMessageId.value = ""
  evidenceExpanded.value = false
  sessionId.value = `qa-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`
  messages.value = []
  pendingQuestion.value = ""
  sidebarCollapsed.value = true
  autoScrollLocked.value = false
  refreshSuggestedQuestions({})
}

async function playAssistantMessage(messageId, content) {
  const frames = buildStreamingFrames(content, { minChunkSize: 20, maxFrames: 12 })
  const currentRunId = ++streamRunId.value
  streamingMessageId.value = messageId
  for (let index = 0; index < frames.length; index += 1) {
    if (streamRunId.value !== currentRunId) return
    setMessagePatch(messageId, { displayedContent: frames[index], isStreaming: index < frames.length - 1 })
    await scrollConversationToBottom(index === 0)
    if (index < frames.length - 1) {
      await new Promise((resolve) => window.setTimeout(resolve, index === 0 ? 160 : 90))
    }
  }
  setMessagePatch(messageId, { displayedContent: content, isStreaming: false })
  streamingMessageId.value = ""
}

function handleStopStreaming() {
  const messageId = streamingMessageId.value
  const targetMessage = messages.value.find((item) => item.id === messageId)
  streamRunId.value += 1
  streamingMessageId.value = ""
  if (targetMessage) setMessagePatch(messageId, { displayedContent: targetMessage.content, isStreaming: false })
}

async function copyAssistantMessage(messageItem) {
  const text = String(messageItem?.content || "").trim()
  if (!text) return
  try {
    if (globalThis.navigator?.clipboard?.writeText) {
      await globalThis.navigator.clipboard.writeText(text)
    } else {
      throw new Error("clipboard unavailable")
    }
    message("回答已复制", { type: "success" })
  } catch (error) {
    message("复制失败，请稍后重试", { type: "warning" })
  }
}

function openEvidencePanel(messageId) {
  selectedEvidenceMessageId.value = messageId
  evidenceExpanded.value = true
  sidebarCollapsed.value = false
}

function resolveUserQuestionForMessage(messageItem) {
  const targetIndex = messages.value.findIndex((item) => item.id === messageItem.id)
  for (let index = targetIndex - 1; index >= 0; index -= 1) {
    if (messages.value[index].role === "user") return messages.value[index].content
  }
  return latestUserMessage.value?.content || ""
}

async function handleRegenerate(messageItem) {
  const question = resolveUserQuestionForMessage(messageItem)
  if (!question || chatLoading.value) return
  await sendQuestion(question, { preserveUserMessage: true })
}

async function sendQuestion(question, options = {}) {
  if (chatLoading.value) return
  const normalizedQuestion = String(question || "").trim()
  if (!normalizedQuestion) {
    message("请输入问题后再发送", { type: "warning" })
    return
  }

  if (!options.preserveUserMessage) {
    messages.value.push(createMessage("user", normalizedQuestion))
  }

  const assistantMessage = createMessage("assistant", "", { displayedContent: "", llmStatus: "streaming", isStreaming: true, analysisMeta: emptyMeta() })
  messages.value.push(assistantMessage)
  pendingQuestion.value = ""
  chatLoading.value = true
  selectedEvidenceMessageId.value = assistantMessage.id
  evidenceExpanded.value = false
  await scrollConversationToBottom(true)

  try {
    const result = normalizeObject(await productQaChatApi(buildChatPayload(normalizedQuestion)))
    const assistantContent = tryDecodeMojibake(result.answer || "我先给你一个简短结论：当前没有拿到可展示的分析结果，换个条件再试试。")
    const analysisMeta = normalizeAnalysisMeta(result.analysisMeta)
    setMessagePatch(assistantMessage.id, {
      content: assistantContent,
      displayedContent: "",
      llmStatus: String(result.llmStatus || "success"),
      analysisMeta,
      analysisSummary: buildAnalysisSummary(analysisMeta),
      isStreaming: true,
    })
    await playAssistantMessage(assistantMessage.id, assistantContent)
    await refreshSuggestedQuestions(extractQuestionContext(normalizedQuestion))
  } catch (error) {
    const fallbackContent = "这次没能顺利拿到完整回答。你可以补充商品 ID、商家 ID、类目或时间范围后再试一次。"
    setMessagePatch(assistantMessage.id, {
      content: fallbackContent,
      displayedContent: fallbackContent,
      llmStatus: "database_unavailable",
      analysisMeta: emptyMeta(),
      analysisSummary: buildAnalysisSummary({}),
      isStreaming: false,
    })
    message(error?.message || "问答生成失败，请稍后重试", { type: "error" })
  } finally {
    chatLoading.value = false
    streamingMessageId.value = ""
    await scrollConversationToBottom()
  }
}

async function handleSendQuestion() {
  await sendQuestion(pendingQuestion.value)
}

onMounted(() => refreshSuggestedQuestions({}))
onBeforeUnmount(() => {
  streamRunId.value += 1
})
</script>

<style scoped lang="scss">
.qa-page { display: flex; flex-direction: column; gap: 18px; min-height: calc(100vh - 120px); }
.qa-topbar, .qa-topbar__actions, .qa-main__header, .qa-composer__footer { display: flex; gap: 12px; }
.qa-topbar { justify-content: space-between; align-items: flex-end; padding-top: 6px; }
.qa-topbar__eyebrow, .qa-evidence-block__title, .qa-evidence-summary__label, .qa-stat span { font-size: 11px; font-weight: 700; letter-spacing: .16em; text-transform: uppercase; color: #74859c; }
.qa-topbar__title { margin: 0; font: 700 clamp(26px, 2vw, 34px)/1.05 Georgia, serif; letter-spacing: -.03em; color: #122033; }
.qa-status { display: inline-flex; align-items: center; gap: 8px; min-height: 36px; padding: 0 14px; border: 1px solid rgba(211,220,230,.9); border-radius: 999px; background: rgba(255,255,255,.88); color: #4e6178; font-size: 12px; font-weight: 700; }
.qa-status__dot, .qa-streaming__dot { width: 8px; height: 8px; border-radius: 999px; background: #cbd5e1; }
.qa-status.is-success .qa-status__dot, .qa-status.is-fallback .qa-status__dot { background: #22c55e; }
.qa-status.is-streaming .qa-status__dot, .qa-status.is-needs_clarification .qa-status__dot { background: #f59e0b; }
.qa-status.is-no_data .qa-status__dot, .qa-status.is-database_unavailable .qa-status__dot { background: #ef4444; }
.qa-shell { position: relative; }
.qa-main { min-height: 760px; border: 1px solid rgba(220,228,238,.88); border-radius: 28px; background: radial-gradient(circle at top, rgba(241,245,249,.92), transparent 34%), linear-gradient(180deg, rgba(255,255,255,.98), rgba(247,250,253,.96)); box-shadow: 0 24px 54px rgba(15,23,42,.08); overflow: hidden; }
.qa-main__header { align-items: center; justify-content: space-between; padding: 18px 22px; border-bottom: 1px solid rgba(226,232,240,.8); background: rgba(250,252,255,.82); }
.qa-main__title { color: #112033; font-size: 16px; font-weight: 700; }
.qa-main__sub { margin-top: 4px; color: #71839b; font-size: 12px; line-height: 1.6; }
.qa-stream { height: calc(100vh - 360px); min-height: 420px; padding: 24px 24px 18px; overflow-y: auto; display: flex; flex-direction: column; gap: 24px; }
.qa-stream.is-empty { justify-content: center; }
.qa-welcome { display: grid; gap: 12px; max-width: 760px; }
.qa-chip-list { display: flex; flex-wrap: wrap; gap: 10px; }
.qa-chip, .qa-link { border: 0; background: none; cursor: pointer; }
.qa-chip--action { min-height: 38px; padding: 10px 14px; border: 1px solid rgba(223,230,239,.95); border-radius: 18px; background: rgba(255,255,255,.92); color: #31445c; font-size: 13px; line-height: 1.55; text-align: left; transition: transform .16s ease, box-shadow .18s ease; }
.qa-chip--static { min-height: 32px; padding: 7px 11px; border: 1px solid rgba(223,230,239,.95); border-radius: 999px; background: rgba(255,255,255,.92); color: #31445c; font-size: 12px; }
.qa-chip--action:hover, .qa-link:hover { transform: translateY(-1px); box-shadow: 0 12px 22px rgba(15,23,42,.08); }
.qa-message { display: grid; grid-template-columns: 42px minmax(0, 1fr); gap: 14px; align-items: start; }
.qa-message__avatar { display: flex; align-items: center; justify-content: center; width: 42px; height: 42px; border-radius: 16px; background: #e8eef7; color: #15304f; font-size: 12px; font-weight: 800; }
.qa-message.is-user .qa-message__avatar { background: linear-gradient(135deg, #1c304c, #29476d); color: #f8fbff; }
.qa-message__body { display: grid; gap: 10px; }
.qa-message__meta { display: flex; align-items: center; justify-content: space-between; gap: 14px; color: #6f8197; font-size: 12px; }
.qa-message__content { display: grid; gap: 12px; max-width: 880px; padding: 18px 20px; border: 1px solid rgba(225,232,240,.9); border-radius: 24px; background: rgba(255,255,255,.95); color: #203348; }
.qa-message.is-user .qa-message__content { margin-left: auto; width: min(100%, 620px); background: linear-gradient(135deg, #1b2f49, #294764); border-color: rgba(27,47,73,.8); color: #f8fbff; }
.qa-block { margin: 0; color: inherit; font-size: 14px; line-height: 1.9; white-space: pre-wrap; word-break: break-word; }
.qa-block--heading { color: #64748b; font-size: 12px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
.qa-message.is-user .qa-block--heading { color: rgba(241,245,249,.84); }
.qa-block--list { display: grid; gap: 8px; margin: 0; padding-left: 18px; color: inherit; font-size: 14px; line-height: 1.85; }
.qa-streaming { display: inline-flex; align-items: center; gap: 8px; color: #5f728b; font-size: 12px; font-weight: 700; }
.qa-streaming__dot { background: #2563eb; animation: qa-pulse 1.1s ease-in-out infinite; }
.qa-message__footer { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
.qa-message__actions { display: flex; gap: 8px; opacity: 0; transition: opacity .16s ease; }
.qa-message:hover .qa-message__actions { opacity: 1; }
.qa-link { color: #61758d; font-size: 12px; font-weight: 700; }
.qa-composer-wrap { position: sticky; bottom: 0; padding: 0 24px 24px; background: linear-gradient(180deg, rgba(247,250,253,0), rgba(247,250,253,.95) 28%); }
.qa-composer { padding: 14px; border: 1px solid rgba(219,227,237,.92); border-radius: 24px; background: rgba(255,255,255,.98); box-shadow: 0 18px 36px rgba(15,23,42,.08), inset 0 1px 0 rgba(255,255,255,.85); }
:deep(.qa-composer .el-textarea__inner) { min-height: 116px; border-radius: 18px; background: #fbfcfe; box-shadow: 0 0 0 1px rgba(226,232,240,.95); }
:deep(.qa-composer .el-textarea__inner:focus) { box-shadow: 0 0 0 1px rgba(65,106,170,.38); }
.qa-composer__footer { align-items: flex-end; justify-content: space-between; margin-top: 14px; }
.qa-composer__tips { display: grid; gap: 4px; color: #74859c; font-size: 12px; line-height: 1.6; }
.qa-composer__actions { display: flex; gap: 10px; flex-wrap: wrap; }
.qa-mask { position: fixed; inset: 0; background: rgba(15,23,42,.24); backdrop-filter: blur(2px); z-index: 9; }
.qa-sidebar { position: fixed; top: 92px; right: 18px; bottom: 20px; width: min(360px, calc(100vw - 36px)); padding: 8px; display: flex; flex-direction: column; gap: 12px; border: 1px solid rgba(216,224,235,.92); border-radius: 28px; background: rgba(247,250,253,.98); box-shadow: 0 28px 60px rgba(15,23,42,.18); overflow-y: auto; z-index: 10; transition: transform .18s ease, opacity .18s ease; }
.qa-sidebar.is-collapsed { transform: translateX(calc(100% + 24px)); opacity: 0; pointer-events: none; }
.qa-panel { padding: 18px; border: 1px solid rgba(223,230,239,.92); border-radius: 22px; background: rgba(255,255,255,.96); }
.qa-panel__header { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-bottom: 14px; color: #172539; font-size: 15px; font-weight: 700; }
.qa-stats { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; }
.qa-stat { padding: 13px 14px; border: 1px solid rgba(226,232,240,.9); border-radius: 18px; background: rgba(248,250,252,.92); }
.qa-stat--wide { grid-column: 1 / -1; }
.qa-stat strong { color: #162538; font-size: 16px; font-weight: 700; }
.qa-stat__mono { display: block; font-size: 12px !important; line-height: 1.6; word-break: break-all; }
.qa-chip-list--dense { gap: 8px; }
.qa-evidence-summary { display: grid; gap: 8px; margin-bottom: 12px; padding: 14px; border: 1px solid rgba(226,232,240,.88); border-radius: 18px; background: rgba(248,250,252,.92); color: #2b3d54; font-size: 13px; line-height: 1.8; }
.qa-evidence-block + .qa-evidence-block { margin-top: 14px; }
.qa-code { margin: 0; padding: 14px; border: 1px solid rgba(226,232,240,.88); border-radius: 16px; background: #f8fafc; color: #24364b; font-size: 12px; line-height: 1.65; white-space: pre-wrap; word-break: break-word; }
.qa-empty-hint { color: #62748b; font-size: 13px; line-height: 1.8; }
@keyframes qa-pulse { 0%,100% { transform: scale(.85); opacity: .62; } 50% { transform: scale(1.1); opacity: 1; } }
@media (max-width: 1080px) { .qa-topbar, .qa-topbar__actions, .qa-main__header, .qa-composer__footer { flex-direction: column; align-items: flex-start; } .qa-stream { height: calc(100vh - 410px); } }
@media (max-width: 768px) { .qa-main { min-height: 680px; border-radius: 24px; } .qa-stream { height: calc(100vh - 420px); min-height: 340px; padding: 18px 16px 14px; } .qa-composer-wrap { padding: 0 16px 16px; } .qa-message { grid-template-columns: 36px minmax(0, 1fr); gap: 10px; } .qa-message__avatar { width: 36px; height: 36px; border-radius: 14px; } .qa-message__content, .qa-message.is-user .qa-message__content { max-width: 100%; width: 100%; } .qa-message__actions { opacity: 1; flex-wrap: wrap; } .qa-sidebar { top: auto; right: 12px; left: 12px; bottom: 12px; width: auto; max-height: 74vh; } }
</style>
