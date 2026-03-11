-- "kesplus_platform"."kes_market" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_market";

CREATE TABLE "kesplus_platform"."kes_market" (
    "id" character varying(32 char) NOT NULL,
	"name" character varying(100 char) NOT NULL,
	"code" character varying(100 char) NOT NULL,
	"type" character varying(50 char) NOT NULL DEFAULT 'app'::varchar,
	"business_type" character varying(32 char) NULL,
	"icon" text NULL,
	"remark" text NULL,
	"create_time" date NULL,
	"create_by" character varying(32 char) NULL,
	"file_name" character varying(200 char) NULL,
	"version" character varying(100 char) NULL DEFAULT '1.0'::varchar,
	"obj_id" character varying(32 char) NULL,
	"use_count" integer NULL DEFAULT 0,
	"app_id" character varying(32 char) NULL,
	"update_time" date NULL,
	"update_by" character varying(32 char) NULL,
	CONSTRAINT "con_kes_plus_kes_app_market_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_market_constraint_2" UNIQUE (version, obj_id, app_id)
);


-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_market"."id" IS '主键';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."name" IS '名称';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."code" IS '编码';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."type" IS '类型 app应用 module模块';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."business_type" IS '业务类型';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."icon" IS '图标';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."remark" IS '描述';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."version" IS '版本号';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."obj_id" IS '对象ID  应用或者模块的ID';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."use_count" IS '使用下载次数';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kes_market"."update_by" IS '更新人';