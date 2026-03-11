-- "kesplus_base"."kesplus_serial_numbers_his" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_serial_numbers_his";

CREATE TABLE "kesplus_base"."kesplus_serial_numbers_his" (
	"id" character varying(32 char) NOT NULL,
	"module_code" character varying(32 char) not NULL,
	"dept_id" character varying(32 char) not NULL,
	"config_id" character varying(32 char) NULL,
	"config_name" character varying(32 char) NULL,
	"config_code" character varying(32 char) NULL,
	"prefix" character varying(32 char) NULL,
	"suffix" character varying(32 char) NULL,
	"use_date" boolean NOT NULL DEFAULT false,
	"date_format" character varying(32 char) NOT NULL DEFAULT 'yyyymmddhh24missff'::varchar,
	"current_date_time" datetime NULL,
	"length" integer NOT NULL DEFAULT 4,
	"current_number" integer NULL,
	"current_serial_number" character varying(128 char) NOT NULL,
	"create_by" integer NULL,
	"create_time" datetime NOT NULL,
	var varchar null,
	CONSTRAINT "pk_base_serial_numbers_his" PRIMARY KEY (id),
	CONSTRAINT "uk_base_serial_numbers_code_current" UNIQUE (config_id, current_serial_number)
);
COMMENT ON TABLE "kesplus_base"."kesplus_serial_numbers_his" IS '流水号历史记录';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."id" IS 'id';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."config_id" IS '流水号模板名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."config_name" IS '流水号模板名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."config_code" IS '流水号模板编码';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."prefix" IS '前缀';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."suffix" IS '后缀';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."use_date" IS '是否使用日期';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."date_format" IS '日期类型格式串';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."current_date_time" IS '当前时间段';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."current_number" IS '当前值';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers_his"."current_serial_number" IS '当前编码';