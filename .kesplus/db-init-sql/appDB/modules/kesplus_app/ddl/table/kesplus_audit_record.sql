-- "kesplus_app"."kesplus_audit_record" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_audit_record";

CREATE TABLE "kesplus_app"."kesplus_audit_record" (
	"id" varchar NOT NULL,
	"table_name" varchar NULL,
	"operation_type" varchar NULL,
	"old_values" jsonb NULL,
	"new_values" jsonb NULL,
	"create_time" datetime NULL DEFAULT CURRENT_TIMESTAMP,
	"request_id" varchar NULL,
	"module_code" varchar NULL,
	"biz_table_name" varchar NULL,
	"change_data" jsonb NULL,
	"table_alias_name" varchar NULL,
	"convert_old_values" jsonb NULL,
	"convert_new_values" jsonb NULL,
	CONSTRAINT "con_kesplus_audit_record_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_app"."kesplus_audit_record" IS '审计记录表';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."table_name" IS '表名';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."operation_type" IS '操作类型';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."old_values" IS '旧数据';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."new_values" IS '新数据';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."create_time" IS '创建日期';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."request_id" IS '请求id';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."module_code" IS '模块编码';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_record"."table_alias_name" IS '表别名';