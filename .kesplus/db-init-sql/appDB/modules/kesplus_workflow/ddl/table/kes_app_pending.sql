-- "kesplus_workflow"."kes_app_pending" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_app_pending";

create table "kesplus_workflow"."kes_app_pending" (
	"id" character varying(32 char) not null,
	"module_code" character varying(50 char) null,
	"dept_id" character varying(32 char) null,
	"type" character varying(64 char) not null,
	"title" character varying(500 char) not null,
	"path" character varying(500 char) not null,
	"create_time" timestamp without time zone null,
	"create_by" character varying(32 char) null,

    "submit_user_id" character varying(32 char) null,
    "submit_user_name" character varying(64 char) null,
    "submit_time" timestamp without time zone null,
    "submit_dept_id" character varying(32 char) null default null::varchar,
    "submit_dept_name" character varying(64 char) null default null::varchar,


	"update_time" timestamp without time zone null,
	"update_by" character varying(32 char) null,
	"status" tinyint null,
	"variables" json null,
	"pending_key" character varying(128 char) not null,
	"pending_id" character varying(128 char)  null,
	"task_def_key" character varying(64 char) null,
	"task_id" character varying(64 char)  null,
    "task_name" character varying(128 char) null,
	"complete_time" timestamp without time zone null,
	"business_id" character varying(32 char) null,
	"form_vue" character varying(255 char) null,
	"real_name" character varying(256 char) null,
    "process_type" integer null,
    "process_instance_id" character varying(64 char) null,
    "process_status" character varying(32 char) null,
    "dept_name" character varying(64 char) null,
    "category" character varying(64 char) NULL,
    "has_open" tinyint null,
    "can_batch" tinyint null,
	constraint "pk_kes_app_pending" primary key (id)
);
create unique index uk_pending_type_key_category on kesplus_workflow.kes_app_pending using btree (type, pending_key,category);

create index inxex_kes_app_pending_business_id on kesplus_workflow.kes_app_pending using btree (business_id);
create index inxex_kes_app_pending_pending_key on kesplus_workflow.kes_app_pending using btree (pending_key);
create index inxex_kes_app_pending_create_by on kesplus_workflow.kes_app_pending using btree (create_by);
create index inxex_kes_app_pending_pending_id on kesplus_workflow.kes_app_pending using btree (pending_id);
CREATE INDEX inxex_kes_app_pending_process_instance_id ON kesplus_workflow.kes_app_pending USING btree (process_instance_id);
CREATE INDEX inxex_kes_app_pending_task_def_key ON kesplus_workflow.kes_app_pending USING btree (task_def_key);
CREATE INDEX inxex_kes_app_pending_process_instance_id_task_def_key ON kesplus_workflow.kes_app_pending USING btree (process_instance_id,task_def_key);

-- column comments

comment on column "kesplus_workflow"."kes_app_pending"."id" is 'id';
comment on column "kesplus_workflow"."kes_app_pending"."module_code" is '模板编号';
comment on column "kesplus_workflow"."kes_app_pending"."dept_id" is '发送人部门id';
comment on column "kesplus_workflow"."kes_app_pending"."type" is '业务表单编号';
comment on column "kesplus_workflow"."kes_app_pending"."title" is '流程标题';
comment on column "kesplus_workflow"."kes_app_pending"."path" is '流程对应路径';
comment on column "kesplus_workflow"."kes_app_pending"."create_time" is '发送时间';
comment on column "kesplus_workflow"."kes_app_pending"."create_by" is '发送人id';

comment on column "kesplus_workflow"."kes_app_pending"."submit_user_id" is '流程提交人id';
comment on column "kesplus_workflow"."kes_app_pending"."submit_user_name" is '流程提交人name';
comment on column "kesplus_workflow"."kes_app_pending"."submit_time" is '流程提交时间';
comment on column "kesplus_workflow"."kes_app_pending"."submit_dept_id" is '流程提交人部门id';
comment on column "kesplus_workflow"."kes_app_pending"."submit_dept_name" is '流程提交人部门name';

comment on column "kesplus_workflow"."kes_app_pending"."update_time" is '接收时间';
comment on column "kesplus_workflow"."kes_app_pending"."update_by" is '更新人id';
comment on column "kesplus_workflow"."kes_app_pending"."status" is '状态';
comment on column "kesplus_workflow"."kes_app_pending"."variables" is '流程变量对应值';
comment on column "kesplus_workflow"."kes_app_pending"."pending_key" is 'id(对应kes_bpmn_task表id)';
comment on column "kesplus_workflow"."kes_app_pending"."pending_id" is 'id(对应kes_app_pending表id)';
comment on column "kesplus_workflow"."kes_app_pending"."task_def_key" is '流程当前节点定义id';
comment on column "kesplus_workflow"."kes_app_pending"."task_id" is '任务id(对应"kesplus_workflow"."act_ru_task"表id)';
comment on column "kesplus_workflow"."kes_app_pending"."task_name" is '流程当前节点定义name';
comment on column "kesplus_workflow"."kes_app_pending"."complete_time" is '流程完成时间';
comment on column "kesplus_workflow"."kes_app_pending"."business_id" is '业务表单业务主键';
comment on column "kesplus_workflow"."kes_app_pending"."form_vue" is '流程对应表单路径';
comment on column "kesplus_workflow"."kes_app_pending"."real_name" is '发送人name';
comment on column "kesplus_workflow"."kes_app_pending"."process_type" is '流程图类型';
comment on column "kesplus_workflow"."kes_app_pending"."process_instance_id" is '流程实例根实例id';
comment on column "kesplus_workflow"."kes_app_pending"."process_status" is '流程最终状态';
comment on column "kesplus_workflow"."kes_app_pending"."dept_name" is '发送人部门id';
comment on column "kesplus_workflow"."kes_app_pending"."category" is '类型(task/message)';
comment on column "kesplus_workflow"."kes_app_pending"."has_open" is '是否已经打开过';
comment on column "kesplus_workflow"."kes_app_pending"."can_batch" is '是否可以批量操作';
