CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_application" AFTER UPDATE ON "kesplus_platform"."kes_application" FOR EACH ROW
BEGIN
    IF new."session_timeout" IS NOT NULL THEN
        UPDATE "kesplus_platform"."kesplus_sys_config" t SET t."config_value" = new."session_timeout" WHERE t."config_key" = 'kes_plus.jwt_exp_minutes';
        --目前与应用会话使用同一配置，后期完善，使用单独配置
        UPDATE "kesplus_platform"."kesplus_sys_config" t SET t."config_value" = new."session_timeout" WHERE t."config_key" = 'kes_plus.vs_jwt_exp_hours';
    END IF;
END;