-- "kesplus_app"."kes_data_sync_link" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kes_data_sync_link";

CREATE TABLE "kesplus_app"."kes_data_sync_link" (
    "id" character varying(32 char) NOT NULL,
	"node_id" integer NULL,
	"service_name" character varying(256 char) NULL,
	"createTime" date NULL DEFAULT now(),
	CONSTRAINT "kes_plus_kes_data_sync_link_pk" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_data_sync_link"."node_id" IS '节点ID';
COMMENT ON COLUMN "kesplus_app"."kes_data_sync_link"."service_name" IS '服务名称';
COMMENT ON COLUMN "kesplus_app"."kes_data_sync_link"."createTime" IS '创建时间';