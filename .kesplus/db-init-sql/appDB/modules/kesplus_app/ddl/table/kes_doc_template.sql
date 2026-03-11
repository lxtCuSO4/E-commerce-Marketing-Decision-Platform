-- "kesplus_app"."kes_doc_template" definition

-- Drop table

-- DROP TABLE "kesplus_app"."kes_doc_template";

CREATE TABLE "kesplus_app"."kes_doc_template" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(128 char) NOT NULL,
	"content" text NULL,
	"file_name" character varying(256 char) NULL,
	"file_type" character varying(128 char) NULL,
	"template_type" varchar NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	"enabled" integer NULL DEFAULT 1,
	"path" varchar NULL,
	CONSTRAINT "con_kes_plus_kes_template_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_template_constraint_2" UNIQUE (name)
);
CREATE UNIQUE INDEX inxex_kes_plus_kes_template_index_1 ON kesplus_app.kes_doc_template USING btree (name);
COMMENT ON TABLE "kesplus_app"."kes_doc_template" IS 'freemark模板表';

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."name" IS '模板名称';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."content" IS '模板内容';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."file_name" IS '模板文件名称';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."file_type" IS '生成文件类型主要针对freemarker模板 word或excel等';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."template_type" IS '模板类型：freeMarker、Excel等';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."enabled" IS '状态 1启用 0禁用';
COMMENT ON COLUMN "kesplus_app"."kes_doc_template"."path" IS '文件路径';