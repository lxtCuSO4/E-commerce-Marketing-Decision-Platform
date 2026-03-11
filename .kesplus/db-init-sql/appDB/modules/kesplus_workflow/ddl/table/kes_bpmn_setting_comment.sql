-- "kesplus_workflow"."kes_bpmn_setting_comment" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kes_bpmn_setting_comment";

CREATE TABLE "kesplus_workflow"."kes_bpmn_setting_comment" (
	"id" character varying(32 char) NOT NULL,
	"module_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"tenant_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"process_type" integer NULL,
	"process_name" character varying(256 char) NULL,
	"process_key" character varying(128 char) NULL,
	"owner_id" character varying(32 char) NULL,
	"owner_name" character varying(32 char) NULL,
	"enabled" tinyint NULL,
	"comment_type" character varying(32 char) NULL,
	"comment_text" json NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp without time zone NULL,
	"update_by" character varying(32 char) NULL DEFAULT NULL::varchar,
	"update_time" timestamp without time zone NULL,
	"dept_id" character varying(32 char) NULL DEFAULT NULL::varchar,
	"module_code" character varying(128 char) NULL DEFAULT NULL::varchar,
	CONSTRAINT "pk_kes_bpmn_setting_comment" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_workflow"."kes_bpmn_setting_comment" IS '流程常用意见配置表';

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."process_type" IS '流程类型';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."process_name" IS '流程名称';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."process_key" IS '流程定义';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."owner_id" IS '常用意见所有者id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."owner_name" IS '常用意见所有者name';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."enabled" IS '是否可用';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."comment_type" IS '常用意见类型';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."comment_text" IS '常用意见文本';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."update_by" IS '修改人id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."update_time" IS '修改时间';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."dept_id" IS '创建人部门id';
COMMENT ON COLUMN "kesplus_workflow"."kes_bpmn_setting_comment"."module_code" IS '模块code';