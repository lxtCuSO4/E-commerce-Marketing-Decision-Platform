CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_user_cache" AFTER UPDATE OR DELETE ON "kesplus_platform"."kes_sys_user" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" where "key" like format('user:%s', OLD.id) || '%' ;
END;