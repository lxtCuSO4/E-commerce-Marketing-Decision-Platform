CREATE TABLE "kesplus_base"."kesplus_message_push" (
	"id" character varying(32 char) NOT NULL,
	"create_time" datetime NULL DEFAULT "sysdate"(),
	"push_time" datetime NULL,
	"status" integer NULL DEFAULT 0,
	"retry" integer NULL DEFAULT 0,
	"app_code" varchar NULL,
	"payload" jsonb NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_push_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_push" IS '消息推送记录';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_push"."status" IS '状态 0待推送  1推送完成';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_push"."retry" IS '重试次数';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_push"."app_code" IS '应用编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_push"."payload" IS '携带参数';