-- "kesplus_base"."kesplus_query_execution" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_base"."kesplus_query_execution";

CREATE TABLE "kesplus_base"."kesplus_query_execution" (
    "id" character varying(32 char) NOT NULL,
	"snapshot_id" character varying(32 char) NOT NULL,
	"queryid" bigint NULL DEFAULT 0,
	"api_id" varchar(32) NULL DEFAULT 0,
	"parent_queryid" bigint NULL DEFAULT 0,
	"execute_times" integer NULL DEFAULT 0,
	"total_time" double precision NULL DEFAULT 0,
	"query" text NOT NULL,
	CONSTRAINT "pk_app_kwr_query_execution" PRIMARY KEY (id)
);