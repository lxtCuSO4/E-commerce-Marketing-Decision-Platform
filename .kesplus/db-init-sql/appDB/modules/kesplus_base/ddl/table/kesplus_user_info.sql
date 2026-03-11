-- "kesplus_base"."kesplus_user_info" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_info";

CREATE TABLE "kesplus_base"."kesplus_user_info" (
	"id" character varying(32 char) NOT NULL,
	"nick_name" character varying(32 char) NULL,
	"avatar_path" character varying(255 char) NULL,
	"nation" character varying(255 char) NULL,
	"birthday" date NULL,
	"native_place" character varying(255 char) NULL,
	"entry_date" date NULL,
	"role_version" json NULL,
	"certificate_type" character varying(255 char) NULL,
	"certificate_number" character varying(255 char) NULL,
	"education" character varying(255 char) NULL,
	"urgent_phone" character varying(255 char) NULL,
	"address" character varying(255 char) NULL,
	"create_by" character varying(255 char) NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(255 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"remark" character varying(500 char) NULL,
	"expansion" jsonb NULL,
	"job_level" integer NULL DEFAULT 7,
	CONSTRAINT "pk_base_user_info" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."nick_name" IS '用户昵称';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."avatar_path" IS '头像文件路径';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."nation" IS '国家';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."birthday" IS '生日';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."native_place" IS '籍贯';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."entry_date" IS '加入时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."education" IS '教育程度';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."urgent_phone" IS '紧急联系人';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."address" IS '地址';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."expansion" IS '其它信息';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."job_level" IS '职务级别';