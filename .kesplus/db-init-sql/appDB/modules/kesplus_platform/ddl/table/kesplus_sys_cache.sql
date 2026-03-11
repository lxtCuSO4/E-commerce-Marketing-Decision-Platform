-- "kesplus_platform"."kesplus_sys_cache" definition

-- Drop table

-- DROP TABLE "kesplus_platform"."kesplus_sys_cache";

CREATE TABLE "kesplus_platform"."kesplus_sys_cache" (
	"id" character varying(32 char) NOT NULL,
	"cache_type" character varying(8 char) NOT NULL,
	"cache_key" character varying(128 char) NOT NULL,
	"cache_value" jsonb NOT NULL,
	"create_time" datetime NOT NULL,
	CONSTRAINT "pk_app_sys_cache" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX inxex_platform_sys_cache ON kesplus_platform.kesplus_sys_cache USING btree (cache_type, cache_key);
COMMENT ON TABLE "kesplus_platform"."kesplus_sys_cache" IS '系统缓存表';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_cache"."id" IS '主键 UUID';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_cache"."cache_type" IS '缓存类型：user-用户信息；role-角色信息；restful-接口信息';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_cache"."cache_key" IS '缓存唯一标识，当前类型下，不可重复';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_cache"."cache_value" IS '缓存值';
COMMENT ON COLUMN "kesplus_platform"."kesplus_sys_cache"."create_time" IS '缓存时间';