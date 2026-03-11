-- "kesplus_platform"."kesplus_auth_code" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_auth_code";

CREATE TABLE "kesplus_platform"."kesplus_auth_code" (
	"uuid" character varying(100 char) NOT NULL,
	"captcha_value" character varying(20 char) NOT NULL,
	"expiration" integer NOT NULL,
	"unit" character varying(20 char) NOT NULL,
	"create_time" datetime NOT NULL,
	CONSTRAINT "pk_auth_code" PRIMARY KEY (uuid)
);
COMMENT ON TABLE "kesplus_platform"."kesplus_auth_code" IS '验证码表';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_auth_code"."uuid" IS '验证码ID';
COMMENT ON COLUMN "kesplus_platform"."kesplus_auth_code"."captcha_value" IS '验证码值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_auth_code"."expiration" IS '过期时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_auth_code"."unit" IS '过期时间单位';
COMMENT ON COLUMN "kesplus_platform"."kesplus_auth_code"."create_time" IS '创建时间';