-- "kesplus_workflow"."kes_bpmn_task" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_bpmn_task";

create table "kesplus_workflow"."kes_bpmn_task" (
	    "id" character varying(32 char) not null,
    	"process_instance_id" character varying(64 char) not null,
    	"execution_id" character varying(64 char) null,
    	"create_by" character varying(32 char) not null,
    	"create_time" timestamp without time zone null,
    	"task_def_key" character varying(64 char) null,
    	"prev_task_def_key" character varying(64 char) null,
    	"task_status" smallint not null default 0,
    	"task_result" character varying(32 char) null,
    	"complete_time" timestamp without time zone null,

    	"handler_id" character varying(32 char) null,
    	"handler_name" character varying(64 char) null,
    	"handler_dept_id" character varying(32 char) null default 0,
    	"handler_dept_name" character varying(64 char) null,

    	"owner_id" character varying(32 char) NULL,
        "owner_name" character varying(64 char) NULL,
        "owner_dept_id" character varying(32 char) NULL,
        "owner_dept_name" character varying(64 char) NULL,

    	"dept_id" character varying(32 char) null default null::varchar,
    	"module_code" character varying(128 char) null default null::varchar,
    	"task_id" character varying(64 char) not null,
    	"task_name" character varying(128 char) null,
    	"prefix_id" character varying(64 char) null default 0::varchar,
    	"can_retract" integer null,
    	"op_status" smallint null default 0,
    	"update_by" varchar null,
    	"update_time" timestamp without time zone null,
    	"variables" json null,
    	"task_flows" jsonb null,
	constraint "pk_kes_bpmn_task" primary key (id)
);
create index idx_kes_bpmn_task_process_instance_id_execution_id on "kesplus_workflow".kes_bpmn_task using btree (process_instance_id, execution_id);
create index idx_kes_bpmn_task_process_instance_id_task_def_key on "kesplus_workflow".kes_bpmn_task using btree (process_instance_id, task_def_key);

create index inxex_kes_bpmn_task_process_instance_id on kesplus_workflow.kes_bpmn_task using btree (process_instance_id);
create index inxex_kes_bpmn_task_prefix_id on kesplus_workflow.kes_bpmn_task using btree (prefix_id);
create index inxex_kes_bpmn_task_task_id on kesplus_workflow.kes_bpmn_task using btree (task_id);

-- column comments

comment on column "kesplus_workflow"."kes_bpmn_task"."id" is 'id';
comment on column "kesplus_workflow"."kes_bpmn_task"."process_instance_id" is '流程实例id';
comment on column "kesplus_workflow"."kes_bpmn_task"."execution_id" is '流程执行实例id';
comment on column "kesplus_workflow"."kes_bpmn_task"."create_by" is '创建人id';
comment on column "kesplus_workflow"."kes_bpmn_task"."create_time" is '创建时间';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_def_key" is '流程当前节点定义id';
comment on column "kesplus_workflow"."kes_bpmn_task"."prev_task_def_key" is '流程当前节点上一节点定义id';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_status" is '任务状态';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_result" is '任务结果';
comment on column "kesplus_workflow"."kes_bpmn_task"."complete_time" is '完成时间';
comment on column "kesplus_workflow"."kes_bpmn_task"."handler_id" is '处理人id';
comment on column "kesplus_workflow"."kes_bpmn_task"."handler_name" is '处理人name';
comment on column "kesplus_workflow"."kes_bpmn_task"."handler_dept_id" is '处理人部门id';
comment on column "kesplus_workflow"."kes_bpmn_task"."handler_dept_name" is '处理人部门name';
comment on column "kesplus_workflow"."kes_bpmn_task"."dept_id" is '创建人部门id';
comment on column "kesplus_workflow"."kes_bpmn_task"."module_code" is '模块编号';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_id" is '任务id(对应"kesplus_workflow"."act_ru_task"表id)';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_name" is '流程当前节点定义name';
comment on column "kesplus_workflow"."kes_bpmn_task"."prefix_id" is '上一id(对应kes_bpmn_task表id)';
comment on column "kesplus_workflow"."kes_bpmn_task"."can_retract" is '是否可以撤回';
comment on column "kesplus_workflow"."kes_bpmn_task"."op_status" is '操作状态';
comment on column "kesplus_workflow"."kes_bpmn_task"."update_by" is '更新人id';
comment on column "kesplus_workflow"."kes_bpmn_task"."update_time" is '更新时间';
comment on column "kesplus_workflow"."kes_bpmn_task"."variables" is '流程变量对应值';
comment on column "kesplus_workflow"."kes_bpmn_task"."task_flows" is '流程节点完成路径';