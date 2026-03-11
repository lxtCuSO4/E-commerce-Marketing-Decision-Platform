-- "${moduleSchema}"."kesplus_module_menu" definition

-- Drop table

-- DROP TABLE "${moduleSchema}"."kesplus_module_menu";

CREATE TABLE "${moduleSchema}"."kesplus_module_menu" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NULL,
	"title" character varying(32 char) NOT NULL,
	"icon" character varying(32 char) NULL,
	"classify" smallint NULL DEFAULT 0,
	"url" character varying(255 char) NULL,
	"outer_link" boolean NULL DEFAULT false,
	"component" character varying(255 char) NULL,
	"hidden_flag" boolean NULL DEFAULT false,
	"enabled" smallint NOT NULL DEFAULT 1,
	"params" json NULL,
	"properties" json NULL,
	"create_by" character varying(32 char)  NULL,
	"create_time" timestamp(0) without time zone  NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) not NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"parent_id" character varying(32 char) NULL,
	"obj_type" character varying(10 char) NULL,
	 "sort_num" integer NULL,
	CONSTRAINT "pk_kesplus_base_module_menu" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."code" IS '编号';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."title" IS '菜单名';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."icon" IS '图标';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."classify" IS '分类：0-菜单（有链接）；1-按钮（操作、无连接）';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."url" IS '访问路径';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."outer_link" IS '是否外部链接';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."component" IS '组件，非外部链接时不能为空';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."hidden_flag" IS '菜单是否隐藏，即，若为true，则为菜单，否则为菜单式按钮';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."enabled" IS '状态 0-保存；1-启用；2-停用';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."params" IS '菜单参数';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."properties" IS '按钮属性';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."tenant_id" IS '租户ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."module_id" IS '模块id，外键，关联kesplus_module表';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu"."obj_type" IS 'dir-目录；obj-菜单';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_menu" ."sort_num" is '对象排序因子，默认正序，最小的排在最上面';

