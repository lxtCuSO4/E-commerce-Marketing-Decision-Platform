
CREATE OR REPLACE VIEW "kesplus_app"."kesplus_v_i18n"
AS    SELECT
   	NVL(ksa."code", ksab."code") AS "code",
   	NVL(ksa."success", ksab."success") AS "success",
   	NVL(ksa."db_error", ksab."db_error") AS "db_error",
   	NVL(ksa."app_module", ksab."app_module") AS "app_module",
   	NVL2(ksa."msg", NVL2(ksab."msg", ksa."msg"::jsonb || ksab."msg"::jsonb, ksa."msg"), ksab."msg") AS "msg",
    NVL(ksa."type_code", ksab."type_code") AS "type_code"
   	FROM kesplus_platform.kesplus_sys_i18n ksa
   	FULL OUTER JOIN kesplus_app.kesplus_sys_i18n ksab ON ksa."code"  = ksab."code" ;  