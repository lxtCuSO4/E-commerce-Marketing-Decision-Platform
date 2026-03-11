-- "kesplus_workflow"."kesplus_workflow_role" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_workflow_role";

CREATE TABLE "kesplus_workflow"."kesplus_workflow_role" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"wrole_type" character varying(2 char) NOT NULL,
	"wrole_code" character varying(128 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"bind_id" character varying(32 char) NOT NULL,
	"node_key" character varying(32 char) NULL,
	"create_by" varchar NOT NULL,
	"create_time" date NOT NULL,
	"update_by" varchar NULL,
	"update_time" date NULL,
	CONSTRAINT "kesplus_workflow_role_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."wrole_type" IS '角色类型：fv-表单查看角色；fa-表单审批角色；nv-节点查看角色；na-节点审批角色';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."wrole_code" IS '角色名称，由角色类型+应用编码+表单id(+ 节点编码)组成';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."form_id" IS '表单id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."bind_id" IS '表单关联id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_workflow_role"."node_key" IS '节点编码';