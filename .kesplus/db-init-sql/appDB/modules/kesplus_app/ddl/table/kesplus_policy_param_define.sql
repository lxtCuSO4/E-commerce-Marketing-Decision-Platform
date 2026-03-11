-- "kesplus_app"."kesplus_policy_param_define" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kesplus_policy_param_define";

CREATE TABLE "kesplus_app"."kesplus_policy_param_define" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NOT NULL,
	"name" character varying(64 char) NOT NULL,
	"title" character varying(64 char) NOT NULL,
	"description" character varying(255 char) NULL,
	"data_type" character varying(32 char) NOT NULL,
	"input_type" character varying(16 char) NULL DEFAULT 0,
	"data_source" smallint NOT NULL DEFAULT 1,
	"data_info" json NULL,
	"mult_flag" boolean NOT NULL DEFAULT false,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"variable_path" character varying(128 char) NULL,
	CONSTRAINT "pk_app_policy_param_define" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."code" IS '参数编号，全局唯一';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."name" IS '参数名称，如deptId';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."title" IS '参数标题';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."description" IS '参数详细描述';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."data_type" IS '参数类型，varchar/boolean/int/date';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."input_type" IS '输入方式，如input、radio、checkbox、select、auto， 其中auto为自动生成，不需要使用人员输入';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."data_source" IS '页面值集、字典数据获取方式：1-自定义；2-通过接口后台获取';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."data_info" IS '页面上需要的其他属性集合';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."mult_flag" IS '是否多选/数组';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."enabled" IS '0-保存；1-启用；2-停用';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_app"."kesplus_policy_param_define"."variable_path" IS '变量表达式';