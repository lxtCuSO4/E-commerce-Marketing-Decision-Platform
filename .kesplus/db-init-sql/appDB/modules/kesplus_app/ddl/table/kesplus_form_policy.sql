CREATE TABLE "kesplus_app"."kesplus_form_policy" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"policy_id" character varying(32 char) NOT NULL,
	"type" smallint not null default 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_kesplus_form_policy" PRIMARY KEY (id)
);

COMMENT ON COLUMN "kesplus_app"."kesplus_form_policy"."type" IS '0-审批；1-查阅';