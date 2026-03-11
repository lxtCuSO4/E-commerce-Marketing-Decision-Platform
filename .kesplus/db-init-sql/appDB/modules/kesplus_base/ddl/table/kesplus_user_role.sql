-- "kesplus_base"."kesplus_user_role" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_role";

CREATE TABLE "kesplus_base"."kesplus_user_role" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"role_name" character varying(32 char) NOT NULL,
	"current_dept_id" character varying(32 char) NOT NULL,
	"role_code" character varying(64 char) NOT NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	"relate_type" integer NULL DEFAULT 0,
	CONSTRAINT "pk_base_user_role" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."user_id" IS '用户id，外键，关联kes_app_user表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."role_id" IS '角色id，外键，关联kes_app_role表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."role_name" IS '角色名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."current_dept_id" IS '部门id，外键，关联kes_app_dept表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."role_code" IS '角色编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."dept_id" IS '记录数据所属部门';