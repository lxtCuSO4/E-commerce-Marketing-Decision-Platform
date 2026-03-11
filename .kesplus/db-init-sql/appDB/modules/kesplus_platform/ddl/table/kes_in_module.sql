-- "kesplus_platform"."kes_in_module" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_in_module";

CREATE TABLE "kesplus_platform"."kes_in_module" (
                                            "id" character varying(32 char) NOT NULL,
                                            "module_name" character varying(100 char) NOT NULL,
                                            "module_code" character varying(50 char) NOT NULL,
                                            "create_time" date NULL,
                                            "create_by" character varying(50 char) NULL,
                                            "selected" smallint NULL,
                                            "sort_num" integer NULL,
                                            "module_path" character varying(255 char) NULL,
                                            CONSTRAINT "kes_in_module_pkey" PRIMARY KEY (id)
);
COMMENT ON TABLE "kesplus_platform"."kes_in_module" IS 'Kes-plus 内置模块列表';
COMMENT ON COLUMN "kesplus_platform"."kes_in_module"."id" IS 'id';
COMMENT ON COLUMN "kesplus_platform"."kes_in_module"."module_name" IS '模块名称';
COMMENT ON COLUMN "kesplus_platform"."kes_in_module"."module_code" IS '模块编码';
COMMENT ON COLUMN "kesplus_platform"."kes_in_module"."selected" IS '是否默认选中 1是 0 不是';
COMMENT ON COLUMN "kesplus_platform"."kes_in_module"."module_path" IS '模块路径,根据选择拼装项目';