function normalizeText(value) {
  return String(value || "").replace(/\r/g, "").trim()
}

export function formatAssistantBlocks(content) {
  const text = normalizeText(content)
  if (!text) {
    return []
  }

  return text
    .split(/\n{2,}/)
    .map((chunk) => chunk.trim())
    .filter(Boolean)
    .flatMap((chunk) => {
      const lines = chunk
        .split("\n")
        .map((line) => line.trim())
        .filter(Boolean)

      if (!lines.length) {
        return []
      }

      const headingLine = lines[0].match(/^(.+?)[:：]$/)
      if (headingLine) {
        const remainingLines = lines.slice(1)
        const blocks = [{ type: "heading", text: headingLine[1] }]

        if (
          remainingLines.length > 1 &&
          remainingLines.every((line) => /^([-•*]|\d+[.、])\s*/.test(line))
        ) {
          blocks.push({
            type: "list",
            items: remainingLines.map((line) => line.replace(/^[-•*\s]*/, "").replace(/^\d+[.、]\s*/, "")),
          })
          return blocks
        }

        if (remainingLines.length) {
          blocks.push({ type: "paragraph", text: remainingLines.join("\n") })
        }

        return blocks
      }

      if (lines.length > 1 && lines.every((line) => /^([-•*]|\d+[.、])\s*/.test(line))) {
        return [
          {
            type: "list",
            items: lines.map((line) => line.replace(/^[-•*\s]*/, "").replace(/^\d+[.、]\s*/, "")),
          },
        ]
      }

      return [{ type: "paragraph", text: lines.join("\n") }]
    })
}

export function buildStreamingFrames(content, options = {}) {
  const text = normalizeText(content)
  if (!text) {
    return []
  }

  const minChunkSize = Math.max(6, Number(options.minChunkSize || 18))
  const maxFrames = Math.max(2, Number(options.maxFrames || 10))
  const segments = text.split(/(\n{2,}|[。！？])/).filter(Boolean)
  const frames = []
  let current = ""

  for (const segment of segments) {
    current += segment
    const compactLength = current.replace(/\s+/g, "").length
    if (compactLength >= minChunkSize && frames.length < maxFrames - 1) {
      frames.push(current.trim())
    }
  }

  if (!frames.length || frames.at(-1) !== text) {
    frames.push(text)
  }

  return frames.filter(Boolean)
}

export function buildAnalysisSummary(meta = {}) {
  const rowCount = Number(meta.rowCount || 0)
  const modules = Array.isArray(meta.modules) ? meta.modules.filter(Boolean).slice(0, 3) : []
  const tables = Array.isArray(meta.tables) ? meta.tables.filter(Boolean).slice(0, 2) : []
  const parts = []

  if (rowCount > 0) {
    parts.push(`搜索到 ${rowCount} 行数据`)
  }
  if (modules.length) {
    parts.push(`涉及 ${modules.join(" / ")}`)
  }
  if (tables.length) {
    parts.push(`参考表 ${tables.join("、")}`)
  }

  return parts.join("，") || "当前回答主要基于规则与上下文整理。"
}

export function getFriendlyStatusLabel(status) {
  const map = {
    success: "回答已准备好",
    fallback: "我先整理了一版可执行结论",
    needs_clarification: "我还需要你补充一点条件",
    no_data: "这次没有查到可用数据",
    database_unavailable: "暂时连不上业务数据，稍后再试",
  }

  return map[String(status || "").trim()] || "正在整理回答"
}
