-- "kesplus_platform"."kesplus_sys_auth" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kesplus_sys_auth";

CREATE TABLE "kesplus_platform"."kesplus_sys_auth" (
	"id" character varying(64 char) NOT NULL,
	"auth_type" character varying(32 char) NOT NULL,
	"schema_name" character varying(64 char) NOT NULL,
	"object_type" character varying(16 char) NOT NULL,
	"object_name" character varying(128 char) NOT NULL,
	"role_name" character varying(64 char) NOT NULL,
	"create_by" character varying(32 char) NULL DEFAULT 0,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"is_deleted" bigint NULL DEFAULT 0,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"current_company" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_kesplus_sys_auth" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."id" IS 'id主键';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."auth_type" IS '权限类型，例如：SELECT、INSERT、EXECUTE、ALL';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."schema_name" IS '模式名称';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."object_type" IS '对象类型，例如：SCHEMA、ALL、PACKAGE、TABLE';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."object_name" IS '对象名称';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."role_name" IS '角色名称';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."is_deleted" IS '逻辑删除标志，0为正常';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."dept_id" IS '创建人部门id，有部门时为部门id，否则为公司id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_auth"."current_company" IS '创建人部门id';