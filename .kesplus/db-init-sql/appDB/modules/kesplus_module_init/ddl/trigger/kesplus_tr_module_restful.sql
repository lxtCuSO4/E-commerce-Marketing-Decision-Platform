CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_restful" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_restful" FOR EACH ROW
declare
    parentId$ varchar;
    topDirId$ varchar;
    treeType$ varchar :='restful';
BEGIN
    select id into topDirId$ from kesplus_app."kes_app_directory" where "directory_code" =treeType$;
    IF NEW."parent_id"=topDirId$ THEN
        parentId$ := NEW."module_id";
    ELSE
        parentId$ := NEW."parent_id";
    END IF;

	IF TG_OP = 'insert' THEN
		INSERT INTO "kesplus_app"."kesplus_sys_restful"(
		    "id", "parent_id", "code", "path", "type", "title", "method", "return_type", "source_type", "auth_status", "remark", "full_path", "show_sort", "module_id", "tenant_id", "sys_api", "func_id", "enabled", "app_id", "api_version", "view_id", "service_code", "create_time", "update_time", "create_by", "update_by", "dept_id", "responsible_person", "tree_sort", "tree_path", "obj_type", "sql_content", "anonymous_block", "params", "is_anonymous"
		) VALUES (
		    new."id", parentId$, new."code", new."path", new."type", new."title", new."method", new."return_type", new."source_type", new."auth_status", new."remark", new."full_path", new."show_sort", new."module_id", new."tenant_id", new."sys_api", new."func_id", new."enabled", new."app_id", new."api_version", new."view_id", new."service_code", new."create_time", new."update_time", new."create_by", new."update_by", new."dept_id", new."responsible_person", new."tree_sort", new."tree_path", new."obj_type", new."sql_content", new."anonymous_block", new."params", new."is_anonymous"
		) ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kesplus_sys_restful"
        SET "parent_id"=parentId$, "code"=new."code", "path"=new."path", "type"=new."type", "title"=new."title", "method"=new."method", "return_type"=new."return_type", "source_type"=new."source_type", "auth_status"=new."auth_status", "remark"=new."remark", "full_path"=new."full_path", "show_sort"=new."show_sort", "module_id"=new."module_id", "tenant_id"=new."tenant_id", "sys_api"=new."sys_api", "func_id"=new."func_id", "enabled"=new."enabled", "app_id"=new."app_id", "api_version"=new."api_version", "view_id"=new."view_id", "service_code"=new."service_code", "create_time"=new."create_time", "update_time"=new."update_time", "create_by"=new."create_by", "update_by"=new."update_by", "dept_id"=new."dept_id", "responsible_person"=new."responsible_person", "tree_sort"=new."tree_sort", "tree_path"=new."tree_path", "obj_type"=new."obj_type", "sql_content"=new."sql_content", "anonymous_block"=new."anonymous_block", "params"=new."params", "is_anonymous"=new."is_anonymous"
        WHERE "id"=new."id";
    ELSE   --delete
        DELETE FROM "kesplus_app"."kesplus_sys_restful" WHERE "id"=OLD.id;
    END IF;

END;