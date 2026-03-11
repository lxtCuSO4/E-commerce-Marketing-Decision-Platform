-- "${moduleSchema}"."kesplus_module_policy_db" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_policy_db";

CREATE TABLE "${moduleSchema}"."kesplus_module_policy_db" (
	"id" character varying(32 char) NOT NULL,
	"db_role_code" character varying(128 char) NULL,
	"schema_name" character varying(64 char) NOT NULL,
	"table_name" character varying(64 char) NOT NULL,
	"policy_id" character varying(32 char) NOT NULL,
	"policy_name" character varying(64 char) NULL DEFAULT 0,
	"auth_type" character varying(8 char) NOT NULL,
	"column_flag" boolean NOT NULL DEFAULT false,
	"table_columns" json NOT NULL DEFAULT '[]'::json,
	"create_policy" text  NULL,
	"drop_policy" text  NULL,
	"grant_auth" text NULL,
	"revoke_auth" text NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"enabled" integer NULL DEFAULT 1,
	"policy_expression" text NULL,
	CONSTRAINT "pk_module_policy_db_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."id" IS '主键ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."db_role_code" IS '数据库角色名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."schema_name" IS '模式名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."table_name" IS '表名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."policy_id" IS '策略实例id，关联kesplus_module_policy表';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."policy_name" IS '策略名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."auth_type" IS '二进制标识高到低分别表示增删改查';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."column_flag" IS '是否对应列权限';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."table_columns" IS '列权限对应字段';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."create_policy" IS '创建policy sql';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."grant_auth" IS '授权sql';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_policy_db"."tenant_id" IS '租户id';