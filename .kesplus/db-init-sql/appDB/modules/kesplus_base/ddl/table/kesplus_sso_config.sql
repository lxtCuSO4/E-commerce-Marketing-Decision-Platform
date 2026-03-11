-- "kesplus_base"."kesplus_sso_config" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_sso_config";

CREATE TABLE "kesplus_base"."kesplus_sso_config" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(50 char) NULL,
	"enabled" smallint NULL DEFAULT 0,
	"schema_name" character varying(64 char) NULL,
	"pkg_name" character varying(64 char) NULL,
	"func_name" character varying(64 char) NOT NULL,
	"type" smallint NULL DEFAULT 0,
	"sso_index" character varying(255 char) NULL,
	"private_key" text NULL,
	"public_key" text NULL,
	"remark" character varying(255 char) NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"create_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_sso_config" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."id" IS '主键';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."name" IS '对接平台名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."code" IS '对接平台编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."enabled" IS '1生效；2停用';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."schema_name" IS '模式名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."pkg_name" IS '包名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."func_name" IS '函数名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."type" IS '0：本平台为服务端，此记录为解密配置；1-本平台为客户端，此记录为生成token配置';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."sso_index" IS 'type为1时有效，对接方单点登录地址';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."remark" IS '备注';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."create_time" IS '创建时间';