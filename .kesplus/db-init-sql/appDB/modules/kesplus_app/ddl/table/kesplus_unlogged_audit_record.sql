CREATE UNLOGGED TABLE "kesplus_app"."kesplus_unlogged_audit_record" (
	"id" varchar NOT NULL,
	"table_name" varchar NULL,
	"operation_type" varchar NULL,
	"old_values" jsonb NULL,
	"new_values" jsonb NULL,
	"create_time" datetime NULL DEFAULT CURRENT_TIMESTAMP,
	"request_id" varchar NULL,
	"module_code" varchar NULL,
	"convert_old_values" jsonb NULL,
	"convert_new_values" jsonb NULL,
	CONSTRAINT "pk_unlogged_audit_record" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_unlogged_audit_record"."module_code" IS '模块编码';