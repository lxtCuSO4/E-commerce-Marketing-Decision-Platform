-- "kesplus_platform"."kes_git_user" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_git_user";

CREATE TABLE "kesplus_platform"."kes_git_user" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NULL,
	"git_id" character varying(32 char) NOT NULL,
	"username" character varying(32 char) NOT NULL,
	"email" character varying(64 char) NOT NULL,
	"auth_type" character varying(1 char) NOT NULL,
	"password" character varying(32 char) NULL,
	"pubkey" character varying(500 char) NULL,
	"status" character varying(1 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" datetime NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" datetime NOT NULL,
	"remark" character varying(500 char) NULL,
	CONSTRAINT "con_kes_plus_kes_git_user_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_git_user_constraint_2" UNIQUE (git_id, username)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."user_id" IS '关联KES_APP_USER表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."git_id" IS '关联KES_GIT表主键ID';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."username" IS '账号';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."email" IS '邮箱';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."auth_type" IS '鉴权类型：1密码、2公钥';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."password" IS '密码';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."pubkey" IS '公钥';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."status" IS '状态：1正常、2禁用';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."create_by" IS '创建者';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."update_by" IS '更新者';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kes_git_user"."remark" IS '备注';