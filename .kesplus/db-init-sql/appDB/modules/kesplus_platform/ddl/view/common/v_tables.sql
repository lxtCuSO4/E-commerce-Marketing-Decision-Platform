-- "kesplus_platform"."v_tables" source

CREATE OR REPLACE VIEW "kesplus_platform"."v_tables"
AS SELECT t.tablename,
    t.schemaname,
    atc.comments,
    t.rowsecurity
   FROM sys_tables t
     LEFT JOIN user_tab_comments atc ON t.tablename = atc.table_name::text AND atc.table_type::text = 'TABLE'::text;