CREATE TABLE "${moduleSchema}"."kes_form_table" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"table_name" character varying(128 char) NOT NULL,
	"type" smallint NOT NULL DEFAULT 1,
	"foreign_key_field" character varying(128 char) NULL,
	"relation_field" varchar NULL,
	"description" character varying(500 char) NULL,
	"create_time" datetime NULL,
	CONSTRAINT "con_kes_plus_kes_form_table_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "${moduleSchema}"."kes_form_table" IS '表单关联表信息';

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."form_id" IS '表单id';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."table_name" IS '表名';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."type" IS '表类型 1主表；2 子表';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."foreign_key_field" IS '外键字段';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."relation_field" IS '关联字段';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."description" IS '说明';
COMMENT ON COLUMN "${moduleSchema}"."kes_form_table"."create_time" IS '创建时间';