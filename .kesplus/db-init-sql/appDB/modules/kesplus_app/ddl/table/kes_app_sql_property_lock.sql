DROP TABLE IF EXISTS "kesplus_app"."kes_app_sql_property_lock";

CREATE TABLE "kesplus_app"."kes_app_sql_property_lock" (
	"id" character varying(32 char) NOT NULL,
	"module_code" character varying(255 char) NULL,
	"sql_property_id" character varying(100 char) NOT NULL,
	"sql_property_name" character varying(100 char) NOT NULL,
	"sql_property_type" character varying(100 char) NOT NULL,
	"sql_property_lock_status" smallint NULL DEFAULT 0,
	"hold_lock_user" character varying(32 char) NULL,
	"lock_time" date NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"create_id" character varying(32 char)  NULL,
	"update_id" character varying(32 char)  NULL,
	CONSTRAINT "kes_app_sql_property_lock_pkey" PRIMARY KEY (id),
	CONSTRAINT "un_property_id_and_type" UNIQUE ("sql_property_id", "sql_property_type")
);
CREATE INDEX lock_id_index_search ON "kesplus_app".kes_app_sql_property_lock USING btree (sql_property_id, sql_property_type, sql_property_lock_status, hold_lock_user);
CREATE INDEX lock_name_index_search ON "kesplus_app".kes_app_sql_property_lock USING btree (sql_property_name, sql_property_type, sql_property_lock_status, hold_lock_user);

COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."id" IS '主键';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."sql_property_id" IS 'SQL对象ID，例如表，视图，函数，存储过程，程序包';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."sql_property_name" IS 'SQL对象名称';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."sql_property_type" IS 'SQL对象类型 0：表 1：视图 2：函数 3：存储过程 4：程序包';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."sql_property_lock_status" IS 'SQL对象锁的状态 0：未被锁定，1：已被锁定';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."hold_lock_user" IS '持有锁的用户ID';
COMMENT ON COLUMN "kesplus_app"."kes_app_sql_property_lock"."lock_time" IS '加锁时间';
