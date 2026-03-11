CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_constraint"
AS
SELECT
	c.oid,
	c."conname"::varchar AS "fkName",
	n."nspname"::varchar AS "schemaName",
	t1."relname"::varchar AS "tableName",
	c."conrelid" AS "tableoid",
	t2."relname"::varchar AS "foreignTableName",
	c."confrelid" AS "foreignTableoid",
	c."contype"::varchar,
	c."conparentid"
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_namespace n ON c."connamespace" = n.oid
JOIN pg_catalog.pg_class t1 ON t1.oid=c.conrelid
LEFT JOIN pg_catalog.pg_class t2 ON t2.oid=c.confrelid;