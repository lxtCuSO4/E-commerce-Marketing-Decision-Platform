-- "kesplus_platform"."kes_logs" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_logs";

CREATE TABLE "kesplus_platform"."kes_logs" (
	"id" character varying(32 char) NOT NULL,
	"request_content" text NULL,
	"request_header" text NULL,
	"response_content" text NULL,
	"ip" character varying(255 char) NULL,
	"create_time" date NULL,
	"elapsed_time" integer NULL,
	"url" character varying(255 char) NULL,
	"type" character varying(20 char) NULL,
	"system" character varying(255 char) NULL,
	"browser" character varying(255 char) NULL,
	"app_id" character varying(32 char) NULL,
	"module_id" character varying(32 char) NULL,
	"action" character varying(255 char) NULL,
	"name" character varying(50 char) NULL,
	"error" text NULL,
	"resquest_id" character varying(255 char) NULL,
	"app_code" character varying(100 char) NULL,
	"end_point" character varying(50 char) NULL,
	"user_id" character varying(32 char) NULL,
	"user_name" character varying(100 char) NULL,
	"api_path" character varying(1024 char) NULL,
	"api_type" character varying(128 char) NULL,
	"response_code" character varying(100 char) NULL,
	"module_code" character varying(32 char) NULL,
	CONSTRAINT "kes_logs_pkey" PRIMARY KEY (id)
);
CREATE INDEX inxex_kes_plus_kes_logs_index_2 ON "kesplus_platform".kes_logs USING btree (create_time);
CREATE INDEX inxex_kes_plus_kes_logs_index_3 ON "kesplus_platform".kes_logs USING btree (module_id);
CREATE INDEX inxex_kes_plus_kes_logs_index_4 ON "kesplus_platform".kes_logs USING btree (error);
CREATE INDEX inxex_kes_plus_kes_logs_index_5 ON "kesplus_platform".kes_logs USING btree (api_path);

-- Column comments

COMMENT ON COLUMN "kesplus_platform"."kes_logs"."request_content" IS '请求内容';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."request_header" IS '请求头';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."response_content" IS '响应内容';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."ip" IS '访问ip';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."elapsed_time" IS '耗时(毫秒)';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."type" IS '日志类型';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."system" IS '操作系统';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."browser" IS '浏览器';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."app_id" IS '应用ID';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."module_id" IS '模块ID';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."action" IS '请求类型';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."name" IS '标签名称';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."error" IS '是否错误';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."resquest_id" IS 'requestId';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."app_code" IS '应用code';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."end_point" IS '日志来源 KServer 或者 KES';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."user_id" IS '用户id';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."user_name" IS '用户名';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."api_path" IS 'api路径';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."api_type" IS 'app类型 app or platform';
COMMENT ON COLUMN "kesplus_platform"."kes_logs"."response_code" IS '响应code';