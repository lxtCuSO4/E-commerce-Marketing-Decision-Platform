CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_form_page_properties AFTER INSERT OR DELETE OR UPDATE ON "${moduleSchema}".kes_form_page_properties FOR EACH ROW
BEGIN
	IF TG_OP = 'insert' THEN
        INSERT INTO "kesplus_app"."kes_form_page_properties"(
         "id", "form_id", "table_name", "field_name", "field_type", "field_num", "label", "label_name", "required", "editable", "pk", "hidden", "component", "other", "create_time", "update_time", "field_status"
        )  VALUES (
         new."id", new."form_id", new."table_name", new."field_name", new."field_type", new."field_num", new."label", new."label_name", new."required", new."editable", new."pk", new."hidden", new."component", new."other", new."create_time", new."update_time", new."field_status"
        )ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kes_form_page_properties"
        SET "form_id"=new."form_id", "table_name"=new."table_name", "field_name"=new."field_name", "field_type"=new."field_type", "field_num"=new."field_num", "label"=new."label", "label_name"=new."label_name", "required"=new."required", "editable"=new."editable", "pk"=new."pk", "hidden"=new."hidden", "component"=new."component", "other"=new."other", "create_time"=new."create_time", "update_time"=new."update_time", "field_status"=new."field_status"
        WHERE "id"=old."id";
	ELSE   --delete
		DELETE FROM "kesplus_app"."kes_form_page_properties" WHERE "id"=OLD.id;
	END IF;

END;