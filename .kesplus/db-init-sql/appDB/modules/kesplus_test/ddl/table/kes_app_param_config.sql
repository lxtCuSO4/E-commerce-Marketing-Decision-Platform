-- "kesplus_test"."kes_app_param_config" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_param_config";

CREATE TABLE "kesplus_test"."kes_app_param_config" (
	"id" character varying(32 char) NOT NULL,
	"key_name" character varying(255 char) NULL,
	"key_value" character varying(1000 char) NULL,
	"type" character varying(16 char) NULL,
	"remark" character varying(255 char) NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"app_id" character varying(32 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	CONSTRAINT "kes_app_scene_global_pkey" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."key_name" IS '参数名';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."key_value" IS '参数值';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."type" IS '参数类型
global :全局参数
header :header参数
form :表单参数
auth  认证参数（用户名等）';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."remark" IS '参数描述';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_param_config"."enabled" IS '是否开启 0否 1是';