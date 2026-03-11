CREATE TABLE "${moduleSchema}"."kesplus_module_role_permission" (
	"id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"permission_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) not NULL,
	CONSTRAINT "pk_module_role_permission_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."id" IS '主键ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."role_id" IS '角色id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."permission_id" IS '权限地id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_permission"."dept_id" IS '记录数据所属部门';