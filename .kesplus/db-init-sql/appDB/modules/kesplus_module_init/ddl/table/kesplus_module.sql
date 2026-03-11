-- "${moduleSchema}"."kesplus_module" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kesplus_module";

CREATE TABLE "${moduleSchema}"."kesplus_module" (
	"id" character varying(32 char) NOT NULL,
	"module_name" character varying(50 char) NOT NULL,
	"module_path" character varying(50 char) NOT NULL,
	"module_code" character varying(50 char) NOT NULL,
	"module_icon" character varying(50 char) NULL,
	"remark" character varying(255 char) NULL,
	"create_time" date NULL,
	"create_by" character varying(50 char) NULL,
	"update_time" date NULL,
	"update_by" character varying(50 char) NULL,
	"app_id" character varying(32 char) NOT NULL,
	"type" smallint NOT NULL DEFAULT 1,
	"enabled" smallint NULL DEFAULT 1,
	"child_api" character varying(255 char) NULL,
	"tenant_id" character varying(32 char) NULL,
	"status" smallint NULL,
	"charge_by" character varying(32 char) NULL,
	"sort" integer NULL,
    "module_version" character varying(32 char) NULL,
    "parent_id" character varying(32 char) NOT NULL DEFAULT 0,
	CONSTRAINT "pk_module_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "uk_path_id_constraint_1" UNIQUE (module_path, app_id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."module_name" IS '模块名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."module_path" IS '模块路径';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."module_code" IS '模块编码';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."module_icon" IS '模块图标';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."remark" IS '备注信息';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."create_time" IS '创建日期';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."create_by" IS '创建人';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."update_time" IS '更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."update_by" IS '更新人';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."app_id" IS '应用id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."type" IS '模块类型 1应用创建 0系统内置';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."enabled" IS '是否开启 1是 0否';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."child_api" IS '子目录api名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."tenant_id" IS '租户id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."status" IS '模块发布状态 1 发布 0 取消发布';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module"."sort" IS '显示顺序';