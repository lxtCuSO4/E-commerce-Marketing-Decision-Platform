-- "kesplus_test"."kes_app_scene" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_scene";

CREATE TABLE "kesplus_test"."kes_app_scene" (
                                            "id" character varying(32 char) NOT NULL,
                                            "name" character varying(100 char) NOT NULL,
                                            "app_id" character varying(32 char) NULL,
                                            "module_id" character varying(32 char) NULL,
                                            "tenant_id" character varying(32 char) NULL,
                                            "create_time" date NULL,
                                            "update_time" date NULL,
                                            "create_by" character varying(32 char) NULL,
                                            "update_by" character varying(32 char) NULL,
                                            "parent_id" character varying(32 char) NULL,
                                            "type" character varying(10 char) NULL,
                                            "params" json NULL,
                                            "remark" character varying(255 char) NULL,
                                            "enabled" smallint NULL DEFAULT 1,
                                            "obj_type" character varying(10 char) NULL,
                                            "sort_num" integer NULL,
                                            CONSTRAINT "kes_app_scene_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."id" IS '主键';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."name" IS '场景名称';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."module_id" IS '模块ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."parent_id" IS '父id';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."type" IS '数据类型
scene-dir 目录(暂时不需要)
scene 场景';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."params" IS '全局参数选择 id逗号分隔';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."remark" IS '备注';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene"."enabled" IS '启用禁用 0禁用 1启用';