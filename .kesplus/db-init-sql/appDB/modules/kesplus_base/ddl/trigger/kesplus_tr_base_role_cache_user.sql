CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_base_role_cache_user" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_base"."kesplus_base_role" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" where "key" like 'user:%';
    delete FROM "public"."global_cache" where "key" like 'utoken:%';
    delete FROM "public"."global_cache" where "key" like 'role:%';
END;

