-- "kesplus_platform"."kesplus_v_aspect" source

CREATE OR REPLACE VIEW "kesplus_app"."kesplus_v_aspect"
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
   FROM kesplus_platform.kesplus_sys_aspect ksa

   union
   SELECT ksa.id,
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
   FROM kesplus_app.kesplus_sys_aspect ksa;



CREATE OR REPLACE VIEW "kesplus_app"."kesplus_v_restful_aspect"
AS SELECT sa.id,
    sa.aspect_code,
    sa.aspect_name,
    sa.order_id,
    sa.fun_before,
    sa.fun_after,
    sa.fun_exception,
    sa.url_pattern,
    sa.aspect_type,
    sa.aspect_version,
    sa.aspect_status,
    sa.check_type,
    ('^'::text || regexp_replace(regexp_replace(sa.url_pattern, '/\*\*'::text, '/[a-zA-z0-9\-_/]+'::text), '/\*'::text, '/[a-zA-z0-9\-_]*'::text)) || '$'::text AS url_pattern2,
    sa.order_id AS order_id2,
    NULL::varchar AS restful_id
   FROM kesplus_app.kesplus_v_aspect sa
  WHERE sa.check_type::text = '0'::bpchar::text AND sa.aspect_status::text = '1'::bpchar::text
UNION
 SELECT sa.id,
    sa.aspect_code,
    sa.aspect_name,
    sa.order_id,
    sa.fun_before,
    sa.fun_after,
    sa.fun_exception,
    sa.url_pattern,
    sa.aspect_type,
    sa.aspect_version,
    sa.aspect_status,
    sa.check_type,
    sa.url_pattern AS url_pattern2,
        CASE
            WHEN saa.order_id IS NOT NULL THEN saa.order_id
            ELSE sa.order_id
        END AS order_id2,
    saa.restful_id
   FROM kesplus_app.kesplus_v_aspect sa,
    kesplus_app.kesplus_sys_restful_aspect saa
  WHERE sa.id::text = saa.aspect_id::text AND sa.check_type::text = '1'::bpchar::text AND sa.aspect_status::text = '1'::bpchar::text
UNION
 SELECT sa.id,
    sa.aspect_code,
    sa.aspect_name,
    sa.order_id,
    sa.fun_before,
    sa.fun_after,
    sa.fun_exception,
    sa.url_pattern,
    sa.aspect_type,
    sa.aspect_version,
    sa.aspect_status,
    sa.check_type,
    ('^'::text || regexp_replace(regexp_replace(sa.url_pattern, '/\*\*'::text, '/[a-zA-z0-9\-_/]+'::text), '/\*'::text, '/[a-zA-z0-9\-_]*'::text)) || '$'::text AS url_pattern2,
    sa.order_id AS order_id2,
    NULL::varchar AS restful_id
   FROM kesplus_app.kesplus_v_aspect sa
  WHERE sa.check_type::text = '0'::bpchar::text AND sa.aspect_status::text = '1'::bpchar::text
UNION
 SELECT sa.id,
    sa.aspect_code,
    sa.aspect_name,
    sa.order_id,
    sa.fun_before,
    sa.fun_after,
    sa.fun_exception,
    sa.url_pattern,
    sa.aspect_type,
    sa.aspect_version,
    sa.aspect_status,
    sa.check_type,
    sa.url_pattern AS url_pattern2,
        CASE
            WHEN saa.order_id IS NOT NULL THEN saa.order_id
            ELSE sa.order_id
        END AS order_id2,
    saa.restful_id
   FROM kesplus_app.kesplus_v_aspect sa,
    kesplus_app.kesplus_sys_restful_aspect saa
  WHERE sa.id::text = saa.aspect_id::text AND sa.check_type::text = '1'::bpchar::text AND sa.aspect_status::text = '1'::bpchar::text;






