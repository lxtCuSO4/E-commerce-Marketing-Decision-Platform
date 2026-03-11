CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_base_permission_cache" AFTER INSERT OR UPDATE OR delete ON "kesplus_base"."kesplus_base_permission" FOR EACH ROW
BEGIN
	delete FROM "public"."global_cache" where "key" like 'permission:%';
END;

