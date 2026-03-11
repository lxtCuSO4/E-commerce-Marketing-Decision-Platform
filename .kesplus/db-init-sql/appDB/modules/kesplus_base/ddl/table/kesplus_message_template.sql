CREATE TABLE "kesplus_base"."kesplus_message_template" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(32 char) NOT NULL,
	"category_code" varchar NOT NULL,
	"content" text NULL,
	"placeholders" jsonb NULL,
	"preview" text NULL,
	"type" varchar NULL,
	"create_time" datetime NULL DEFAULT "sysdate"(),
	"update_time" datetime NULL DEFAULT "sysdate"(),
	"title" varchar NULL,
	"code" character varying(32 char) NULL,
	"link_url" text NULL,
	"receive_scope" jsonb NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_template_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kesplus_base_kesplus_message_template_constraint_2" UNIQUE (code)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_template" IS '消息模板表';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."name" IS '模板名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."category_code" IS '分类编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."content" IS '模板内容';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."placeholders" IS '占位符';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."preview" IS '预览内容';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."type" IS '模板类型（TEXT HTML MARKDOWN等）';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."title" IS '消息标题';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."code" IS '模板编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_template"."receive_scope" IS '接收范围';