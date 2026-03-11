-- "kesplus_base"."kesplus_tenant" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_tenant";

CREATE TABLE "kesplus_base"."kesplus_tenant" (
	"id" character varying(32 char) NOT NULL,
	"tenant_name" character varying(128 char) NOT NULL,
	"tenant_code" character varying(32 char) NOT NULL,
	"enable" smallint NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NOT NULL,
	CONSTRAINT "pk_base_tenant" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."tenant_name" IS '租户名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."tenant_code" IS '租户编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."enable" IS '状态 0-保存；1-启用；2-停用';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."dept_id" IS '记录数据所属部门';