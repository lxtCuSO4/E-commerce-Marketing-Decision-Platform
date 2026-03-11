-- "kesplus_workflow"."kes_bpmn_modeler" definition

-- drop table

drop table if exists "kesplus_workflow"."kes_bpmn_modeler";

create table "kesplus_workflow"."kes_bpmn_modeler" (
	    "id" character varying(32 char) not null,
    	"module_id" character varying(32 char) null default null::varchar,
    	"tenant_id" character varying(32 char) null default null::varchar,
    	"process_key" character varying(64 char) not null,
    	"process_name" character varying(255 char) null default null::varchar,
    	"bytes_" bytea null,
    	"process_type" smallint null,
    	"process_type_name" character varying(255 char) null default null::varchar,
    	"deployed" integer not null default 0,
    	"enabled" tinyint null,
    	"create_by" character varying(32 char) not null,
    	"create_time" timestamp without time zone null,
    	"update_by" character varying(32 char) null default null::varchar,
    	"update_time" timestamp without time zone null,
    	"del" tinyint null,
    	"biz_meta" text null,
    	"dept_id" character varying(32 char) null default null::varchar,
    	"module_code" character varying(128 char) null default null::varchar,
    	"process_version" integer null default 0,
	constraint "idx_kes_bpmn_modeler_process_key" unique (process_key),
	constraint "pk_kes_bpmn_modeler" primary key (id)
);
create index idx_kes_bpmn_modeler_enabled on "kesplus_workflow".kes_bpmn_modeler using btree (enabled);