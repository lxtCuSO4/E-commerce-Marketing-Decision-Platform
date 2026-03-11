DROP TABLE IF EXISTS "kesplus_app"."kes_app_formdesign_custom";

CREATE TABLE "kesplus_app"."kes_app_formdesign_custom" (
    "id" character varying(32 char) NOT NULL,
	"group" character varying(50 char) NOT NULL,
	"block_title" character varying(100 char) NULL,
	"block_icon" character varying(50 char) NULL,
	"status" integer NULL DEFAULT 0,
	"widget_json" text NOT NULL,
	"create_time" date NULL,
	"create_by" character varying(50 char) NULL,
	"update_time" date NULL,
	"update_by" character varying(50 char) NULL,
	"tenant_id" character varying(32 char) NULL,
	CONSTRAINT "con_kes_plus_kes_app_formdesign_custom_pk" PRIMARY KEY (id)
);