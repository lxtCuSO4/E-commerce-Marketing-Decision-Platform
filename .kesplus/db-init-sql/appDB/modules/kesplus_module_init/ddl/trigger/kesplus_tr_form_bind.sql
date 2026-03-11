CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_form_bind AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}".kes_form_bind FOR EACH ROW
BEGIN
	IF TG_OP = 'insert' THEN
        INSERT INTO "kesplus_app"."kes_form_bind"(
         "id", "form_id", "process_id", "config_name", "config_code", "variables", "properties", "process_title", "create_time", "update_time"
        )  VALUES (
         new."id", new."form_id", new."process_id", new."config_name", new."config_code", new."variables", new."properties", new."process_title", new."create_time", new."update_time"
        )ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kes_form_bind"
        SET "form_id"=new."form_id", "process_id"=new."process_id", "config_name"=new."config_name", "config_code"=new."config_code", "variables"=new."variables", "properties"=new."properties", "process_title"=new."process_title", "create_time"=new."create_time", "update_time"=new."update_time"
        WHERE "id"=old."id";
	ELSE   --delete
		DELETE FROM "kesplus_app"."kes_form_bind" WHERE "id"=OLD.id;
	END IF;

END;