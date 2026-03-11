CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_restful_aspect_cache_restful" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_platform"."kesplus_sys_restful_aspect" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" t WHERE t."key" = 'restful:'|| OLD.restful_id;
END;