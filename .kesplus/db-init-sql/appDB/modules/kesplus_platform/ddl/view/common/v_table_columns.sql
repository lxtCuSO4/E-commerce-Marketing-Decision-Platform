-- "kesplus_platform"."v_table_columns" source

CREATE OR REPLACE VIEW "kesplus_platform"."v_table_columns"
AS SELECT c.table_schema,
    c.table_name,
    c.column_name,
    c.data_type,
    c.ordinal_position,
    null as "comments",
    c.is_nullable
   FROM information_schema.columns c;