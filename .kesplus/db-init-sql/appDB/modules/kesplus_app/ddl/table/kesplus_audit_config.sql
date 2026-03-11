
CREATE TABLE "kesplus_app"."kesplus_audit_config" (
	"id" varchar NOT NULL,
	"type" varchar NULL,
	"obj_id" varchar NULL,
	"obj_value" jsonb NULL,
	"create_time" datetime NULL,
	CONSTRAINT "con_kesplus_app_kesplus_audit_config_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_app"."kesplus_audit_config" IS '审计配置表';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_audit_config"."type" IS '类型 table ';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_config"."obj_id" IS '对象id';
COMMENT ON COLUMN "kesplus_app"."kesplus_audit_config"."obj_value" IS '对象值';