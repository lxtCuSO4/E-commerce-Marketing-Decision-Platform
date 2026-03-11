CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_form AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}".kes_form FOR EACH ROW
BEGIN
	IF TG_OP = 'insert' THEN
        INSERT INTO "kesplus_app"."kes_form"(
         "id", "form_name", "form_code", "form_path", "module_id", "description", "form_type", "form_theme", "form_style", "form_config", "form_record", "create_time", "update_time", "create_by", "update_by"
        )  VALUES (
         new."id", new."form_name", new."form_code", new."form_path", new."module_id", new."description", new."form_type", new."form_theme", new."form_style", new."form_config", new."form_record", new."create_time", new."update_time", new."create_by", new."update_by"
        )ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kes_form"
        SET "form_name"=new."form_name", "form_code"=new."form_code", "form_path"=new."form_path", "module_id"=new."module_id", "description"=new."description", "form_type"=new."form_type", "form_theme"=new."form_theme", "form_style"=new."form_style", "form_config"=new."form_config", "form_record"=new."form_record", "create_time"=new."create_time", "update_time"=new."update_time", "create_by"=new."create_by", "update_by"=new."update_by"
        WHERE "id"=old."id";
	ELSE   --delete
		DELETE FROM "kesplus_app"."kes_form" WHERE "id"=OLD.id;
	END IF;

END;