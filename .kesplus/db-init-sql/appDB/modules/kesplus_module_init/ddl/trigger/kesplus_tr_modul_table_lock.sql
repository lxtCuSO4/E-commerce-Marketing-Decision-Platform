CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_table_lock" BEFORE DELETE OR UPDATE ON "${moduleSchema}"."kes_tables" FOR EACH ROW
declare
    user_id_ varchar;
    hold_lock_user_ varchar;
    hold_lock_user_realname_ varchar;
BEGIN
    user_id_ := "kesplus_platform".user('userId');
    if user_id_ is not null then
        select t.hold_lock_user into hold_lock_user_ from "kesplus_app"."kes_app_sql_property_lock" t where t.sql_property_id= old.id and t.sql_property_type in (0,1);

        SELECT realname INTO hold_lock_user_realname_ FROM "kesplus_platform".kes_sys_user WHERE id =hold_lock_user_;

        if hold_lock_user_ != user_id_ then
            raise exception '表或视图:%正在由%编辑,请先获取编辑锁',OLD.name,hold_lock_user_realname_;
        end if;
    end if;
END;