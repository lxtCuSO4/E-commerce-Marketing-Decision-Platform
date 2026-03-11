-- Drop table

-- DROP TABLE "kesplus_workflow"."kes_bpmn_setting_delegation";

CREATE TABLE "kesplus_workflow"."kes_bpmn_setting_delegation" (
	"id" character varying(32 char) NOT NULL,
	"module_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"tenant_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"process_type" integer NULL,
	"process_name" character varying(256 char) NULL,
	"process_key" character varying(128 char) NULL,
	"owner_id" character varying(32 char) NULL,
	"owner_name" character varying(32 char) NULL,
	"delegation_id" character varying(32 char) NULL,
	"delegation_name" character varying(32 char) NULL,
	"enabled" tinyint NULL,
	"start_time" timestamp without time zone NULL,
	"end_time" timestamp without time zone NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp without time zone NULL,
	"update_by" character varying(32 char) NULL DEFAULT NULL::varchar,
	"update_time" timestamp without time zone NULL,
	"dept_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"module_code" character varying(128 char) NULL DEFAULT NULL::varchar,
	CONSTRAINT "pk_kes_bpmn_setting_delegation" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_workflow"."kes_bpmn_setting_delegation" IS '流程代理配置表';

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."process_type" IS '流程类型';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."process_name" IS '流程名称';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."process_key" IS '流程定义';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."owner_id" IS '流程所有者id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."owner_name" IS '流程所有者name';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."delegation_id" IS '流程代理者id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."delegation_name" IS '流程代理者name';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."enabled" IS '是否可用';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."start_time" IS '代理开始时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."end_time" IS '代理结束时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."update_by" IS '修改人id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."update_time" IS '修改时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."dept_id" IS '创建人部门id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_delegation"."module_code" IS '模块code';