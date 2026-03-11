-- "kesplus_app"."kesplus_sys_filter" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_sys_filter";

CREATE TABLE "kesplus_app"."kesplus_sys_filter" (
	"id" character varying(32 char) NOT NULL,
	"filter_code" character varying(63 char) NOT NULL,
	"filter_name" character varying(255 char) NOT NULL,
	"filter_order" integer NULL DEFAULT 0,
	"include_urls" text NULL,
	"exclude_urls" text NULL,
	"post_method" character varying(255 char) NULL,
	"complete_method" character varying(255 char) NULL,
	"filter_type" character varying(1 char) NOT NULL DEFAULT 2,
	"filter_version" character varying(15 char) NOT NULL,
	"filter_status" character varying(1 char) NULL DEFAULT 0,
	"create_time" date NULL,
	"create_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"is_deleted" bigint NULL DEFAULT 0,
	CONSTRAINT "pk_app_sys_filter" PRIMARY KEY (id),
	CONSTRAINT "uk_app_sys_filter_code_version" UNIQUE (filter_code, filter_version, is_deleted)
);
CREATE UNIQUE INDEX uk_app_sys_filter_code ON kesplus_app.kesplus_sys_filter USING btree (filter_code, filter_version);
COMMENT ON INDEX "kesplus_app"."uk_app_sys_filter_code" IS '同一版本下，过滤器编号唯一';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."id" IS '主键，过滤器id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_code" IS '过滤器编号，不允许重复';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_name" IS '过滤器名称';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_order" IS '过滤器顺序，越大越先执行，数值一致，则判断编号（字典序顺序），默认值为0';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."include_urls" IS 'filter中匹配的拦截的url格式,半角逗号分隔的多个配置（include）';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."exclude_urls" IS 'filter中匹配的拦截的url格式,半角逗号分隔的多个配置（exclude）';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."post_method" IS '过滤器前置处理方法';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."complete_method" IS '过滤器后置处理方法';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_type" IS '过滤器种类，0为系统过滤器，用户不可编辑，必选；1为系统过滤器，用户不可编辑，可选；2为自定义过滤器，可编辑，可选';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_version" IS '过滤器适用的版本';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."filter_status" IS '过滤器状态，0为未生效，1为生效';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_filter"."is_deleted" IS '逻辑删除标志';