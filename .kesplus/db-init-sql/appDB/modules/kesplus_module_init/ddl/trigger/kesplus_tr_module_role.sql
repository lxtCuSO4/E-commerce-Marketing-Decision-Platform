CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_role" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_role" FOR EACH ROW
DECLARE
    parent_id_ text := new."parent_id";
    top_id_ text;
BEGIN
    perform 1 from "kesplus_base"."kesplus_base_role" t where t.id = OLD."id";
	IF (TG_OP = 'insert' AND not found) OR (TG_OP = 'update' AND not found) THEN
        INSERT INTO "kesplus_base"."kesplus_base_role"(
            "id", "name", "code", "description", "global_flag", "role_level", "data_scope", "classify", "role_type", "hidden_flag", "enabled", "create_by", "create_time", "update_by", "update_time", "tenant_id", "module_id", "dept_id","obj_type","parent_id", "sort_num"
        ) VALUES (
            new."id", new."name", new."code", new."description", new."global_flag", new."role_level", new."data_scope", new."classify", new."role_type", new."hidden_flag", new."enabled", new."create_by", new."create_time", new."update_by", new."update_time", new."tenant_id", new."module_id", new."dept_id",new."obj_type", parent_id_, new."sort_num"
        )ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
        UPDATE "kesplus_base"."kesplus_base_role"
        SET "name"=new."name", "code"=new."code", "description"=new."description", "global_flag"=new."global_flag", "role_level"=new."role_level", "data_scope"=new."data_scope", "classify"=new."classify", "role_type"=new."role_type", "hidden_flag"=new."hidden_flag", "enabled"=new."enabled", "create_by"=new."create_by", "create_time"=new."create_time", "update_by"=new."update_by", "update_time"=new."update_time", "tenant_id"=new."tenant_id", "module_id"=new."module_id", "dept_id"=new."dept_id","obj_type"=new."obj_type","parent_id"=parent_id_,"sort_num"=new."sort_num"
        WHERE "id"=old."id";
	ELSEIF FOUND THEN   --delete
		DELETE FROM "kesplus_base"."kesplus_base_role" WHERE "id"=OLD.id;
	END IF;

END;