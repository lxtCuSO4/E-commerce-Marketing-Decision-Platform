CREATE TABLE "${moduleSchema}"."kesplus_code_generation_config" (
	"id" character varying(32 char) NOT NULL,
	"table_id" character varying(32 char) NOT NULL,
	"table_name" character varying(128 char) NULL,
	"child_table_names" text[] NULL,
	"schema_name" character varying(128 char) NULL,
	"module_id" character varying(32 char) NULL,
	"content" jsonb NULL,
	"generated" boolean NULL DEFAULT false,
	"create_time" datetime NULL,
	"create_by" varchar NULL,
	"update_time" datetime NULL,
	"update_by" varchar NULL,
	CONSTRAINT "con_test_kesplus_code_generation_config_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_test_kesplus_code_generation_config_constraint_2" UNIQUE (table_id)
);
COMMENT ON TABLE "${moduleSchema}"."kesplus_code_generation_config" IS '代码生成配置表';

-- Column comments

COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."id" IS '主键';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."table_id" IS '表id';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."table_name" IS '表名';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."child_table_names" IS '子表名';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."content" IS '配置信息';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."generated" IS '是否已生成  ';
COMMENT ON COLUMN "${moduleSchema}"."kesplus_code_generation_config"."create_time" IS '创建时间';