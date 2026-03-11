-- "kesplus_app"."kesplus_v_auth" source

CREATE OR REPLACE VIEW "kesplus_app"."kesplus_v_auth"
AS SELECT ksa.id,
    ksa.auth_type,
    ksa.schema_name,
    ksa.object_type,
    ksa.object_name,
    ksa.role_name,
    ksa.create_by,
    ksa.create_time,
    ksa.update_by,
    ksa.update_time,
    ksa.is_deleted,
    ksa.dept_id,
    ksa.current_company
   FROM kesplus_platform.kesplus_sys_auth ksa
UNION
 SELECT ksa.id,
    ksa.auth_type,
    ksa.schema_name,
    ksa.object_type,
    ksa.object_name,
    ksa.role_name,
    ksa.create_by,
    ksa.create_time,
    ksa.update_by,
    ksa.update_time,
    ksa.is_deleted,
    ksa.dept_id,
    ksa.current_company
   FROM kesplus_app.kesplus_sys_auth ksa;