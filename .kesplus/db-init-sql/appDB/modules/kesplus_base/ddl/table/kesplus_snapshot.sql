-- "kesplus_base"."kesplus_snapshot" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_base"."kesplus_snapshot";

CREATE TABLE "kesplus_base"."kesplus_snapshot" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NOT NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"create_user" character varying(32 char) NULL,
	CONSTRAINT "pk_app_snapshot" PRIMARY KEY (id)
);