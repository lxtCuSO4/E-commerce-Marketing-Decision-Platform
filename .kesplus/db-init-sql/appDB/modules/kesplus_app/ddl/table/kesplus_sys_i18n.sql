CREATE TABLE "kesplus_app"."kesplus_sys_i18n" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(255 char) NOT NULL,
	"db_error" integer NOT NULL DEFAULT 0,
	"success" character varying(255 char) NOT NULL DEFAULT 0,
	"app_module" character varying(255 char) NULL,
	"msg" json NOT NULL,
	"type_code" integer ,
	CONSTRAINT "pk_app_sys_i18n" PRIMARY KEY (id),
	CONSTRAINT "uk_app_sys_18n" UNIQUE (code)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_sys_i18n"."code" IS '状态码';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_i18n"."db_error" IS '是否数据库错误';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_i18n"."success" IS '是否成功';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_i18n"."app_module" IS '创建者';
COMMENT ON COLUMN "kesplus_app"."kesplus_sys_i18n"."msg" IS '消息详细内容';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_i18n"."type_code" IS '错误分类编码';