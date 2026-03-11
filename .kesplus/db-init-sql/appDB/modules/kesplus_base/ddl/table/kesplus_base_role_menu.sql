-- "kesplus_base"."kesplus_base_role_menu" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_base_role_menu";

CREATE TABLE "kesplus_base"."kesplus_base_role_menu" (
	"id" character varying(32 char) NOT NULL,
	"role_id" character varying(32 char) NOT NULL,
	"menu_id" character varying(32 char) NOT NULL,
	"create_by" character varying(32 char) NOT NULL,
	"create_time" date NOT NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	CONSTRAINT "pk_base_role_menu" PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."id" IS '主键ID';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."role_id" IS '角色id';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."menu_id" IS '菜单id';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."create_by" IS '记录创建人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."create_time" IS '记录创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."update_by" IS '记录更新人id';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."update_time" IS '记录更新时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_base_role_menu"."dept_id" IS '记录数据所属部门';

CREATE INDEX idx_kesplus_role_menu_role_menu ON kesplus_base.kesplus_base_role_menu(role_id,menu_id);

