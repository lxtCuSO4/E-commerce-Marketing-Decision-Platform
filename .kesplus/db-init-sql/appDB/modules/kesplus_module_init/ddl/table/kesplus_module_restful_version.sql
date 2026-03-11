-- "${moduleSchema}"."kesplus_module_restful_version" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_restful_version";

CREATE TABLE "${moduleSchema}"."kesplus_module_restful_version" (
	"id" character varying(32 char) NOT NULL,
	"pid" character varying(32 char) NULL DEFAULT 0,
	"path" character varying(100 char) NOT NULL,
	"type" integer NULL,
	"title" character varying(100 char) NULL,
	"method" character varying(20 char) NULL,
	"return_type" character varying(50 char) NULL,
	"source_type" character varying(50 char) NULL,
	"auth_status" smallint NULL DEFAULT 0,
	"create_time" date NULL,
	"update_time" date NULL,
	"remark" character varying(255 char) NULL,
	"full_path" character varying(255 char) NULL,
	"service_code" character varying(255 char) NULL,
	"show_sort" smallint NULL DEFAULT 0,
	"module_id" character varying(32 char) not NULL,
	"tenant_id" character varying(32 char) NULL,
	"sys_api" smallint NOT NULL DEFAULT 1,
	"func_id" character varying(32 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	"pkg_id" character varying(32 char) NULL,
	"pkg_info" json NULL,
	"app_id" character varying(32 char) NULL,
	"role_ids" character varying(1000 char) NULL,
	"api_version" character varying(255 char) NULL,
	"permission" character varying(200 char) NULL,
	"view_id" character varying(32 char) NULL,
	"params" json NULL,
	"sql_content" text NULL,
	"version_no" character varying(32 char) NOT NULL,
	"api_id" character varying(32 char) NOT NULL,
	CONSTRAINT "pk_module_restful_version_id" PRIMARY KEY (id)
);
CREATE INDEX index_${moduleSchema}_module_restful_version ON "${moduleSchema}"."kesplus_module_restful_version" USING btree (api_id, version_no);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."id" IS '主键id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."pid" IS '父id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."path" IS 'uri路径';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."type" IS '资源类型（4：虚拟目录；5：接口）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."title" IS 'api名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."method" IS '接口类型 GET POST PUT DELETE';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."return_type" IS '返回类型：ONE ROW; NONE';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."source_type" IS '* 源类型：
     * TABLE
     * VIEW
     * PL/SQL PRODURE
     * PL/SQL FUNCTION';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."auth_status" IS '   * 0 未授权
     * 1 已授权';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."remark" IS '说明';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."full_path" IS '全路径-（暂未使用）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."show_sort" IS '排序';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."tenant_id" IS '租户id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."sys_api" IS '系统内置api。 0是 ；1否（默认）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."func_id" IS '绑定的函数表id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."enabled" IS '是否启用  0否 1是';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."pkg_id" IS '选择包的id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."pkg_info" IS '包信息';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."app_id" IS '应用id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."role_ids" IS '角色id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."api_version" IS '版本号(X.Y.Z) 大版本.小版本.补丁版本';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."view_id" IS '绑定的视图id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."params" IS '参数json';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."sql_content" IS 'sql内容';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."version_no" IS '版本号';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_restful_version"."api_id" IS 'kesplus_module_restful的主键';