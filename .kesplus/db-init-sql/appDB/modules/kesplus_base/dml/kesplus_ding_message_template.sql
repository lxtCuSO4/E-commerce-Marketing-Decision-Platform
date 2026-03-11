INSERT INTO "kesplus_base"."kesplus_ding_message_template" ("id", "name", "content", "create_time", "enabled", "remark") VALUES('1', 'text', '{
    "msgtype": "text",
    "text": {
        "content": "${content}"
    }
}', '''2025-10-13 17:33:40''', true, '文本消息');
INSERT INTO "kesplus_base"."kesplus_ding_message_template" ("id", "name", "content", "create_time", "enabled", "remark") VALUES('3', 'action_card', '{
    "msgtype": "action_card",
    "action_card": {
    	"title":"${title}",
        "markdown": "${content}",
        "btn_orientation": "0",
        "btn_json_list": [
            {
                "title": "${btnName}",
                "action_url": "${btnLink}"
            }
		]
    }
}', '''2025-10-13 17:33:40''', true, '卡片消息，消息内容使用markdown语法编写，支持按钮跳转 默认一个按钮 如果需要多个请自行更改模板');
INSERT INTO "kesplus_base"."kesplus_ding_message_template" ("id", "name", "content", "create_time", "enabled", "remark") VALUES('2', 'markdown', '{
    "msgtype": "markdown",
    "markdown": {
    	"title":"${title}",
        "text": "${content}"
    }
}', '''2025-10-13 17:33:40''', true, 'markdown消息 消息内容使用markdown语法编写');
