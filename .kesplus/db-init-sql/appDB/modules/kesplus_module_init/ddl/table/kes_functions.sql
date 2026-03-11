-- "${moduleSchema}"."kes_functions" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kes_functions";

CREATE TABLE "${moduleSchema}"."kes_functions" (
                                            "id" character varying(32 char) NOT NULL,
                                            "category" smallint NULL DEFAULT 4,
                                            "directory_code" character varying(100 char) NULL,
                                            "name" character varying(100 char) NULL,
                                            "schema_name" character varying(50 char) NULL,
                                            "return_type" character varying(100 char) NULL,
                                            "owner_name" character varying(50 char) NULL,
                                            "parameters" json NULL,
                                            "app_id" character varying(32 char) NULL,
                                            "module_id" character varying(32 char) NULL,
                                            "parent_id" character varying(32 char) NULL DEFAULT 0,
                                            "content" text NULL,
                                            "create_time" date NULL,
                                            "update_time" date NULL,
                                            "is_rest" smallint NULL DEFAULT 0,
                                            "api_directory_id" character varying(32 char) NULL,
                                            "method" character varying(50 char) NULL,
                                            "module_path" character varying(255 char) NULL,
                                            "api_path" character varying(255 char) NULL,
                                            "return_value_type" character varying(255 char) NULL,
                                            "tenant_id" character varying(32 char) NULL,
                                            "auth_status" smallint NULL DEFAULT 1,
                                            "role_ids" character varying(1000 char) NULL,
                                            "remark" text NULL,
                                             "update_by" character varying(32 char) NULL,
                                             "create_by" character varying(32 char) NULL,
                                            "obj_type" character varying(10 char) NULL,
                                            "sort_num" integer NULL,
                                            "api_title" character varying(100 char) NULL,
                                            CONSTRAINT "kes_functions_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."category" IS '类型 4 目录 5 对象';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."directory_code" IS '目录类型
functions  函数
procedures 存储过程';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."name" IS '名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."schema_name" IS '模式名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."return_type" IS '返回类型 ONE ROW; NONE;COLLECTION';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."owner_name" IS '属主';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."parameters" IS '参数json';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."app_id" IS '应用id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."parent_id" IS '父id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."content" IS '语句内容';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."is_rest" IS '是否发布为Rest api
1 是
0 否';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."api_directory_id" IS '分类目录：sys_api表中目录类型id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."method" IS '请求类型：GET\POST\DELETE\PUT';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."module_path" IS '模块url';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."api_path" IS '接口url';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."return_value_type" IS '返回值类型 函数的reutrn类型';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."tenant_id" IS '租户id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."auth_status" IS '授权状态 0不需授权 1需授权';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."role_ids" IS '角色id';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."remark" IS '备注';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."sort_num" IS '对象排序因子，默认正序，最小的排在最上面';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."obj_type" IS '对象类型：dir、obj';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."create_by" IS '创建人';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."update_by" IS '修改人';
COMMENT ON COLUMN "${moduleSchema}"."kes_functions"."api_title" IS 'rest名称';
