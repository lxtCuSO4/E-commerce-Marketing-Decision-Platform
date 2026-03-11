CREATE OR REPLACE TRIGGER kesplus_tr_base_menu_cache AFTER INSERT OR UPDATE OR DELETE ON kesplus_base.kesplus_base_menu FOR EACH ROW
BEGIN
	delete FROM "public"."global_cache" where "key" like 'menu:%';
END;

