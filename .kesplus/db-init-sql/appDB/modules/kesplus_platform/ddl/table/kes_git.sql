-- "kesplus_platform"."kes_git" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_git";

CREATE TABLE "kesplus_platform"."kes_git" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(200 char) NULL,
	"git_addr" character varying(200 char) NOT NULL,
	"admin_user" character varying(200 char) NULL,
	"admin_pass" character varying(200 char) NULL,
	"status" character varying(1 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" datetime NOT NULL,
	"update_by" character varying(32 char) NOT NULL,
	"update_time" datetime NOT NULL,
	"remark" character varying(500 char) NULL,
	CONSTRAINT "con_kes_plus_kes_git_constraint_1" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_git"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."git_addr" IS '仓库名称';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."git_addr" IS 'GIT地址';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."admin_user" IS '管理员账户';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."admin_pass" IS '管理员密码';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."status" IS '状态：1正常、2禁用';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."create_by" IS '创建者';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."update_by" IS '更新着';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kes_git"."remark" IS '备注';