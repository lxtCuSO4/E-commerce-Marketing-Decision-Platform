-- "kesplus_workflow"."kes_bpmn_listener" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_bpmn_listener";

create table "kesplus_workflow"."kes_bpmn_listener" (
		"id" character varying(32 char) not null,
    	"form_code" character varying(128 char) null default null::varchar,
    	"listener_type" smallint null default 2,
    	"listener_content" character varying(512 char) not null,
    	"node_id" character varying(64 char) null default null::varchar,
    	"listener_index" integer null default 1,
    	"create_by" character varying(32 char) not null,
    	"create_time" timestamp without time zone null,
    	"update_by" character varying(32 char) null default null::varchar,
    	"update_time" timestamp without time zone null,
    	"dept_id" character varying(32 char) null default null::varchar,
    	"module_code" character varying(128 char) null default null::varchar,
    	"config_id" varchar not null,
	constraint "pk_kes_bpmn_listener" primary key (id)
);

-- column comments

comment on column "kesplus_workflow"."kes_bpmn_listener"."form_code" is '表单编号';
comment on column "kesplus_workflow"."kes_bpmn_listener"."listener_type" is '2-用户任务监听；其他待定义';
comment on column "kesplus_workflow"."kes_bpmn_listener"."listener_content" is '监听器的表达式';
comment on column "kesplus_workflow"."kes_bpmn_listener"."node_id" is '节点定义id';
comment on column "kesplus_workflow"."kes_bpmn_listener"."listener_index" is '执行顺序';
comment on column "kesplus_workflow"."kes_bpmn_listener"."config_id" is '流程配置表id';