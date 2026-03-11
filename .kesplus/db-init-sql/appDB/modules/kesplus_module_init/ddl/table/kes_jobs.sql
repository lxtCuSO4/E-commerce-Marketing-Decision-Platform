-- "${moduleSchema}"."kes_jobs" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kes_jobs";

CREATE TABLE "${moduleSchema}"."kes_jobs" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(32 char)  NULL,
	"name" character varying(32 char) NOT NULL,
	"jobid" integer NULL,
	"next_date" timestamp(0) without time zone NULL,
	"sql_content" text NULL,
	"real_content" text NULL,
	"interval" character varying(255 char) NULL,
	"cron_expression" character varying(255 char) NULL,
	"inte_freq_params" json NULL,
	"run_status" smallint  NULL,
	"create_by" character varying(32 char)  NULL,
	"create_time" timestamp(0) without time zone  NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NOT NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"description" character varying(255 char) NULL,
	"obj_type" character varying(10 char) NULL,
	"parent_id" character varying(32 char) NULL DEFAULT 0,
    "sort_num" integer NULL,
    "job_type" smallint NULL DEFAULT 0,
    "app_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_jobs" PRIMARY KEY (id)
);