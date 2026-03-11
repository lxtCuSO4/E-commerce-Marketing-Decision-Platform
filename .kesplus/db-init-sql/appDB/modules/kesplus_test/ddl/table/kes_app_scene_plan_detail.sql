-- "kesplus_test"."kes_app_scene_plan_detail" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_test"."kes_app_scene_plan_detail";

CREATE TABLE "kesplus_test"."kes_app_scene_plan_detail" (
                                                        "id" varchar NOT NULL,
                                                        "plan_id" varchar NOT NULL,
                                                        "status" smallint NULL,
                                                        "start_time" timestamp(0) without time zone NULL,
                                                        "end_time" timestamp(0) without time zone NULL,
                                                        "result_info" text NULL,
                                                        "request_headers" text NULL,
                                                        "request_params" text NULL,
                                                        "case_id" varchar NULL,
                                                        "elapsed_time" integer NULL,
                                                        "batch_no" character varying(32 char) NULL,
                                                        "assert_status" smallint NULL,
                                                        CONSTRAINT "kes_app_scene_plan_detail_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."id" IS '主键';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."plan_id" IS '计划ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."status" IS '状态
0 失败
1 成功';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."start_time" IS '开始时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."end_time" IS '结束时间';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."result_info" IS '返回结果';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."request_headers" IS '请求头';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."request_params" IS '请求数据';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."case_id" IS '用例ID';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."elapsed_time" IS '运行时间（毫秒）';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."batch_no" IS '批次号';
COMMENT ON COLUMN "kesplus_test"."kes_app_scene_plan_detail"."assert_status" IS '断言状态';