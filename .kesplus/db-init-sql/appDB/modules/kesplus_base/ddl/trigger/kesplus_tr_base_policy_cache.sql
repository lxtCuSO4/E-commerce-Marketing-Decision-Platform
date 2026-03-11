CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_base_policy_cache" AFTER INSERT OR UPDATE OR DELETE ON "kesplus_base"."kesplus_base_policy" FOR EACH ROW
BEGIN
	delete FROM "public"."global_cache" where "key" like 'policy:%';
END;
