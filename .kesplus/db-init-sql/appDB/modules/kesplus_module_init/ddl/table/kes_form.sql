CREATE TABLE "${moduleSchema}"."kes_form" (
	"id" character varying(32 char) NOT NULL,
	"form_name" character varying(128 char) NOT NULL,
	"form_code" character varying(128 char) NOT NULL,
	"form_path" character varying(1024 char) NULL,
	"module_id" character varying(32 char) NULL,
	"description" text NULL,
	"form_type" smallint NULL DEFAULT 1,
	"form_theme" smallint NULL DEFAULT 1,
	"form_style" smallint NULL,
	"form_config" json NULL,
	"form_record" json NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	"create_by" varchar NULL,
	"update_by" varchar NULL,
	CONSTRAINT "con_kes_plus_kes_form_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "${moduleSchema}"."kes_form" IS '表单定义';

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kes_form"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_name" IS '表单名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_code" IS '表单编码';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."module_id" IS '模块ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."description" IS '说明';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_type" IS '表单类型：1 单表; 2 一对一; 3 一对多';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_theme" IS '主题类型：1,2,3';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_style" IS '表单属性排列样式：一列、两列、三列、四列';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."create_by" IS '创建人';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."update_by" IS '更新人';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_path" IS '表单页面地址';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_config" IS '代码生成配置';
COMMENT ON COLUMN "${moduleSchema}"."kes_form"."form_record" IS '记录生成数据';