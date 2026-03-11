-- "${moduleSchema}"."kesplus_module_restful" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_restful";

CREATE TABLE "${moduleSchema}"."kesplus_module_restful" (
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
	"module_id" character varying(32 char) not NULL,
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
	"obj_type" character varying(10 char) NULL,
	"sql_content" text NULL,
	"anonymous_block" text NULL,
	"params" jsonb NULL,
	 "sort_num" integer NULL,
    "is_anonymous" smallint NULL DEFAULT 0,
	CONSTRAINT "pk_module_restful_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."id" IS '主键id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."parent_id" IS '父id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."path" IS 'uri路径';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."type" IS '资源类型（4：虚拟目录；5：接口）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."title" IS 'api名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."method" IS '接口类型 GET POST PUT DELETE';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."return_type" IS '返回类型：ONE ROW; NONE';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."source_type" IS '* 源类型：
     * TABLE
     * VIEW
     * PL/SQL PRODURE
     * PL/SQL FUNCTION';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."auth_status" IS '   * 0 未授权
     * 1 已授权';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."remark" IS '说明';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."full_path" IS '全路径-（暂未使用）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."show_sort" IS '排序';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."tenant_id" IS '租户id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."sys_api" IS '系统内置api。 0是 ；1否（默认）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."func_id" IS '绑定的函数表id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."enabled" IS '是否启用  0否 1是';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."api_version" IS '版本号(X.Y.Z) 大版本.小版本.补丁版本';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."view_id" IS '绑定的视图id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."create_by" IS '创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."update_by" IS '修改人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."dept_id" IS '创建人部门id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."responsible_person" IS '负责人';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."sort_num" IS '对象排序因子，默认正序，最小的排在最上面';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful"."is_anonymous" IS '是否匿名访问  0否 1是';
