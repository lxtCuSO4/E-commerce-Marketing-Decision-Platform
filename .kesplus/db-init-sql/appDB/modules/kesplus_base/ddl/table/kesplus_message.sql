CREATE TABLE "kesplus_base"."kesplus_message" (
	"id" character varying(32 char) NOT NULL,
	"message_id" character varying(32 char) NULL,
	"receiver_id" varchar NULL,
	"title" text NULL,
	"content" text NULL,
	"read_status" integer NULL DEFAULT 0,
	"read_time" datetime NULL,
	"create_time" datetime NULL,
	"type" varchar NULL,
	"link_url" text NULL,
	"category_code" varchar NULL,
	"push_id" varchar NULL,
	"module_code" varchar NULL,
	"sender_id" varchar NULL,
	"reminder_method" integer NULL DEFAULT 0,
	"start_time" datetime NULL,
	"end_time" datetime NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_recipient_constraint_1" PRIMARY KEY (id)
);
CREATE INDEX inxex_kesplus_base_kesplus_message_index_1 ON kesplus_base.kesplus_message USING btree (receiver_id, read_status);
CREATE INDEX inxex_kesplus_base_kesplus_message_index_2 ON kesplus_base.kesplus_message USING btree (category_code);
COMMENT ON TABLE "kesplus_base"."kesplus_message" IS '消息接收表';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message"."message_id" IS '消息id';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."title" IS '消息标题';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."content" IS '消息内容';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."read_status" IS '阅读状态 未读0 已读1';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."read_time" IS '阅读时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."type" IS '消息类型';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."push_id" IS '推送id';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."module_code" IS '模块编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."sender_id" IS '发送者';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."reminder_method" IS '0 站内信 1 弹窗提醒';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."start_time" IS '开始时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message"."end_time" IS '截止时间';