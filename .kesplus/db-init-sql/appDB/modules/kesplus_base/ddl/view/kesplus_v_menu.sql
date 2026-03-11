-- "kesplus_base"."kesplus_v_menu" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_menu"
AS
SELECT kam.id,
    kam.logical_pid AS parentId,
    kam.title AS name,
    kamm.title AS parentName,
    kam.code,
    kam.icon,
    NVL(int4(kam.enabled), 1) AS enabled,
    kam.hidden_flag AS hiddenFlag,
    kam.outer_link AS outerLink,
    kam.classify,
    kam.tenant_id AS tenantId,
    kam.module_id AS moduleId,
    kam.obj_type AS objType,
    kk.module_code AS moduleCode,
    kk.module_path AS modulePath,
    kk.sort AS moduleSort,
    CASE kam.parent_id WHEN '0'::text THEN kk.sort ELSE kam.sort_num END AS sortNum,
    t."sourceType",
    t.component,
    t."url"
FROM kesplus_base.kesplus_base_menu kam
JOIN (
    SELECT k."id", t0."sourceType", t0."url", t0."component"
    FROM kesplus_base.kesplus_base_menu k
    CROSS JOIN JSON_TABLE(k."properties"::jsonb, '$[*]' COLUMNS (
        "sourceType" varchar PATH '$.sourceType', "url" varchar PATH '$.url', "component" varchar PATH '$.component'
    )) AS t0
    WHERE t0."sourceType" != 'pc'
    UNION ALL
    SELECT k."id", 'pc', k."url", k."component"
    FROM kesplus_base.kesplus_base_menu k
) AS t ON kam."id" = t."id"
JOIN kesplus_app.kesplus_module kk ON kam.module_id::text = kk.id::text
LEFT JOIN kesplus_base.kesplus_base_menu kamm ON kam.parent_id::text = kamm.id::text and kamm.is_vertual = false
WHERE kam.is_vertual = false;