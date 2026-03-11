CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_role_restful"
AS
SELECT kbp."role_id", ksrp."permission_id", ksrp."restful_id"
FROM "kesplus_base"."kesplus_base_role_permission" kbp
JOIN "kesplus_app"."kesplus_sys_restful_permission" ksrp ON kbp."permission_id" = ksrp."permission_id";