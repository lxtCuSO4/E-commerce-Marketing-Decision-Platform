CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_userrole" AS
-- 用户与角色关联
SELECT ku."id", ku."username", kud."current_dept_id", kur."role_id"
FROM "kesplus_base"."kesplus_user" ku
JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
JOIN "kesplus_base"."kesplus_user_role" kur ON kud."current_dept_id" = kur."current_dept_id" AND kud."user_id" = kur."user_id"
UNION --公共角色
SELECT ku."id", ku."username", kud."current_dept_id", kbr."id"
FROM "kesplus_base"."kesplus_user" ku
JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
JOIN "kesplus_base"."kesplus_base_role" kbr ON kbr."classify" = 1 AND kbr."obj_type" = 'obj' AND kbr."hidden_flag" = FALSE;




CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_urole" AS
--用户与用户角色
SELECT ku."id", ku."username",
CASE WHEN kud."current_dept_id" IS NULL THEN '-1' ELSE kud."current_dept_id" END AS "current_dept_id",
CASE WHEN kud."login_flag" THEN 2 WHEN kud."default_flag" THEN 1 ELSE 0 END AS "weight",
CASE WHEN kud."current_dept_id" IS NOT NULL THEN FORMAT('u:%s:%s:%s', ka."code", ku."username", substring(md5(kud."current_dept_id"), 1, 8)) ELSE FORMAT('u:%s:%s', ka."code", ku."username") END AS "db_user_role"
FROM "kesplus_base"."kesplus_user" ku
LEFT JOIN "kesplus_platform".kes_application ka ON 1=1
LEFT JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id" ;


CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_role" AS
--角色
SELECT kbr."id", kbr."name", kbr."code", kbr."classify", kbr."role_type", FORMAT('r:%s:%s', ka."code", kbr."id") AS "db_role", kbr.module_id
FROM "kesplus_base"."kesplus_base_role" kbr
JOIN "kesplus_platform"."kes_application" ka ON 1=1
WHERE kbr."obj_type" = 'obj';


CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_user_restful" AS
--用户与restful
SELECT ku."id", ku."username", kud."current_dept_id", ksrp."restful_id"
FROM "kesplus_base"."kesplus_user" ku
JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
JOIN "kesplus_base"."kesplus_user_role" kur ON kud."current_dept_id" = kur."current_dept_id" AND kud."user_id" = kur."user_id"
JOIN "kesplus_base"."kesplus_base_role_permission" kbrp ON kur."role_id" = kbrp."role_id"
JOIN "kesplus_app"."kesplus_sys_restful_permission" ksrp ON kbrp."permission_id" = ksrp."permission_id"
JOIN "kesplus_app"."kesplus_v_restful" kvr ON ksrp."restful_id" = kvr."id" OR kvr."is_anonymous" = 1
UNION --匿名restful
SELECT ku."id", ku."username", kud."current_dept_id", kvr."id"
FROM "kesplus_base"."kesplus_user" ku
JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
JOIN "kesplus_app"."kesplus_v_restful" kvr ON kvr."is_anonymous" = 1;


CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_policy" AS
--数据权限
SELECT t."id", t."db_id", t."name", t."enabled", t."polenabled", t."db_policy_role", t.module_id,
FORMAT('CREATE ROLE "%s" WITH ADMIN "%s";', t."db_policy_role", t."db_access_role") as "create_role",
FORMAT('DROP ROLE "%s";', t."db_policy_role") as "drop_role",
FORMAT('CREATE POLICY %I ON %I.%I FOR %s TO "%s" %s', t."policy_name", t."schema_name", t."table_name", t."auth_type", t."db_policy_role", t."policy_expression") AS "create_policy",
FORMAT('DROP POLICY IF EXISTS %I ON %I.%I', t."policy_name", t."schema_name", t."table_name") AS "drop_policy",
FORMAT('GRANT %s ON TABLE %I.%I TO "%s"', t."auth", t."schema_name", t."table_name", t."db_policy_role") AS "grant_auth",
FORMAT('REVOKE %s ON TABLE %I.%I FROM "%s"', t."auth", t."schema_name", t."table_name", t."db_policy_role") AS "revoke_auth",
t."schema_name", t."table_name", st.rowsecurity, t."policy_name"
FROM (
    SELECT kbp."id", kbpd."id" as "db_id", kbp."name", kbpd."enabled", kbp."enabled" AS "polenabled", FORMAT('p:%s:%s:%s', ka."code", substring(kbpd."auth_type", 1, 1), kbpd."id") AS "db_policy_role",
        FORMAT('r:kes_plus:%s:access', ka."code") AS "db_access_role",
        kbpd.schema_name,kbpd.table_name,
        CASE
            WHEN NOT kbpd."column_flag" OR kbpd."auth_type" = 'DELETE'
                THEN kbpd."auth_type"
            ELSE
                FORMAT('%s(%s)', kbpd."auth_type", (SELECT string_agg(t."columnName", ',') FROM JSON_TABLE(kbpd.table_columns::jsonb, '$[*]' COLUMNS("checked" boolean PATH '$.checked', "columnName" VARCHAR PATH '$.columnName')) t WHERE t."checked" = TRUE))
        END AS "auth", kbpd."policy_expression", kbpd."policy_name", kbpd."auth_type", kbp.module_id
    FROM "kesplus_base"."kesplus_base_policy" kbp
    JOIN "kesplus_base"."kesplus_base_policy_db" kbpd ON kbp."id" = kbpd."policy_id"
    JOIN "kesplus_platform"."kes_application" ka ON 1=1
) AS t
JOIN sys_tables st ON st."schemaName" = t.schema_name AND st."tableName" = t.table_name;






CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_user_permission" AS
--用户与权限点
WITH RECURSIVE t AS (
     SELECT karm."role_id", kbp."code", kbp."logical_pid" AS "pid"
     FROM "kesplus_base"."kesplus_base_permission" kbp
     JOIN "kesplus_base"."kesplus_base_role_permission" karm ON kbp."id" = karm."permission_id"
     UNION
     SELECT t."role_id", kbp."code", kbp."logical_pid" AS "pid"
     FROM "kesplus_base"."kesplus_base_permission" kbp
     JOIN t ON t."pid" = kbp.id
)

SELECT r."id", r."current_dept_id", r."role_id", t."code"
FROM t
JOIN (
    SELECT ku."id", kud."current_dept_id", kur."role_id"
    FROM "kesplus_base"."kesplus_user" ku
    JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
    JOIN "kesplus_base"."kesplus_user_role" kur ON kud."current_dept_id" = kur."current_dept_id" AND kud."user_id" = kur."user_id"
    UNION --公共角色
    SELECT ku."id", kud."current_dept_id", kbr."id"
    FROM "kesplus_base"."kesplus_user" ku
    JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
    JOIN "kesplus_base"."kesplus_base_role" kbr ON kbr."classify" = 1 AND kbr."obj_type" = 'obj' AND kbr."hidden_flag" = FALSE
) AS r ON t."role_id" = r."role_id"
WHERE t."code" IS NOT NULL;



   --用户、部门、
CREATE OR REPLACE VIEW"kesplus_base"."kesplus_v_user_info" AS
SELECT ku."id", ku."username", ku."password", ku."real_name", ku."phone", ku."user_code", ku."gender", ku."email", ku."pwd_reset_time", ku."user_type", ku."user_sort", ku."enabled", ku."is_admin", ku."is_vip", ku."last_login", ku."login_lock", ku."login_lock_time", ku."user_source", ku."manager_user_id", ku."remark",
kui."nick_name", kui."avatar_path", kui."nation", kui."birthday", kui."native_place", kui."entry_date", kui."certificate_type", kui."certificate_number", kui."education", kui."urgent_phone", kui."address", kui."expansion", kui."job_level",
kd."id" AS "dept_id", kd."dept_code", kd."dept_name", kd."dept_short_name", kd."dept_common_name", kd."dept_former_name", kd."dept_type", kd."classify", kd."manager_user_id" AS "dept_manager_user_id", kd."dept_position", kd."dept_responsibility", kd."contract_user_id", kd."company_id", kd."enabled" AS "enabled1", kd."expansion" AS "dept_expansion", kd."dept_header",kd. "dept_major_leader", kd."dept_charger_leader",
kud."default_flag", kud."login_flag", kud."enabled" AS "enabled2", kd."expansion" ->> 'divisionId' AS "division_id"
FROM "kesplus_base"."kesplus_user" ku
JOIN "kesplus_base"."kesplus_user_info" kui ON ku."id" = kui."id"
JOIN "kesplus_base"."kesplus_user_dept" kud ON ku."id" = kud."user_id"
JOIN "kesplus_base"."kesplus_dept" kd ON kud."current_dept_id" = kd."id"
;






