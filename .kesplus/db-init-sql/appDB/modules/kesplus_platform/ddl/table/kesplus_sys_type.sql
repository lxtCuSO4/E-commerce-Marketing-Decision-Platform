-- "kesplus_platform"."kesplus_sys_type" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_type";

CREATE TABLE "kesplus_platform"."kesplus_sys_type" (
	"oid" integer NOT NULL,
	"type_name" varchar NOT NULL,
	"has_precision" boolean NOT NULL,
	"length" integer NULL,
	"type_val" varchar NULL,
	"min_val" integer NULL,
	"max_val" integer NULL,
	"is_collatable" boolean NOT NULL,
	"namespace" varchar NOT NULL,
	CONSTRAINT "con_kesplus_platform_kesplus_sys_type_pk" PRIMARY KEY (oid)
);