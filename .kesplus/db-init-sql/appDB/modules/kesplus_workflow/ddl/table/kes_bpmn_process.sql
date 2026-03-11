-- "kesplus_workflow"."kes_bpmn_process" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_bpmn_process";

create table "kesplus_workflow"."kes_bpmn_process" (
    "id" character varying(32 char) not null,
	"form_code" character varying(64 char) not null,
	"business_id" character varying(64 char) not null,
	"form_role_id" character varying(64 char) not null,
	"process_key" character varying(64 char) not null,
	"process_instance_id" character varying(64 char) null,
	"root_process_instance_id" character varying(64 char) null,
	"parent_process_instance_id" character varying(64 char) null default 0,
	"submit_user_id" character varying(32 char) null,
	"submit_user_name" character varying(64 char) null,
	"submit_time" timestamp without time zone null,
	"complete_user_id" character varying(32 char) null,
	"complete_time" timestamp without time zone null,
	"process_status" character varying(32 char) null default 0,
	"dept_id" character varying(32 char) null default null::varchar,
	"dept_name" character varying(64 char) null default null::varchar,
	"module_code" character varying(128 char) null default null::varchar,
	"process_result" integer null,
	"process_version" integer null default 1,
	"start_node_id" varchar null,
	"start_node_name" varchar null,
	"end_node_id" varchar null,
	"end_node_name" varchar null,
	"config_id" varchar null,
	"title" character varying(500 char) null,
	"variables" json null,
	"path" character varying(500 char) null,
	"form_vue" character varying(255 char) null,
	"form_type" integer null,
	"process_variables" json null,
	"end_flows" jsonb null,
	"create_time" timestamp without time zone null,
	"process_type" integer null,
	"process_name" character varying(256 char) null,
	constraint "pk_kes_bpmn_process" primary key (id)
);
create index idx_kes_bpmn_process_form_code_business_id on "kesplus_workflow".kes_bpmn_process using btree (form_code, business_id);

create index inxex_kes_bpmn_process_process_instance_id on kesplus_workflow.kes_bpmn_process using btree (process_instance_id);
create index inxex_kes_bpmn_process_business_id on kesplus_workflow.kes_bpmn_process using btree (business_id);
create index inxex_kes_bpmn_process_process_key_process_version on kesplus_workflow.kes_bpmn_process using btree (process_key, process_version);
create index inxex_kes_bpmn_process_submit_user_id on kesplus_workflow.kes_bpmn_process using btree (submit_user_id);
-- column comments

comment on column "kesplus_workflow"."kes_bpmn_process"."id" is 'id';
comment on column "kesplus_workflow"."kes_bpmn_process"."form_code" is '业务表单编号';
comment on column "kesplus_workflow"."kes_bpmn_process"."business_id" is '业务表单业务主键';
comment on column "kesplus_workflow"."kes_bpmn_process"."form_role_id" is '权限角色id';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_key" is '流程图编号';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_instance_id" is '流程实例id';
comment on column "kesplus_workflow"."kes_bpmn_process"."root_process_instance_id" is '流程实例根实例id';
comment on column "kesplus_workflow"."kes_bpmn_process"."parent_process_instance_id" is '流程实例上层实例id';
comment on column "kesplus_workflow"."kes_bpmn_process"."submit_user_id" is '流程提交人id';
comment on column "kesplus_workflow"."kes_bpmn_process"."submit_user_name" is '流程提交人name';
comment on column "kesplus_workflow"."kes_bpmn_process"."submit_time" is '流程提交时间';
comment on column "kesplus_workflow"."kes_bpmn_process"."complete_user_id" is '流程完成人id';
comment on column "kesplus_workflow"."kes_bpmn_process"."complete_time" is '流程完成时间';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_status" is '流程最终状态';
comment on column "kesplus_workflow"."kes_bpmn_process"."dept_id" is '流程提交人部门id';
comment on column "kesplus_workflow"."kes_bpmn_process"."dept_name" is '流程提交人部门name';
comment on column "kesplus_workflow"."kes_bpmn_process"."module_code" is '模块编号';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_result" is '流程最终结果';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_version" is '流程图版本号';
comment on column "kesplus_workflow"."kes_bpmn_process"."start_node_id" is '开始节点的节点id';
comment on column "kesplus_workflow"."kes_bpmn_process"."start_node_name" is '开始节点的节点名称';
comment on column "kesplus_workflow"."kes_bpmn_process"."end_node_id" is '结束节点的节点id';
comment on column "kesplus_workflow"."kes_bpmn_process"."end_node_name" is '结束节点的节点名称';
comment on column "kesplus_workflow"."kes_bpmn_process"."config_id" is '流程配置表id';
comment on column "kesplus_workflow"."kes_bpmn_process"."title" is '流程标题';
comment on column "kesplus_workflow"."kes_bpmn_process"."variables" is '流程变量对应值';
comment on column "kesplus_workflow"."kes_bpmn_process"."path" is '流程对应路径';
comment on column "kesplus_workflow"."kes_bpmn_process"."form_vue" is '流程对应表单路径';
comment on column "kesplus_workflow"."kes_bpmn_process"."form_type" is '业务表单类型';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_variables" is '流程变量对应定义';
comment on column "kesplus_workflow"."kes_bpmn_process"."end_flows" is '流程图完成路径';
comment on column "kesplus_workflow"."kes_bpmn_process"."create_time" is '创建时间';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_type" is '流程图类型';
comment on column "kesplus_workflow"."kes_bpmn_process"."process_name" is '流程图名称';