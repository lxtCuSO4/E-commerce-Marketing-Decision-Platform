create extension if not exists dbms_session cascade;
create extension if not exists pgjwt cascade;
create extension if not exists http cascade;
CREATE EXTENSION IF NOT EXISTS session_variable cascade;
CREATE EXTENSION IF NOT EXISTS plsql_check cascade;--需要在shared_preload_libraries中添加“plsql_check, plpgsql_check”配置
CREATE EXTENSION IF NOT EXISTS kdb_schedule cascade;
CREATE EXTENSION IF NOT EXISTS sys_kwr cascade;
CREATE EXTENSION IF NOT EXISTS plsql_plprofiler cascade;
CREATE EXTENSION IF NOT EXISTS kdb_utils_function; --用于支持驼峰和大小写的转换
CREATE EXTENSION IF NOT EXISTS dbms_metadata;
-- CREATE EXTENSION IF NOT EXISTS klog cascade;
