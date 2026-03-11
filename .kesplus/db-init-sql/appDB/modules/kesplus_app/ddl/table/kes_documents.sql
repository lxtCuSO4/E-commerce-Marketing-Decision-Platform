-- "kesplus_app"."kes_documents" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_documents";

CREATE TABLE "kesplus_app"."kes_documents" (
                                            "doc_id" character varying(32 char) NOT NULL,
                                            "name" character varying(255 char) NOT NULL,
                                            "suffix" character varying(50 char) NOT NULL,
                                            "classify" character varying(20 char) NULL,
                                            "type" character varying(20 char) NULL,
                                            "content" text NULL,
                                            "create_by" character varying(32 char) NULL,
                                            "create_time" date NULL,
                                            "update_by" character varying(32 char) NULL,
                                            "update_time" date NULL,
                                            "pid" character varying(32 char) NULL,
                                            "file" character varying(100 char) NULL,
                                            "f_id" character varying(32 char) NULL,
                                            CONSTRAINT "kes_document_pkey" PRIMARY KEY (doc_id)
);
COMMENT ON COLUMN "kesplus_app"."kes_documents"."name" IS '文档名称';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."suffix" IS '文档格式
md (默认)
word
excel
txt
ppt
sql
等';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."classify" IS '功能分类
guide 开发指南
help 帮助文档';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."type" IS '分类
目录 doc-dir
文档 doc';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."content" IS '文本内容';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."create_by" IS '创建人';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."create_time" IS '创建日期';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."update_by" IS '更新人';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."update_time" IS '更新日期';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."pid" IS '父id';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."file" IS '文件创建方式';
COMMENT ON COLUMN "kesplus_app"."kes_documents"."f_id" IS '文件id';