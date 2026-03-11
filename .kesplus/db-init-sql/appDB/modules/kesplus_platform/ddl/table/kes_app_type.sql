-- "kesplus_platform"."kes_app_type" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_app_type";

CREATE TABLE "kesplus_platform"."kes_app_type" (
                                           "id" character varying(32 char) NOT NULL,
                                           "type_name" character varying(255 char) NOT NULL,
                                           "create_time" date NULL,
                                           "create_by" character varying(32 char) NULL,
                                           "pid" character varying(32 char) NULL DEFAULT 1,
                                           "type_icon" character varying(50 char) NULL,
                                           "remark" character varying(255 char) NULL,
                                           "sort_num" integer NULL DEFAULT 1000,
                                           CONSTRAINT "kes_app_category_pkey" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_platform"."kes_app_type" IS 'Kes-plus 应用分类';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."id" IS 'id';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."type_name" IS '分类名称';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."create_time" IS '创建日期';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."pid" IS '父类id';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."type_icon" IS '类型图标';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."remark" IS '描述';
COMMENT ON COLUMN "kesplus_platform"."kes_app_type"."sort_num" IS '排序序号';