-- "kesplus_app"."kesplus_spi_config" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_spi_config";

CREATE TABLE "kesplus_app"."kesplus_spi_config" (
	"id" character varying(32 char) NOT NULL,
	"spi_code" character varying(32 char) NOT NULL,
	"spi_token" character varying(255 char) NOT NULL,
	"spi_configs" json NOT NULL,
	"comment" character varying(255 char) NULL,
	"create_time" date NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"update_time" date NOT NULL,
	"update_by" character varying(32 char) NOT NULL,
	"status" integer NOT NULL DEFAULT 1,
	"sort" integer NOT NULL DEFAULT 1,
	CONSTRAINT "pk_kesplus_spi_config" PRIMARY KEY (id),
	CONSTRAINT "uk_kesplus_spi_config" UNIQUE (spi_code, status)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_spi_config"."spi_code" IS '对接平台编码';
COMMENT ON COLUMN "kesplus_app"."kesplus_spi_config"."spi_configs" IS '详细配置';
COMMENT ON COLUMN "kesplus_app"."kesplus_spi_config"."comment" IS '备注';
COMMENT ON COLUMN "kesplus_app"."kesplus_spi_config"."status" IS '1为有效，非1为无效';