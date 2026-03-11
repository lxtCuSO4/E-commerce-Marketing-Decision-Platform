CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_config_cache_user" AFTER UPDATE OR DELETE OR INSERT ON "kesplus_platform"."kesplus_sys_config" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" where "key" like 'user:%';
    delete FROM "public"."global_cache" where "key" = 'config';
END;