-- "kes_plus"."kes_plus_view_restful_all" source

CREATE OR REPLACE FORCE VIEW "kesplus_platform"."kesplus_v_restful"
AS SELECT sa.id,
    sa.code,
    sa.path,
    sa.title,
    sa.return_type,
    sa.source_type,
    sa.sys_api,
    sa.service_code,
    sa.method,
    sa.enabled,
    sa.responsible_person,
    sa.api_version,
    regexp_like(sa.path::text, '/:[a-zA-Z0-9\-_]+'::text) AS path_type,
    regexp_replace(sa.path::text, '/:[a-zA-Z0-9\-_]+'::text, '/[a-zA-Z0-9\-_]+'::text) AS path_pattern,
    regexp_count(sa.path::text, '/[:a-zA-Z0-9\-_]+'::text) AS path_level,
    sa.sql_content,
    sa.anonymous_block,
    '0' AS belongs,
    sa."params",
    sa."module_id",
    sa."is_anonymous"
   FROM kesplus_platform.kesplus_sys_restful sa;