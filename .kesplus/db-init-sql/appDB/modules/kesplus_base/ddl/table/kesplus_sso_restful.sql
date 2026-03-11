-- "kesplus_base"."kesplus_sso_restful" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_sso_restful";

CREATE TABLE "kesplus_base"."kesplus_sso_restful" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(50 char) NOT NULL,
	"enabled" smallint NULL DEFAULT 0,
	"restful_id" character varying(64 char) NOT NULL,
	"remark" character varying(255 char) NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"create_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_sso_restful" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."id" IS '主键';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."code" IS '对接平台编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."enabled" IS '1生效；0停用';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."restful_id" IS 'restfulid';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."remark" IS '备注';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."create_time" IS '创建时间';