CREATE TABLE "kesplus_base"."kesplus_message_register" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(20 char) NOT NULL,
	"type" character varying(20 char) NULL,
	"template_code" character varying(20 char) NOT NULL,
	"execute_object" character varying(100 char) NULL,
	"status" integer NULL DEFAULT 1,
	"create_time" datetime NULL,
	"create_by" character varying(32 char) NULL,
	"module_code" character varying(20 char) NULL,
	"register_object" jsonb NULL,
	"permissions" jsonb NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_register_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_register" IS '消息注册';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."name" IS '注册名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."type" IS '类型 默认REST';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."template_code" IS '模板编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."execute_object" IS '任务执行对象';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."status" IS '状态 0禁用 1启用';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."module_code" IS '模块编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_register"."permissions" IS '注册功能权限';