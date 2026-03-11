INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num") VALUES
	 ('95eb669fca0b4ec99ab1b421bfe7d672','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_serial_numbers','system','kesplus_base','CREATE TABLE "kesplus_base"."kesplus_serial_numbers"(
"id" varchar (32)  NOT NULL ,
"module_code" varchar (50)  NOT NULL ,
"dept_id" varchar (32)  NOT NULL ,
"name" varchar (32)  NULL ,
"code" varchar (32)  NULL ,
CONSTRAINT "kesplus_serial_numbers_id_pk" PRIMARY KEY (id) ENABLE VALIDATE ,
CONSTRAINT "uk_base_serial_numbers_code" UNIQUE (code)
)  ;

COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."id" IS ''id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."module_code" IS ''模块代码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."dept_id" IS ''部门ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."name" IS ''流水号模板名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_serial_numbers"."code" IS ''编码，用于参数传递'';



',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_serial_numbers", "check": [], "label": "流水号信息", "indexs": [{"name": "kesplus_serial_numbers_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [{"name": "uk_base_serial_numbers_code", "columns": ["code"], "deferred": false, "validate": false, "deferrable": false, "operationEnum": 1}], "columns": [{"id": "916ed126d1334d9f98a24ea2c4f0b569", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "1b41669b2589463692918b9ac6c51463", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "7422c08077824f6fb1386b244223ae22", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}, {"id": "6b81d3222aa340afa072d44727297cb6", "name": "name", "label": "", "serial": false, "comment": "流水号模板名称", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "4fd52c11bff24268a30309b4b2abcbfd", "name": "code", "label": "", "serial": false, "comment": "编码，用于参数传递", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}], "primary": {"name": "kesplus_serial_numbers_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}','流水号信息',NULL,'${currentUserId}','obj',0,1),
	 ('a74743fe1d144ed7b2c7d1e0bf852197','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_menu','system','kesplus_base','-- "kesplus_base"."kesplus_base_menu" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_base_menu";

CREATE TABLE "kesplus_base"."kesplus_base_menu" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NULL,
	"title" character varying(32 char) NULL,
	"icon" character varying(32 char) NULL,
	"classify" smallint NULL DEFAULT 0,
	"url" character varying(255 char) NULL,
	"outer_link" boolean NULL DEFAULT false,
	"component" character varying(255 char) NULL,
	"hidden_flag" boolean NULL DEFAULT false,
	"enabled" smallint NOT NULL DEFAULT 1,
	"params" json NULL,
	"properties" json NULL,
	"create_by" character varying(32 char)  NULL,
	"create_time" timestamp(0) without time zone  NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"tenant_id" character varying(32 char)  NULL DEFAULT 0,
	"module_id" character varying(32 char)  NULL,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	"parent_id" character varying(32 char) NULL,
	"sort_num" integer NULL,
	"obj_type" character varying(8 char) NULL,
	CONSTRAINT "pk_base_menu" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."code" IS ''编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."title" IS ''菜单名'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."icon" IS ''图标'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."classify" IS ''分类：0-菜单（有链接）；1-按钮（操作、无连接）'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."url" IS ''访问路径'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."outer_link" IS ''是否外部链接'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."component" IS ''组件，非外部链接时不能为空'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."hidden_flag" IS ''菜单是否隐藏，即，若为true，则为菜单，否则为菜单式按钮'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."enabled" IS ''状态 0-保存；1-启用；2-停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."params" IS ''菜单参数'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."properties" IS ''按钮属性'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."tenant_id" IS ''租户ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."module_id" IS ''模块id，外键，关联kesplus_module表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."dept_id" IS ''记录数据所属部门'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_menu"."obj_type" IS ''0-目录；1-菜单'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_menu", "check": [], "indexs": [{"name": "kesplus_base_menu_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "3864a1ee506042e3aac08e23c88d1aae", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "8846e3f41cdb49c1a70070dd1014047d", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "6806982143e9431aa6df644bba7831cb", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_menu_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,2),
	 ('9965ca3f67404b54a4efd7b8dae4d09d','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_permission','system','kesplus_base','-- "kesplus_permission" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_permission";

CREATE TABLE "kesplus_base"."kesplus_base_permission" (
	"id" character varying(32 char) NOT NULL,
	"module_code" character varying(50 char)  NULL,
	"dept_id" character varying(32 char) NULL,
	"name" character varying(100 char) NULL,
	"code" character varying(100 char) NULL,
	"obj_type" character varying(10 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"status" character varying(1 char) NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" varchar NULL,
	"module_id" varchar NULL,
	"remark" character varying(200 char) NULL,
    "sort_num" integer NULL,
	CONSTRAINT "kesplus_base_permission_id_pk" PRIMARY KEY (id)
);

COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."name" IS ''权限点名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."code" IS ''权限点编码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."obj_type" IS ''权限点类型：obj=权限点；dir=权限点目录'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."parent_id" IS ''上级权限点分类ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."status" IS ''启用状态：1=启用；0=停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."remark" IS ''备注描述'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."create_by" IS ''创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."create_time" IS ''创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."update_by" IS ''更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."update_time" IS ''更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."module_code" IS ''模块编码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_permission"."module_id" IS ''模块Id'';
',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_permission", "check": [], "indexs": [{"name": "kesplus_base_permission_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "f17283fb613049759e6ede765ea44286", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "dc44b999df5e4fe6a3cfaaa007ae354b", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "9da42edd0b50499085fec165730449d2", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_permission_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,3),
	 ('ededb39577d64e5fa125bfb5b1875d46','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_policy','system','kesplus_base','-- "kesplus_base"."kesplus_module_policy" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_module_policy";

CREATE TABLE "kesplus_base"."kesplus_base_policy" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NULL,
	"name" character varying(64 char) NOT NULL,
	"db_role_code" character varying(128 char) NULL,
	"description" character varying(255 char) NULL,
	"enabled" smallint NULL DEFAULT 1,
	"params" jsonb NULL,
	"tables" jsonb NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NOT NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"version_id" character varying(32 char) NULL,
	"parent_id" character varying(32 char) NULL,
	"obj_type" character varying(8 char) NULL,
	"sort_num" integer NULL,
	CONSTRAINT "pk_kesplus_base_policy" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_policy", "check": [], "indexs": [{"name": "kesplus_base_policy_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "46e9c6f91cb54dca81a2827cedd58d61", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "afb25d6405ca4bc5b670f584ea1ca671", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "695f1401be164dcbb91646751b758fbe", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_policy_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,4),
	 ('2ef16a0e85de445883252e5ef1feb457','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_policy_db','system','kesplus_base','-- "kesplus_base"."kesplus_base_policy_db" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_base_policy_db";

CREATE TABLE "kesplus_base"."kesplus_base_policy_db" (
	"id" character varying(32 char) NOT NULL,
	"db_role_code" character varying(128 char) NOT NULL,
	"schema_name" character varying(64 char) NOT NULL,
	"table_name" character varying(64 char) NOT NULL,
	"policy_id" character varying(32 char) NOT NULL,
	"policy_name" character varying(64 char) NULL DEFAULT 0,
	"auth_type" character varying(8 char) NOT NULL,
	"column_flag" boolean NOT NULL DEFAULT false,
	"table_columns" json NOT NULL DEFAULT ''[]''::json,
	"create_policy" text NOT NULL,
	"drop_policy" text NOT NULL,
	"grant_auth" text NULL,
	"revoke_auth" text NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_policy_db" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."db_role_code" IS ''数据库角色名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."schema_name" IS ''模式名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."table_name" IS ''表名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."policy_id" IS ''策略实例id，关联kesplus_base_policy_db_instance表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."policy_name" IS ''策略名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."auth_type" IS ''二进制标识高到低分别表示增删改查'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."column_flag" IS ''是否对应列权限'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."table_columns" IS ''列权限对应字段'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."create_policy" IS ''创建policy sql'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."grant_auth" IS ''授权sql'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."dept_id" IS ''记录数据所属部门'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."module_id" IS ''模块id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_policy_db"."tenant_id" IS ''租户id'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_policy_db", "check": [], "indexs": [{"name": "kesplus_base_policy_db_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "eb6f51768bf64f408b1b67a2b554de47", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "758e0da558374eb3a02be8b93e18d046", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "8f159cf30b014923924b6389b679ea47", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_policy_db_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,5),
	 ('be30dccc8f39456588c5a5cd7c6c7efb','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_role','system','kesplus_base','-- "kesplus_base"."kesplus_base_role" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_base_role";

CREATE TABLE "kesplus_base"."kesplus_base_role" (
	"id" character varying(32 char) NULL,
	"name" character varying(255 char) NULL,
	"code" character varying(50 char) NULL,
	"description" character varying(255 char) NULL,
	"global_flag" boolean NULL DEFAULT false,
	"role_level" smallint NULL DEFAULT ''-1''::integer,
	"data_scope" varchar NULL,
	"classify" smallint NULL DEFAULT 2,
	"role_type" smallint NULL DEFAULT 2,
	"hidden_flag" boolean NULL DEFAULT false,
	"db_role_code" character varying(128 char) NULL,
	"enabled" smallint NULL DEFAULT 0,
	"create_by" character varying(255 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(255 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char)  NULL DEFAULT 0,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
    "obj_type" character varying(10 char) NULL,
    "parent_id" character varying(32 char) NULL,
    "sort_num" int NULL,
	CONSTRAINT "pk_base_role" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."name" IS ''角色名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."code" IS ''角色编码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."description" IS ''详细描述'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."role_level" IS ''1-平台，2-租户；3-级联部门'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."classify" IS ''0-匿名角色，1-公共角色；2-普通角色'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."role_type" IS ''角色类型：0-内置角色；1-系统角色；2-自定义角色'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."hidden_flag" IS ''隐藏标识'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."db_role_code" IS ''数据库内角色编号，自动生成，不能编辑'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."enabled" IS ''0-保存；1-启用；2-停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."create_by" IS ''创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."create_time" IS ''创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."update_by" IS ''更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."update_time" IS ''更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."tenant_id" IS ''租户ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role"."module_id" IS ''模块Id'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_role", "check": [], "label": "kesplus_base_role", "indexs": [{"name": "kesplus_base_role_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "9630054d592a4846a3d2fcf5f75b6441", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "aa734c9e98114c9296dcd324bc9b2aa9", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "809cf39fb5ce45c2b4fcb060b3e81d10", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_role_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}','kesplus_base_role',NULL,'${currentUserId}','obj',0,15),
	 ('07c30ad0bdbe45b990556c4e49dbea8a','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_role_permission','system','kesplus_base','CREATE TABLE "kesplus_base"."kesplus_base_role_permission" (
	"id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"permission_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) not NULL,
	CONSTRAINT "pk_kesplus_base_role_permission" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."role_id" IS ''角色id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."permission_id" IS ''权限地id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_permission"."dept_id" IS ''记录数据所属部门'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_role_permission", "check": [], "indexs": [{"name": "kesplus_base_role_permission_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "2d2a688ec65f4f1c96e17ad83acad2c0", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "f9bf71228df24aca884d5f3142ee7568", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "5d8640fba90942eb936d4a6f338e2f70", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_role_permission_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,6),
	 ('41fc01ac37a34e09949ee82b7221bdb1','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_base_role_policy','system','kesplus_base','-- "kesplus_base"."kesplus_base_role_policy" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_base_role_policy";

CREATE TABLE "kesplus_base"."kesplus_base_role_policy" (
	"id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"policy_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_role_policy" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."role_id" IS ''角色id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."policy_id" IS ''策略实例id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_policy"."dept_id" IS ''记录数据所属部门'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_role_policy", "check": [], "indexs": [{"name": "kesplus_base_role_policy_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "8ef95433d1c64b9386eb979847bf9c2a", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "432821336d3949b9a9ffdb6cefb181b1", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "8a8b0e6d594e4a1cbf90288f4b7cf726", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_role_policy_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,7),
	 ('d7c5af088c43431a9396a32d36ca4ffa','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_dept','system','kesplus_base','-- "kesplus_base"."kesplus_dept" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_dept";

CREATE TABLE "kesplus_base"."kesplus_dept" (
	"id" character varying(32 char) NOT NULL,
	"dept_code" character varying(32 char) NOT NULL,
	"dept_name" character varying(128 char) NOT NULL,
	"dept_short_name" character varying(32 char) NULL,
	"dept_common_name" character varying(32 char) NULL,
	"dept_former_name" character varying(32 char) NULL,
	"dept_type" smallint NULL DEFAULT 0,
	"classify" character varying(32 char) NULL,
	"manager_user_id" character varying(32 char) NULL,
	"dept_position" character varying(32 char) NULL,
	"dept_responsibility" character varying(255 char) NULL,
	"contract_user_id" character varying(32 char) NULL,
	"company_id" character varying(32 char) NULL DEFAULT 0,
	"enabled" smallint NULL DEFAULT 0,
	"pid" character varying(32 char) NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"expanded_manager_keys" character varying(255 char) NULL,
	"tree_sort" integer NULL,
	"tree_level" integer NULL,
	"tree_path" text NULL,
	CONSTRAINT "pk_base_dept" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_code" IS ''部门编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_name" IS ''部门名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_short_name" IS ''部门简称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_type" IS ''部门类型：0-公司；1-部门'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."enabled" IS ''状态 0-保存；1-启用；2-停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."pid" IS ''当前部门的上级部门id,1级部门的上级id为0'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."dept_id" IS ''记录数据所属部门'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tenant_id" IS ''租户id，外键，关联kes_app_tenant表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."expanded_manager_keys" IS ''主管领导回显部门id集合'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_sort" IS ''排序'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_level" IS ''层级'';
COMMENT ON COLUMN "kesplus_base"."kesplus_dept"."tree_path" IS ''路径'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_dept", "check": [], "indexs": [{"name": "kesplus_dept_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "f14ac13d0bbc430c9b40ed11eb36afe8", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "9f17fbef604b47a6aa002942ac413883", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "489d65c36f8341a09b90225b326556ed", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_dept_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,8),
	 ('cf872b9544d54ceb8c86a810ea7f2b4b','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_dictionary','system','kesplus_base','-- "kesplus_base"."kesplus_dictionary" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_dictionary";

CREATE TABLE "kesplus_base"."kesplus_dictionary" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NOT NULL,
	"dictionary_id" character varying(32 char) NOT NULL,
	"name" character varying(100 char) NOT NULL,
	"description" character varying(255 char) NULL,
	"val" character varying(255 char) NULL,
	"full_path" character varying(255 char) NOT NULL,
	"sub_count" smallint NULL DEFAULT 0,
	"pid" character varying(32 char) NOT NULL DEFAULT ''0''::varchar,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	"sort" integer NULL DEFAULT 0,
	"dictionary_level" integer NULL DEFAULT 0,
	"filters" json NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"val_type" character varying(8 char) NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_dictionary" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_dictionary", "check": [], "indexs": [{"name": "kesplus_dictionary_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "efd79f7898294d11be0597704dc9b52f", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "7f4a830c83af47d588d51f1f642666d8", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "8ad70bf2d26243598a7d020b0f77e48e", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_dictionary_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,9),
	 ('8a580aebd42f45db86f271b0f8daa8c4','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_job','system','kesplus_base','-- "kesplus_base"."kesplus_job" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_job";

CREATE TABLE "kesplus_base"."kesplus_job" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(32 char) NOT NULL,
	"job_level" character varying(32 char) NULL,
	"job_type" character varying(32 char) NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char)  NULL DEFAULT 0,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	"job_index" integer NULL,
	"description" character varying(2000 char) NULL,
	CONSTRAINT "pk_base_job" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_job"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."name" IS ''岗位名'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."code" IS ''岗位编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."job_level" IS ''岗位级别'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."job_type" IS ''岗位分类'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."enabled" IS ''0-保存；1-启用；2-停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."create_by" IS ''创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."create_time" IS ''创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."update_by" IS ''更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."update_time" IS ''更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."tenant_id" IS ''租户id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."dept_id" IS ''创建人部门id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_job"."description" IS ''岗位说明'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_job", "check": [], "indexs": [{"name": "kesplus_job_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "4f249de97e544e489ad1e51accc22c44", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "3997d4c5cd754674a244338c53009f57", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "5229933ee6824831b6aa38b3c2bb5462", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_job_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,10);
INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num") VALUES
	 ('18cee052affa4327b02b0e0848688a0c','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_kwr_report','system','kesplus_base','-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_kwr_report";

CREATE TABLE "kesplus_base"."kesplus_kwr_report" (
	"id" character varying(32 char) NOT NULL,
	"snap_id_begin" character varying(64 char) NOT NULL,
	"snap_id_end" character varying(64 char) NOT NULL,
	"start_time" timestamp(0) without time zone NOT NULL,
	"end_time" timestamp(0) without time zone NULL,
	"status" SMALLINT NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_kwr_report" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_kwr_report", "check": [], "indexs": [{"name": "kesplus_kwr_report_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "2538dbce398d4e3d947e120502f7be38", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "7b70adfeeee5432e80bf00c7d264bbb1", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "776b211d26894582971a227f9a50e140", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_kwr_report_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,11),
	 ('7dbc9cabe3ab44369b1b9b9c2b1a3a36','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_kwr_snapshot','system','kesplus_base','-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_kwr_snapshot";

CREATE TABLE "kesplus_base"."kesplus_kwr_snapshot" (
	"id" character varying(32 char) NOT NULL,
	"snap_id" character varying(64 char) NOT NULL,
	"snap_time" timestamp(0) without time zone NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_kwr_snapshot" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_kwr_snapshot", "check": [], "indexs": [{"name": "kesplus_kwr_snapshot_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "9e7ee49576be4ee48798b82c0f21cc4a", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "494cd477d0004094983deef70beeb145", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "df82a9b26c2d4daab9597150bfc9144c", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_kwr_snapshot_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,12),
	 ('196a8a860702436c94ec76c191056edd','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_query_execution','system','kesplus_base','-- "kesplus_base"."kesplus_query_execution" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_base"."kesplus_query_execution";

CREATE TABLE "kesplus_base"."kesplus_query_execution" (
	"snapshot_id" character varying(32 char) NOT NULL,
	"queryid" bigint NULL DEFAULT 0,
	"api_id" varchar(32) NULL DEFAULT 0,
	"parent_queryid" bigint NULL DEFAULT 0,
	"execute_times" integer NULL DEFAULT 0,
	"total_time" double precision NULL DEFAULT 0,
	"query" text NOT NULL
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_query_execution", "check": [], "indexs": [{"name": "kesplus_query_execution_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "2073535b53ab4040827076f8f11b55f0", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "19a68907a5e84fdf8b7a4d69d7175d98", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "3d89dac8696748a09d6116794279be7e", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_query_execution_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,13),
	 ('e4f7a7e6833e4df0be45126b746fa0fe','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_schedule','system','kesplus_base','-- "kesplus_base"."kesplus_schedule" definition

-- Drop table

-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_schedule";

CREATE TABLE "kesplus_base"."kesplus_schedule" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(32 char) NOT NULL,
	"cron" character varying(16 char) NOT NULL,
	"handle_service" character varying(64 char) NOT NULL,
	"schedule_service" character varying(64 char) NOT NULL,
	"unique_key" character varying(64 char) NOT NULL,
	"params" character varying(255 char) NULL,
	"app_code" character varying(64 char) NOT NULL,
	"is_single" smallint NOT NULL DEFAULT 1,
	"interval_second" bigint NOT NULL,
	"current_job_id" character varying(32 char) NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_schedule" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_schedule", "check": [], "indexs": [{"name": "kesplus_schedule_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "ace9c0607943440eb9240722cc1bbb80", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "b7c447ff76144505a0a2f057cdc4110a", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "ac3a5b2ffac14884b12a31442470e829", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_schedule_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,14),
	 ('8147906f1cf5434fa1112d21876641a2','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_schedule_job','system','kesplus_base','-- "kesplus_base"."kesplus_schedule_job" definition

-- Drop table

-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_schedule_job";

CREATE TABLE "kesplus_base"."kesplus_schedule_job" (
	"id" character varying(32 char) NOT NULL,
	"schedule_id" character varying(32 char) NOT NULL,
	"consume_millis" character varying(64 char) NOT NULL,
	"start_time" date NOT NULL,
	"finish_time" date NULL,
	"status" integer NULL DEFAULT 0,
	CONSTRAINT "pk_app_schedule_job" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_schedule_job", "check": [], "indexs": [{"name": "kesplus_schedule_job_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "72b54fc7b53141af82b10541d70b6736", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "f8a935fa0a4b44f99a640c0bc63d51c1", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "1e0ee4b412ad4dc4a353f56587cb3c3e", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_schedule_job_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,15),
	 ('8ddff619a5254cb0acf303c35cea6a57','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_snapshot','system','kesplus_base','-- DROP TABLE IF EXISTS "kesplus_base"."kesplus_kwr_snapshot";

CREATE TABLE "kesplus_base"."kesplus_kwr_snapshot" (
	"id" character varying(32 char) NOT NULL,
	"snap_id" character varying(64 char) NOT NULL,
	"snap_time" timestamp(0) without time zone NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" timestamp(0) without time zone NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_app_kwr_snapshot" PRIMARY KEY (id)
);',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_snapshot", "check": [], "indexs": [{"name": "kesplus_snapshot_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "d9c7362e16fb4ad29bdcc2691f00502b", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "3435f760372c4c90a3e36a4d20445945", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "7b563257bbae47b9aa45089ed6fe193b", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_snapshot_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,16),
	 ('a6302fab5209444fbac3aa4a63487a0d','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_sso_config','system','kesplus_base','-- "kesplus_base"."kesplus_sso_config" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_sso_config";

CREATE TABLE "kesplus_base"."kesplus_sso_config" (
	"id" character varying(32 char) NOT NULL,
	"name" character varying(255 char) NOT NULL,
	"code" character varying(50 char) NULL,
	"enabled" smallint NULL DEFAULT 0,
	"schema_name" character varying(64 char) NULL,
	"pkg_name" character varying(64 char) NULL,
	"func_name" character varying(64 char) NOT NULL,
	"type" smallint NULL DEFAULT 0,
	"sso_index" character varying(255 char) NULL,
	"private_key" text NULL,
	"public_key" text NULL,
	"remark" character varying(255 char) NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"create_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_sso_config" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."name" IS ''对接平台名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."code" IS ''对接平台编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."enabled" IS ''1生效；2停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."schema_name" IS ''模式名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."pkg_name" IS ''包名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."func_name" IS ''函数名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."type" IS ''0：本平台为服务端，此记录为解密配置；1-本平台为客户端，此记录为生成token配置'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."sso_index" IS ''type为1时有效，对接方单点登录地址'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."remark" IS ''备注'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."create_by" IS ''创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."update_by" IS ''更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."update_time" IS ''更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_config"."create_time" IS ''创建时间'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_sso_config", "check": [], "indexs": [{"name": "kesplus_sso_config_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "74404f5b24c24527a1bd17b0cb903f5d", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "bf5d4037224346019f72644911c81481", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "b5cd481d682943c39068ba835f156b0d", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_sso_config_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,17),
	 ('043d368b10a24165a3ce1f0341c71d56','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_sso_restful','system','kesplus_base','-- "kesplus_base"."kesplus_sso_restful" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_sso_restful";

CREATE TABLE "kesplus_base"."kesplus_sso_restful" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(50 char) NOT NULL,
	"enabled" smallint NULL DEFAULT 0,
	"restful_id" character varying(64 char) NOT NULL,
	"remark" character varying(255 char) NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"create_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_sso_restful" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."id" IS ''主键'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."code" IS ''对接平台编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."enabled" IS ''1生效；0停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."restful_id" IS ''restfulid'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."remark" IS ''备注'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."create_by" IS ''创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."update_by" IS ''更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."update_time" IS ''更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_sso_restful"."create_time" IS ''创建时间'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_sso_restful", "check": [], "indexs": [{"name": "kesplus_sso_restful_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "af197a464fce4eff9188fbbd9e968fcd", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "4ed85a7b59e84464bf3eb7557aee62e1", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "5193d2c33f084e2fbf64f375c1843f0b", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_sso_restful_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,18),
	 ('ff65ecad699e40888e11df7041a7183c','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_tenant','system','kesplus_base','-- "kesplus_base"."kesplus_tenant" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_tenant";

CREATE TABLE "kesplus_base"."kesplus_tenant" (
	"id" character varying(32 char) NOT NULL,
	"tenant_name" character varying(128 char) NOT NULL,
	"tenant_code" character varying(32 char) NOT NULL,
	"enable" smallint NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NOT NULL,
	CONSTRAINT "pk_base_tenant" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."tenant_name" IS ''租户名称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."tenant_code" IS ''租户编号'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."enable" IS ''状态 0-保存；1-启用；2-停用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_tenant"."dept_id" IS ''记录数据所属部门'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_tenant", "check": [], "indexs": [{"name": "kesplus_tenant_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "cadccee990be41f5916d84e90592626e", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "9477f4750e0248b9a4d433460de50083", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "902baa2f31ad4b9fb618fe8fac8cfb6f", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_tenant_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,19),
	 ('db62018cbee24e2192f0ca7b718975fb','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_user','system','kesplus_base','-- "kesplus_base"."kesplus_user" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user";

CREATE TABLE "kesplus_base"."kesplus_user" (
	"id" character varying(32 char) NOT NULL,
	"username" character varying(32 char) NOT NULL,
	"password" character varying(255 char) NOT NULL,
	"real_name" character varying(30 char) NULL,
	"phone" character varying(20 char) NULL,
	"user_code" character varying(32 char) NULL,
	"gender" character varying(2 char) NULL,
	"email" character varying(255 char) NULL,
	"pwd_reset_time" date NULL,
	"user_type" smallint NULL DEFAULT 1,
	"user_sort" integer NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"is_admin" boolean NULL DEFAULT false,
	"is_vip" boolean NULL DEFAULT false,
	"create_by" character varying(255 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(255 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"last_login" date NULL,
	"login_lock" smallint NULL DEFAULT 0,
	"login_lock_time" date NULL,
	"user_source" integer NULL DEFAULT 0,
	"manager_user_id" character varying(32 char) NULL,
	"expanded_manager_keys" character varying(255 char) NULL,
	"extended_info" json NULL,
	CONSTRAINT "pk_base_user" PRIMARY KEY (id),
	CONSTRAINT "uk_base_user_uname" UNIQUE (username)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."username" IS ''用户名'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."password" IS ''密码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."real_name" IS ''用户姓名'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."phone" IS ''电话'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."email" IS ''邮箱'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."pwd_reset_time" IS ''密码重置时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_type" IS ''用户类型 0系统用户，1 应用用户'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_sort" IS ''排序'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."enabled" IS ''启用禁用'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."user_source" IS ''默认0;ldap同步 1'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."manager_user_id" IS ''主管领导'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user"."expanded_manager_keys" IS ''主管领导回显部门id集合'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_user", "check": [], "indexs": [{"name": "kesplus_user_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "cc85cb2e5c4a4748b9d825733626d661", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "846aa213dcd54100b7f7fcdc1244a7b6", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "3bd51ac7bd5d4a7990d78f17ae1c29e6", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_user_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,20);
INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num") VALUES
	 ('f546b66c82ea43058f2cc828068dae49','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_user_dept','system','kesplus_base','-- "kesplus_base"."kesplus_user_dept" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_dept";

CREATE TABLE "kesplus_base"."kesplus_user_dept" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"current_dept_id" character varying(32 char) NOT NULL,
	"default_flag" boolean NOT NULL DEFAULT true,
	"login_flag" boolean NOT NULL DEFAULT false,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "con_t_app_user_dept_constraint_userid_deptid" UNIQUE (user_id, current_dept_id),
	CONSTRAINT "pk_base_user_dept" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."user_id" IS ''用户id，外键，关联kes_app_user表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."current_dept_id" IS ''部门id，外键，关联kes_app_dept表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."default_flag" IS ''是否主要关联，单个人可能关联多个部门，但有且只有一个主要关联'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_dept"."dept_id" IS ''记录数据所属部门'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_user_dept", "check": [], "indexs": [{"name": "kesplus_user_dept_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "d789e3c864d1416396c62760bbcb9e30", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "b4521cadf96a408dbe5b113b259ac2aa", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "a092d667ef614981b889401ffad288e6", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_user_dept_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,21),
	 ('301a8b02fb0740aaa2884d60528be508','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_user_info','system','kesplus_base','-- "kesplus_base"."kesplus_user_info" definition

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
	"dept_id" character varying(32 char) NULL default 0,
	"remark" character varying(500 char) NULL,
	CONSTRAINT "pk_base_user_info" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."nick_name" IS ''用户昵称'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."avatar_path" IS ''头像文件路径'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."nation" IS ''国家'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."birthday" IS ''生日'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."native_place" IS ''籍贯'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."entry_date" IS ''加入时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."education" IS ''教育程度'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."urgent_phone" IS ''紧急联系人'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_info"."address" IS ''地址'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_user_info", "check": [], "indexs": [{"name": "kesplus_user_info_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "f9d263addd1e49f383c4e675e309d457", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "ac00400d61614a46b8d3f403d60040bc", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "a1f400556bf2485d9adfb48fbdb5b858", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_user_info_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,22),
	 ('ad0b106773e341c5b70b3c95a587f014','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_user_job','system','kesplus_base','-- "kesplus_base"."kesplus_user_job" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_job";

CREATE TABLE "kesplus_base"."kesplus_user_job" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NOT NULL,
	"job_id" character varying(32 char) NOT NULL,
	"current_dept_id" character varying(32 char) NULL DEFAULT 0,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char)  NULL DEFAULT 0,
	CONSTRAINT "pk_base_user_job" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."id" IS ''主键ID'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."user_id" IS ''用户id，外键，关联kes_app_user表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."job_id" IS ''岗位id，外键，关联kes_app_job表'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."create_by" IS ''记录创建人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."create_time" IS ''记录创建时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."update_by" IS ''记录更新人id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."update_time" IS ''记录更新时间'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_job"."dept_id" IS ''记录数据所属部门'';',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_user_job", "check": [], "indexs": [{"name": "kesplus_user_job_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "9b723d8326594885912036a46c41ff22", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "8c17db69dc0345fa808e17f0561dd92c", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "0faab2dd90314783b711ce14a52fce5e", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_user_job_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,23),
	 ('629351882b6e4703922c29103c4db810','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_user_role','system','kesplus_base','CREATE TABLE "kesplus_base"."kesplus_user_role"(
"id" varchar (32)  NOT NULL ,
"module_code" varchar (50)  NOT NULL ,
"dept_id" varchar (32)  NOT NULL ,
CONSTRAINT "kesplus_user_role_id_pk" PRIMARY KEY (id) ENABLE VALIDATE
)  ;

COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."id" IS ''id'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."module_code" IS ''模块代码'';
COMMENT ON COLUMN "kesplus_base"."kesplus_user_role"."dept_id" IS ''部门ID'';



',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_user_role", "check": [], "indexs": [{"name": "kesplus_user_role_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "indexpos": 0, "columnpos": 0, "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "clustered": false, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "56b958c212ba46fbba2faadb1a5b5209", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "cb2046d46c1543aab40a99659ae9b610", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "7aba6399396147298347a9667c4ca5fe", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "operationObj": {"status": 1, "initvalue": {"serial": false, "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_user_role_id_pk", "columns": ["id"], "comment": "默认ID主键", "deferred": false, "deferrable": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "tableSpace": "sys_default", "constraints": false, "hasForceRowSec": false}',NULL,NULL,'${currentUserId}','obj',0,24),
	 ('4804698a7ad4411da99b62ba08f8add6','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_v_dept','system','kesplus_base','-- "kesplus_base"."kesplus_v_dept" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_dept"
AS SELECT kad.id,
    kad.dept_name AS name,
    kad.dept_code AS code,
    kad.pid,
    kad.tree_sort AS treeSort,
    kad.tree_path AS treePath,
    kad.tree_level AS treeLevel,
    kad.enabled AS status,
    kad.dept_code AS deptCode,
    kad.dept_name AS deptName,
    kad.dept_short_name AS deptShortName,
    kad.dept_common_name AS deptCommonName,
    kad.dept_former_name AS deptFormerName,
    kad.dept_type AS deptType,
    kad.classify,
    kad.manager_user_id AS managerUserId,
    kau.real_name AS manager,
    kau.phone AS managerPhone,
    kau.email AS managerEmail,
    kad.dept_position AS deptPosition,
    kad.contract_user_id AS contractUserId,
    kau0.real_name AS contractPersion,
    kau0.phone AS contractPhone,
    kau0.email AS contractEmail,
    kad.dept_responsibility AS deptResponsibility,
    kad.company_id AS companyId,
    kac.dept_name AS companyName,
    kap.dept_name AS parentName,
    kad.enabled,
    NVL(duc.userCount, int8(0)) AS userCount
   FROM kesplus_base.kesplus_dept kad
     LEFT JOIN kesplus_base.kesplus_user kau ON kad.manager_user_id::text = kau.id::text
     LEFT JOIN kesplus_base.kesplus_user kau0 ON kad.contract_user_id::text = kau0.id::text
     LEFT JOIN kesplus_base.kesplus_dept kap ON kad.pid::text = kap.id::text
     LEFT JOIN kesplus_base.kesplus_dept kac ON kad.company_id::text = kac.id::text
     LEFT JOIN ( SELECT kt.id AS deptId,
            count(kt.id) AS userCount
           FROM kesplus_base.kesplus_dept kt
             JOIN kesplus_base.kesplus_dept kt0 ON regexp_like(kt0.tree_path, ''^''::text || kt.tree_path)
             JOIN kesplus_base.kesplus_user_dept kaud ON kaud.current_dept_id::text = kt0.id::text
          GROUP BY kt.id) duc ON kad.id::text = duc.deptId::text;',SYSDATE,SYSDATE,'2',5,'view',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'${currentUserId}','obj',0,1),
	 ('ca414c600c9f4071905b68b0e16ef711','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_v_menu','system','kesplus_base','-- "kesplus_base"."kesplus_v_menu" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_menu"
AS SELECT kam.id,
    kam.parent_id AS parentId,
    kam.title AS name,
    kamm.title AS parentName,
    kam.code,
    kam.icon,
    NVL(int4(kam.enabled), 1) AS enabled,
    kam.hidden_flag AS hiddenFlag,
    kam.outer_link AS outerLink,
    kam.classify,
    kam.tenant_id AS tenantId,
    kam.component,
    kam.url,
    kam.module_id AS moduleId,
    kam.obj_type AS objType,
    kk.module_code AS moduleCode,
    kk.module_path AS modulePath,
    kk.sort AS moduleSort,
    NVL(kk.sort, 1) * -1000 + nvl(kam."sort_num", 1) AS "sortNum"
   FROM kesplus_base.kesplus_base_menu kam
     JOIN kesplus_app.kesplus_module kk ON kam.module_id::text = kk.id::text
     LEFT JOIN kesplus_base.kesplus_base_menu kamm ON kam.parent_id::text = kamm.id::text;',SYSDATE,SYSDATE,'2',5,'view',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'${currentUserId}','obj',0,2),
	 ('6677b12545d84ff595c703df440caf71','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_v_role_restful','system','kesplus_base','CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_role_restful"
AS
SELECT kbp."role_id", ksrp."permission_id", ksrp."restful_id"
FROM "kesplus_base"."kesplus_base_role_permission" kbp
JOIN "kesplus_app"."kesplus_sys_restful_permission" ksrp ON kbp."permission_id" = ksrp."permission_id"',SYSDATE,SYSDATE,'2',5,'view',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'${currentUserId}','obj',0,3),
	 ('9f56e9f1b4aa4ea9a5c3371c106d3a69','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kesplus_v_user_role','system','kesplus_base','-- "kesplus_base"."kesplus_v_user_role" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_user_role"
AS
 SELECT kar.id,
    kar.name,
    kar.enabled,
    kar.code,
    kar.role_type AS roleType,
    kar.db_role_code AS dbRoleCode,
    kar.role_level AS roleLevel,
    kar.data_scope AS dataScope,
    kar.classify,
    kaur.user_id AS userId,
    kaur.current_dept_id AS deptId,
    COALESCE(kao.tenant_id, ''0''::varchar) AS tenantId
   FROM kesplus_base.kesplus_base_role kar
     JOIN kesplus_base.kesplus_user_role kaur ON kaur.role_id::text = kar.id::text
     LEFT JOIN kesplus_base.kesplus_dept kao ON kao.id::text = kaur.current_dept_id::text AND kao.enabled = 1
  WHERE kar.enabled = 1 AND kar.classify = 2;',SYSDATE,SYSDATE,'2',5,'view',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'${currentUserId}','obj',0,4);


  INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num") VALUES

  	 ('e62e1d9bdf514b679b84c79b58512e73','dfb8894291c34ac28e3458bba277e0ff','${appId}','${tenantId}','kes_app_selector_relation','system','kesplus_base','CREATE TABLE kesplus_base."kes_app_selector_relation" (
  	"id" character varying(32) NOT NULL,
  	"title" character varying(255) NOT NULL,
  	"key" character varying(32) NOT NULL,
  	"type" character varying(8) NULL,
  	"isLeaf" boolean DEFAULT true NOT NULL,
  	"pid" character varying(32) DEFAULT ''0''::varchar NOT NULL,
  	"sort" integer DEFAULT 1 NULL,
  	"anonymous_block" text NULL,
  	"desc" text NULL,
  	"tree_path" character varying(512) NULL,
  	"create_by" character varying(32) DEFAULT ''0''::varchar NULL,
  	"create_time" date NULL,
  	"update_by" character varying(32) NULL,
  	"update_time" date NULL,
  	"dept_id" character varying(32) NULL,
  	CONSTRAINT "pk_kes_app_selector_relation" PRIMARY KEY (id)
  );',SYSDATE,NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"name": "kes_app_selector_relation", "check": null, "owner": "system", "indexs": [{"name": "pk_kes_app_selector_relation", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "sortOrder": "ASC"}], "comment": null, "clustered": false, "isPrimary": true, "accessMethod": "btree", "indconstraint": null}], "unique": null, "columns": [{"id": "f4fb5fa018304d67a8e369c755898eea", "name": "id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": true, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "2669a791efaf4ff8908a6f3e1df3b824", "name": "title", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 255, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "ca33cd545c5248669d9e639305274937", "name": "key", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "2c807c7383924f3085ca2eff6b3bd1ed", "name": "type", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 8, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "b738d7085a4e4ee0a927b5005091b39c", "name": "isLeaf", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "bool", "hasScale": false, "precision": null, "defaultRow": false, "primaryKey": false, "defaultValue": "true", "hasPrecision": false, "fromParentTable": false}, {"id": "c0a96095f5214fc0b16475f19c85a635", "name": "pid", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": "''0''::varchar", "hasPrecision": true, "fromParentTable": false}, {"id": "9fc5b64fc8da4339a0a80c10d76e8eb7", "name": "sort", "label": null, "scale": 0, "serial": false, "comment": null, "NULLABLE": true, "dataType": "int4", "hasScale": true, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": "1", "hasPrecision": true, "fromParentTable": false}, {"id": "26b991a1e4d44cf483c4788605c53ae0", "name": "anonymous_block", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "text", "hasScale": false, "precision": null, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": false, "fromParentTable": false}, {"id": "ffee692f86b040519894417f3b038bfe", "name": "desc", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "text", "hasScale": false, "precision": null, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": false, "fromParentTable": false}, {"id": "834db44f705e41afa34fe09ccbbe4f39", "name": "tree_path", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 512, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "6e76bc6302174697935585c6a553133c", "name": "create_by", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": "''0''::varchar", "hasPrecision": true, "fromParentTable": false}, {"id": "a86767d28d554adaa70fcf39661c0d97", "name": "create_time", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "date", "hasScale": false, "precision": 0, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "e0ed38a58e784220b6cf74aa839a6a39", "name": "update_by", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "1bd7d09d73744be9ab19e68e31234164", "name": "update_time", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "date", "hasScale": false, "precision": 0, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "6e7043d9b4f141ca86883826a85f415b", "name": "dept_id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}], "primary": {"name": "pk_kes_app_selector_relation", "COMMENT": null, "columns": ["id"], "DEFERRED": false, "DEFERRABLE": false, "operationEnum": 4}, "foreigin": null, "tableSpace": "sys_default"}',NULL,NULL,NULL,'obj',0,53);

INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num","api_title","increment_ddl") VALUES ('689132912a324814b171b0b6de610e99','dfb8894291c34ac28e3458bba277e0ff','53027de425834e27937e703a8501a368',NULL,'kesplus_base_node_mapping',NULL,'kesplus_base','CREATE TABLE kesplus_base.kesplus_base_node_mapping(
	"id" character varying(32 char) NOT NULL,
	"type_code" character varying(8 char) NOT NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"create_by" character varying(32 char) NULL,
	"create_time" timestamp(0) without time zone NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" timestamp(0) without time zone NULL,
	"tenant_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"logical_pid" character varying(32 char) NULL,
	CONSTRAINT "pk_base_node_mapping" PRIMARY KEY (id)
);


','''2024-11-27 08:51:15''',NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_base_node_mapping", "check": [], "label": "kesplus_base_node_mapping", "indexs": [{"name": "kesplus_base_node_mapping_id_pk", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "sortOrder": "ASC"}], "comment": "默认ID主键", "primary": true, "accessMethod": "btree"}], "unique": [], "columns": [{"id": "abee20882fb240828b6d5022e10fc56b", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": true, "operationObj": {"status": 3, "initvalue": {"name": "id", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": true, "extendProperty": {}}}, "extendProperty": {"label": "id"}}, {"id": "efa335f3949742118f2286b9976e61fb", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"name": "module_code", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 50, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "模块代码"}}, {"id": "86c8d7e49b944343a041b8a8eba4d419", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"name": "dept_id", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": false, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": "部门ID"}}], "primary": {"name": "kesplus_base_node_mapping_id_pk", "status": false, "columns": ["id"], "comment": "默认ID主键", "validated": false, "operationEnum": 1}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "authStatus": 0, "tableSpace": "sys_default", "auditStatus": 0, "constraints": false, "hasForceRowSec": false}','kesplus_base_node_mapping',NULL,NULL,'obj',0,NULL,NULL,NULL);


INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num","api_title","increment_ddl") VALUES ('d87af964bf494124b0744f369c34c39a','dfb8894291c34ac28e3458bba277e0ff','7b9b5e91212b4762b5edcd417f1166c9',NULL,'kesplus_serial_numbers_his',NULL,'kesplus_base','CREATE TABLE kesplus_base.kesplus_serial_numbers_his(
 id varchar NOT NULL,
 module_code varchar NOT NULL,
 dept_id varchar NOT NULL,
 config_id character varying(32 char),
 config_name character varying(32 char),
 config_code character varying(32 char),
 prefix character varying(32 char),
 suffix character varying(32 char),
 use_date boolean,
 date_format character varying(32 char),
 current_date_time datetime,
 length smallint,
 current_number integer,
 current_serial_number character varying(128 char),
 create_by varchar,
 create_time datetime,
 update_by varchar,
 update_time datetime,
CONSTRAINT "kesplus_serial_numbers_his_id_pk" PRIMARY KEY (id),
CONSTRAINT "uk_base_serial_numbers_code_current1" UNIQUE (config_id, current_serial_number)
)
;

COMMENT ON COLUMN kesplus_base.kesplus_serial_numbers_his.id IS ''id'';
COMMENT ON COLUMN kesplus_base.kesplus_serial_numbers_his.module_code IS ''模块代码'';
COMMENT ON COLUMN kesplus_base.kesplus_serial_numbers_his.dept_id IS ''部门ID''
;


','''2024-12-21 16:07:15''','''2024-12-21 16:09:14''','1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'{"label": {"id": "id", "dept_id": "部门ID", "module_code": "模块代码"}}',NULL,'{"name": "kesplus_serial_numbers_his", "check": [], "indexs": [{"name": "kesplus_serial_numbers_his_id_pk", "unique": true, "columns": [{"colname": "id", "initValue": {"colname": "id"}, "operationEnum": 4}], "primary": true, "initValue": {"name": "kesplus_serial_numbers_his_id_pk", "unique": true, "columns": [{"colname": "id"}], "primary": true, "accessMethod": "btree"}, "accessMethod": "btree", "operationEnum": 4}], "unique": [{"name": "uk_base_serial_numbers_code_current1", "status": true, "columns": ["config_id", "current_serial_number"], "validate": false, "validated": true, "operationEnum": 1}], "columns": [{"id": "1", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": true, "operationObj": {"status": 3, "initvalue": {"id": "1", "name": "id", "label": "id", "serial": false, "comment": "id", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": true, "extendProperty": {"label": "id"}}}, "extendProperty": {"label": "id"}}, {"id": "2", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "2", "name": "module_code", "label": "模块代码", "serial": false, "comment": "模块代码", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {"label": "模块代码"}}}, "extendProperty": {"label": "模块代码"}}, {"id": "3", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "3", "name": "dept_id", "label": "部门ID", "serial": false, "comment": "部门ID", "dataType": "varchar", "inColumn": false, "nullable": false, "primaryKey": false, "extendProperty": {"label": "部门ID"}}}, "extendProperty": {"label": "部门ID"}}, {"id": "4", "name": "config_id", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "4", "name": "config_id", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "5", "name": "config_name", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "5", "name": "config_name", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "6", "name": "config_code", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "6", "name": "config_code", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "7", "name": "prefix", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "7", "name": "prefix", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "8", "name": "suffix", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "8", "name": "suffix", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "9", "name": "use_date", "label": "", "serial": false, "comment": "", "dataType": "boolean", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "9", "name": "use_date", "serial": false, "dataType": "boolean", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "10", "name": "date_format", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "10", "name": "date_format", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 32, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "11", "name": "current_date_time", "label": "", "serial": false, "comment": "", "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "11", "name": "current_date_time", "serial": false, "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "12", "name": "length", "label": "", "serial": false, "comment": "", "dataType": "smallint", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "12", "name": "length", "serial": false, "dataType": "smallint", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "13", "name": "current_number", "label": "", "serial": false, "comment": "", "dataType": "integer", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "13", "name": "current_number", "serial": false, "dataType": "integer", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "14", "name": "current_serial_number", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 128, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "14", "name": "current_serial_number", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "precision": 128, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "15", "name": "create_by", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "15", "name": "create_by", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "16", "name": "create_time", "label": "", "serial": false, "comment": "", "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "16", "name": "create_time", "serial": false, "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "17", "name": "update_by", "label": "", "serial": false, "comment": "", "dataType": "varchar", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "17", "name": "update_by", "serial": false, "dataType": "varchar", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}, {"id": "18", "name": "update_time", "label": "", "serial": false, "comment": "", "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "operationObj": {"status": 3, "initvalue": {"id": "18", "name": "update_time", "serial": false, "dataType": "datetime", "inColumn": false, "nullable": true, "primaryKey": false, "extendProperty": {}}}, "extendProperty": {"label": ""}}], "primary": {"name": "kesplus_serial_numbers_his_id_pk", "status": false, "columns": ["id"], "initValue": {"name": "kesplus_serial_numbers_his_id_pk", "status": false, "columns": ["id"], "validated": false}, "validated": false, "operationEnum": 3}, "storage": false, "foreigin": [], "hasRowSec": false, "schemaOid": 0, "authStatus": 0, "tableSpace": "sys_default", "auditStatus": 0, "constraints": false, "hasForceRowSec": false}',NULL,'546508b9842c4e3698a1f2d3ae6fa917',NULL,'obj',0,NULL,NULL,'{"1734768488.040016": "COMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_id\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_name\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_code\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"prefix\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"suffix\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"use_date\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"date_format\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_date_time\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"length\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_number\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_serial_number\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"create_by\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"create_time\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"update_by\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"update_time\" IS '''';\nCREATE unique INDEX \"uk_base_serial_numbers_code_current\" ON \"kesplus_base\".\"kesplus_serial_numbers_his\" USING btree (config_id DESC nulls FIRST,current_serial_number DESC nulls FIRST) ;\n", "1734768554.332555": "COMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_id\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_name\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"config_code\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"prefix\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"suffix\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"use_date\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"date_format\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_date_time\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"length\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_number\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"current_serial_number\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"create_by\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"create_time\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"update_by\" IS '''';\nCOMMENT ON COLUMN \"kesplus_base\".\"kesplus_serial_numbers_his\".\"update_time\" IS '''';\nALTER TABLE \"kesplus_base\".\"kesplus_serial_numbers_his\" ADD CONSTRAINT \"uk_base_serial_numbers_code_current1\" UNIQUE (config_id,current_serial_number)  ENABLE VALIDATE;\ndo $$begin IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname=''uk_base_serial_numbers_code_current'' AND schemaname = ''kesplus_base'') then \nDROP INDEX \"kesplus_base\".\"uk_base_serial_numbers_code_current\";\nEND if;end $$;\n"}');

INSERT INTO kesplus_base.kes_tables ("id","module_id","app_id","tenant_id","name","owner_name","schema_name","ddl","create_time","update_time","parent_id","category","directory_code","tbs","comments","obj_oid","schema_oid","table_code","is_rest","api_directory_id","method","module_path","api_path","auth_status","role_ids","return_type","check_type","table_oid","extend_property","parameters","latest_req_parameters","label","update_by","create_by","obj_type","generated","sort_num","api_title","increment_ddl") VALUES ('6da640910bd84a089089c7f2585e6c7d','dfb8894291c34ac28e3458bba277e0ff','f2bc9bea22ea48cd8baaa3c142039732',NULL,'kesplus_base_role_menu','system','kesplus_base','CREATE TABLE kesplus_base.kesplus_base_role_menu(
 id character varying(32 char) NOT NULL,
 role_id character varying(32 char) NOT NULL,
 menu_id character varying(32 char) NOT NULL,
 create_by character varying(32 char) NOT NULL,
 create_time date NOT NULL,
 update_by character varying(32 char),
 update_time date,
 dept_id character varying(32 char) DEFAULT 0,
 module_code character varying(64 char),
 module_id character varying(32 char) DEFAULT 0,
CONSTRAINT "kesplus_base_role_menu_pkey" PRIMARY KEY (id)
)
;





','''2025-01-06 20:07:53''',NULL,'1',5,'table',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"name": "kesplus_base_role_menu", "check": null, "owner": "system", "indexs": [{"name": "kesplus_base_role_menu_pkey", "unique": true, "columns": [{"nulls": "LAST", "colname": "id", "sortOrder": "ASC"}], "comment": null, "clustered": false, "isPrimary": true, "accessMethod": "btree", "indconstraint": null}], "unique": null, "columns": [{"id": "ad01be570d744bb390a7eca624674967", "name": "id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": true, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "eac594256af44e3d9b9adc907dc989c3", "name": "role_id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "7a7e1e0ff83f426d8c7f82fce47126ee", "name": "menu_id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "295adb3249754b13baec5596bc1dd88e", "name": "create_by", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "a81d001151a24cd7a7ae3e096683f395", "name": "create_time", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": false, "dataType": "date", "hasScale": false, "precision": 0, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "dab672dbe03244fe8e5f115069a5658a", "name": "update_by", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "20e32507bb9f401581bbede6a5c5e65f", "name": "update_time", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "date", "hasScale": false, "precision": 0, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "ee65493ab5ac4eb189c0b2438e7d9b33", "name": "dept_id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": "0", "hasPrecision": true, "fromParentTable": false}, {"id": "f764417b6ebb461d85296b2ded922ddd", "name": "module_code", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 64, "defaultRow": false, "primaryKey": false, "defaultValue": null, "hasPrecision": true, "fromParentTable": false}, {"id": "d14148fa0c214b479a20304fe0f12f92", "name": "module_id", "label": null, "scale": null, "serial": false, "comment": null, "NULLABLE": true, "dataType": "varchar", "hasScale": false, "precision": 32, "defaultRow": false, "primaryKey": false, "defaultValue": "0", "hasPrecision": true, "fromParentTable": false}], "primary": {"name": "kesplus_base_role_menu_pkey", "COMMENT": null, "columns": ["id"], "DEFERRED": false, "DEFERRABLE": false, "operationEnum": 4}, "foreigin": null, "tableSpace": "sys_default"}',NULL,NULL,NULL,'obj',0,NULL,NULL,NULL);
