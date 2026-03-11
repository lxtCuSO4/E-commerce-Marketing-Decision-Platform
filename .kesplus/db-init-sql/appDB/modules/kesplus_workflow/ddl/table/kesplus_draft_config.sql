-- "kesplus_workflow"."kesplus_draft_config" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_draft_config";

CREATE TABLE "kesplus_workflow"."kesplus_draft_config" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"form_name" varchar NULL,
	"form_path" varchar NULL,
	"draft_title" varchar NULL,
	"draft_config" jsonb NULL,
	"enabled" boolean NULL,
	"create_by" varchar NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"update_by" varchar NULL,
	"form_code" varchar NULL,
	CONSTRAINT "tab_draft_config_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft_config"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft_config"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft_config"."dept_id" IS '部门ID';