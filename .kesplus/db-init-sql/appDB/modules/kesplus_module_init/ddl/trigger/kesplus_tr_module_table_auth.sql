CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_module_table_auth AFTER INSERT OR UPDATE ON "${moduleSchema}".kes_tables FOR EACH ROW
BEGIN
	IF NEW.obj_type = 'dir' THEN
		RETURN;
	END IF;
	IF NEW."directory_code" = 'view' THEN
		CALL "kesplus_platform"."sys_auth".after_view(NEW.SCHEMA_NAME, NEW.NAME);
		RETURN;
	END IF;
	IF TG_OP = 'update' and (old."name" != new."name" or COALESCE(md5(old."increment_ddl"::text) != md5(new."increment_ddl"::text), true)) THEN
		call "kesplus_app"."kesplus_pkg_module_policy".rename_table(old."schema_name", old."name", new."name");
	END IF;
    CALL "kesplus_platform"."sys_auth".after_table(NEW.SCHEMA_NAME, NEW.NAME);
END;

ALTER TABLE "${moduleSchema}".kes_tables DISABLE TRIGGER kesplus_tr_module_table_auth;