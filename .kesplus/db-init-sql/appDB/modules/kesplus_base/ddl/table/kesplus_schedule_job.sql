-- "kesplus_base"."kesplus_schedule_job" definition

-- Drop table

-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_schedule_job";

CREATE TABLE "kesplus_base"."kesplus_schedule_job" (
	"id" character varying(32 char) NOT NULL,
	"schedule_id" character varying(32 char) NOT NULL,
	"consume_millis" character varying(64 char) NOT NULL,
	"start_time" date NOT NULL,
	"finish_time" date NULL,
	"status" integer NULL DEFAULT 0,
	CONSTRAINT "pk_app_schedule_job" PRIMARY KEY (id)
);