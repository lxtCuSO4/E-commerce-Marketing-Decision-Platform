const TITLE_KEYWORDS = [
  "连衣裙",
  "羽绒服",
  "针织衫",
  "打底衫",
  "秋装",
  "冬装",
  "夏装",
  "春装",
  "女装",
  "男装",
  "外套",
  "衬衫",
  "裤装",
  "毛衣",
  "卫衣",
  "短袖",
  "长袖",
]

export function extractQuestionContext(text) {
  const question = String(text || "").trim()
  const itemIdMatch = question.match(/(?:商品\s*ID|商品ID|item\s*id|itemId|ID)\s*[:：]?\s*(\d{3,})/i)
  const categoryMatch = question.match(/(?:类目|品类)\s*[:：]?\s*([^\s，。；,.]{2,20})/)
  const title = TITLE_KEYWORDS.find((keyword) => question.includes(keyword)) || ""

  return {
    itemId: itemIdMatch?.[1] || "",
    category: categoryMatch?.[1] || "",
    title,
  }
}
