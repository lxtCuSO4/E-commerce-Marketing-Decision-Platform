-- "kesplus_module_permission" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_permission";

CREATE TABLE "${moduleSchema}"."kesplus_module_permission" (
	"id" character varying(32 char) NOT NULL,
	"module_code" character varying(50 char) NULL,
	"dept_id" character varying(32 char) NULL,
	"name" character varying(100 char) NULL,
	"code" character varying(100 char) NULL,
	"obj_type" character varying(10 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"status" character varying(1 char) NULL default 1,
	"create_by" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" varchar NULL,
	"module_id" varchar NULL,
	"remark" character varying(200 char) NULL,
    "sort_num" integer NULL,
    "custom" integer not NULL default 0,
	CONSTRAINT "kesplus_module_permission_id_pk" PRIMARY KEY (id)
);

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."name" IS '权限点名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."code" IS '权限点编码';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."obj_type" IS '权限点类型：obj=权限点；dir=权限点目录';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."parent_id" IS '上级权限点分类ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."status" IS '启用状态：1=启用；0=停用';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."remark" IS '备注描述';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."create_by" IS '创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."update_by" IS '更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."module_code" IS '模块编码';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_permission"."module_id" IS '模块Id';
