CREATE TABLE "kesplus_base"."kesplus_message_task" (
	"id" character varying(32 char) NOT NULL,
	"task_content" jsonb NULL,
	"create_time" datetime NULL,
	"create_by" character varying(32 char) NULL,
	"type" integer NULL DEFAULT 0,
	CONSTRAINT "con_kesplus_base_kesplus_message_task_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_task" IS '任务列表';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_task"."task_content" IS '任务内容';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_task"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_task"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_task"."type" IS '类型 ';