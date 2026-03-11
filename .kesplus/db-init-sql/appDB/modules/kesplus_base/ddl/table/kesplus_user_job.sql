-- "kesplus_base"."kesplus_user_job" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_job";

CREATE TABLE "kesplus_base"."kesplus_user_job" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"job_id" character varying(32 char) NOT NULL,
	"current_dept_id" character varying(32 char) NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	"is_sec_job" boolean DEFAULT false,
	CONSTRAINT "pk_base_user_job" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."user_id" IS '用户id，外键，关联kes_app_user表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."job_id" IS '岗位id，外键，关联kes_app_job表';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."dept_id" IS '记录数据所属部门';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."is_sec_job" IS '是否副岗';

CREATE INDEX idx_kesplus_user_job_job_id ON kesplus_base.kesplus_user_job(job_id);
CREATE INDEX idx_kesplus_user_job_user_id ON kesplus_base.kesplus_user_job(user_id);
CREATE INDEX idx_kesplus_user_job_user_job ON kesplus_base.kesplus_user_job(job_id,user_id);


