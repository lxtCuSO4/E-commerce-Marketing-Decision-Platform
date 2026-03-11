-- "kesplus_base"."kesplus_job" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_job";

CREATE TABLE "kesplus_base"."kesplus_job" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(32 char) NOT NULL,
	"job_level" character varying(32 char) NULL,
	"job_type" character varying(32 char) NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char)  NULL DEFAULT 0,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	"job_index" integer NULL,
	"description" character varying(2000 char) NULL,
	CONSTRAINT "pk_base_job" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_job"."id" IS '主键';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."name" IS '岗位名';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."code" IS '岗位编号';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."job_level" IS '岗位级别';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."job_type" IS '岗位分类';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."enabled" IS '0-保存；1-启用；2-停用';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."create_by" IS '创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."update_by" IS '更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."update_time" IS '更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."dept_id" IS '创建人部门id';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."description" IS '岗位说明';

CREATE INDEX idx_kesplus_job_code ON kesplus_base.kesplus_job(code);
