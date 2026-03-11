CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_restful_cache_restful" AFTER UPDATE OR DELETE ON "kesplus_platform"."kesplus_sys_restful" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" t WHERE t."key" LIKE 'restful:%';
END;