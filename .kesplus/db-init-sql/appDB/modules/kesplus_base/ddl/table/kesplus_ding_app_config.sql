-- "kesplus_base"."kesplus_ding_app_config" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_ding_app_config";

CREATE TABLE "kesplus_base"."kesplus_ding_app_config" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"app_id" varchar NULL,
	"agent_id" varchar NULL,
	"app_key" varchar NULL,
	"client_secret" varchar NULL,
	"corp_id" varchar NULL,
	"api_token" varchar NULL,
	"enabled" boolean NULL DEFAULT false,
	CONSTRAINT "ding_app_config_id_pk" PRIMARY KEY (id)
);