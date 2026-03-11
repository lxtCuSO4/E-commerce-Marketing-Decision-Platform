-- "${moduleSchema}"."kes_form_page_properties" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kes_form_page_properties";

CREATE TABLE "${moduleSchema}"."kes_form_page_properties" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"table_name" character varying(128 char) NOT NULL,
	"field_name" character varying(128 char) NOT NULL,
	"field_type" character varying(256 char) NULL,
	"field_num" integer NULL,
	"label" character varying(128 char) NOT NULL,
	"label_name" character varying(128 char) NOT NULL,
	"required" boolean NULL DEFAULT true,
	"editable" boolean NULL DEFAULT true,
	"pk" boolean NULL DEFAULT false,
	"hidden" boolean NULL DEFAULT false,
	"component" character varying(128 char) NULL,
	"other" json NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	"field_status" integer NULL DEFAULT 0,
	CONSTRAINT "con_kes_plus_kes_form_page_properties_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "${moduleSchema}"."kes_form_page_properties" IS '表单页面属性';

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."form_id" IS '表单ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."table_name" IS '表名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."field_name" IS '表字段名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."field_type" IS '表字段数据类型';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."label" IS '表单属性显示名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."label_name" IS '表单属性字段';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."required" IS '是否必填';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."editable" IS '是否编辑';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."pk" IS '是否主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."hidden" IS '是否隐藏';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."component" IS '输入组件：text、textarea、select等';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."other" IS '其他扩展属性';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."field_num" IS '字段排序号';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_page_properties"."field_status" IS '字段状态 0正常  1新增 2删除';