-- "kesplus_workflow"."kesplus_workflow_role_permission" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_workflow_role_permission";

CREATE TABLE "kesplus_workflow"."kesplus_workflow_role_permission" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"wrole_id" character varying(32 char) NOT NULL,
	"wrole_code" character varying(128 char) NOT NULL,
	"permission_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	CONSTRAINT "kesplus_workflow_role_permission_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."wrole_id" IS '审批角色id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."wrole_code" IS '审批角色名称';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role_permission"."permission_id" IS '权限点id';