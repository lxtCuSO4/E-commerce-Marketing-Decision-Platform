-- "kesplus_test"."kes_app_case" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_case";

CREATE TABLE "kesplus_test"."kes_app_case" (
                                           "id" character varying(32 char) NOT NULL,
                                           "api_id" character varying(255 char) NULL,
                                           "remark" character varying(255 char) NULL,
                                           "name" character varying(255 char) NULL,
                                           "create_time" date NULL,
                                           "params" json NULL,
                                           "parent_id" character varying(32 char) NULL,
                                           "type" character varying(255 char) NULL,
                                           "update_time" date NULL,
                                           "module_id" character varying(32 char) NULL,
                                           "app_id" character varying(32 char) NULL,
                                           "tenant_id" character varying(32 char) NULL,
                                           "asserts" json NULL,
                                           "case_type" character varying(10 char) NULL,
                                           "sql_script" text NULL,
                                           "run_info" text NULL,
                                           "obj_type" character varying(10 char) NULL,
                                           "sort_num" integer NULL,
                                           "update_by" character varying(32 char) NULL,
                                           "create_by" character varying(32 char) NULL,
                                           CONSTRAINT "kes_app_scene_case_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."id" IS '主键';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."api_id" IS 'API ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."remark" IS '备注';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."name" IS '用例名称';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."params" IS '参数值';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."parent_id" IS '父id';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."type" IS '数据类型
case-dir 用例目录
case 用例';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."module_id" IS '模块ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."asserts" IS '断言配置';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."case_type" IS '用例类型
API ：  restful接口
SQL： sql脚本';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."sql_script" IS 'SQL脚本';
COMMENT ON COLUMN "kesplus_test"."kes_app_case"."run_info" IS '执行信息';