-- "kesplus_app"."kesplus_v_version" source

CREATE OR REPLACE VIEW "kesplus_app"."kesplus_v_version"
AS SELECT ksa.id,
    ksa.version_code,
    ksa.version_name,
    ksa.version_desc,
    ksa.version_type,
    ksa.version_status,
    ksa.effect_time,
    ksa.create_time,
    ksa.create_by,
    ksa.update_time,
    ksa.update_by
   FROM kesplus_platform.kesplus_sys_version ksa
UNION
 SELECT ksa.id,
    ksa.version_code,
    ksa.version_name,
    ksa.version_desc,
    ksa.version_type,
    ksa.version_status,
    ksa.effect_time,
    ksa.create_time,
    ksa.create_by,
    ksa.update_time,
    ksa.update_by
   FROM kesplus_app.kesplus_sys_version ksa;