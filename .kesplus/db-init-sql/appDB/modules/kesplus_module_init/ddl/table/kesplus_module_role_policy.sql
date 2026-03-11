CREATE TABLE "${moduleSchema}"."kesplus_module_role_policy" (
	"id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"policy_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_module_role_policy_id" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."id" IS '主键ID';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."role_id" IS '角色id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."policy_id" IS '策略实例id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_module_role_policy"."dept_id" IS '记录数据所属部门';