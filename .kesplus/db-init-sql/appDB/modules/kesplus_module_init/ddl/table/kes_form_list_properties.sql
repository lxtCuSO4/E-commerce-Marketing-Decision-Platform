-- "${moduleSchema}"."kes_form_list_properties" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kes_form_list_properties";

CREATE TABLE "${moduleSchema}"."kes_form_list_properties" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"table_name" character varying(128 char) NOT NULL,
	"field_name" character varying(128 char) NOT NULL,
	"field_type" character varying(128 char) NULL,
	"label" character varying(128 char) NOT NULL,
	"label_name" character varying(128 char) NOT NULL,
	"pk" boolean NULL DEFAULT false,
	"sort_type" character varying(10 char) NULL,
	"component" character varying(128 char) NULL,
	"query_condition" boolean NULL DEFAULT false,
	"field_num" integer NULL DEFAULT 0,
	"other" json NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	CONSTRAINT "kes_form_list_properties_pkey" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."form_id" IS '表单ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."table_name" IS '表名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."field_name" IS '表字段名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."field_type" IS '字段类型';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."label" IS '表单属性显示名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."label_name" IS '表单属性名';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."pk" IS '是否主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."other" IS '其他扩展属性';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."sort_type" IS '排序类型 正序 asc ;倒序 desc';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."component" IS '组件类型';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."query_condition" IS '是否为查询条件';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_list_properties"."field_num" IS '字段排序号';