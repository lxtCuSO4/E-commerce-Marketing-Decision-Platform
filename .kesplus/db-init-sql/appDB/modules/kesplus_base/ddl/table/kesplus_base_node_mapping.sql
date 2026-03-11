CREATE TABLE "kesplus_base"."kesplus_base_node_mapping" (
	"id" character varying(32 char) NOT NULL,
	"type_code" character varying(16 char) NOT NULL,
	"node_id" character varying(32 char) NOT NULL,
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

-- Column comments


-- Table Triggers

CREATE OR REPLACE TRIGGER kesplus_tr_base_node_mapping AFTER INSERT OR UPDATE OR DELETE ON kesplus_base.kesplus_base_node_mapping FOR EACH ROW
BEGIN
     IF TG_OP = 'insert' OR TG_OP = 'delete' OR new."logical_pid" != OLD.logical_pid THEN
     	IF NEW."type_code" = 'menus' THEN
     		update "kesplus_base"."kesplus_base_menu" t set t."update_time"=SYSDATE where t."id" = new."node_id";
     	ELSEIF NEW."type_code" = 'permissions' THEN
     		update "kesplus_base"."kesplus_base_permission" t set t."update_time"=SYSDATE where t."id" = new."node_id";
     	ELSEIF NEW."type_code" = 'roles' THEN
     		update "kesplus_base"."kesplus_base_role" t set t."update_time"=SYSDATE where t."id" = new."node_id";
     	ELSE
     		update "kesplus_base"."kesplus_base_policy" t set t."update_time"=SYSDATE where t."id" = new."node_id";
     	END IF;
    end if;
END;