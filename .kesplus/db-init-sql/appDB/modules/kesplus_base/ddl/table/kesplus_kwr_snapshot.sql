DROP TABLE IF EXISTS "kesplus_base"."kesplus_kwr_snapshot";

CREATE TABLE "kesplus_base"."kesplus_kwr_snapshot" (
	"id" character varying(32 char) NOT NULL,
	"snap_id" character varying(64 char) NOT NULL,
	"snap_time" timestamp(0) without time zone NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_kwr_snapshot" PRIMARY KEY (id)
);