CREATE OR REPLACE TRIGGER "kesplus_app"."kesplus_tr_filter_cache_restful" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_app"."kesplus_sys_filter" FOR EACH ROW
BEGIN
    delete FROM "kesplus_platform"."kesplus_sys_cache" where "cache_type" = 'RESTFUL';
END;