CREATE TABLE "kesplus_app"."kesplus_form_permission" (
	"id" character varying(32 char) NOT NULL,
	"form_id" character varying(32 char) NOT NULL,
	"permission_id" character varying(32 char) NOT NULL,
	"type" smallint not null default 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NOT NULL,
	CONSTRAINT "pk_kesplus_form_permission" PRIMARY KEY (id)
);


COMMENT ON COLUMN "kesplus_app"."kesplus_form_permission"."type" IS '0-审批；1-查阅';
