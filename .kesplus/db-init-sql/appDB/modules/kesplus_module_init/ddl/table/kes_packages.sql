-- "${moduleSchema}"."kes_packages" definition

-- Drop table

DROP TABLE IF EXISTS "${moduleSchema}"."kes_packages";

CREATE TABLE "${moduleSchema}"."kes_packages" (
                                           "id" character varying(32 char) NOT NULL,
                                           "parent_id" character varying(32 char) NULL,
                                           "module_id" character varying(32 char) NULL,
                                           "app_id" character varying(32 char) NULL,
                                           "schema_name" character varying(50 char) NULL,
                                           "authid_name" character varying(50 char) NULL,
                                           "name" character varying(100 char) NOT NULL,
                                           "header_content" text NULL,
                                           "body_content" text NULL,
                                           "type" character varying(100 char) NULL,
                                           "remark" character varying(500 char) NULL,
                                           "create_time" date NULL,
                                           "update_time" date NULL,
                                           "update_by" character varying(32 char) NULL,
                                            "create_by" character varying(32 char) NULL,
                                           "tenant_id" character varying(32 char) NULL,
                                           "obj_type" character varying(10 char) NULL,
                                           "sort_num" integer NULL,
                                           CONSTRAINT "kes_package_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."parent_id" IS '父id';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."module_id" IS '模块id';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."app_id" IS '应用id(备用)';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."schema_name" IS '模式名';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."authid_name" IS '调用检查权限
current_user
definer';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."name" IS '包名字';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."header_content" IS '包定义内容';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."body_content" IS '包体内容';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."type" IS '数据类型
目录 package-dir,
包 package';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."remark" IS '备注';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."tenant_id" IS '租户id';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."sort_num" IS '对象排序因子，默认正序，最小的排在最上面';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."obj_type" IS '对象类型：dir、obj';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."create_by" IS '创建人';
COMMENT ON COLUMN "${moduleSchema}"."kes_packages"."update_by" IS '修改人';
