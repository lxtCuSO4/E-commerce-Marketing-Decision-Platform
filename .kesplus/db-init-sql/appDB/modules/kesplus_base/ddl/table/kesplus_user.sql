-- "kesplus_base"."kesplus_user" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user";

CREATE TABLE "kesplus_base"."kesplus_user" (
	"id" character varying(32 char) NOT NULL,
	"username" character varying(32 char) NOT NULL,
	"password" character varying(255 char) NOT NULL,
	"real_name" character varying(30 char) NULL,
	"phone" character varying(20 char) NULL,
	"user_code" character varying(32 char) NULL,
	"gender" character varying(2 char) NULL,
	"email" character varying(255 char) NULL,
	"pwd_reset_time" date NULL,
	"user_type" smallint NULL DEFAULT 1,
	"user_sort" integer NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"is_admin" boolean NULL DEFAULT false,
	"is_vip" boolean NULL DEFAULT false,
	"create_by" character varying(255 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(255 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"last_login" date NULL,
	"login_lock" smallint NULL DEFAULT 0,
	"login_lock_time" date NULL,
	"user_source" integer NULL DEFAULT 0,
	"manager_user_id" character varying(32 char) NULL,
	"expanded_manager_keys" character varying(255 char) NULL,
	"extended_info" json NULL,
	"remark" varchar NULL,
	"ldap_id" character varying(64) NULL,
	CONSTRAINT "pk_base_user" PRIMARY KEY (id),
	CONSTRAINT "uk_base_user_uname" UNIQUE (username)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."username" IS '用户名';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."password" IS '密码';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."real_name" IS '用户姓名';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."phone" IS '电话';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."email" IS '邮箱';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."pwd_reset_time" IS '密码重置时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_type" IS '用户类型 0系统用户，1 应用用户';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_sort" IS '排序';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."enabled" IS '启用禁用';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_source" IS '默认0;ldap同步 1';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."manager_user_id" IS '主管领导';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."expanded_manager_keys" IS '主管领导回显部门id集合';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."remark" IS '备注';