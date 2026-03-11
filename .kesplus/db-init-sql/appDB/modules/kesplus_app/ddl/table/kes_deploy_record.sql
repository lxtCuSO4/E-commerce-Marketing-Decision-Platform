-- "kesplus_app"."kes_deploy_record" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_deploy_record";


CREATE TABLE "kesplus_app"."kes_deploy_record" (
    "id" character varying(32 char) NOT NULL,
    "app_id" character varying(32 char) NOT NULL,
    "app_code" character varying(32 char) NOT NULL,
    "app_name" character varying(128 char) NOT NULL,
	"deploy_version" character varying(64 char) NOT NULL,
	"pkg_type" smallint NOT NULL,
	"status" character varying(32 char) NOT NULL,
	"dist_file_name" character varying(128 char) NULL,
	"dist_path" character varying(512 char) NULL,
	"result" character varying(1024 char) NULL,
	"remark" character varying(1024 char) NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" datetime NOT NULL,
	CONSTRAINT "kes_deploy_record_pkey" PRIMARY KEY (id)
);

COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."id" IS 'ID';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."app_code" IS '应用code';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."app_name" IS '应用name';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."deploy_version" IS '部署包版本号';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."pkg_type" IS '包类型：1-源码安装包；2-源码更新包；3-源码补丁包;4-部署安装包；5-部署更新包；6-部署补丁包';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."status" IS '部署执行的状态：SUCCESS-成功；FAILED-失败';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."dist_file_name" IS 'dist包文件名';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."dist_path" IS 'dist包存放路径';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."result" IS '部署执行失败信息';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."remark" IS '部署日志';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_app"."kes_deploy_record"."create_time" IS '创建时间';