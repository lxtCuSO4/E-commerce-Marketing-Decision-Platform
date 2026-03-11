drop table if exists "kesplus_workflow"."kes_bpmn_task_assignee";
create table "kesplus_workflow"."kes_bpmn_task_assignee" (
	    "id" character varying(32 char) not null,
    	"task_id" character varying(32 char) not null,
    	"assignee_id" character varying(32 char) not null,
    	"assignee_name" character varying(64 char) null,
    	"assignee_dept_id" character varying(32 char) null default 0,
    	"assignee_dept_name" character varying(64 char) null,
    	"delegation_id" character varying(32 char) NULL,
        "delegation_name" character varying(64 char) NULL,
        "delegation_dept_id" character varying(32 char) NULL,
        "delegation_dept_name" character varying(64 char) NULL,

    	"task_op_id" character varying(64 char) null,
	constraint "pkey_bpmn_task_assignee" primary key (id)
);
create index idx_kes_bpmn_task_assignee_assignee_id_assignee_dept_id on "kesplus_workflow".kes_bpmn_task_assignee using btree (assignee_id, assignee_dept_id);
create index idx_kes_bpmn_task_task_id on "kesplus_workflow".kes_bpmn_task_assignee using btree (task_id);

create index inxex_kes_bpmn_task_assignee_task_op_id on kesplus_workflow.kes_bpmn_task_assignee using btree (task_op_id);
create index inxex_kes_bpmn_task_assignee_assignee_id on kesplus_workflow.kes_bpmn_task_assignee using btree (assignee_id);


-- column comments

comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."id" is 'id';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."task_id" is '任务id(对应"kesplus_workflow"."act_ru_task"表id)';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."assignee_id" is '处理人id';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."assignee_name" is '处理人name';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."assignee_dept_id" is '处理人部门id';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."assignee_dept_name" is '处理人部门name';
comment on column "kesplus_workflow"."kes_bpmn_task_assignee"."task_op_id" is 'id(对应kes_bpmn_task表id)';