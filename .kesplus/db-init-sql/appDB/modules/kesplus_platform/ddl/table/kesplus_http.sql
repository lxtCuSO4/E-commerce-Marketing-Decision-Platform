-- "kesplus_platform"."kesplus_http" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_http";

CREATE TABLE "kesplus_platform"."kesplus_http" (
	"id" character varying(32 char) NOT NULL,
	"url" character varying(512 char) NOT NULL,
	"request_method" character varying(200 char) NOT NULL,
	"protocol" character varying(16 char) NOT NULL,
	"header" jsonb NULL,
	"type" character varying(32 char) NOT NULL,
	"body" text NULL,
	"response" text NULL,
	"return_code" character varying(32 char) NULL,
	"call_time" datetime NULL,
	"send_time" datetime NULL,
	"finish_time" datetime NULL,
	"create_by" character varying(32 char) NULL,
	"params" jsonb NULL,
	CONSTRAINT "con_kesplus_http_constraint_1" PRIMARY KEY (id)
);