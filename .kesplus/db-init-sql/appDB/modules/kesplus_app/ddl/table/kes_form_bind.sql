DROP TABLE IF EXISTS "kesplus_app"."kes_form_bind";

CREATE TABLE "kesplus_app"."kes_form_bind" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"process_id" character varying(32 char) NOT NULL,
	"config_name" character varying(128 char) NOT NULL,
	"config_code" character varying(128 char) NULL,
	"variables" json NULL,
	"properties" json NULL,
	"process_title" character varying(128 char) NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	CONSTRAINT "con_kesplus_app_kes_form_bind_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_app"."kes_form_bind" IS '表单流程绑定';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."id" IS '主键';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."form_id" IS '表单ID';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."process_id" IS '流程ID';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."config_name" IS '配置名称';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."config_code" IS '配置编码';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."properties" IS '节点表单属性集合';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_app"."kes_form_bind"."variables" IS '流程变量映射';
