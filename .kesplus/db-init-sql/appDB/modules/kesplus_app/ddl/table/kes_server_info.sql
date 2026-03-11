-- "kesplus_app"."kes_server_info" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_server_info";

CREATE TABLE "kesplus_app"."kes_server_info" (
    "id" character varying(32 char) NOT NULL,
	"server_name" character varying(255 char) NULL,
	"server_ip" character varying(255 char) NULL,
	"server_port" integer NULL,
	"app_id" character varying(32 char) NULL,
	"app_domain" character varying(64 char) NULL,
	"app_name" character varying(64 char) NULL,
	"nginx_ip" character varying(64 char) NULL,
	"nginx_port" integer NULL,
	"status" smallint default 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" datetime NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" datetime NULL,
	CONSTRAINT "kes_server_info_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."id" IS 'ID';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."server_name" IS '服务器名称';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."server_ip" IS '服务器IP';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."server_port" IS '应用端口';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."app_domain" IS '应用域名';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."app_name" IS '应用名';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."nginx_ip" IS 'nginx的IP';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."nginx_port" IS 'nginx的端口';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."status" IS '服务器状态 0-离线；1-在线';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."update_by" IS '修改人';
COMMENT ON COLUMN "kesplus_app"."kes_server_info"."update_time" IS '修改时间';