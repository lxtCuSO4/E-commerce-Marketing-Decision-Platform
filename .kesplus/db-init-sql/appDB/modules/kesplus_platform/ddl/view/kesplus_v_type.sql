CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_type" AS
SELECT DISTINCT
    t.typname AS systypname,
    regexp_replace(format_type(t.oid, NULL),'pg_catalog.([a-zA-Z\[\]]+)','\1','g') AS aliastypname,
    CASE WHEN t.typelem > 0 THEN t.typelem ELSE t.oid END AS elemoid,
    typlen,
    typtype,
    t.oid,
    nspname,
    nspname <> 'sys_catalog' AS "isSysCatalog",
    nspname <> 'public' AS "isPlublic",
    (SELECT COUNT(1) > 1 FROM pg_type t2 WHERE t2.typname = t.typname) AS isdup,
    CASE WHEN t.typcollation != 0 THEN TRUE ELSE FALSE END AS is_collatable
FROM pg_type t
JOIN pg_namespace nsp ON typnamespace = nsp.oid
WHERE t.typname != 'unknown'
    AND nspname != 'information_schema'
    AND t.typcategory not in ('P','X','Y')
    AND t.typname not like 'pg_%'
    AND t.typname not like '_pg_%'
    AND t.typname not like 'dbms_%' --dbms SQL
    AND t.typname not like '_dbms_%' --dbms sql
    AND t.typname not like '%_unconstrained'--dbms SQL
    AND t.typname not like '%cstring%'
    AND t.typname not in('time_stamp', '_time_stamp', 'character_data', '_character_data', 'cardinal_number', '_cardinal_number', 'sql_identifier', '_sql_identifier', 'yes_or_no', '_yes_or_no')  --information_schema专用特殊数据类型
    AND t.typname not in('bpcharbyte', '_bpcharbyte', 'varcharbyte', '_varcharbyte')--使用默认NLS_LENGTH_SEMANTICS确定是 char还是byte
    AND aliastypname NOT IN ('"char"', '"char"[]')
    AND format_type(t.oid, NULL) not in ('pg_catalog.date', 'pg_catalog.date[]')
    AND typisdefined --过滤未定义的占位符，比如shell类型
    AND typtype not in ('r', 'p')--过滤掉 范围类型和伪类型
    AND (t.typrelid=0  OR t.typnamespace = 'public'::regnamespace)
    AND NOT EXISTS (SELECT 1 FROM pg_class WHERE relnamespace=typnamespace AND relname = typname AND relkind != 'c')
    AND (typname NOT LIKE '_%' OR NOT EXISTS (
        SELECT 1 FROM pg_class
        WHERE relnamespace=typnamespace AND relname = substring(typname FROM 2)::name AND relkind != 'c')
    )
    ORDER BY regexp_replace(aliastypname, '"([a-zA-Z\[\]\.]+)"', '\1', 'g'), isSysCatalog, isPlublic, nspname	;