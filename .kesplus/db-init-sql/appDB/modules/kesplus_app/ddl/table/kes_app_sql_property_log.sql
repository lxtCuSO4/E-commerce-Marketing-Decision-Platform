DROP TABLE IF EXISTS "kesplus_app"."kes_app_sql_property_log";

CREATE TABLE "kesplus_app"."kes_app_sql_property_log" (
    "id" character varying(32 char) NOT NULL,
    "module_code" character varying(255 char) NULL,
	"sql_property_id" character varying(100 char) NOT NULL,
	"sql_property_name" character varying(100 char) NOT NULL,
	"sql_property_type" character varying(100 char) NOT NULL,
	"sql_content" text NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"create_id" character varying(32 char)  NULL,
	"update_id" character varying(32 char)  NULL,
	"change_type" tinyint NULL,
	"file_store_status" integer NOT NULL DEFAULT 1,
	"pkg_header" text NULL,
	"pkg_body" text NULL,
	CONSTRAINT "kes_app_sql_property_log_pkey" PRIMARY KEY (id)
);
CREATE INDEX log_id_index_search ON "kesplus_app".kes_app_sql_property_log USING btree (sql_property_id, sql_property_type);

COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."id" IS '主键';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."sql_property_id" IS 'SQL对象ID，例如表，视图，函数，存储过程，程序包';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."sql_property_name" IS 'SQL对象名称';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."sql_property_type" IS 'SQL对象类型 0：表 1：视图 2：函数 3：存储过程 4：程序包';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."sql_content" IS 'SQL对象内容';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."change_type" IS '0新增 1修改 2回滚';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_log"."file_store_status" IS '文件存储状态 1:成功，0:失败（待补偿）';