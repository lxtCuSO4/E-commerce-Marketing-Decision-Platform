-- "kesplus_platform"."kesplus_v_aspect" source

CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_aspect"
AS SELECT ksa.id,
    ksa.aspect_code,
    ksa.aspect_name,
    ksa.order_id,
    ksa.fun_before,
    ksa.fun_after,
    ksa.fun_exception,
    ksa.url_pattern,
    ksa.create_by,
    ksa.create_time,
    ksa.update_by,
    ksa.update_time,
    ksa.aspect_type,
    ksa.aspect_version,
    ksa.aspect_status,
    ksa.check_type,
    ksa.is_deleted
   FROM kesplus_platform.kesplus_sys_aspect ksa;