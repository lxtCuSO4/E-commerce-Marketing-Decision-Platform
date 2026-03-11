CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_dept_cache_user" AFTER UPDATE OR DELETE OR INSERT ON "kesplus_base"."kesplus_dept" FOR EACH ROW
BEGIN
    delete FROM "public"."global_cache" where "key" like 'user:%';
    delete FROM "public"."global_cache" where "key" like 'utoken:%';
END;