from openai import OpenAI

client = OpenAI(api_key='ollama', base_url='http://localhost:11434/v1')

try:
    resp = client.chat.completions.create(
        model='qwen3:8b',
        messages=[{'role': 'user', 'content': 'hello'}]
    )
    print("成功:", resp.choices[0].message.content)
except Exception as e:
    print("失败:", str(e))
    import traceback
    print(traceback.format_exc())
