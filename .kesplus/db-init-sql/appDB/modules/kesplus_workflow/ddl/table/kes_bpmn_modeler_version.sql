drop table if exists "kesplus_workflow"."kes_bpmn_modeler_version";
create table "kesplus_workflow"."kes_bpmn_modeler_version" (
	    "id" character varying(32 char) not null,
    	"process_key" character varying(64 char) not null,
    	"process_version" integer null default 1,
    	"bytes_" bytea null,
    	"actived" tinyint null,
    	"create_by" character varying(32 char) not null,
    	"create_time" timestamp without time zone null,
    	"update_by" character varying(32 char) null default null::varchar,
    	"update_time" timestamp without time zone null,
    	"del" tinyint null,
    	"dept_id" character varying(32 char) null default null::varchar,
    	"module_code" character varying(128 char) null default null::varchar,
    	"process_type" integer null,
    	"process_name" character varying(256 char) null,
    	"process_def_id" character varying(128 char) null,
    	"variables" json null,
    	"process_flows" jsonb null,
    	"process_title" character varying(255 char) null,
	constraint "idx_kes_bpmn_modeler_version_process_key_process_version" unique (process_key, process_version),
	constraint "pk_kes_bpmn_modeler_version" primary key (id)
);