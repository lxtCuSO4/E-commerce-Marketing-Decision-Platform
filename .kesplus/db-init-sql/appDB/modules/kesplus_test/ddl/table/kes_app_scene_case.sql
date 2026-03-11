-- "kesplus_test"."kes_app_scene_case" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_scene_case";

CREATE TABLE "kesplus_test"."kes_app_scene_case" (
                                                 "id" character varying(32 char) NOT NULL,
                                                 "case_id" character varying(32 char) NOT NULL,
                                                 "create_time" date NULL,
                                                 "case_order" smallint NULL,
                                                 "scene_id" character varying(32 char) NOT NULL,
                                                 "update_time" date NULL,
                                                 "order_str" character varying(64 char) NULL,
                                                 "enabled" smallint NULL DEFAULT 1,
                                                 CONSTRAINT "kes_app_scene_case_pkey1" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."case_id" IS '用例ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."case_order" IS '案例顺序';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."scene_id" IS '场景ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."order_str" IS '排序字符';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_case"."enabled" IS '0 禁用 1启用';