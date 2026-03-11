-- "kesplus_app"."kesplus_component" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_component";

CREATE TABLE "kesplus_app"."kesplus_component" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(128 char) NOT NULL,
	"code" character varying(128 char) NOT NULL,
	"sql_content" character varying(1024 char) NULL,
	"columns" jsonb NOT NULL,
	"params" jsonb NULL,
	"mappings" character varying(512 char) NOT NULL,
	"module_id" character varying(32 char) NOT NULL,
	CONSTRAINT "con_kesplus_app_kesplus_component_constraint_1" PRIMARY KEY (id)
);