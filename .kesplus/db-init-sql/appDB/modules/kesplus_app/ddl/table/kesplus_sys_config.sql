-- "kesplus_app"."kesplus_sys_config" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_sys_config";

CREATE TABLE "kesplus_app"."kesplus_sys_config" (
	"id" character varying(64 char) NOT NULL,
	"config_key" character varying(500 char) NOT NULL,
	"config_value" character varying(1000 char) NOT NULL,
	"scope" smallint NULL DEFAULT 1,
	"scope_id" character varying(64 char) NULL DEFAULT 0,
	"create_by" character varying(64 char) NULL DEFAULT 0,
	"create_time" date NOT NULL,
	"update_by" character varying(64 char) NULL,
	"update_time" date NULL,
	"is_deleted" bigint NULL DEFAULT 0,
	CONSTRAINT "pk_sys_config" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."id" IS 'id主键';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."config_key" IS '配置key';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."config_value" IS '配置值';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."scope" IS '作用域类型/配置权重，1为平台，2为应用，3为租户，4为部门，5为用户';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."scope_id" IS '作用域，类型为平台时无意义，类型为应用时为应用id，类型为租户时为租户id，类型为部门时为部门id，类型为用户时为用户id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_config"."is_deleted" IS '逻辑删除标志，0为正常';