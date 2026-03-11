CREATE TABLE "kesplus_base"."kesplus_message_record" (
	"id" character varying(32 char) NOT NULL,
	"template_code" character varying(32 char) NOT NULL,
	"sender_id" character varying(32 char) NOT NULL,
	"status" integer NULL DEFAULT 1,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	"send_record" jsonb NULL,
	CONSTRAINT "kesplus_message_record_pkey" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."template_code" IS '模板id';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."sender_id" IS '发送人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."status" IS '状态 1待发送 2发送中 3已完成';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_record"."send_record" IS '发送记录';