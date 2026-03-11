-- "kesplus_workflow"."kes_bpmn_log" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_bpmn_log";

create table "kesplus_workflow"."kes_bpmn_log" (
    "id" character varying(32 char) not null,
	"process_instance_id" character varying(64 char) not null,
	"execution_id" character varying(64 char) null,
	"task_id" character varying(64 char) null,
	"handle_type" smallint null default 0,
	"handle_result" smallint null default 0,
	"create_by" character varying(32 char) not null,
	"create_time" timestamp without time zone null,
	"handle_time" timestamp without time zone null,
	"handler_id" character varying(32 char) not null,
	"handler_name" character varying(64 char) not null,
	"handler_dept_id" character varying(32 char) not null default 0,
	"handler_dept_name" character varying(64 char) null,
	"handle_opinions" json null,
	"dept_id" character varying(32 char) null default null::varchar,
	"module_code" character varying(128 char) null default null::varchar,
	"task_def_key" character varying(64 char) null,
	"task_name" character varying(128 char) null,
	"task_op_id" varchar null default 0::varchar,
	constraint "pk_kes_bpmn_log" primary key (id)
);
create index kes_bpmn_log_process_instance_id on kesplus_workflow.kes_bpmn_log using btree (process_instance_id);
create index inxex_kes_bpmn_log_task_op_id on kesplus_workflow.kes_bpmn_log using btree (task_op_id);
-- column comments

comment on column "kesplus_workflow"."kes_bpmn_log"."process_instance_id" is '流程实例id';
comment on column "kesplus_workflow"."kes_bpmn_log"."execution_id" is '执行id';
comment on column "kesplus_workflow"."kes_bpmn_log"."task_id" is '流程任务id';
comment on column "kesplus_workflow"."kes_bpmn_log"."handle_type" is '操作类型1-创建实例；2-创建任务；3-任务办结；4-实例办结';
comment on column "kesplus_workflow"."kes_bpmn_log"."handle_result" is '操作结果';
comment on column "kesplus_workflow"."kes_bpmn_log"."create_time" is '创建时间';
comment on column "kesplus_workflow"."kes_bpmn_log"."handle_time" is '办理完成时间';
comment on column "kesplus_workflow"."kes_bpmn_log"."handler_id" is '办理人用户id';
comment on column "kesplus_workflow"."kes_bpmn_log"."handler_name" is '办理人姓名';
comment on column "kesplus_workflow"."kes_bpmn_log"."handler_dept_id" is '办理人部门id';
comment on column "kesplus_workflow"."kes_bpmn_log"."handler_dept_name" is '办理人部门';
comment on column "kesplus_workflow"."kes_bpmn_log"."task_def_key" is '任务节点定义id';
comment on column "kesplus_workflow"."kes_bpmn_log"."task_name" is '任务名称';