CREATE OR REPLACE TRIGGER kesplus_tr_role_permission_cache_user AFTER INSERT OR DELETE OR UPDATE ON kesplus_base.kesplus_base_role_permission FOR EACH ROW
BEGIN
--     delete FROM "kesplus_platform"."kesplus_sys_cache" t where t."cache_type" = 'USER' and exists(
--         select r."id" from "kesplus_base"."kesplus_user_role" r where r."role_id" = OLD.id and t."cache_key" like r.user_id || '%'
--     ) ;
END;
