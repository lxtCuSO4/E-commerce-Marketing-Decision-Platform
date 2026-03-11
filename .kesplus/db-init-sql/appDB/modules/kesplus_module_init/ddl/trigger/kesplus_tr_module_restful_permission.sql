CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_restful_permission" AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}"."kesplus_module_restful_permission" FOR EACH ROW
BEGIN
   IF TG_OP = 'insert' THEN
		INSERT INTO "kesplus_app"."kesplus_sys_restful_permission"(
		    "id", "module_id", "tenant_id", "create_time", "update_time", "create_by", "update_by", "dept_id", "restful_id","permission_id"
		) VALUES (
		    new."id",   new."module_id", new."tenant_id", new."create_time", new."update_time", new."create_by", new."update_by", new."dept_id", new."restful_id",new."permission_id"
		) ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
UPDATE "kesplus_app"."kesplus_sys_restful_permission"
SET "restful_id"=new."restful_id", "permission_id"=new."permission_id", "module_id"=new."module_id", "tenant_id"=new."tenant_id",  "create_time"=new."create_time", "update_time"=new."update_time", "create_by"=new."create_by", "update_by"=new."update_by", "dept_id"=new."dept_id"
WHERE "id"=new."id";
ELSE   --delete
DELETE FROM "kesplus_app"."kesplus_sys_restful_permission" WHERE "id"=OLD.id;
END IF;
END;