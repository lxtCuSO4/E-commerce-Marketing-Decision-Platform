-- "${schemaName}"."kesplus_serial_numbers" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_base"."kesplus_serial_numbers";

CREATE TABLE "kesplus_base"."kesplus_serial_numbers" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(32 char) NULL,
	"code" character varying(32 char) NULL,
	"prefix" character varying(32 char) NULL,
	"suffix" character varying(32 char) NULL,
	"use_date" boolean NOT NULL DEFAULT false,
	"date_format" character varying(32 char) NOT NULL DEFAULT 'yyyymmddhh24missff'::varchar,
	"current_date_time" datetime NULL,
	"length" integer NOT NULL DEFAULT 4,
	"start_number" integer NOT NULL DEFAULT 1,
	"current_number" integer NULL,
	"sort" integer NULL,
	"serial_expression" character varying(128 char) NULL,
	"params" jsonb NULL,
	use_var boolean NULL DEFAULT false,
	current_numbers jsonb null,
	CONSTRAINT "uk_base_serial_numbers_code" UNIQUE (code),
	CONSTRAINT "pk_base_serial_numbers" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_serial_numbers" IS '流水号信息';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."id" IS 'id';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."name" IS '流水号模板名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."code" IS '编码，用于参数传递';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."prefix" IS '前缀';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."suffix" IS '后缀';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."use_date" IS '是否使用日期';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."date_format" IS '日期类型格式串';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."current_date_time" IS '当前时间段';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."length" IS '顺序号长度';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."start_number" IS '起始值';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."current_number" IS '当前值';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."sort" IS '显示顺序';