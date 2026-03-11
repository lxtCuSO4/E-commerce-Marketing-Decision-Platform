CREATE TABLE "kesplus_app"."kesplus_job_his" (
	"id" character varying(32 char) NOT NULL,
	"job_id" character varying(32 char) NOT NULL,
	"job_code" character varying(128 char) NOT NULL,
	"job_name" character varying(255 char) NOT NULL,
	"execute_time" timestamp without time zone NOT NULL,
	"execute_sql" text NOT NULL,
	"module_id" character varying(32 char) NOT NULL,
	"error_message" jsonb NULL,
	"result" boolean NOT NULL,
	CONSTRAINT "kesplus_job_his_id_pk" PRIMARY KEY (id)
);