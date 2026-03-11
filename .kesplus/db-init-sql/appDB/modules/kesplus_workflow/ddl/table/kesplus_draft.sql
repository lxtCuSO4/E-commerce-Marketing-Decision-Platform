-- "kesplus_workflow"."kesplus_draft" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kesplus_draft";

CREATE TABLE "kesplus_workflow"."kesplus_draft" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"form_name" varchar NULL,
	"form_path" varchar NULL,
	"title" varchar NULL,
	"create_by" varchar NULL,
	"create_by_name" varchar NULL,
	"content" jsonb NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"config_name" varchar NULL,
	CONSTRAINT "kesplus_draft_id_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."id" IS 'id';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."form_name" IS '表单编码';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."form_path" IS '表单路径';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."title" IS '草稿标题';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."create_by" IS '草稿所属人';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."create_by_name" IS '草稿所属人姓名';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."content" IS '草稿内容';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_workflow"."kesplus_draft"."config_name" IS '草稿类型名称';