-- "${moduleSchema}"."kes_tables" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kes_tables";

CREATE TABLE "${moduleSchema}"."kes_tables" (
                                         "id" character varying(32 char) NOT NULL,
                                         "module_id" character varying(32 char) NULL,
                                         "app_id" character varying(32 char) NULL,
                                         "tenant_id" character varying(32 char) NULL,
                                         "name" character varying(32 char) NULL,
                                         "owner_name" character varying(32 char) NULL,
                                         "schema_name" character varying(32 char) NULL,
                                         "ddl" text NULL,
                                         "create_time" date NULL,
                                         "update_time" date NULL,
                                         "parent_id" character varying(32 char) NULL,
                                         "category" smallint NULL,
                                         "directory_code" character varying(32 char) NULL,
                                         "tbs" character varying(32 char) NULL,
                                         "comments" character varying(32 char) NULL,
                                         "obj_oid" character varying(32 char) NULL,
                                         "schema_oid" character varying(32 char) NULL,
                                         "table_code" smallint NULL,
                                         "is_rest" smallint NULL DEFAULT 0,
                                         "api_directory_id" character varying(32 char) NULL,
                                         "method" character varying(50 char) NULL,
                                         "module_path" character varying(255 char) NULL,
                                         "api_path" character varying(255 char) NULL,
                                         "auth_status" smallint NULL default 0,
                                         "role_ids" character varying(1000 char) NULL,
                                         "return_type" character varying(100 char) NULL,
                                         "check_type" character varying(32 char) NULL,
                                         "table_oid" integer NULL,
                                         "extend_property" json NULL,
                                         "parameters" json NULL,
                                         "latest_req_parameters" text NULL,
                                         "label" character varying(32 char) NULL,
                                         "update_by" character varying(32 char) NULL,
                                         "create_by" character varying(32 char) NULL,
                                         "obj_type" character varying(10 char) NULL,
                                         "generated" smallint NULL DEFAULT 0,
                                         "sort_num" integer NULL,
                                         "api_title" character varying(100 char) NULL,
                                         "increment_ddl" jsonb NULL,
                                         CONSTRAINT "pk_tables_constraint_1" PRIMARY KEY (id)
);
COMMENT ON TABLE "${moduleSchema}"."kes_tables" IS 'table and view information';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."module_id" IS '模块ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."app_id" IS '应用ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."name" IS '目录、表名、视图名';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."owner_name" IS '目录、表名、视图的owner';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."schema_name" IS '视图或表的模式名';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."ddl" IS '建视图或表DDL语句';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."create_time" IS '创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."update_time" IS '修改时间';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."parent_id" IS '父目录的id';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."category" IS '当前节点类型。4 目录，5，对象';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."directory_code" IS '目录类型，table 表，view 视图';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."table_code" IS '表类型 8分区表 9普通表';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."is_rest" IS '是否发布为Rest api 1 是 0 否';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."api_directory_id" IS '分类目录：sys_api表中目录类型id';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."method" IS '请求类型：GET\POST\DELETE\PUT';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."module_path" IS '模块url';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."api_path" IS '接口url';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."auth_status" IS '授权状态 0不需授权 1需授权';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."role_ids" IS '角色id';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."return_type" IS '返回类型 ONE ROW; NONE;COLLECTION';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."check_type" IS '视图的check属性';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."extend_property" IS '扩展字段';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."parameters" IS '视图参数';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."latest_req_parameters" IS '前端表相关的入参';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."label" IS '中文名称';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."generated" IS '代码生成标识 0否 1是';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."sort_num" IS '对象排序因子，默认正序，最小的排在最上面';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."obj_type" IS '对象类型：dir、obj';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."create_by" IS '创建人';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."update_by" IS '修改人';
COMMENT ON COLUMN "${moduleSchema}"."kes_tables"."api_title" IS 'rest名称';


