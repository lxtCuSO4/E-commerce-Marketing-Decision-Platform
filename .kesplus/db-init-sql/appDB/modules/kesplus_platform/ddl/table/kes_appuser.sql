-- "kesplus_platform"."kes_appuser" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_appuser";

CREATE TABLE "kesplus_platform"."kes_appuser" (
	"id" character varying(32 char) NOT NULL,
	"app_id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"user_git" character varying(32 char) NULL,
	"role_id" character varying(2000 char) NULL,
	"status" character varying(1 char) NOT NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" datetime NULL,
	"remark" character varying(500 char) NULL,
	CONSTRAINT "con_kes_plus_kes_appuser_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_appuser_constraint_2" UNIQUE (app_id, user_id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."app_id" IS '关联kes_application表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."user_id" IS '关联kes_app_user表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."user_git" IS '关联kes_git_user表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."role_id" IS '关联kes_app_role表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."status" IS '状态：1正常、2禁用';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."create_by" IS '创建者';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."update_by" IS '更新者';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kes_appuser"."remark" IS '备注';