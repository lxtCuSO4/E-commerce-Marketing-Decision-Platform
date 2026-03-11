CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_role_menu" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_role_menu" FOR EACH ROW
BEGIN
	IF TG_OP = 'insert' THEN
        INSERT INTO "kesplus_base"."kesplus_base_role_menu"(
            "id", "role_id", "menu_id", "create_by", "create_time", "update_by", "update_time", "dept_id", "module_id"
        )VALUES(
        	new."id", new."role_id", new."menu_id", new."create_by", new."create_time", new."update_by", new."update_time", new."dept_id", new."module_id"
        ) ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_base"."kesplus_base_role_menu"
        SET "role_id"=new."role_id", "menu_id"=new."menu_id", "update_by"=new."update_by", "update_time"=new."update_time"
        WHERE "id"=old."id";
	ELSE   --delete
		DELETE FROM "kesplus_base"."kesplus_base_role_menu" WHERE "id"=OLD.id;
	END IF;

END;