-- "kesplus_app"."kes_route_info" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_route_info";

CREATE TABLE "kesplus_app"."kes_route_info" (
    "id" character varying(32 char) NOT NULL,
	"route_name" character varying(32 char) NOT NULL,
	"owner_dept_id" character varying(32 char) NULL,
	"standalone_deploy_flag" smallint NULL DEFAULT 0,
	"server_id" character varying(32 char) NULL,
	"app_id" character varying(32 char) NULL,
	"group_id" integer NOT NULL DEFAULT '-1'::integer,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" datetime NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" datetime NULL,
	"status" integer NULL DEFAULT 1,
	"target_route_id" character varying(32 char) NULL,
	"queries_per_second" integer NULL DEFAULT '-1'::integer,
	"queries_per_second_per_ip" integer NULL DEFAULT '-1'::integer,
	"group_name" character varying(32 char) NULL,
    "included" boolean NULL DEFAULT true,
	"role_ids" text NULL,
	"manual" boolean NULL DEFAULT false,
	"special_role_ids" text NULL,
	CONSTRAINT "kes_kes_route_info_pkey" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_route_info"."id" IS 'ID';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."route_name" IS '路由名称';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."owner_dept_id" IS '部门ID';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."standalone_deploy_flag" IS '是否独立部署(0-共享;1-独立)';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."server_id" IS '服务器ID';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."group_id" IS '分组ID';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."update_by" IS '修改人';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."update_time" IS '修改时间';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."status" IS '路由状态（1-正常，2-切机，3-托管，4-断开）';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."target_route_id" IS '目标路由id';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."queries_per_second" IS '每秒查询数（QPS）-1:不限';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."queries_per_second_per_ip" IS '每个IP每秒查询数（QPS）-1:不限';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."group_name" IS '分组名称';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."included" IS '受限角色类型，true：包含，false：排除';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."role_ids" IS '角色列表，以逗号分隔';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."manual" IS '是否开启手动限流';
COMMENT ON COLUMN "kesplus_app"."kes_route_info"."special_role_ids" IS '手动限流时，无限制的角色列表，以逗号分隔';