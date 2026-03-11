CREATE OR REPLACE VIEW "${moduleSchema}"."kesplus_v_tables"
AS SELECT kt.id,
    kt.name AS table_name,
    kt.schema_name,
    kt."label" AS "comments",
    kt.module_id
   FROM "${moduleSchema}".kes_tables kt
     JOIN sys_tables t ON kt.schema_name::text = t.schemaname AND kt.name::text = t.tablename;