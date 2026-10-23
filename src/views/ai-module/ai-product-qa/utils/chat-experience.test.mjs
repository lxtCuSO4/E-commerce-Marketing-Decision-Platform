import test from "node:test"
import assert from "node:assert/strict"

import {
  buildAnalysisSummary,
  buildStreamingFrames,
  formatAssistantBlocks,
  getFriendlyStatusLabel,
} from "./chat-experience.js"

test("formatAssistantBlocks keeps natural paragraphs and lists", () => {
  const blocks = formatAssistantBlocks(`先说结论：这款商品值得继续投放。\n\n原因：\n- 点击稳定\n- 转化不错\n\n建议先放大女装人群。`)

  assert.equal(blocks[0].type, "paragraph")
  assert.match(blocks[0].text, /值得继续投放/)
  assert.equal(blocks[1].type, "heading")
  assert.equal(blocks[1].text, "原因")
  assert.equal(blocks[2].type, "list")
  assert.deepEqual(blocks[2].items, ["点击稳定", "转化不错"])
  assert.equal(blocks[3].type, "paragraph")
})

test("buildStreamingFrames reveals assistant answer progressively", () => {
  const frames = buildStreamingFrames("第一段先给结论。\n\n第二段补充依据。", { minChunkSize: 6, maxFrames: 6 })

  assert.ok(frames.length >= 2)
  assert.equal(frames.at(-1), "第一段先给结论。\n\n第二段补充依据。")
  assert.ok(frames[0].length < frames.at(-1).length)
})

test("buildAnalysisSummary compresses visible evidence", () => {
  const summary = buildAnalysisSummary({
    rowCount: 12,
    modules: ["商品", "销量", "预测"],
    tables: ["item", "sales"],
  })

  assert.match(summary, /搜索到 12 行数据/)
  assert.match(summary, /商品/)
  assert.match(summary, /销量/)
})

test("getFriendlyStatusLabel rewrites system states conversationally", () => {
  assert.equal(getFriendlyStatusLabel("success"), "回答已准备好")
  assert.equal(getFriendlyStatusLabel("needs_clarification"), "我还需要你补充一点条件")
  assert.equal(getFriendlyStatusLabel("database_unavailable"), "暂时连不上业务数据，稍后再试")
})
