-- "kesplus_app"."kes_app_directory" definition

-- Drop table

--DROP TABLE IF EXISTS "kesplus_app"."kes_app_directory";

CREATE TABLE "kesplus_app"."kes_app_directory" (
                                                "id" character varying(32 char) NOT NULL,
                                                "sort_num" integer NULL DEFAULT 0,
                                                "directory_type" smallint NOT NULL DEFAULT 10,
                                                "pid" character varying(32 char) NULL,
                                                "directory_name" character varying(50 char) NOT NULL,
                                                "directory_code" character varying(50 char) NOT NULL,
                                                "directory_icon" character varying(50 char) NULL,
                                                "data_table" character varying(128 char) NULL,
                                                "status" smallint NOT NULL DEFAULT 1,
                                                "sub_count" smallint NULL DEFAULT 0,
                                                "app_id" character varying(32 char) NULL,
                                                "create_time" date NULL,
                                                "child_api" character varying(255 char) NULL,
                                                "tenant_id" character varying(32 char) NULL,
                                                CONSTRAINT "kes_directory_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."sort_num" IS '顺序';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."directory_type" IS '目录类型
1 系统一级目录（表、视图、存储过程等）
2 系统二级目录（Restfull服务、权限点定义、内置角色、自动化测试等）
10 自定义目录
20 表对象
21 视图对象
22 函数对象
23 存储过程对象
24 包对象
25 定时任务
30 RestFul对象
31 权限点对象
32 角色对象
33 测试对象
40 菜单对象
41 VUE对象
42 JS对象
43 CSS对象
44 IMage对象
45 I18n对象';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."pid" IS '父目录id';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."directory_name" IS '目录名称';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."directory_code" IS '目录编码';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."directory_icon" IS '目录icon';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."status" IS '状态 1 启用 0禁用';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."sub_count" IS '子目录个数';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."app_id" IS '应用id';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."child_api" IS '获取子集api';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."tenant_id" IS '租户id';
COMMENT ON COLUMN "kesplus_app"."kes_app_directory"."data_table" IS '关联的数据表';