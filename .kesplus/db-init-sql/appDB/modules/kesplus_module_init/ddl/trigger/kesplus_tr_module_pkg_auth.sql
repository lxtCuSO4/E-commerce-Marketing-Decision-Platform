CREATE OR REPLACE TRIGGER "${moduleSchema}".kesplus_tr_module_pkg_auth AFTER INSERT OR UPDATE ON "${moduleSchema}".kes_packages FOR EACH ROW
BEGIN
    --EXECUTE FORMAT('GRANT ALL ON PACKAGE "${moduleSchema}"."%s" TO "r:kes_plus:${appCode}:developer";', NEW.NAME);
    --EXECUTE FORMAT('GRANT EXECUTE ON PACKAGE "${moduleSchema}"."%s" TO "r:kes_plus:${appCode}:base";', NEW.NAME);
	IF NEW.obj_type = 'dir' THEN
		RETURN;
	END IF;
    CALL "kesplus_platform"."sys_auth".after_pkg(NEW.SCHEMA_NAME, NEW.NAME);
END;

ALTER TABLE "${moduleSchema}".kes_packages DISABLE TRIGGER kesplus_tr_module_pkg_auth;