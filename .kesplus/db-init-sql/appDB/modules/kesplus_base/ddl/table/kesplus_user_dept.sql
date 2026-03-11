-- "kesplus_base"."kesplus_user_dept" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_dept";

CREATE TABLE "kesplus_base"."kesplus_user_dept" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"current_dept_id" character varying(32 char) NOT NULL,
	"default_flag" boolean NOT NULL DEFAULT true,
	"login_flag" boolean NOT NULL DEFAULT false,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "con_t_app_user_dept_constraint_userid_deptid" UNIQUE (user_id, current_dept_id),
	CONSTRAINT "pk_base_user_dept" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."user_id" IS '用户id，外键，关联kes_app_user表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."current_dept_id" IS '部门id，外键，关联kes_app_dept表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."default_flag" IS '是否主要关联，单个人可能关联多个部门，但有且只有一个主要关联';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."dept_id" IS '记录数据所属部门';


CREATE INDEX idx_kesplus_user_dept_dept_id ON kesplus_base.kesplus_user_dept(current_dept_id);
CREATE INDEX idx_kesplus_user_dept_user_id ON kesplus_base.kesplus_user_dept(user_id);

