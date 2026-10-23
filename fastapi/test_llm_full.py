import json
import os
from openai import OpenAI

client = OpenAI(api_key='ollama', base_url='http://localhost:11434/v1')

# 模拟实际的 prompt 结构
prompt = """你是电商运营分析助手。请根据商品标题关键字、销量、点击与近7日行为特征，为每个商品输出推荐理由与推荐等级。
请仅返回 JSON，不要输出 Markdown。
JSON 格式必须为 {"items":[{"itemId":123,"recommendationReason":"...","recommendationLevel":"高推荐"}]}。
关键字：测试。 商品列表：[{"itemId": 1, "title": "测试商品", "category": "测试", "sellerId": "S001", "clickCnt": 100, "payCnt": 50, "clickCnt7D": 20, "clickUv7D": 15, "payPerClick7D": 0.5, "ruleScore": 45.5}]"""

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
    print("成功，返回内容:")
    print(content)

    # 验证 JSON 解析
    data = json.loads(content)
    print("\n解析后的数据:")
    print(json.dumps(data, ensure_ascii=False, indent=2))

except Exception as e:
    print("失败:", str(e))
    import traceback
    print(traceback.format_exc())
