-- "kesplus_app"."kes_app_build" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_app_build";

CREATE TABLE "kesplus_app"."kes_app_build" (
    "id" character varying(32 char) NOT NULL,
	"app_id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"version" character varying(50 char) NULL,
	"build_type" integer NOT NULL,
	"from_tag" character varying(32 char) NULL,
	"to_tag" character varying(32 char) NOT NULL,
	"build_comment" text NULL,
	"build_time" datetime NULL DEFAULT now(),
	"build_file_name" character varying(100 char) NOT NULL,
	"build_file_full_path" character varying(150 char) NOT NULL,
	CONSTRAINT "con_kes_plus_kes_app_build_constraint_1" PRIMARY KEY (id)
);
CREATE INDEX inxex_kes_plus_kes_app_build_index_1 ON kesplus_app.kes_app_build USING btree (app_id);
COMMENT ON TABLE "kesplus_app"."kes_app_build" IS '构建信息';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_app_build"."id" IS 'i构建d';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."app_id" IS '应用id';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."user_id" IS '用户id';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."version" IS '版本号';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."build_type" IS '构建类型，1：安装包，2：更新包，3：补丁包';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."from_tag" IS '起始tag，作为更新包的开始版本';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."to_tag" IS '终止tag';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."build_comment" IS '构建日志或注释';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."build_time" IS '构建时间';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."build_file_name" IS '构建的文件包名称，不包括扩展名（.zip）';
COMMENT ON COLUMN "kesplus_app"."kes_app_build"."build_file_full_path" IS '构建文件的全路径';