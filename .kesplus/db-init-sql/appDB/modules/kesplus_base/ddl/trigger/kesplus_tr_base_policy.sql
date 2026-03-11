CREATE OR REPLACE TRIGGER "kesplus_base"."kesplus_tr_base_policy" AFTER INSERT OR UPDATE ON "kesplus_base"."kesplus_base_policy" FOR EACH ROW
DECLARE
    v_parent_id varchar := new.parent_id;
    v_logical_pid varchar;
    v_is_vertual boolean;
BEGIN
	SELECT ksnp.logical_pid INTO v_logical_pid FROM "kesplus_base".kesplus_base_node_mapping ksnp WHERE ksnp.node_id = NEW.id and ksnp."type_code" = 'policys';
	IF v_logical_pid IS NOT NULL THEN
		v_is_vertual := FALSE;
	ELSE
		"kesplus_app".caculate_logically('policys', new.module_id, v_parent_id, v_logical_pid, v_is_vertual);
	END IF;
    IF new."parent_id" = v_parent_id AND new."logical_pid" = v_logical_pid AND new."is_vertual" = v_is_vertual THEN

    ELSE
        update "kesplus_base"."kesplus_base_policy" t set t."parent_id"=v_parent_id, t."sort_num"=new."sort_num", t."logical_pid"=v_logical_pid, "is_vertual"=v_is_vertual where t."id" = new."id";
    end if;
END;
