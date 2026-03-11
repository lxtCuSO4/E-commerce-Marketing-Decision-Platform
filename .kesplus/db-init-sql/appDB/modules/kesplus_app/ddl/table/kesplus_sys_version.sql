-- "kesplus_app"."kesplus_sys_version" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_sys_version";

CREATE TABLE "kesplus_app"."kesplus_sys_version" (
	"id" character varying(32 char) NOT NULL,
	"version_code" character varying(32 char) NOT NULL,
	"version_name" character varying(63 char) NOT NULL,
	"version_desc" character varying(255 char) NOT NULL,
	"version_type" integer NOT NULL DEFAULT 1,
	"version_status" character(1 char) NOT NULL DEFAULT '1'::bpchar,
	"effect_time" date NULL,
	"create_time" date NULL,
	"create_by" text NULL,
	"update_time" date NULL,
	"update_by" text NULL,
	"is_deleted" text NULL,
	CONSTRAINT "pk_sys_version" PRIMARY KEY (id),
	CONSTRAINT "uk_sys_version_code" UNIQUE (version_code)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."id" IS '主键，版本id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."version_code" IS '版本编号，不允许重复(和逻辑删除字段一起)';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."version_name" IS '版本名称';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."version_desc" IS '版本描述';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."version_type" IS '版本类型，1为开发版本(dev)，2为测试版本(uat)，3为预生产版本(dat)，4为生产版本(prod)';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."version_status" IS '版本状态，1为正式版本，2为过期/废弃版本';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."effect_time" IS '发布时间（由dat发布为prod版本的时间）';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_version"."update_by" IS '更新人id';