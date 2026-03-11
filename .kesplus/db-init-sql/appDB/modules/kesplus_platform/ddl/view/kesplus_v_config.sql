-- "kes_plus"."kes_plus_view_config_all" source

CREATE OR REPLACE VIEW "kesplus_platform"."kesplus_v_config"
AS SELECT kesplus_sys_config.config_key,
    kesplus_sys_config.config_value,
    kesplus_sys_config.scope,
    kesplus_sys_config.scope_id
   FROM kesplus_platform.kesplus_sys_config
  WHERE kesplus_sys_config.is_deleted = 0 AND kesplus_sys_config.scope::integer = 1
UNION ALL
 SELECT kesplus_sys_config.config_key,
    kesplus_sys_config.config_value,
    kesplus_sys_config.scope,
    kesplus_sys_config.scope_id
   FROM kesplus_platform.kesplus_sys_config
  WHERE kesplus_sys_config.is_deleted = 0 AND kesplus_sys_config.scope::integer = 2;