CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_columns"
AS SELECT n.nspname AS schema_name,
    c.relname AS table_name,
    a.attname AS column_name,
    kst."type_name" AS data_type,
    pg_get_expr(def.adbin,def.adrelid) AS column_default,
    CASE
        WHEN column_default LIKE '%nextval%' THEN TRUE
        ELSE FALSE
    END AS is_serial,
    pt."typcategory",
    a.attnum AS column_sort,
    CASE
        WHEN (a.atttypmod - 4) > 0 THEN a.atttypmod - 4
        ELSE 0
    END AS column_length,
    a.attnotnull AS column_is_not_null,
    CASE
        WHEN d.description IS NULL THEN a.attname
        ELSE d.description::name
    END AS column_description
   FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_attribute a ON a.attrelid = c.oid
    JOIN pg_type pt ON a.atttypid = pt.oid
    JOIN "kesplus_platform".kesplus_sys_type kst ON pt.oid = kst."oid"
    LEFT JOIN pg_attrdef def ON  a."attrelid" =def.adrelid and a.attnum=def.adnum
    LEFT JOIN pg_description d ON d.objoid = a.attrelid AND d.objsubid = a.attnum
  WHERE a.attnum > 0;