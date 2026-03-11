CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_table_before" BEFORE DELETE ON "${moduleSchema}"."kes_tables" FOR EACH ROW
BEGIN
    if old."obj_type" = 'obj' and old."directory_code" = 'table' then
       	IF "kesplus_app"."kesplus_pkg_module_policy".count_by_table(old."schema_name", old."name") > 0 THEN
			RAISE EXCEPTION '请先删除该表相关数据权限';
        END IF;
    end if;
END;