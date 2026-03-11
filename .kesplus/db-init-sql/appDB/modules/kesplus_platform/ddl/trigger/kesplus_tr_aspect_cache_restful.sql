CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_aspect_cache_restful" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_platform"."kesplus_sys_aspect" FOR EACH ROW
BEGIN
    --delete FROM "kesplus_platform"."kesplus_sys_cache" where "cache_type" = 'RESTFUL';
    DELETE FROM "public"."global_cache" t WHERE t."key" LIKE 'restful:%';
END;