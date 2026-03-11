-- "${moduleSchema}"."kesplus_tr_module_menu" definition

CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_module_menu AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}".kesplus_module_menu FOR EACH ROW
DECLARE
    v_module_code varchar;
    v_menu_type varchar :='dir';
    v_pid varchar;
    v_top_dir_id varchar;
    v_tree_type varchar :='menus';
    v_permission_pid varchar;
    v_permission_top_id varchar;
    v_permission_tree_type varchar :='permissions';
    v_associated boolean;
    v_top boolean := false;
BEGIN
    v_pid := NEW."parent_id";
    select id into v_top_dir_id from kesplus_app."kes_app_directory" where "directory_code" = v_tree_type;
    IF NEW."parent_id" = v_top_dir_id THEN
        select id into v_permission_top_id from kesplus_app."kes_app_directory" where "directory_code" = v_permission_tree_type;
        v_permission_pid := v_permission_top_id;
        v_top := true;
    ELSE
        v_permission_pid:= NEW."parent_id";
    END IF;

    perform 1 from "kesplus_base"."kesplus_base_menu" t where t.id = OLD."id";

    IF (TG_OP = 'insert' AND not found) OR (TG_OP = 'update' AND not found) THEN
        INSERT INTO "kesplus_base"."kesplus_base_menu"(
            "id", "code", "title", "icon", "classify", "url", "outer_link", "component", "hidden_flag", "enabled", "params", "properties", "create_by", "create_time", "update_by", "update_time", "tenant_id", "module_id", "dept_id", "parent_id", "sort_num", "obj_type"
        ) VALUES (
             new."id", new."code", new."title", new."icon", new."classify", new."url", new."outer_link", new."component", new."hidden_flag", new."enabled", new."params", new."properties", new."create_by", new."create_time", new."update_by", new."update_time", new."tenant_id", new."module_id", new."dept_id",v_pid, new."sort_num", new."obj_type"
        )ON CONFLICT("id") do nothing;

        perform 1 from "${moduleSchema}"."kesplus_module_permission" where id = new."id";
        if not found then
            perform 1 from "${moduleSchema}"."kesplus_module_permission" where id = v_permission_pid;
            if found or v_top = true then
                 INSERT INTO "${moduleSchema}"."kesplus_module_permission"(
                    "id", "module_id", "module_code", "dept_id", "name", "code", "obj_type", "parent_id", "status","create_by", "create_time", "update_by", "update_time"
                ) VALUES(
                    new."id",new."module_id", v_module_code,new."dept_id", new."title", new."code", v_menu_type, v_permission_pid,new."enabled",new."create_by", new."create_time", new."update_by", new."update_time"
                );
            end if;
        else
            update "${moduleSchema}"."kesplus_module_permission" t set t."custom" = 0 where t.id = new."id";
        end if;

    ELSEIF TG_OP = 'update' THEN
        UPDATE "kesplus_base"."kesplus_base_menu"
        SET "code"=new."code", "title"=new."title", "icon"=new."icon", "classify"=new."classify", "url"=new."url", "outer_link"=new."outer_link", "component"=new."component", "hidden_flag"=new."hidden_flag", "enabled"=new."enabled", "params"=new."params", "properties"=new."properties", "update_by"=new."update_by", "update_time"=new."update_time", "tenant_id"=new."tenant_id", "module_id"=new."module_id", "dept_id"=new."dept_id", "parent_id"=v_pid, "sort_num"=new."sort_num", "obj_type"=new."obj_type"
        WHERE "id"=old."id";

        UPDATE  "${moduleSchema}"."kesplus_module_permission"
        SET "code"=new."code", "name"=new."title", "status"=new."enabled", "parent_id"=v_permission_pid,  "update_by"=new."update_by", "update_time"=new."update_time"
        WHERE "id"=old."id";
    ELSEIF FOUND THEN   --delete
        DELETE FROM "kesplus_base"."kesplus_base_menu" WHERE "id"=OLD.id;
        DELETE FROM "kesplus_base"."kesplus_base_role_menu" WHERE "menu_id"=OLD.id;
        if kesplus_platform.setting('delete.source') = 'menu' then
            v_associated := kesplus_platform.setting('delete.associated')::boolean;
            IF v_associated = TRUE THEN
                perform 1 from "${moduleSchema}"."kesplus_module_permission" t where t.parent_id = OLD.id;
                if found then
                    RAISE EXCEPTION '关联的权限点目录含有下级节点';
                end if;
                DELETE FROM "${moduleSchema}"."kesplus_module_permission" WHERE "id"=OLD.id;
            else
                update "${moduleSchema}"."kesplus_module_permission" t set t."custom" = 1 where "id"=OLD.id;
            END IF;
        end if;

    END IF;

END;