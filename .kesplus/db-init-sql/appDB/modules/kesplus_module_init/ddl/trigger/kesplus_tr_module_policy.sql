CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_policy" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_policy" FOR EACH ROW
DECLARE
    parent_id_ text := new."parent_id";
    top_id_ text;
BEGIN
    perform 1 from "kesplus_base"."kesplus_base_policy" t where t.id = OLD."id";
	IF (TG_OP = 'insert' AND not found) OR (TG_OP = 'update' AND not found) THEN
        INSERT INTO "kesplus_base"."kesplus_base_policy"(
            "id", "code", "name", "description", "enabled", "params", "tables", "create_by", "create_time", "update_by", "update_time", "dept_id", "module_id", "tenant_id", "parent_id", "obj_type", "sort_num"
        )VALUES(
            new."id", new."code", new."name", new."description", new."enabled", new."params", new."tables", new."create_by", new."create_time", new."update_by", new."update_time", new."dept_id", new."module_id", new."tenant_id", parent_id_, new."obj_type", new."sort_num"
        )ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
        UPDATE "kesplus_base"."kesplus_base_policy"
        SET "code"=new."code", "name"=new."name", "description"=new."description", "enabled"=new."enabled", "params"=new."params", "tables"=new."tables", "create_by"=new."create_by", "create_time"=new."create_time", "update_by"=new."update_by", "update_time"=new."update_time", "dept_id"=new."dept_id", "module_id"=new."module_id", "tenant_id"=new."tenant_id", "parent_id"=parent_id_, "obj_type"=new."obj_type", "sort_num"=new."sort_num"
        WHERE "id"=old."id";
	ELSEIF FOUND THEN   --delete
		DELETE FROM "kesplus_base"."kesplus_base_policy" WHERE "id"=OLD.id;
	END IF;

END;