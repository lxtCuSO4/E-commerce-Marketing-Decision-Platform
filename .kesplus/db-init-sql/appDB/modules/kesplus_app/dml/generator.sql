INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('3', 'form_function_detail', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_detail"({{&pk}} varchar) return json as
declare
    result_json json;
begin
    if {{&pk}} is null then
    	"kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_SELECT_PARA_NOT_EMPTY_1031); --raise exception ''查询参数不能为空'';
    end if;
    return kesplus_platform.crud.get_by_id(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',{{&pk}});
end;', '单表详情模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('12', 'form_add_segment', '
	IF _bean.isNotNull(''{{&tableName}}'') THEN
		FOR rec IN SELECT json_array_elements(_bean.getJson(''{{&tableName}}'')) val LOOP
			call kesplus_platform.crud.save(''{{&schemaName}}'',''{{&tableName}}'',rec.val::jsonb || jsonb_build_object(''{{&pk}}'',lower(sys_guid())));
		END LOOP;
	END IF;', '一对多新增模板片段');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('4', 'form_function_update', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_update"(jsonData text) return json as
declare
    _bean bean :=bean(jsonData::json);
begin
    if jsonData is null then
	    "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_INPUT_DATA_1035); 	--raise exception ''请输入数据'';
    end if;
    call kesplus_platform.crud.update(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',jsonData::json);
    return "{{&schemaName}}"."fun_form_{{&tableName}}_detail"(_bean.getString(''{{&pk}}''));
end;', '单表更新模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('6', 'form_function_page', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_page"(jsonData text) returns json as
declare
    condition_sql varchar;
    execute_sql text;
    result_json json;
    _bean bean :=bean(jsonData::json);
    orderby_sql varchar;
	conditions query[] := array[{{&conditions}}]::query[];
begin
    condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,conditions);
    execute_sql := ''select {{&selectFields}} from "{{&schemaName}}"."{{&tableName}}"'';
	if condition_sql IS NOT NULL then
		execute_sql := execute_sql || '' where  ''|| condition_sql;
	end if;
	orderby_sql := "kesplus_platform"."utils".get_order_by_sql(_bean.getString(''orderColumns''));
	execute_sql := execute_sql || orderby_sql;
    select kesplus_platform.page.list(execute_sql,_bean.getInteger(''pageIndex''),_bean.getInteger(''pageSize'')) into result_json;
    return result_json;
end;', '单表分页查询模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('2', 'form_function_add', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_add"(jsonData text) return json as
declare
    _id varchar;
    _bean bean = bean(jsonData::json);
begin
    _id := lower(sys_guid());
    _bean.set(''{{&pk}}'',_id);
    call kesplus_platform.crud.save(''{{&schemaName}}'',''{{&tableName}}'',_bean.obj);
    return "{{&schemaName}}"."fun_form_{{&tableName}}_detail"(_id);
end;', '单表新增模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('9', 'form_function_detail2', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_detail"({{&pk}} varchar) return json as
declare
    result_json json;
begin
    if {{&pk}} is null then
    	"kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_SELECT_PARA_NOT_EMPTY_1031);  --raise exception ''查询参数不能为空'';
    end if;
    result_json := kesplus_platform.crud.get_by_id(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',{{&pk}});
	{{&detailChildTables}}
	return result_json;
end;', '一对多详情模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('7', 'form_function_add2', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_add"(jsonData text) return json as
declare
    _id varchar;
    _bean bean = bean(jsonData::json);
begin
    _id := lower(sys_guid());
    _bean.set(''{{&pk}}'',_id);
    call kesplus_platform.crud.save(''{{&schemaName}}'',''{{&tableName}}'',_bean.obj);
	{{&saveChildTables}}
    return "{{&schemaName}}"."fun_form_{{&tableName}}_detail"(_id);
end;', '一对多新增模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('8', 'form_function_update2', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_update"(jsonData text) return json as
declare
    _bean bean := bean(jsonData::json);
	childBean bean;
begin
    if jsonData is null then
	    "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_INPUT_DATA_1035); --raise exception ''请输入数据'';
    end if;
    call kesplus_platform.crud.update(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',jsonData::json);
	{{&updateChildTables}}
    return "{{&schemaName}}"."fun_form_{{&tableName}}_detail"(_bean.getString(''{{&pk}}''));
end;', '一对多更新模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('11', 'form_update_segment2', '
	IF _bean.isNotNull(''{{&tableName}}'') THEN
		childBean := bean(_bean.getJson(''{{&tableName}}''));
		IF childBean.get(''$delFlag'') = TRUE THEN
			call kesplus_platform.crud.del(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',childBean.get(''{{&pk}}''));
		END IF;
		IF childBean.isNull(''{{&pk}}'') THEN
			childBean.set(''{{&pk}}'',lower(sys_guid()));
			call kesplus_platform.crud.save(''{{&schemaName}}'',''{{&tableName}}'',childBean.obj);
		ELSE
			call kesplus_platform.crud.update(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',childBean.obj);
		END IF;
	END IF;', '一对一更新模板片段');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('1', 'form_update_segment3', '
	IF _bean.isNotNull(''{{&tableName}}'') THEN
		FOR rec IN SELECT json_array_elements(_bean.getJson(''{{&tableName}}'')) val LOOP
			childBean := bean(rec.val);
			IF childBean.get(''$delFlag'')::boolean = TRUE THEN
				call kesplus_platform.crud.del(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',childBean.get(''{{&pk}}''));
			END IF;
			IF childBean.isNull(''{{&pk}}'') THEN
				childBean.set(''{{&pk}}'',lower(sys_guid()));
				call kesplus_platform.crud.save(''{{&schemaName}}'',''{{&tableName}}'',childBean.obj);
			ELSE
				call kesplus_platform.crud.update(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',childBean.obj);
			END IF;
		END LOOP;
	END IF;', '一对多更新模板片段');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('5', 'form_procedure_delete', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_delete"({{&pk}} varchar) return json as
begin
    if {{&pk}} is null then
    	"kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_SELECT_DELETE_DATA_1036); --raise exception ''请选择删除数据'';
    end if;
    for rec in select unnest(string_to_array({{&pk}},'','')) val loop
		call kesplus_platform.crud.del(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',rec.val);
	end loop;
	return json_build_object();
end;', '单表删除模板');
INSERT INTO "kesplus_app"."kes_ddl_template" ("id", "code", "content", "description") VALUES('10', 'form_procedure_delete2', 'create or replace function "{{&schemaName}}"."{{&formCode}}_{{&tableName}}_delete"({{&pk}} varchar) return json as
declare
	result_json json;
begin
    if {{&pk}} is null then
    	"kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_GENERATOR_SELECT_DELETE_DATA_1036); --raise exception ''请选择删除数据'';
    end if;
    for rec in select unnest(string_to_array({{&pk}},'','')) val loop
		result_json := kesplus_platform.crud.get_by_id(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',rec.val);
		if result_json is not null then
			call kesplus_platform.crud.del(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',rec.val);
			{{&deleteChildTables}}
		end if;
	end loop;
	return json_build_object();
end;', '一对多删除模板');
