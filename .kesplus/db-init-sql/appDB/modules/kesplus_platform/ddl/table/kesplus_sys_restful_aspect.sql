-- "kesplus_platform"."kesplus_sys_restful_aspect" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_restful_aspect";

CREATE TABLE "kesplus_platform"."kesplus_sys_restful_aspect" (
	"id" character varying(32 char) NOT NULL,
	"restful_id" character varying(32 char) NOT NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"order_id" smallint NOT NULL,
	"aspect_id" character varying(32 char) NOT NULL,
	"create_by" text NULL,
	"update_by" text NULL,
	CONSTRAINT "pk_platform_restful_aspect" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_platform"."kesplus_sys_restful_aspect" IS '接口和切面关联表';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful_aspect"."id" IS '主键';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful_aspect"."restful_id" IS 'api表id';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful_aspect"."order_id" IS '顺序，值越大越先执行，会覆盖切面定义表值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_restful_aspect"."aspect_id" IS '切面id';