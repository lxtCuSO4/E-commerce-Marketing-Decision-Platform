-- "kesplus_platform"."kes_application" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_application";

CREATE TABLE "kesplus_platform"."kes_application" (
                                              "id" character varying(32 char) NOT NULL,
                                              "name" character varying(255 char) NOT NULL,
                                              "code" character varying(100 char) NOT NULL,
                                              "icon" text NULL,
                                              "layout" smallint NOT NULL,
                                              "business_type" character varying(32 char) NULL,
                                              "datasource" character varying(32 char) NULL,
                                              "security" character varying(20 char) NULL,
                                              "session_timeout" smallint NULL,
                                              "remark" character varying(255 char) NULL,
                                              "create_time" date NULL,
                                              "update_time" date NULL,
                                              "create_by" character varying(50 char) NULL,
                                              "update_by" character varying(50 char) NULL,
                                              "select_modules" character varying(255 char) NULL,
                                              "enabled" smallint NULL DEFAULT 1,
                                              "project_admin_id" character varying(32 char) NULL,
                                              "app_admin_id" character varying(32 char) NULL,
                                              "git_url" character varying(255 char) NULL,
                                              "form_json" text NULL,
                                              "share_module" character varying(1000 char) NULL,
                                              "git_id" character varying(32 char) NULL,
                                              "shared" smallint NULL DEFAULT '0'::smallint,
                                              "host" character varying(64 char) NULL,
                                              "import_type" smallint NOT NULL default '1'::smallint,
                                              "app_type" smallint NOT NULL default '0'::smallint,
                                              "copyright" text NULL,
                                              "app_version" text NULL,
                                              CONSTRAINT "kes_application_pkey" PRIMARY KEY (id),
                                              CONSTRAINT "kes_application_session_timeout" CHECK (((session_timeout >= 5) AND (session_timeout <= 10080))),
                                              CONSTRAINT "kes_plus_kes_application_code_union" UNIQUE (code)
);
COMMENT ON TABLE "kesplus_platform"."kes_application" IS 'Kes-plus 应用表';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."id" IS '主键';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."name" IS '应用名称';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."code" IS '应用编码';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."icon" IS '应用图标';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."layout" IS '布局，1 .经典左右；2.时尚左右；3.传统风格；4.大屏显示';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."business_type" IS '业务类型，请参见业务类型表';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."datasource" IS '数据源';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."security" IS '系统安全 http https';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."session_timeout" IS '会话超时时间（分钟）';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."remark" IS '备注';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."update_by" IS '更新人';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."select_modules" IS '选择功能 code逗号分隔';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."enabled" IS '是否开启 1是 0否';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."project_admin_id" IS '项目管理员';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."app_admin_id" IS '应用管理员';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."git_url" IS '项目git地址';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."form_json" IS '表单JSON';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."share_module" IS '共享模块id';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."git_id" IS 'gitId';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."host" IS 'http/https://x.x.x.x:x/';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."import_type" IS '应用导入方式，1.创建导入，有git; 2.安装包部署导入，无git';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."app_type" IS '应用创建方式，0.创建；1.导入; 2.安装包部署';
COMMENT ON COLUMN "kesplus_platform"."kes_application"."copyright" IS '版权信息';
