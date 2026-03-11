-- "${moduleSchema}"."kesplus_module_form" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_form";

CREATE TABLE "${moduleSchema}"."kesplus_module_form" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(128 char) NOT NULL,
	"code" character varying(128 char) NOT NULL,
	"status" smallint NOT NULL,
	"gen_method" smallint NOT NULL,
	"main_table" character varying(128 char) NOT NULL,
	"sub_tables" jsonb NULL,
	"field_config" jsonb NOT NULL,
	"vue_component" character varying(512 char) NOT NULL,
	"edit_permissions" varchar[] NULL,
	"view_permissions" varchar[] NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"module_id" character varying(32 char) NOT NULL,
	"obj_type" character varying(10 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"sort_num" integer NULL,
	CONSTRAINT "con_kesplus_module_form_pk" PRIMARY KEY (id)
);
COMMENT ON TABLE "${moduleSchema}"."kesplus_module_form" IS '表单记录';

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."id" IS '主键，表单id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."name" IS '表单页面名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."code" IS '表单编号';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."status" IS '表单状态，0-编辑中，1-已生效';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."gen_method" IS '表单创建方式，1-手动新增；2-代码生成自动产生';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."main_table" IS '主表名称';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."sub_tables" IS '子表、子表与主表关联模式及子表与主表关联字段';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."field_config" IS '主子表字段映射及配置';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."vue_component" IS 'vue组件路径';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."edit_permissions" IS '审批所需权限点';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_form"."view_permissions" IS '审阅所需权限点';

