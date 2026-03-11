-- "kesplus_app"."kesplus_code_template" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_code_template";

CREATE TABLE "kesplus_app"."kesplus_code_template" (
	"id" varchar NOT NULL,
	"name" varchar NOT NULL,
	"code" varchar NOT NULL,
	"content" text NOT NULL,
	"description" text NULL,
	"type" integer NOT NULL DEFAULT 1,
	"pid" varchar NULL DEFAULT 0,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	CONSTRAINT "con_kesplus_app_kesplus_code_template_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_app"."kesplus_code_template" IS '代码生成模板';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."name" IS '名称';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."code" IS '编码';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."content" IS '模板内容';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."description" IS '描述';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."type" IS '标识 0 系统模板';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_code_template"."update_time" IS '更新时间';