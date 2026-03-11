CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_filter_cache_restful" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_platform"."kesplus_sys_filter" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" t WHERE t."key" LIKE 'restful:%';
END;