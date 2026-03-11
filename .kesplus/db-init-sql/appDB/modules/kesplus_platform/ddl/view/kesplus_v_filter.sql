-- "kesplus_platform"."kesplus_v_filter" source

CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_filter"
AS SELECT ksa.id,
    ksa.filter_code,
    ksa.filter_name,
    ksa.filter_order,
    ksa.include_urls,
    ksa.exclude_urls,
    ksa.post_method,
    ksa.complete_method,
    ksa.filter_type,
    ksa.filter_version,
    ksa.filter_status,
    ksa.create_time,
    ksa.create_by,
    ksa.update_time,
    ksa.update_by,
    ksa.is_deleted
   FROM kesplus_platform.kesplus_sys_filter ksa;