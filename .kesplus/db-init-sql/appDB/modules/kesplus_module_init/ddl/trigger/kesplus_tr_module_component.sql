CREATE OR REPLACE TRIGGER "${moduleSchema}"."kesplus_tr_module_component" AFTER INSERT OR UPDATE OR DELETE ON "${moduleSchema}"."kesplus_module_component" FOR EACH ROW
declare
    parentId$ varchar;
    topDirId$ varchar;
    treeType$ varchar :='restful';
BEGIN
	IF TG_OP = 'insert' THEN
		INSERT INTO "kesplus_app"."kesplus_component"(
            "id", "name", "code", "sql_content", "columns", "params", "mappings", "module_id"
		) VALUES (
            new."id",new. "name", new."code", new."sql_content", new."columns", new."params", new."mappings", new."module_id"
		)ON CONFLICT("id") do nothing;
	ELSEIF TG_OP = 'update' THEN
		UPDATE "kesplus_app"."kesplus_component"
        SET "name"=new."name", "code"=new."code", "sql_content"=new."sql_content", "columns"=new."columns", "params"=new."params", "mappings"=new."mappings", "module_id"=new."module_id"
        WHERE "id"=new."id";
    ELSE   --delete
        DELETE FROM "kesplus_app"."kesplus_component" WHERE "id"=OLD.id;
    END IF;

END;