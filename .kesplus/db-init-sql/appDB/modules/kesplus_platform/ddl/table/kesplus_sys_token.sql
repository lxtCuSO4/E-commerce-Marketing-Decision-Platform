-- "kesplus_platform"."kesplus_sys_token" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_token";

CREATE TABLE "kesplus_platform"."kesplus_sys_token" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"come_from" smallint NULL DEFAULT 0,
	"token_value" text NOT NULL,
	"token_info" jsonb NOT NULL,
	"expired_epoch" integer NULL,
	"token_type" character varying(16 char) NULL,
	"refresh_id" character varying(32 char) NULL,
	"create_time" datetime NOT NULL
);
COMMENT ON TABLE "kesplus_platform"."kesplus_sys_token" IS 'token缓存记录';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."id" IS 'token的md5值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."user_id" IS '用户ID';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."dept_id" IS '用户部门ID';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."come_from" IS '用户来源/类型，0-平台；1-应用';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."expired_epoch" IS '超时时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_token"."token_type" IS 'token类型，token/refreshToken';