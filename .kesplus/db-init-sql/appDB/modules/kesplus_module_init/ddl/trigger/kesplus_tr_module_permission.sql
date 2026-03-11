-- "kesplus_tr_module_permission" definition

CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_module_permission AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}".kesplus_module_permission FOR EACH ROW
DECLARE
    v_pid varchar := new."parent_id";
    v_top_dir_id varchar;
    v_tree_type varchar := 'permissions';
    v_associated boolean;
BEGIN
    perform 1 from "kesplus_base"."kesplus_base_permission" t where t.id = OLD."id";

    IF (TG_OP = 'insert' AND not found) OR (TG_OP = 'update' AND not found) THEN
        INSERT INTO "kesplus_base"."kesplus_base_permission" (
            "id", "module_id", "module_code", "dept_id", "name", "code", "obj_type", "parent_id", "status","create_by", "create_time", "update_by", "update_time", "remark", "sort_num", "custom"
        ) VALUES(
            new."id",new."module_id", new."module_code",new."dept_id", new."name", new."code", new."obj_type", v_pid,new."status",new."create_by", new."create_time", new."update_by", new."update_time", new."remark", new."sort_num", new."custom"
        )ON CONFLICT("id") do nothing;

    ELSEIF TG_OP = 'update' THEN
        UPDATE "kesplus_base"."kesplus_base_permission"
        SET "code"=new."code", "name"=new."name", "status"=new."status", "parent_id"=v_pid,  "update_by"=new."update_by", "update_time"=new."update_time", "remark"=new."remark" , "sort_num"=new."sort_num", "custom"=new."custom"
        WHERE "id"=old."id";

        if new."custom" = 0 then
            perform 1 from "${moduleSchema}"."kesplus_module_menu" t where t.id = old."id" and t."title" != new."name";
            if found then
                update "${moduleSchema}"."kesplus_module_menu" t set t."title" =  new."name" where t.id = old."id";
            end if;
        end if;
    ELSEIF FOUND THEN   --delete
        DELETE FROM "kesplus_base"."kesplus_base_permission" WHERE "id"=OLD.id;
        DELETE FROM "kesplus_base"."kesplus_base_role_permission" WHERE "permission_id"=OLD.id;
        if kesplus_platform.setting('delete.source') = 'permission' then
            v_associated := kesplus_platform.setting('delete.associated')::boolean;
            IF v_associated = TRUE THEN
                perform 1 from "${moduleSchema}"."kesplus_module_menu" t where t.parent_id = OLD.id;
                if found then
                    RAISE EXCEPTION '关联的菜单含有下级节点';
                end if;
                DELETE FROM "${moduleSchema}"."kesplus_module_menu" WHERE "id"=OLD.id ;
            END IF;
        end if;

    END IF;

END;