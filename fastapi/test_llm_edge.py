import json
import os
from openai import OpenAI
from pydantic import BaseModel

client = OpenAI(api_key='ollama', base_url='http://localhost:11434/v1')

class RecommendItem(BaseModel):
    itemId: int | None = None
    title: str | None = ""
    category: str | None = ""
    sellerId: str | int | None = None
    clickCnt: float | int | None = 0
    collectCnt: float | int | None = 0
    cartCnt: float | int | None = 0
    payCnt: float | int | None = 0
    clickCnt7D: float | int | None = 0
    clickUv7D: float | int | None = 0
    payPerClick7D: float | int | None = 0
    recommendationScore: float | int | None = 0
    recommendationLevel: str | None = ""
    recommendationReason: str | None = ""

def compute_rule_score(item):
    score = (
        float(item.payCnt or 0) * 0.45
        + float(item.clickCnt or 0) * 0.20
        + float(item.clickCnt7D or 0) * 0.15
        + float(item.clickUv7D or 0) * 0.10
        + max(float(item.payPerClick7D or 0), 0.0) * 100 * 0.10
    )
    return round(score, 4)

def build_llm_prompt(keyword, items):
    compact_items = []
    for item in items[:20]:
        compact_items.append({
            "itemId": item.itemId,
            "title": item.title,
            "category": item.category,
            "sellerId": item.sellerId,
            "clickCnt": item.clickCnt,
            "payCnt": item.payCnt,
            "clickCnt7D": item.clickCnt7D,
            "clickUv7D": item.clickUv7D,
            "payPerClick7D": item.payPerClick7D,
            "ruleScore": compute_rule_score(item),
        })

    return (
        "你是电商运营分析助手。请根据商品标题关键字、销量、点击与近7日行为特征，"
        "为每个商品输出推荐理由与推荐等级。"
        "请仅返回 JSON，不要输出 Markdown。"
        'JSON 格式必须为 {"items":[{"itemId":123,"recommendationReason":"...","recommendationLevel":"高推荐"}]}。'
        f" 关键字：{keyword}。 商品列表：{json.dumps(compact_items, ensure_ascii=False)}"
    )

# 测试用例1: 空列表
print("=== 测试空列表 ===")
try:
    if []:
        print("会执行")
    else:
        print("空列表，不会调用 LLM（符合预期）")
except Exception as e:
    print(f"错误: {e}")

# 测试用例2: itemId 为 None
print("\n=== 测试 itemId 为 None ===")
item = RecommendItem(itemId=None, title="测试商品", payCnt=10)
prompt = build_llm_prompt("测试", [item])
print(f"Prompt 包含: itemId={item.itemId}")

try:
    response = client.chat.completions.create(
        model='qwen3:8b',
        temperature=0.2,
        messages=[
            {"role": "system", "content": "你是严谨的电商运营分析助手。"},
            {"role": "user", "content": prompt},
        ],
        response_format={"type": "json_object"},
    )
    content = response.choices[0].message.content
    data = json.loads(content)
    print(f"返回数据: {json.dumps(data, ensure_ascii=False)}")
except Exception as e:
    print(f"错误: {e}")
    import traceback
    print(traceback.format_exc())

# 测试用例3: 大量数据
print("\n=== 测试大量数据 ===")
items = []
for i in range(50):
    items.append(RecommendItem(
        itemId=i+1,
        title=f"商品{i+1}" * 10,
        payCnt=i*10,
        clickCnt=i*20
    ))

prompt = build_llm_prompt("关键字" * 50, items)
print(f"Prompt 长度: {len(prompt)} 字符")

try:
    response = client.chat.completions.create(
        model='qwen3:8b',
        temperature=0.2,
        messages=[
            {"role": "system", "content": "你是严谨的电商运营分析助手。"},
            {"role": "user", "content": prompt},
        ],
        response_format={"type": "json_object"},
    )
    content = response.choices[0].message.content
    data = json.loads(content)
    print(f"返回 items 数量: {len(data.get('items', []))}")
except Exception as e:
    print(f"错误: {e}")
    import traceback
    print(traceback.format_exc())
