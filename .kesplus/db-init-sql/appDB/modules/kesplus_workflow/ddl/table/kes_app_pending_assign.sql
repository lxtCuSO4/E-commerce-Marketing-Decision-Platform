-- "kesplus_workflow"."kes_app_pending_assign" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_app_pending_assign";

create table "kesplus_workflow"."kes_app_pending_assign" (
	"id" character varying(32 char) not null,
	"module_code" character varying(50 char) null,
	"dept_id" character varying(32 char) null,
	"pending_id" character varying(32 char) not null,
	"assignee_id" character varying(32 char) not null,
	"assignee_dept_id" character varying(32 char) null,
	"assignee_name" character varying(32 char) null,
	"assignee_dept_name" character varying(128 char) null,
	"delegation_id" character varying(32 char) NULL,
    "delegation_name" character varying(64 char) NULL,
    "delegation_dept_id" character varying(32 char) NULL,
    "delegation_dept_name" character varying(64 char) NULL,
	"create_time" timestamp without time zone null,
	"create_by" character varying(32 char) null,
	"update_time" timestamp without time zone null,
	"update_by" character varying(32 char) null,
	constraint "pk_kes_app_pending_assign" primary key (id)
);


create index inxex_kes_app_pending_assign_pending_id on kesplus_workflow.kes_app_pending_assign using btree (pending_id);
create index inxex_kes_app_pending_assign_assignee_id on kesplus_workflow.kes_app_pending_assign using btree (assignee_id);

-- column comments

comment on column "kesplus_workflow"."kes_app_pending_assign"."id" is 'id';
comment on column "kesplus_workflow"."kes_app_pending_assign"."module_code" is '模板编号';
comment on column "kesplus_workflow"."kes_app_pending_assign"."dept_id" is '创建人部门id';
comment on column "kesplus_workflow"."kes_app_pending_assign"."pending_id" is 'id(对应kes_app_pending表id)';
comment on column "kesplus_workflow"."kes_app_pending_assign"."assignee_id" is '接收人id';
comment on column "kesplus_workflow"."kes_app_pending_assign"."assignee_dept_id" is '接收人部门id';
comment on column "kesplus_workflow"."kes_app_pending_assign"."assignee_name" is '接收人name';
comment on column "kesplus_workflow"."kes_app_pending_assign"."assignee_dept_name" is '接收人部门name';
comment on column "kesplus_workflow"."kes_app_pending_assign"."create_time" is '创建时间';
comment on column "kesplus_workflow"."kes_app_pending_assign"."create_by" is '创建人id';
comment on column "kesplus_workflow"."kes_app_pending_assign"."update_time" is '更新时间';
comment on column "kesplus_workflow"."kes_app_pending_assign"."update_by" is '更新人id';