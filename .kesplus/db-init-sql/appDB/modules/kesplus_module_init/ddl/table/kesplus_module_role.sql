-- "${moduleSchema}"."kesplus_module_role" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_role";

CREATE TABLE "${moduleSchema}"."kesplus_module_role" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(50 char) NULL,
	"description" character varying(255 char) NULL,
	"global_flag" boolean  NULL DEFAULT false,
	"role_level" smallint  NULL DEFAULT '-1'::integer,
	"data_scope" varchar NULL,
	"classify" smallint  NULL DEFAULT 2,
	"role_type" smallint  NULL DEFAULT 2,
	"hidden_flag" boolean  NULL DEFAULT false,
	"db_role_code" character varying(128 char)  NULL,
	"enabled" smallint NULL DEFAULT 0,
	"create_by" character varying(255 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(255 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) not NULL DEFAULT 0,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
    "obj_type" character varying(10 char) NULL,
    "parent_id" character varying(32 char) NULL,
    "sort_num" int NULL,
	CONSTRAINT "pk_module_role_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."name" IS '角色名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."code" IS '角色编码';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."description" IS '详细描述';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."role_level" IS '1-平台，2-租户；3-级联部门';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."classify" IS '0-匿名角色，1-公共角色；2-普通角色';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."role_type" IS '角色类型：0-内置角色；1-系统角色；2-自定义角色';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."hidden_flag" IS '隐藏标识';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."db_role_code" IS '数据库内角色编号，自动生成，不能编辑';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."enabled" IS '0-保存；1-启用；2-停用';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."create_by" IS '创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."update_by" IS '更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role"."module_id" IS '模块Id';