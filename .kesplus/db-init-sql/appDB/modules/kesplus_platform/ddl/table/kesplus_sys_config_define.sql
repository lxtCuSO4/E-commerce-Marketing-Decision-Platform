-- "kesplus_platform"."kesplus_sys_config_define" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_config_define";

CREATE TABLE "kesplus_platform"."kesplus_sys_config_define" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NOT NULL,
	"name" character varying(64 char) NOT NULL,
	"description" character varying(255 char) NULL,
	"data_type" character varying(32 char) NOT NULL,
	"input_type" character varying(16 char) NULL DEFAULT 0,
	"data_source" smallint NOT NULL DEFAULT 1,
	"data_info" json NULL,
	"mult_flag" boolean NOT NULL DEFAULT false,
	"scope_type" smallint NOT NULL DEFAULT 1,
	"default_value" character varying(255 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_platform_sys_config_define" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."code" IS '参数编号，全局唯一';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."name" IS '参数名称，如deptId';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."description" IS '参数详细描述';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."data_type" IS '参数类型，varchar/boolean/int/date';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."input_type" IS '输入方式，如input、radio、checkbox、select、auto， 其中auto为自动生成，不需要使用人员输入';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."data_source" IS '页面值集、字典数据获取方式：1-自定义；2-通过接口后台获取';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."data_info" IS '页面上需要的其他属性集合';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."mult_flag" IS '是否多选/数组';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."scope_type" IS '作用域类型，4-仅平台配置生效，不允许单独设置；3-仅允许租户单独设置；2-允许租户、组织设置；1-允许个人设置';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."default_value" IS '默认值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_config_define"."module_id" IS '模块id';