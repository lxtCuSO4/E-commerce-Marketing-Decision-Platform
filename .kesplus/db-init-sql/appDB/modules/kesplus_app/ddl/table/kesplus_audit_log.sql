-- DROP TABLE "kesplus_app"."kesplus_audit_log";

CREATE TABLE "kesplus_app"."kesplus_audit_log" (
	"id" varchar NOT NULL,
	"request_id" varchar NULL,
	"request_body" jsonb NULL,
	"request_header" jsonb NULL,
	"response_body" jsonb NULL,
	"create_time" datetime NULL,
	"module_code" varchar NULL,
	"rest_url" varchar null,
	"method" varchar NULL,
	"client_ip" varchar NULL,
	"status" integer NULL DEFAULT 1,
	"rest_remark" text,
	"user_id" varchar,
	"username" varchar,
	CONSTRAINT "con_table_name_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_app"."kesplus_audit_log" IS '审计日志表';