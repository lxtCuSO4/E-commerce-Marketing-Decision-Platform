CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_user_cache_user" AFTER UPDATE OR DELETE ON "kesplus_base"."kesplus_user_info" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" where "key" like 'user:'|| old.id || '%';
    delete FROM "public"."global_cache" where "key" like 'utoken:'|| old.id || '%';
END;