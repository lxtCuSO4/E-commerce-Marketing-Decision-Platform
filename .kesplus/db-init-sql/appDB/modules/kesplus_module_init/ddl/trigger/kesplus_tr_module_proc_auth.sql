CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_module_proc_auth AFTER INSERT OR UPDATE ON "${moduleSchema}".kes_functions FOR EACH ROW
DECLARE
	obj_type_ varchar := 'PROCEDURE';
BEGIN
	IF NEW.obj_type = 'dir' THEN
		RETURN;
	END IF;
	IF NEW.directory_code = 'functions' THEN
		obj_type_ := 'FUNCTION';
	END IF;
    CALL "kesplus_platform"."sys_auth".after_proc(upper(obj_type_), NEW.SCHEMA_NAME, NEW.NAME, NEW.parameters);
END;

ALTER TABLE "${moduleSchema}".kes_functions DISABLE TRIGGER kesplus_tr_module_proc_auth;