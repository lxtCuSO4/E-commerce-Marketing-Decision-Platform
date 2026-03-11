-- "kesplus_workflow"."kesplus_workflow_user_role" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_workflow_user_role";

CREATE TABLE "kesplus_workflow"."kesplus_workflow_user_role" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"wrole_id" character varying(32 char) NOT NULL,
	"wrole_code" character varying(128 char) NOT NULL,
	"create_by" varchar NOT NULL,
	"create_time" date NOT NULL,
	"update_by" varchar NULL,
	"update_time" date NULL,
	CONSTRAINT "kesplus_workflow_user_role_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."user_id" IS '用户id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."wrole_id" IS '审批角色id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_user_role"."wrole_code" IS '审批角色名称';