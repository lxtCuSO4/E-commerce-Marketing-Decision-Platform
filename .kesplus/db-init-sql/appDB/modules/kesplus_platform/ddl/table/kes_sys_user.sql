-- "kesplus_platform"."kes_sys_user" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_sys_user";

CREATE TABLE "kesplus_platform"."kes_sys_user" (
	"id" character varying(32 char) NOT NULL,
	"username" character varying(100 char) NULL,
	"password" character varying(255 char) NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"avatar_name" character varying(500 char) NULL,
	"email" character varying(255 char) NULL,
	"avatar_path" character varying(255 char) NULL,
	"create_by" character varying(255 char) NULL,
	"update_by" character varying(255 char) NULL,
	"pwd_reset_time" date NULL,
	"user_sort" integer NULL,
	"enabled" integer NULL,
	"access_token" character varying(500 char) NULL,
	"auth_type" integer NULL,
	"is_admin" boolean NULL,
	"is_vip" boolean NULL DEFAULT false,
	"vc_username" character varying(255 char) NULL,
	"vc_password" character varying(255 char) NULL,
	"role_ids" character varying(255 char) NULL,
	"realname" character varying(255 char) NULL,
	"u_key" character varying(64 char) NULL,
	"is_remember_me" character varying(1 char) NULL DEFAULT 0,
	"last_login" date NULL,
	"login_lock" smallint NULL DEFAULT 0,
	"login_lock_time" date NULL,
	CONSTRAINT "kes_plus_user_pkey" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."auth_type" IS '认证方式: 1.用户名密码; 2.令牌';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."is_admin" IS '是否是管理员';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."vc_username" IS '版本管理用户名';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."vc_password" IS '版本管理密码';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."is_remember_me" IS '是否记住登录状态';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."last_login" IS '最后登录时间';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."login_lock" IS '0 正常  1锁定';
COMMENT ON COLUMN "kesplus_platform"."kes_sys_user"."login_lock_time" IS '账号锁定时间';