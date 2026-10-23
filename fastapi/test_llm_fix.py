import json
import os
from openai import OpenAI

client = OpenAI(api_key='ollama', base_url='http://localhost:11434/v1')

# 构造一个长 prompt（模拟大量商品数据）
items = [{"itemId": i, "title": f"商品{i}" * 20, "payCnt": i*100} for i in range(30)]
prompt = "分析以下商品:" + json.dumps(items, ensure_ascii=False)

print(f"Prompt 长度: {len(prompt)} 字符")

# 测试1: 原始调用方式
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
    print(f"\n原始方式 - content 长度: {len(content) if content else 0}")
    print(f"content 内容: {repr(content[:200] if content else 'None')}")
except Exception as e:
    print(f"原始方式失败: {e}")

# 测试2: 去掉 response_format
try:
    response = client.chat.completions.create(
        model='qwen3:8b',
        temperature=0.2,
        messages=[
            {"role": "system", "content": "你是严谨的电商运营分析助手。"},
            {"role": "user", "content": prompt + "\n请仅返回JSON格式。"},
        ],
        # 不加 response_format
    )
    content = response.choices[0].message.content
    print(f"\n无 response_format - content 长度: {len(content) if content else 0}")
    print(f"content 内容: {repr(content[:200] if content else 'None')}")
except Exception as e:
    print(f"无 response_format 失败: {e}")

# 测试3: 减少商品数量（10条）
items_short = [{"itemId": i, "title": f"商品{i}", "payCnt": i*100} for i in range(10)]
prompt_short = "分析以下商品:" + json.dumps(items_short, ensure_ascii=False)
print(f"\n短 Prompt 长度: {len(prompt_short)} 字符")

try:
    response = client.chat.completions.create(
        model='qwen3:8b',
        temperature=0.2,
        messages=[
            {"role": "system", "content": "你是严谨的电商运营分析助手。"},
            {"role": "user", "content": prompt_short},
        ],
        response_format={"type": "json_object"},
    )
    content = response.choices[0].message.content
    print(f"短 prompt - content 长度: {len(content) if content else 0}")
    data = json.loads(content)
    print(f"解析成功，返回 items 数量: {len(data.get('items', []))}")
except Exception as e:
    print(f"短 prompt 失败: {e}")
