DROP TABLE IF EXISTS "kesplus_app"."kesplus_kwr_report";

CREATE TABLE "kesplus_app"."kesplus_kwr_report" (
	"id" character varying(32 char) NOT NULL,
	"snap_id_begin" character varying(64 char) NOT NULL,
	"snap_id_end" character varying(64 char) NOT NULL,
	"start_time" timestamp(0) without time zone NOT NULL,
	"end_time" timestamp(0) without time zone NULL,
	"status" SMALLINT NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_kwr_report" PRIMARY KEY (id)
);