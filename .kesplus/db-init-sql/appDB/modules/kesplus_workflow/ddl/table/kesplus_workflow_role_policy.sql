-- "kesplus_workflow"."kesplus_workflow_role_policy" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_workflow_role_policy";

CREATE TABLE "kesplus_workflow"."kesplus_workflow_role_policy" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"wrole_id" character varying(32 char) NOT NULL,
	"wrole_code" character varying(32 char) NOT NULL,
	"policy_name" character varying(128 char) NOT NULL,
	"grant_auth" character varying(512 char) NOT NULL,
	"revoke_auth" character varying(512 char) NOT NULL,
	"create_policy" text NOT NULL,
	"drop_policy" character varying(255 char) NOT NULL,
	"table_name" character varying(32 char) NOT NULL,
	"table_column" json NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	CONSTRAINT "kesplus_workflow_role_policy_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."wrole_id" IS '审批角色id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."wrole_code" IS '审批角色名称';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."policy_name" IS '数据策略名称';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."grant_auth" IS '授权语句';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."revoke_auth" IS '取消授权语句';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."create_policy" IS '创建策略语句';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."drop_policy" IS '删除策略语句';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."table_name" IS '表名称';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_policy"."table_column" IS '表字段配置';