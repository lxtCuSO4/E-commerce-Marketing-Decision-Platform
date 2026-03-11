-- "${moduleSchema}"."kesplus_module_policy" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_policy";

CREATE TABLE "${moduleSchema}"."kesplus_module_policy" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NULL,
	"name" character varying(64 char) NOT NULL,
	"db_role_code" character varying(128 char) NULL,
	"description" character varying(255 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	"params" jsonb NULL,
	"tables" jsonb NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NOT NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"version_id" character varying(32 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"obj_type" character varying(8 char) NULL,
	"sort_num" integer NULL,
	CONSTRAINT "pk_module_policy_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."id" IS '主键ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."code" IS '模板编号，全局唯一';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."name" IS '模板名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."description" IS '详细描述';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy"."tenant_id" IS '租户id';