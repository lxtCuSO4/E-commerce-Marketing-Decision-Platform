-- "kesplus_app"."business_comments" definition

-- Drop table

-- DROP TABLE "kesplus_app"."business_comments";

CREATE TABLE "kesplus_app"."business_comments" (
	"id" varchar NOT NULL,
	"module_code" varchar NOT NULL,
	"dept_id" varchar NOT NULL,
	"business_id" character varying(64 char) NOT NULL,
	"process_id" character varying(64 char) NULL,
	"create_by" character varying(64 char) NOT NULL,
	"create_name" character varying(32 char) NULL,
	"create_time" timestamp without time zone NULL,
	"comment" text NULL,
	"is_hidden" boolean NULL,
	"visible_user" varchar[] NULL,
	"comment_type" integer NOT NULL,
	"parent_comment_id" character varying(64 char) NULL,
	"to_user_id" character varying(64 char) NULL,
	"to_user_name" character varying(32 char) NULL,
	"comment_file" varchar[] NULL,
	"process_operation" character varying(32 char) NULL,
	"process_log_id" character varying(32 char) NULL,
	CONSTRAINT "business_comments_id_pk" PRIMARY KEY (id)
);
CREATE INDEX business_id_index ON kesplus_app.business_comments USING btree (business_id DESC);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."business_comments"."id" IS 'id';
COMMENT ON COLUMN "kesplus_app"."business_comments"."module_code" IS '模块代码';
COMMENT ON COLUMN "kesplus_app"."business_comments"."dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_app"."business_comments"."business_id" IS '业务表单id';
COMMENT ON COLUMN "kesplus_app"."business_comments"."process_id" IS '业务流程id';
COMMENT ON COLUMN "kesplus_app"."business_comments"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_app"."business_comments"."create_name" IS '创建人姓名';
COMMENT ON COLUMN "kesplus_app"."business_comments"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."business_comments"."comment" IS '附言信息';
COMMENT ON COLUMN "kesplus_app"."business_comments"."is_hidden" IS '是否隐藏';
COMMENT ON COLUMN "kesplus_app"."business_comments"."visible_user" IS '可见用户';
COMMENT ON COLUMN "kesplus_app"."business_comments"."comment_type" IS '附言类型（0-发起人，1-处理人）';
COMMENT ON COLUMN "kesplus_app"."business_comments"."parent_comment_id" IS '父级评论id';
COMMENT ON COLUMN "kesplus_app"."business_comments"."to_user_id" IS '被回复的用户Id';
COMMENT ON COLUMN "kesplus_app"."business_comments"."to_user_name" IS '被回复的用户名称';
COMMENT ON COLUMN "kesplus_app"."business_comments"."comment_file" IS '附言文件';
COMMENT ON COLUMN "kesplus_app"."business_comments"."process_operation" IS '流程操作';
COMMENT ON COLUMN "kesplus_app"."business_comments"."process_log_id" IS '关联日志id';