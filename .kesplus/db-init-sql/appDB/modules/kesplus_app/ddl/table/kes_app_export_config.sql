-- "kesplus_app"."kes_app_export_config" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_app_export_config";

CREATE TABLE "kesplus_app"."kes_app_export_config" (
    "id" varchar NULL,
    "name" varchar NOT NULL,
    "schema_name" varchar NOT NULL,
    "table_name" varchar NOT NULL,
    "is_app_export_table" boolean NOT NULL DEFAULT false,
    "column_names" varchar NULL,
    "sort" integer NULL,
    "sql" text NOT NULL,
	CONSTRAINT "pk_app_export_config" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."id" IS 'id';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."name" IS '名称';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."schema_name" IS '模式名';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."table_name" IS '表名';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."is_app_export_table" IS '导出应用时才导出此表';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."column_names" IS '表中待执行sql的字段名称';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."sort" IS '执行的顺序';
COMMENT ON COLUMN "kesplus_app"."kes_app_export_config"."sql" IS '执行的sql';