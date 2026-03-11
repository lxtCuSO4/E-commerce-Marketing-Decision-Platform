-- "kesplus_app"."kes_server_conn" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_server_conn";

CREATE TABLE "kesplus_app"."kes_server_conn" (
                                          "id" character varying(32 char) NOT NULL,
                                          "from_server_id" character varying(32 char) NULL,
                                          "to_server_id" character varying(32 char) NULL,
                                          "trusteeship" character varying(20 char) NULL,
                                          "switch_server" character varying(20 char) NULL,
                                          CONSTRAINT "kes_server_conn_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_app"."kes_server_conn"."id" IS '主键';
COMMENT ON COLUMN "kesplus_app"."kes_server_conn"."from_server_id" IS '源服务器ID';
COMMENT ON COLUMN "kesplus_app"."kes_server_conn"."to_server_id" IS '目标服务器ID';
COMMENT ON COLUMN "kesplus_app"."kes_server_conn"."trusteeship" IS '托管(0, 未托管；1，托管)';
COMMENT ON COLUMN "kesplus_app"."kes_server_conn"."switch_server" IS '切机(0, 未切机；1，切机)';