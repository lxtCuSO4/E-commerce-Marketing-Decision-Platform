-- "kesplus_platform"."kesplus_sys_restful" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_restful";

CREATE TABLE "kesplus_platform"."kesplus_sys_restful" (
	"id" character varying(32 char) NOT NULL,
	"parent_id" character varying(32 char) NULL DEFAULT 0,
	"code" character varying(128 char) NULL,
	"path" character varying(100 char) NULL,
	"type" integer NULL,
	"title" character varying(100 char) NULL,
	"method" character varying(20 char) NULL,
	"return_type" character varying(50 char) NULL,
	"source_type" character varying(50 char) NULL,
	"auth_status" smallint NULL DEFAULT 0,
	"remark" character varying(255 char) NULL,
	"full_path" character varying(255 char) NULL,
	"show_sort" smallint NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL,
	"tenant_id" character varying(32 char) NULL,
	"sys_api" smallint NULL DEFAULT 1,
	"func_id" character varying(32 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	"app_id" character varying(32 char) NULL,
	"api_version" character varying(255 char) NULL,
	"view_id" character varying(32 char) NULL,
	"service_code" character varying(100 char) NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"dept_id" character varying(32 char) NULL,
	"responsible_person" character varying(100 char) NULL,
	"tree_sort" integer NULL,
	"tree_path" text NULL,
	"obj_type" character varying(8 char) NULL,
	"sql_content" text NULL,
	"anonymous_block" text NULL,
	"params" jsonb NULL,
	"sort_num" integer NULL,
	"is_anonymous" smallint NULL DEFAULT 0,
	"execute_content" varchar NULL,
	"sql_content_simple" varchar NULL,
	"env" integer NULL,
	CONSTRAINT "pk_platform_restful" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."id" IS '主键id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."parent_id" IS '父id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."path" IS 'uri路径';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."type" IS '资源类型（4：虚拟目录；5：接口）';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."title" IS 'api名称';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."method" IS '接口类型 GET POST PUT DELETE';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."return_type" IS '返回类型：ONE ROW; NONE';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."source_type" IS '* 源类型：
     * TABLE
     * VIEW
     * PL/SQL PRODURE
     * PL/SQL FUNCTION';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."auth_status" IS '   * 0 未授权
     * 1 已授权';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."remark" IS '说明';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."full_path" IS '全路径-（暂未使用）';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."show_sort" IS '排序';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."sys_api" IS '系统内置api。 0是 ；1否（默认）';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."func_id" IS '绑定的函数表id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."enabled" IS '是否启用  0否 1是';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."api_version" IS '版本号(X.Y.Z) 大版本.小版本.补丁版本';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."view_id" IS '绑定的视图id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."update_by" IS '修改人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."dept_id" IS '创建人部门id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful"."responsible_person" IS '负责人';

-- Table Triggers

CREATE OR REPLACE TRIGGER kesplus_tr_restful_cache_restful AFTER DELETE OR UPDATE ON kesplus_platform.kesplus_sys_restful FOR EACH ROW
BEGIN
    delete FROM "kesplus_platform"."kesplus_sys_cache" where "cache_type" = 'RESTFUL' and "cache_key" = OLD.id;
END;