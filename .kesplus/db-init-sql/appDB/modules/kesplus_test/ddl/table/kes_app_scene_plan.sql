-- "kesplus_test"."kes_app_scene_plan" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_scene_plan";

CREATE TABLE "kesplus_test"."kes_app_scene_plan" (
                                                 "id" character varying(32 char) NOT NULL,
                                                 "name" character varying(100 char) NOT NULL,
                                                 "type" smallint NULL DEFAULT 1,
                                                 "expression" character varying(255 char) NULL,
                                                 "scene_id" character varying(32 char) NOT NULL,
                                                 "status" smallint NULL DEFAULT 0,
                                                 "start_time" date NULL,
                                                 "end_time" date NULL,
                                                 "create_time" date NULL,
                                                 "create_by" character varying(32 char) NULL,
                                                 "total_count" bigint NULL DEFAULT 0,
                                                 "success_count" bigint NULL DEFAULT 0,
                                                 "fail_count" bigint NULL DEFAULT 0,
                                                 "order" smallint NULL DEFAULT 0,
                                                 "error_info" text NULL,
                                                 "run_count" bigint NULL DEFAULT 0,
                                                 "elapsed_time" bigint NULL,
                                                 "batch_no" character varying(32 char) NULL,
                                                 "auto_fill" smallint NULL DEFAULT 0,
                                                 "enabled" smallint NULL DEFAULT 1,
                                                 "app_id" character varying(32 char) NULL, -- 应用ID
	                                             "module_id" character varying(32 char) NULL, -- 模块id
	                                             "app_code" character varying(30 char) NULL, -- 应用编码
                                                 CONSTRAINT "kes_app_scene_plan_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."id" IS '主键';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."name" IS '执行计划名称';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."type" IS '计划类型
1 立即执行
2 定时执行';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."expression" IS '定时corn表达式';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."scene_id" IS '场景ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."status" IS '计划状态
0 待执行
1 执行中
2 已完成
3 执行失败';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."start_time" IS '开始执行时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."end_time" IS '结束执行时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."total_count" IS '用例总数';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."success_count" IS '成功数';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."fail_count" IS '失败数';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."order" IS '是否顺序执行
0 否
1 是';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."error_info" IS '计划执行失败信息';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."run_count" IS '运行次数';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."elapsed_time" IS '运行时间（毫秒）';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."batch_no" IS '批次号';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."auto_fill" IS '自动填充
0 不使用
1 使用';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."enabled" IS '是否启用
0 禁用
1 启用';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan"."app_code" IS '应用编码';