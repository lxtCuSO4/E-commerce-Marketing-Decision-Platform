CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_policy_db" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_policy_db" FOR EACH ROW
BEGIN
    perform 1 from "kesplus_base"."kesplus_base_policy_db" t where t.id = OLD."id";
    IF (TG_OP = 'insert' AND not found) OR (TG_OP = 'update' AND not found) THEN
        INSERT INTO "kesplus_base"."kesplus_base_policy_db" (
            "id", "schema_name", "table_name", "policy_id", "policy_name", "auth_type", "column_flag", "table_columns", "create_by", "create_time", "update_by", "update_time", "dept_id", "module_id", "tenant_id","enabled","policy_expression"
        ) VALUES(
            new."id", new."schema_name", new."table_name", new."policy_id", new."policy_name", new."auth_type", new."column_flag", new."table_columns", new."create_by", new."create_time", new."update_by", new."update_time", new."dept_id", new."module_id", new."tenant_id", new."enabled", new."policy_expression"
        )ON CONFLICT("id") do nothing;
    ELSEIF TG_OP = 'update' THEN
        UPDATE "kesplus_base"."kesplus_base_policy_db"
        SET "schema_name"=new."schema_name", "table_name"=new."table_name", "policy_id"=new."policy_id", "policy_name"=new."policy_name", "auth_type"=new."auth_type", "column_flag"=new."column_flag", "table_columns"=new."table_columns", "update_by"=new."update_by", "update_time"=new."update_time", "enabled"=new."enabled", "policy_expression"=new."policy_expression"
        WHERE "id"=old."id";
    ELSEIF FOUND THEN   --delete
        DELETE FROM "kesplus_base"."kesplus_base_policy_db" WHERE "id"=OLD.id;
    END IF;

END;