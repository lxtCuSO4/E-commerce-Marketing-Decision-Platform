-- "kesplus_base"."kesplus_ding_message_template" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_ding_message_template";

CREATE TABLE "kesplus_base"."kesplus_ding_message_template" (
	"id" varchar NOT NULL,
	"name" varchar NOT NULL,
	"content" text NOT NULL,
	"create_time" datetime NULL,
	"enabled" boolean NULL DEFAULT true,
	"remark" text NULL,
	CONSTRAINT "con_kesplus_base_kesplus_ding_message_template_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_ding_message_template" IS '钉钉消息模板';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_ding_message_template"."name" IS '模板名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_ding_message_template"."content" IS '模板内容';
COMMENT ON COLUMN "kesplus_base"."kesplus_ding_message_template"."enabled" IS '是否开启 ';