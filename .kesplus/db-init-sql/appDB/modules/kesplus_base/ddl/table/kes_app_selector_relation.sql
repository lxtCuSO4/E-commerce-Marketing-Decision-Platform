-- "kesplus_base"."kes_app_selector_relation" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kes_app_selector_relation";

CREATE TABLE "kesplus_base"."kes_app_selector_relation" (
	"id" character varying(32 char) NOT NULL,
	"title" character varying(255 char) NOT NULL,
	"key" character varying(32 char) NOT NULL,
	"type" character varying(8 char) NULL,
	"isLeaf" boolean NOT NULL DEFAULT true,
	"pid" character varying(32 char) NOT NULL DEFAULT '0'::varchar,
	"sort" integer NULL DEFAULT 1,
	"anonymous_block" text NULL,
	"desc" text NULL,
	"tree_path" character varying(512 char) NULL,
	"create_by" character varying(32 char) NULL DEFAULT '0'::varchar,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL,
	CONSTRAINT "pk_kes_app_selector_relation" PRIMARY KEY (id)
);