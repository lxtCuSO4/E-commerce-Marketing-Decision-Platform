CREATE OR REPLACE TRIGGER "${moduleSchema}"."trigger_module_info" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module" FOR EACH ROW
BEGIN
	IF TG_OP = 'insert' THEN
		INSERT INTO "kesplus_app"."kesplus_module" ("id", "module_name", "module_path", "module_code", "module_icon", "remark", "create_time", "create_by","app_id", "type", "enabled","status", "charge_by", "sort", "module_version", "parent_id")
		VALUES (NEW.id,NEW.module_name,NEW.module_path,NEW.module_code, NEW.module_icon,NEW.remark,NEW.create_time,NEW.create_by,NEW.app_id,NEW.type,NEW.enabled,NEW.status,NEW.charge_by,NEW.sort,NEW.module_version, new."parent_id");
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kesplus_module" SET "id"=NEW.id, "module_name"=NEW.module_name,"module_icon"=NEW.module_icon, "remark"=NEW.remark,"update_time"=NEW.update_time, "update_by"=NEW.update_by,"enabled"=NEW.enabled,"status"=NEW.status, "charge_by"=NEW.charge_by, "sort"=NEW.sort, "module_version"=NEW.module_version, "parent_id" = new."parent_id" WHERE "id"=OLD.id;
		UPDATE "kesplus_base"."kesplus_base_role" SET "id"=NEW.id, "name" = NEW.module_name,"sort_num" =NEW.sort  WHERE "name" = OLD.module_name AND id = OLD.id;
		UPDATE "kesplus_base"."kesplus_base_menu" SET "id"=NEW.id, "title" = NEW.module_name,"icon" =NEW.module_icon,"sort_num" =NEW.sort WHERE "title" = OLD.module_name AND id = OLD.id;
		UPDATE "kesplus_base"."kesplus_base_policy" SET "id"=NEW.id, "name" = NEW.module_name ,"sort_num" =NEW.sort WHERE "name" = OLD.module_name AND id = OLD.id;
		UPDATE "kesplus_base"."kesplus_base_permission" SET "id"=NEW.id, "name" = NEW.module_name ,"sort_num" =NEW.sort  WHERE "name" = OLD.module_name AND id = OLD.id;

		if (old.parent_id IS NOT NULL OR new.parent_id IS NOT NULL) AND nvl(old.parent_id, '0') != nvl(new.parent_id, '0') then
            UPDATE "kesplus_base"."kesplus_base_role" SET "update_time"=NEW.update_time, "update_by"=NEW.update_by WHERE "logical_pid" = OLD.id or parent_id = OLD.id;
            UPDATE "kesplus_base"."kesplus_base_menu" SET "update_time"=NEW.update_time, "update_by"=NEW.update_by WHERE "logical_pid" = OLD.id or parent_id = OLD.id;
            UPDATE "kesplus_base"."kesplus_base_policy" SET "update_time"=NEW.update_time, "update_by"=NEW.update_by WHERE "logical_pid" = OLD.id or parent_id = OLD.id;
            UPDATE "kesplus_base"."kesplus_base_permission" SET "update_time"=NEW.update_time, "update_by"=NEW.update_by WHERE "logical_pid" = OLD.id or parent_id = OLD.id;
		end if;
	ELSE   --delete
		DELETE FROM "kesplus_app"."kesplus_module" WHERE "id"=OLD.id;
	END IF;

END;