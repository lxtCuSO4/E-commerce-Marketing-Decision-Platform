-- "kesplus_base"."kesplus_schedule" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_base"."kesplus_schedule";

CREATE TABLE "kesplus_base"."kesplus_schedule" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(32 char) NOT NULL,
	"cron" character varying(16 char) NOT NULL,
	"handle_service" character varying(64 char) NOT NULL,
	"schedule_service" character varying(64 char) NOT NULL,
	"unique_key" character varying(64 char) NOT NULL,
	"params" character varying(255 char) NULL,
	"app_code" character varying(64 char) NOT NULL,
	"is_single" smallint NOT NULL DEFAULT 1,
	"interval_second" bigint NOT NULL,
	"current_job_id" character varying(32 char) NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_schedule" PRIMARY KEY (id)
);