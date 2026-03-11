-- "kesplus_platform"."kes_logs_statistics" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_logs_statistics";

CREATE TABLE "kesplus_platform"."kes_logs_statistics" (
    "id" character varying(32 char) NOT NULL,
	"type" character varying(100 char) NULL,
	"stat_date" date NULL,
	"create_time" datetime NULL,
	"content" json NULL,
	"module_id" character varying(32 char) NULL,
	"app_id" character varying(32 char) NULL,
	CONSTRAINT "con_kes_plus_kes_logs_statistics_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kes_plus_kes_logs_statistics_constraint_3" UNIQUE (type, stat_date, module_id),
	CONSTRAINT "con_kes_plus_kes_logs_statistics_constraint_4" UNIQUE (type, stat_date, module_id, app_id)
);
CREATE INDEX inxex_kes_plus_kes_logs_statistics_index_1 ON "kesplus_platform".kes_logs_statistics USING btree (type);
CREATE INDEX inxex_kes_plus_kes_logs_statistics_index_2 ON "kesplus_platform".kes_logs_statistics USING btree (stat_date);
CREATE INDEX inxex_kes_plus_kes_logs_statistics_index_3 ON "kesplus_platform".kes_logs_statistics USING btree (create_time);
COMMENT ON TABLE "kesplus_platform"."kes_logs_statistics" IS '日志统计数据表';

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."type" IS '统计项分类';
COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."stat_date" IS '统计日期';
COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."content" IS '统计内容';
COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."module_id" IS '模块id';
COMMENT ON COLUMN "kesplus_platform"."kes_logs_statistics"."app_id" IS '应用id';