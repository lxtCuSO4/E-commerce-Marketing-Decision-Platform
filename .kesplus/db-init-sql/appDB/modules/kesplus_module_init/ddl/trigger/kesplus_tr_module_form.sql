-- Table Triggers

CREATE OR REPLACE TRIGGER kesplus_tr_module_form AFTER INSERT OR DELETE OR UPDATE ON ${moduleSchema}.kesplus_module_form FOR EACH ROW
DECLARE

BEGIN
	IF TG_OP = 'insert' THEN
		INSERT INTO "kesplus_app"."kesplus_form"(
			"id", "name", "code", "status", "gen_method", "main_table", "sub_tables", "field_config", "vue_component", "edit_permissions", "view_permissions", "create_by", "create_time", "update_by", "update_time", "module_id", "obj_type", "parent_id", "sort_num"
		)VALUES(
			NEW."id", NEW."name", NEW."code", NEW."status", NEW."gen_method", NEW."main_table", NEW."sub_tables", NEW."field_config", NEW."vue_component", NEW."edit_permissions", NEW."view_permissions", NEW."create_by", NEW."create_time", NEW."update_by", NEW."update_time", NEW."module_id", NEW."obj_type", NEW."parent_id", NEW."sort_num"
		)ON CONFLICT("id") do nothing;

	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kesplus_form"
		SET "name"=NEW."name", "code"=NEW."code", "status"=NEW."status", "gen_method"=NEW."gen_method", "main_table"=NEW."main_table", "sub_tables"=NEW."sub_tables", "field_config"=NEW."field_config", "vue_component"=NEW."vue_component",
			"edit_permissions"=NEW."edit_permissions", "view_permissions"=NEW."view_permissions", "update_by"=NEW."update_by", "update_time"=NEW."update_time", "parent_id"=NEW."parent_id", "sort_num"=NEW."sort_num"
		WHERE "id"=OLD."id";
    ELSE   --delete
		DELETE FROM "kesplus_app"."kesplus_form" WHERE "id" = OLD."id";
    END IF;
END;

ALTER TABLE "${moduleSchema}".kesplus_module_form DISABLE TRIGGER kesplus_tr_module_form;