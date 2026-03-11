CREATE OR REPLACE TRIGGER "kesplus_app"."kesplus_tr_restful_cache_restful" AFTER UPDATE OR DELETE ON "kesplus_app"."kesplus_sys_restful" FOR EACH ROW
BEGIN
    delete FROM "kesplus_platform"."kesplus_sys_cache" where "cache_type" = 'RESTFUL' and "cache_key" = OLD.id;
END;