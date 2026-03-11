-- "kesplus_base"."kesplus_module_policy" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_module_policy";

CREATE TABLE "kesplus_base"."kesplus_base_policy" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NULL,
	"name" character varying(64 char) NOT NULL,
	"db_role_code" character varying(128 char) NULL,
	"description" character varying(255 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	"params" jsonb NULL,
	"tables" jsonb NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NOT NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"version_id" character varying(32 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"obj_type" character varying(8 char) NULL,
	"sort_num" integer NULL,
	"logical_pid" character varying(32 char) NULL,
	"is_vertual" boolean NULL,
	CONSTRAINT "pk_kesplus_base_policy" PRIMARY KEY (id)
);

