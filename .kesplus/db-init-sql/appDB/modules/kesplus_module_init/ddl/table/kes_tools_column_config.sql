-- "${moduleSchema}"."kes_tools_column_config" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kes_tools_column_config";

CREATE TABLE "${moduleSchema}"."kes_tools_column_config" (
                                                  "id" character varying(32 char) NOT NULL,
                                                  "table_name" character varying(255 char) NULL,
                                                  "column_type" character varying(255 char) NULL,
                                                  "key_type" character varying(255 char) NULL,
                                                  "extra" character varying(1000 char) NULL,
                                                  "remark" character varying(255 char) NULL,
                                                  "not_null" smallint NULL DEFAULT '0'::smallint,
                                                  "list_show" smallint NULL DEFAULT '1'::smallint,
                                                  "form_show" smallint NULL DEFAULT '1'::smallint,
                                                  "form_type" character varying(255 char) NULL,
                                                  "query_type" character varying(32 char) NULL,
                                                  "dict_name" character varying(255 char) NULL,
                                                  "column_name" character varying(255 char) NULL,
                                                  "table_id" character varying(32 char) NULL,
                                                  "column_num" integer NULL,
                                                  "field_ext" character varying(2000 char) NULL,
                                                  "table_oid" bigint NULL,
                                                  "form_code" character varying(255 char) NULL,
                                                  "field_required" smallint NULL DEFAULT '0'::smallint,
                                                  CONSTRAINT "kes_tools_column_config_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."table_name" IS '表名';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."column_type" IS '字段类型';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."key_type" IS '数据库字段键类型。 PK：主键';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."extra" IS '字段额外参数';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."remark" IS '字段描述';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."not_null" IS '表单是否必填(0,非必填，1，必填)';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."list_show" IS '是否在列表显示 0否 1是';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."form_show" IS '是否在表单显示 0否 1是';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."form_type" IS '表单类型
Input :文本框
Textarea：文本域
Select：下拉框
Radio：单选框
Date：日期框
';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."query_type" IS '查询方式
=
!=
>=
<=
Like
NotNull
BetWeen';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."dict_name" IS '字典名称(暂不使用)';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."column_name" IS '字段名';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."table_id" IS '表ID';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."column_num" IS '字段号';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."field_ext" IS '表单字段额外json';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."form_code" IS '表单字段';
COMMENT ON COLUMN "${moduleSchema}"."kes_tools_column_config"."field_required" IS '字段是否必填(0,非必填，1，必填)';