CREATE OR REPLACE TRIGGER "kesplus_platform"."kesplus_tr_token" AFTER insert ON "kesplus_platform"."kesplus_sys_token" FOR EACH ROW
DECLARE
	time_ int;
	count_ int;
BEGIN
	time_ := extract(epoch from now())::integer- 60 * 60 * 24;
	SELECT count(*) INTO count_ FROM "kesplus_platform"."kesplus_sys_config" ksc WHERE ksc."config_key" = 'kes_plus.token_tri' AND ksc."config_value"::int < time_ ;
	IF count_ > 0 THEN
		DELETE FROM "kesplus_platform"."kesplus_sys_token" kst WHERE kst."expired_epoch" < time_ AND kst."token_type" = 'refresh_token';
		DELETE FROM "kesplus_platform"."kesplus_sys_token" kst WHERE kst."expired_epoch" < time_ AND kst."token_type" = 'token' AND NOT EXISTS (
			SELECT t."id" FROM "kesplus_platform"."kesplus_sys_token" t WHERE t."id" = kst."refresh_id"
		);
		UPDATE "kesplus_platform"."kesplus_sys_config" ksc SET ksc."config_value" = time_::TEXT WHERE ksc."config_key" = 'kes_plus.token_tri';
	END IF;
END;