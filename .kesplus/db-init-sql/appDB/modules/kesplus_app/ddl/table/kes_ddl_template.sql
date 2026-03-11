-- "kesplus_app"."kes_ddl_template" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kes_ddl_template";

CREATE TABLE "kesplus_app"."kes_ddl_template" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(128 char) NULL,
	"content" text NULL,
	"description" text NULL,
	CONSTRAINT "con_kes_plus_kes_ddl_template_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_ddl_template_constraint_2" UNIQUE (code)
);
COMMENT ON TABLE "kesplus_app"."kes_ddl_template" IS '脚本模板表';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_ddl_template"."id" IS '主键';
COMMENT ON COLUMN "kesplus_app"."kes_ddl_template"."code" IS '模板编码';
COMMENT ON COLUMN "kesplus_app"."kes_ddl_template"."content" IS '模板内容';
COMMENT ON COLUMN "kesplus_app"."kes_ddl_template"."description" IS '模板参数说明';