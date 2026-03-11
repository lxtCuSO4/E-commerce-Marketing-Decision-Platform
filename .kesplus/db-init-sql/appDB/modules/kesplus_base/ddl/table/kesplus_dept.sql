-- "kesplus_base"."kesplus_dept" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_dept";

CREATE TABLE "kesplus_base"."kesplus_dept" (
	"id" character varying(32 char) NOT NULL,
	"dept_code" character varying(32 char) NOT NULL,
	"dept_name" character varying(128 char) NOT NULL,
	"dept_short_name" character varying(32 char) NULL,
	"dept_common_name" character varying(32 char) NULL,
	"dept_former_name" character varying(32 char) NULL,
	"dept_type" smallint NULL DEFAULT 0,
	"classify" character varying(32 char) NULL,
	"manager_user_id" character varying(32 char) NULL,
	"dept_position" character varying(32 char) NULL,
	"dept_responsibility" character varying(255 char) NULL,
	"contract_user_id" character varying(32 char) NULL,
	"company_id" character varying(32 char) NULL DEFAULT 0,
	"enabled" smallint NULL DEFAULT 0,
	"pid" character varying(32 char) NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"expanded_manager_keys" character varying(255 char) NULL,
	"tree_sort" integer NULL,
	"tree_level" integer NULL,
	"tree_path" text NULL,
	"expansion" jsonb NULL,
	"dept_header" character varying(32 char) NULL,
	"dept_major_leader" character varying(32 char) NULL,
	"dept_charger_leader" character varying(32 char) NULL,
	"ldap_id" character varying(64) NULL,
	CONSTRAINT "pk_base_dept" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_code" IS '部门编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_name" IS '部门名称';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_short_name" IS '部门简称';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_type" IS '部门类型：0-公司；1-部门';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."enabled" IS '状态 0-保存；1-启用；2-停用';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."pid" IS '当前部门的上级部门id,1级部门的上级id为0';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tenant_id" IS '租户id，外键，关联kes_app_tenant表';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."expanded_manager_keys" IS '主管领导回显部门id集合';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_sort" IS '排序';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_level" IS '层级';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_path" IS '路径';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."expansion" IS '其它信息';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_header" IS '部门负责人';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_major_leader" IS '部门主管领导';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_charger_leader" IS '部门分管领导';

CREATE INDEX idx_kesplus_dept_dept_header ON kesplus_base.kesplus_dept(dept_header);
CREATE INDEX idx_kesplus_dept_dept_major_leader ON kesplus_base.kesplus_dept(dept_major_leader);
CREATE INDEX idx_kesplus_dept_dept_charger_leader ON kesplus_base.kesplus_dept(dept_charger_leader);