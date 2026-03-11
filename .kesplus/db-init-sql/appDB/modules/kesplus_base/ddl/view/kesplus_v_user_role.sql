-- "kesplus_base"."kesplus_v_user_role" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_user_role"
AS
 SELECT kar.id,
    kar.name,
    kar.enabled,
    kar.code,
    kar.role_type AS roleType,
    format('r:%s:%s', ka."code", kar."id") AS dbRoleCode,
    kar.role_level AS roleLevel,
    kar.data_scope AS dataScope,
    kar.classify,
    kaur.user_id AS userId,
    kaur.current_dept_id AS deptId,
    COALESCE(kao.tenant_id, '0'::varchar) AS tenantId
   FROM kesplus_base.kesplus_base_role kar
    JOIN kesplus_base.kesplus_user_role kaur ON kaur.role_id::text = kar.id::text
    join kesplus_platform.kes_application ka on 1=1
     LEFT JOIN kesplus_base.kesplus_dept kao ON kao.id::text = kaur.current_dept_id::text AND kao.enabled = 1
  WHERE kar.enabled = 1 AND kar.classify = 2;