-- "kesplus_app"."kes_sys_datatype" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_sys_datatype";

CREATE TABLE "kesplus_app"."kes_sys_datatype" (
    "id" character varying(32 char) NOT NULL,
	"typeName" character varying(255 char), --类型名字
	"componentType" character varying(32 char) NULL, --组件类型
	"label" character varying(32 char) NULL DEFAULT 1, --标题
	"group" character varying(32 char) NULL, --分组
	"sortId" integer NULL DEFAULT 1, --排序
	"rule" varchar[], --路由策略
	"hasPrecision" boolean, -- 是否有精度
	"length" boolean, --长度
	"typval" character varying(32 char) NULL, --当前类型长度
	"minVal" integer NULL DEFAULT 0, --最小长度
	"maxVal" integer NULL DEFAULT 0, --最大长度
	"isCollatable" character varying(32 char) NULL, --是否是可排序的
	"del_flag" character varying(2 char), --删除标志,
	"create_time" date NULL, -- 创建时间
	"update_time" date NULL, -- 修改时间
	"delete_time" date NULL, -- 删除时间
	CONSTRAINT "kes_sys_datatype_pkey" PRIMARY KEY (id) --主键id
);

-- Column comments

COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."id" IS 'id主键';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."typeName" IS '类型名字';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."componentType" IS '组件类型';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."label" IS '标题';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."group" IS '分组';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."sortId" IS '排序';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."rule" IS '路由策略';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."hasPrecision" IS '是否有精度';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."length" IS '是否有长度';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."typval" IS '当前类型长度';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."minVal" IS '最小长度';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."maxVal" IS '最大长度';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."isCollatable" IS '是否是可排序的';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."del_flag" IS '删除标志';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."update_time" IS '修改时间';
COMMENT ON COLUMN "kesplus_app"."kes_sys_datatype"."delete_time" IS '删除时间';

INSERT INTO "kesplus_app".kes_sys_datatype VALUES (1,'\"char\"', 'InputNumber', '数字输入框', '输入', 1, ARRAY['/^[0-9]*$//^\\d+$/'], FALSE, FALSE, '', 0, 0, NULL, '0', current_date , current_date, current_date);
