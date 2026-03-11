-- "kesplus_platform"."kesplus_sys_aspect" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_aspect";

CREATE TABLE "kesplus_platform"."kesplus_sys_aspect" (
	"id" character varying(32 char) NOT NULL,
	"aspect_code" character varying(64 char) NULL,
	"aspect_name" character varying(64 char) NULL,
	"order_id" smallint NULL DEFAULT 0,
	"fun_before" character varying(255 char) NULL,
	"fun_after" character varying(255 char) NULL,
	"fun_exception" character varying(255 char) NULL,
	"url_pattern" text NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"aspect_type" character varying(1 char) NOT NULL DEFAULT 2,
	"aspect_version" character varying(15 char) NOT NULL,
	"aspect_status" character varying(1 char) NULL DEFAULT 0,
	"check_type" character varying(1 char) NULL DEFAULT 0,
	"is_deleted" bigint NULL DEFAULT 0,
	CONSTRAINT "pk_platform_sys_aspect" PRIMARY KEY (id),
	CONSTRAINT "uk_platform_sys_aspect_code_version" UNIQUE (aspect_code, aspect_version, is_deleted)
);
COMMENT ON TABLE "kesplus_platform"."kesplus_sys_aspect" IS '切面定义表';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."id" IS '主键';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."aspect_code" IS '编号';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."aspect_name" IS '名称';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."order_id" IS '过滤器顺序，越大越先执行，数值一致，则判断编号（字典序顺序），默认值为0';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."fun_before" IS '前置调用方法';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."fun_after" IS '后置调用方法';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."fun_exception" IS '异常处理方法';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."url_pattern" IS '若根据url配置，则写入此值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."update_by" IS '更新人';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."aspect_type" IS '种类，0为系统过滤器，用户不可编辑，必选；1为系统过滤器，用户不可编辑，可选；2为自定义过滤器，可编辑，可选';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."aspect_version" IS '版本';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."aspect_status" IS '状态，0为未生效，1为生效';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."check_type" IS '关联类型，1为根据id关联api，0为url_pattern关联';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_aspect"."is_deleted" IS '逻辑删除标志';