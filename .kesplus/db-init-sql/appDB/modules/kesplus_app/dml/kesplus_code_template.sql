INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('1','主表新增','MATER_ADD','	FUNCTION add(jsonData jsonb) RETURN JSONB AS
	DECLARE
		--生成随机主表id
		v_id varchar := lower(sys_guid());
		v_module_code varchar;
		v_child_data jsonb;
		v_error_data jsonb;
	BEGIN
		v_module_code := COALESCE(trim(jsonData ->> ''moduleCode''), kesplus_platform.session(''serviceCode''));

		--设置默认字段的值
		jsonData := jsonData || jsonb_build_object(''{{&pk}}'',v_id,''moduleCode'',v_module_code);
{{&MATER_CHECK_FREGMANT}}
		--对主表表单数据进行校验,包括业务表字段的非空和字段长度
		call kesplus_platform.crud.check_columns(''{{&schemaName}}'',''{{&tableName}}'',jsonData,ALIAS_DEFINITION);

		--保存主表数据
		{{&MASTER_ADD_SQL}};

{{&MATER_ADD_FREGMANT}}
		--调用工作流处理逻辑
		--CALL "kesplus_workflow"."pkg_kesplus_process_api".execute_process(jsonData,''{{&schemaName}}.{{&pkgName}}.workflowCallback'');

		--返回主子表结构化数据
		RETURN get_by_id(v_id);
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END add;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('1.1','主表新增-子表片段','MATER_ADD_FREGMANT','
		--子表数据不为空,则新增1=1子表 {{&childTableName}} 数据
		IF trim(jsonData ->> ''{{&childAliasName}}'') IS NOT NULL THEN
			--获取子表数据
			v_child_data := jsonData -> ''{{&childAliasName}}'';

			--设置默认字段和关联字段的值
			v_child_data := jsonb_build_object(''{{&childIdAlias}}'',lower(sys_guid()),''moduleCode'',v_module_code) ||
							v_child_data || {{&relationColumnJson}};
{{&MATER_CHECK_FREGMANT}}
			--对子表表单数据进行校验,包括业务表字段的非空和字段长度
			call kesplus_platform.crud.check_columns(''{{&childSchemaName}}'',''{{&childTableName}}'',v_child_data,ALIAS_DEFINITION);

			--保存子表数据
			{{&CHILD_ADD_SQL}};

		END IF;
		',NULL,1,'0',NULL,NULL);

INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('2','主表更新','MATER_UPDATE','	FUNCTION update(jsonData jsonb) RETURN JSONB AS
	DECLARE
		v_child_data jsonb;
		v_exist_child_ids TEXT[];
		v_exist_child_id TEXT;
		v_error_data jsonb;
	BEGIN
{{&MATER_CHECK_FREGMANT}}
		--对主表表单数据进行校验,包括业务表字段的非空和字段长度
		call kesplus_platform.crud.check_columns(''{{&schemaName}}'',''{{&tableName}}'',jsonData,ALIAS_DEFINITION);

		--更新主表数据,若表中含有更新人id和更新时间字段,则自动更新
		{{&MASTER_UPDATE_SQL}};
{{&MATER_UPDATE_FREGMANT}}
		--调用工作流处理逻辑
		--call "kesplus_workflow"."pkg_kesplus_process_api".execute_process(jsonData::jsonb,''{{&schemaName}}.{{&pkgName}}.workflowCallback'');

		--返回主子表结构化数据
		RETURN get_by_id(jsonData->>''id'');
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END update;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('2.1','主表更新-子表片段','MATER_UPDATE_FREGMANT','
		--子表数据不为空,则新增或更新1=1子表 {{&childTableName}} 数据
		IF trim(jsonData ->> ''{{&childAliasName}}'') IS NOT NULL THEN
			--获取子表数据
			v_child_data := jsonData -> ''{{&childAliasName}}'';

			--若未传入子表id,则生成id
			v_exist_child_id :=COALESCE(trim(v_child_data ->>''{{&childIdAlias}}''), lower(sys_guid()));

			--设置默认字段和关联字段的值
			v_child_data := v_child_data || {{&relationColumnJson}} || jsonb_build_object(''{{&childIdAlias}}'',v_exist_child_id,''moduleCode'',''{{&childSchemaName}}'') ;
{{&MATER_CHECK_FREGMANT}}
			--对子表表单数据进行校验,包括业务表字段的非空和字段长度
			call kesplus_platform.crud.check_columns(''{{&childSchemaName}}'',''{{&childTableName}}'',v_child_data,ALIAS_DEFINITION);

			--表中有该主键记录,则根据主键进行记录更新,否则,进行数据新增
			{{&CHILD_MERGE_SQL}}

		END IF;
		',NULL,1,'0',NULL,NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('3', '主表删除', 'MATER_DELETE_SINGLE', '	PROCEDURE del({{&pk}}s varchar) AS
	BEGIN
		IF trim({{&pk}}s) IS NULL THEN
			RAISE EXCEPTION ''请选择删除数据'';
		END IF;

		{{&MATER_DELETE_FRAGMENT2}}
		call kesplus_platform.crud.del(''{{&schemaName}}'',''{{&tableName}}'',''{{&pk}}'',{{&pk}}s);
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION ''删除失败'';
	END del;', NULL, 1, '0', NULL, NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('4','主子表删除','MATER_DELETE','	PROCEDURE del({{&pk}}s varchar) AS
	DECLARE
		v_id varchar;
		v_data jsonb;
		v_error_data jsonb;
		v_execute_delete_sql text;
	BEGIN
		IF trim({{&pk}}s) IS NULL THEN
			RAISE EXCEPTION ''请选择删除数据!'';
		END IF;
		{{&MATER_DELETE_FRAGMENT}}

		--删除主表数据
		{{&MASTER_DELETE_SQL}};
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END del;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('4.1','主子表删除-片段1','MATER_DELETE_FRAGMENT1','	--删除子表{{&childTableName}}数据
				v_execute_delete_sql :=''{{&CHILD_DELETE_SQL}}'';
				execute v_execute_delete_sql using {{&deleteConditionParams}};
			',NULL,1,'0',NULL,NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('4.2', '主子表删除-片段2', 'MATER_DELETE_FRAGMENT2', '--删除子表{{&childTableName}}数据
		call kesplus_platform.crud.del(''{{&childSchemaName}}'',''{{&childTableName}}'',''{{&relationColumns}}'',{{&pk}}s);
		', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('4.3', '主子表删除-片段3', 'MATER_DELETE_FRAGMENT3', '		FOREACH v_id IN ARRAY (select regexp_split_to_array({{&pk}}s,'','')) LOOP
			v_data := get_by_id(v_id);
			IF v_data IS NOT NULL THEN
			{{&MATER_DELETE_FRAGMENT1}}
			END IF;
		END LOOP;', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('5', '主表详情', 'MATER_DETAIL', '	FUNCTION get_by_id({{&pk}} varchar) RETURNS JSONB AS
	DECLARE
		v_result_json jsonb;
		v_join text;
		v_columns text;
		v_child_data jsonb;
	BEGIN
		IF trim({{&pk}}) IS NULL THEN
			RAISE EXCEPTION ''{{&pk}}不能为空!'';
		END IF;
		--获取查询列
		v_columns := kesplus_platform.sql_util.columns_select(ALIAS_DEFINITION,false);
		{{&MATER_DETAIL_FRAGMENT}}
		--查询表数据
		EXECUTE kesplus_platform.json.object_sql(FORMAT(''select %s from %I.%I as t1 %s where "t1"."id" = %L'',v_columns,''{{&schemaName}}'',''{{&tableName}}'',v_join,{{&pk}}) ) INTO v_result_json;
		{{&MATER_DETAIL_FRAGMENT_1=n}}
		RETURN v_result_json;

	EXCEPTION WHEN NO_DATA_FOUND THEN
		RETURN NULL;
	END get_by_id;', NULL, 1, '0', NULL, NULL);

INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('5.1', '主表详情-子表片段', 'MATER_DETAIL_FRAGMENT', 'v_join := ''{{&tableJoinRelation}}'';', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('6', '主表列表', 'MATER_LIST', '	FUNCTION list(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql varchar;
		v_execute_sql varchar;
		v_result_json jsonb;
		v_orderby_sql text;
		v_join text;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;
		--构建查询语句
		v_execute_sql := kesplus_platform.sql_util.columns_select(ALIAS_DEFINITION,false);
		{{&MATER_LIST_FRAGMENT}}
		--拼接查询条件
		v_condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,CONDITIONS);
		v_execute_sql := format(''select %s from %I.%I as t1 %s where %s'',v_execute_sql,''{{&schemaName}}'',''{{&tableName}}'',v_join,v_condition_sql);

		--处理排序
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');
		v_execute_sql := v_execute_sql || v_orderby_sql;

		EXECUTE kesplus_platform.json.array_sql(v_execute_sql) INTO v_result_json;
		{{&MATER_LIST_FRAGMENT_1=n}}
		RETURN v_result_json;
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION ''查询失败'';
	END list;', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('6.1', '主表列表-单表片段', 'MATER_LIST_SINGLE', 'v_execute_sql := kesplus_platform.sql_util.columns_select(ALIAS_DEFINITION);', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('6.2', '主表列表-子表片段', 'MATER_LIST_FRAGMENT', 'v_join := ''{{&tableJoinRelation}}'';', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('7', '主表分页列表', 'MATER_PAGE', '	FUNCTION page(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql varchar;
		v_execute_sql text;
		v_result_json jsonb;
		v_orderby_sql varchar;
		v_join text;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;
		--构建查询语句
		v_execute_sql := kesplus_platform.sql_util.columns_select(ALIAS_DEFINITION,false);
		{{&MATER_PAGE_FRAGMENT}}

		--拼接查询条件
		v_condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,CONDITIONS);
		v_execute_sql := format(''select %s from %I.%I as t1 %s where %s'',v_execute_sql,''{{&schemaName}}'',''{{&tableName}}'',v_join,v_condition_sql);

		--处理排序
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');
		v_execute_sql := v_execute_sql || v_orderby_sql;

		SELECT kesplus_platform.page.list(v_execute_sql,(jsonData ->> ''pageIndex''),(jsonData ->> ''pageSize'')) INTO v_result_json;
		{{&MATER_PAGE_FRAGMENT_1=n}}
		RETURN v_result_json;
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION ''查询失败'';
	END page;', NULL, 1, '0', NULL, NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('8','package主模板','PACKAGE_HEADER','CREATE OR REPLACE PACKAGE "{{&schemaName}}"."{{&pkgName}}" AUTHID CURRENT_USER AS
	FUNCTION add(jsonData jsonb) RETURN JSONB;
	FUNCTION update(jsonData jsonb) RETURN JSONB;
	PROCEDURE del({{&pk}}s varchar);
	FUNCTION get_by_id({{&pk}} varchar) RETURN JSONB;
	FUNCTION list(jsonData jsonb) RETURN JSONB;
	FUNCTION page(jsonData jsonb) RETURN JSONB;
{{&ChildHeader}}
	/*工作流表单回调存储过程定义*/
	PROCEDURE workflowCallback (flowContent JSONB);

	--当前业务主表的表名
	TB_NAME VARCHAR := ''{{&tableName}}'';

	--当前业务主表的主键字段
	PK_COLUMN_NAME VARCHAR := ''{{&pk}}'';

	--分页查询页面的筛选条件 JSON数组形式,包括tableName、tableAlias、keyName、queryType和blurry
	--例如:[{"blurry": "value_a", "keyName": "columnA", "queryType": "=", "tableName": "table_a", "tableAlias": "t"}] 代表table_a的筛选条件,使用时表示为 t."columnA" = ''value_a''
	CONDITIONS JSON := ''{{&conditions}}''::JSON;

	--表单和业务字段的映射关系
	ALIAS_DEFINITION JSONB := ''{{&alias_definition}}'';
END;',NULL,1,'0',NULL,NULL);

INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('9','子表CRUD模板','CHILD_CRUD','	/**
	 * @Description 子表{{&childTableName}}新增 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/add)
	 * @param jsonData json信息
	 * @Return 返回id
	 */
	FUNCTION {{&tableAliasName}}_add(jsonData jsonb) RETURN JSONB AS
	DECLARE
		v_id varchar := lower(sys_guid());
		v_module_code varchar;
		v_data jsonb;
		v_error_data jsonb;
	BEGIN
		v_module_code :=  COALESCE(trim(jsonData ->> ''moduleCode''), kesplus_platform.session(''serviceCode''));

		--关联主表信息
		{{&CHILD_CRUD_ADD_FRAGMENT}}

		--设置默认字段的值
		jsonData := jsonData::jsonb || jsonb_build_object(''{{&childIdAlias}}'',v_id,''moduleCode'',v_module_code);
{{&MATER_CHECK_FREGMANT}}
		--对表单数据进行校验,包括业务表字段的非空和字段长度
		call kesplus_platform.crud.check_columns(''{{&childSchemaName}}'',''{{&childTableName}}'',jsonData,ALIAS_DEFINITION);

		{{&MASTER_ADD_SQL}};

		RETURN {{&tableAliasName}}_get_by_id(v_id);
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_add;

	/**
	 * @Description 子表{{&childTableName}}更新 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/update)
	 * @param jsonData json信息
	 * @Return 返回id
	 */
	FUNCTION {{&tableAliasName}}_update(jsonData jsonb) RETURN JSONB AS
	DECLARE
		v_error_data jsonb;
	BEGIN
{{&MATER_CHECK_FREGMANT}}
		--对表单数据进行校验,包括业务表字段的非空和字段长度
		call kesplus_platform.crud.check_columns(''{{&childSchemaName}}'',''{{&childTableName}}'',jsonData,ALIAS_DEFINITION);

		{{&MASTER_UPDATE_SQL}};

		RETURN {{&tableAliasName}}_get_by_id(jsonData ->> ''{{&pkAlias}}'');
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_update;

	/**
	 * @Description 子表{{&childTableName}}删除 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/del)
	 * @param  主键，多个{{&pk}}使用逗号分隔
	 * @Return
	 */
	PROCEDURE {{&tableAliasName}}_del({{&pk}}s varchar) AS
	DECLARE
		v_id varchar;
		v_error_data jsonb;
	BEGIN
		IF trim({{&pk}}s) IS NULL THEN
			RAISE EXCEPTION ''请选择删除数据!'';
		END IF;

		--删除子表数据
		{{&MASTER_DELETE_SQL}};
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_del;

	/**
	 * @Description 子表{{&childTableName}}详情 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/detail)
	 * @param  主键
	 * @Return json
	 */
	FUNCTION {{&tableAliasName}}_get_by_id({{&pk}} varchar) RETURNS JSONB AS
	DECLARE
		v_result_json jsonb;
		v_error_data jsonb;
		v_execute_get_query_sql text;
	BEGIN
		IF trim({{&pk}}) IS NULL THEN
			RAISE EXCEPTION ''请输入查询条件!'';
		END IF;

		--查询语句,其中查询条件和排序规则使用占位符
		v_execute_get_query_sql :=''{{&MASTER_GET_QUERY_SQL}}'';

		--进行详细查询，结果为json对象形式
		EXECUTE kesplus_platform.json.object_sql(format(v_execute_get_query_sql,format(''where %s.id=%L'',''{{&tableQueryAlias}}'',id),'''')) INTO v_result_json;

		return v_result_json;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN NULL;
			WHEN OTHERS THEN
	 			v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_get_by_id;


	 /**
	 * @Description 子表{{&childTableName}}列表查询 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/list)
	 * @param jsonData json信息查询条件
	 * @Return json
	 */
	FUNCTION {{&tableAliasName}}_list(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql text;
		v_orderby_sql text;
		v_relation_conditions jsonb :=''{{&childConditions}}'';
		v_result_json jsonb;
		v_error_data jsonb;
		v_execute_list_query_sql text;
	BEGIN
		--构建查询条件
		v_condition_sql := ''where ''|| kesplus_platform.search_model.getConditionSql(jsonData, v_relation_conditions);

		--构建排序规则
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');

		--查询语句，其中查询条件和排序规则使用占位符
		v_execute_list_query_sql :=''{{&MASTER_LIST_QUERY_SQL}}'';

		--进行列表查询，结果为json数组形式
		EXECUTE kesplus_platform.json.array_sql(format(v_execute_list_query_sql,v_condition_sql,nvl(v_orderby_sql,'' ''))) INTO v_result_json;

		RETURN v_result_json;
		EXCEPTION
			WHEN OTHERS THEN
	 			v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_list;

	/**
	 * @Description 子表{{&childTableName}}分页查询 (已发布RESTful:/{{&childSchemaName}}/{{&tableName}}/{{&childTableName}}/page)
	 * @param jsonData json信息查询条件
	 * @Return json
	 */
	FUNCTION {{&tableAliasName}}_page(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql text;
		v_orderby_sql text;
		v_all jsonb;
		v_sql jsonb;
		v_relation_conditions jsonb :=''{{&childConditions}}'';
		v_result_json jsonb;
		v_error_data jsonb;
		v_execute_count_query_sql text;
		v_execute_page_query_sql text;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;

		--构建查询条件
		v_condition_sql := '' where '' || kesplus_platform.search_model.getConditionSql(jsonData, v_relation_conditions);

		--构建排序规则
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');

		--数量统计查询语句,筛选条件使用占位符
		v_execute_count_query_sql :=''{{&MASTER_COUNT_QUERY_SQL}}'';

		--查询语句,其中查询条件和排序规则使用占位符
		v_execute_page_query_sql :=''{{&MASTER_PAGE_QUERY_SQL}}'';

		--进行分页查询
		SELECT kesplus_platform.page.page(jsonb_build_object(''countSql'',format(v_execute_count_query_sql,v_condition_sql),''querySql'',format(v_execute_page_query_sql,v_condition_sql || '' limit $1 offset $2'',nvl(v_orderby_sql,'' ''))),(jsonData ->> ''pageIndex''),(jsonData ->> ''pageSize'')) INTO v_result_json;

		RETURN v_result_json;
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END {{&tableAliasName}}_page;',NULL,1,'0',NULL,NULL);

INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('9.1','子模板crud-add片段','CHILD_CRUD_ADD_FRAGMENT1','if trim(jsonData ->> ''$id'') is not null then
			--根据主教查询主表数据，然后获取关联字段的值
			v_data := get_by_id(jsonData ->> ''$id'');
			jsonData := jsonData || {{&relationColumnJson}};
		end if;
		',NULL,1,'0',NULL,NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('10', '别名定义模板', 'ALIAS_DEFINITION', 'ALIAS_DEFINITION := {{&alias_definition}};', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('11', '子表CRUD模板header', 'CHILD_CRUD_HEADER', '	FUNCTION {{&tableAliasName}}_add(jsonData jsonb) RETURN JSONB;
	FUNCTION {{&tableAliasName}}_update(jsonData jsonb) RETURN JSONB;
	PROCEDURE {{&tableAliasName}}_del({{&pk}}s varchar);
	FUNCTION {{&tableAliasName}}_get_by_id({{&pk}} varchar) RETURNS JSONB;
	FUNCTION {{&tableAliasName}}_list(jsonData jsonb) RETURNS JSONB;
	FUNCTION {{&tableAliasName}}_page(jsonData jsonb) RETURNS JSONB;', NULL, 1, '0', NULL, NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('12','package主模板body','PACKAGE_BODY','CREATE OR REPLACE PACKAGE BODY "{{&schemaName}}"."{{&pkgName}}" AS

	/**
	* @Description 保存主子表表单数据 (已发布RESTful:/{{&schemaName}}/{{&tableName}}/add)
	* @param jsonData JSONB 结构化的表单数据对象,格式为：{"param1": "value1","param2": "value2"} 如想要取某个值，可以使用jsonData->>''param1''
	* @Return JSONB 返回包含主表id的结构化数据
	*/
{{&materAddFregmant}}


	/**
	* @Description 更新主子表数据 (已发布RESTful:/{{&schemaName}}/{{&tableName}}/update)
	* @param jsonData JSONB 结构化的表单数据对象 格式为：{"param1": "value1","param2": "value2"} 如想要取某个值，可以使用jsonData->>''param1''
	* @Return JSONB 返回包含主表id的结构化数据
	*/
{{&materUpdateFragment}}

	/**
	* @Description 删除（支持批量删除） (已发布RESTful:/{{&schemaName}}/{{&tableName}}/del)
	* @param {{&pk}}s 主键，多个{{&pk}}使用逗号分隔
	* @Return
	*/
{{&materDeleteFragment}}

	/**
	* @Description 根据主键查询详情 (已发布RESTful:/{{&schemaName}}/{{&tableName}}/detail)
	* @param {{&pk}}_ 主键
	* @Return json
	*/
{{&materDetailFragment}}

	/**
	* @Description 列表查询  (已发布RESTful:/{{&schemaName}}/{{&tableName}}/list)
	* @param jsonData json信息查询条件
	* @Return json
	*/
{{&materListFragment}}


	/**
	* @Description 分页查询 (已发布RESTful:/{{&schemaName}}/{{&tableName}}/page)
	* @param jsonData json信息查询条件
	* @Return json
	*/
{{&materPageFragment}}
{{&materDelConditionFragment}}
{{&materUpdateConditionFragment}}
{{&materGetConditionFragment}}
	/**
	* @Description 工作流表单回调存储过程实现
	* @param flowContent 流程上下文信息
	*/
	PROCEDURE workflowCallback(flowContent JSONB) AS
	DECLARE
		v_business_id varchar;
		v_process_instance_id varchar;
		v_process_status varchar;
	BEGIN
		/*表单id*/
		v_business_id := flowContent ->>''business_id'';
		/*流程实例id*/
		v_process_instance_id := flowContent ->>''process_instance_id'';
		v_process_status := flowContent ->>''process_status'';

		/*流程启动后*/
		IF v_process_status = ''start'' THEN
			/*表单更新操作*/
			/*示例如下，请根据实际业务需求进行调整*/
			/*
			update "{{&tableName}}" set status=2,process_id=v_process_instance_id where id= v_business_id;
			*/
		END IF;

		/*流程完成后*/
		IF v_process_status = ''end'' THEN
			/*表单更新操作*/
			/*示例如下，请根据实际业务需求进行调整*/
			/*
			update "{{&tableName}}" set status=4 where id= v_business_id;
			*/
		END IF;

		/*流程撤回后*/
		IF v_process_status = ''cancel'' THEN
			/*表单更新操作*/
			/*示例如下，请根据实际业务需求进行调整*/
			/*
			update "{{&tableName}}" set status=5,process_id=null where id= v_business_id;
			*/
		END IF;

	END workflowCallback;


	{{&ChildBody}}
END;',NULL,1,'0',NULL,NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('13', '主表查询-根据条件', 'MATER_QUERY', '	FUNCTION get_by_condition(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_result_json jsonb;
		v_join text;
		v_columns text;
		v_where_sql text;
		v_error_data jsonb;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;
		--获取查询列
		v_columns := kesplus_platform.sql_util.columns_select(ALIAS_DEFINITION,false);
		{{&MATER_DETAIL_FRAGMENT}}
		v_where_sql  := kesplus_platform.utils.whereSql(jsonData,''t1'');
		--查询表数据
		EXECUTE kesplus_platform.json.object_sql(FORMAT(''select %s from %I.%I as t1 %s where %s'',v_columns,''{{&schemaName}}'',''{{&tableName}}'',v_join,v_where_sql ) ) INTO v_result_json;
		RETURN v_result_json;

	EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION ''查询结果包含多行记录'';
        WHEN OTHERS THEN
		 	v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
			kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END get_by_condition;', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('14', '主表多条件删除', 'MATER_DELETE_CONDITION', '	PROCEDURE del_by_condition(jsonData jsonb) AS
	DECLARE
		v_where_sql TEXT;
		v_error_data jsonb;
	BEGIN

		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;
		--获取删除条件
		v_where_sql  := kesplus_platform.utils.whereSql(jsonData);
		{{&MATER_DELETE_CONDITION_FRAGMENT}}
		EXECUTE FORMAT(''delete from "{{&schemaName}}"."{{&tableName}}" where %s'',v_where_sql);
		EXCEPTION
			WHEN OTHERS THEN
		 	v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
			kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END del_by_condition;', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('14.1', '主表多条件删除-子表片段', 'MATER_DELETE_CONDITION_FRAGMENT', '--删除{{&childTableName}}子表数据
		EXECUTE FORMAT(''delete from "{{&childSchemaName}}"."{{&childTableName}}" where ({{&relationColumns}}) in(
		select {{&parentColumns}} from "{{&childSchemaName}}"."{{&tableName}}" where %s)'',v_where_sql);

		', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('15', '主表多条件更新', 'MATER_UPDATE_CONDITION', '	PROCEDURE update_by_condition(jsonData jsonb) AS
	DECLARE
		v_condition_data JSONB; --条件数据
		v_update_data JSONB; --更新数据
		v_set_clause TEXT;
		v_where TEXT;
		v_error_data jsonb;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;
	 	v_condition_data := jsonData -> ''conditionData'';
	 	v_update_data := jsonData -> ''updateData'';

		v_where := kesplus_platform.utils.whereSql(v_condition_data);
		{{&MATER_UPDATE_CONDITION_FRAGMENT}}
		--更新主表数据
		v_set_clause := kesplus_platform.utils.setClause(v_update_data);

	 	EXECUTE FORMAT(''update %I.%I set %s where %s'',''{{&schemaName}}'',''{{&tableName}}'',v_set_clause ,v_where );
		EXCEPTION
			WHEN OTHERS THEN
		 	v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
			kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END update_by_condition;', NULL, 1, '0', NULL, NULL);
INSERT INTO "kesplus_app"."kesplus_code_template" ("id", "name", "code", "content", "description", "type", "pid", "create_time", "update_time") VALUES('15.1', '主表多条件更新-子片段', 'MATER_UPDATE_CONDITION_FRAGMENT', '--更新子表{{&childTableName}}数据
		v_set_clause := kesplus_platform.utils.setClause(v_update_data -> ''{{&childAliasName}}'');
		EXECUTE FORMAT(''update %I.%I set %s from %I.%I where %s and %s'',''{{&childSchemaName}}'',''{{&childTableName}}'',v_set_clause ,''{{&childSchemaName}}'',''{{&tableName}}'',''{{&onField}}'',v_where);
		v_update_data := v_update_data - ''{{&childTableName}}'';--删除子表对象
		', NULL, 1, '0', NULL, NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('6.3','主表列表-子表片段-1对N','MATER_LIST_FRAGMENT_1=n','--如需一次性返回全部子表数据，则取消注释
		--SELECT jsonb_agg(get_by_id(value->>''id'')) INTO v_result_json FROM jsonb_array_elements(v_result_json) AS value;
',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('7.2','主表分页列表-子表片段-1对N','MATER_PAGE_FRAGMENT_1=n','--如需一次性返回全部子表数据，则取消注释
		--SELECT v_result_json || jsonb_build_object(''content'',jsonb_agg(get_by_id(value->>''id''))) INTO v_result_json FROM jsonb_array_elements(v_result_json->''content'')  AS value;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('5.2','主表详情-子表片段-1对N','MATER_DETAIL_FRAGMENT_1=n','--如需一次性返回全部子表数据，则取消注释
		--EXECUTE kesplus_platform.json.array_sql("kesplus_platform"."crud_util".select(''{{&childSchemaName}}'',''{{&childTableName}}'') || FORMAT(''where %s=$1'',''{{&relationColumns}}'')) INTO v_child_data USING v_result_json ->> ''{{&parentColumns}}'' ;
		--v_result_json :=v_result_json || jsonb_build_object(''{{&childAliasName}}'',v_child_data);',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('2.2','主表更新-子表片段-1对N','MATER_UPDATE_FREGMANT_1=n','
		--更新1=N子表 {{&childTableName}} 数据
		v_exist_child_ids :=null;
		FOR childObject IN SELECT jsonb_array_elements(jsonData->''{{&childAliasName}}'') value LOOP
			--若未传入子表id,则生成id
			v_exist_child_id :=COALESCE(trim(childObject.value ->>''{{&childIdAlias}}''),lower(sys_guid()));

			--设置默认字段和关联字段的值
			v_child_data :=childObject.value::jsonb || {{&relationColumnJson}} || jsonb_build_object(''{{&childIdAlias}}'',v_exist_child_id,''moduleCode'',''{{&childSchemaName}}'');
{{&MATER_CHECK_FREGMANT}}
			--对子表表单数据进行校验,包括业务表字段的非空和字段长度
			call kesplus_platform.crud.check_columns(''{{&childSchemaName}}'',''{{&childTableName}}'',v_child_data,ALIAS_DEFINITION);

			--表中有该主键记录,则根据主键进行记录更新,否则,进行数据新增
			{{&CHILD_MERGE_SQL}}

			--记录新增或者更新的记录的主键
			v_exist_child_ids :=array_append(v_exist_child_ids,v_exist_child_id);

		END LOOP;

		--将不包含在当前记录的主键集合中的子表数据全部清除
		EXECUTE format(''DELETE FROM %s.%s WHERE "id" NOT IN (SELECT UNNEST($1)) AND {{&deleteCondition}}'',''{{&childSchemaName}}'',''{{&childTableName}}'') USING v_exist_child_ids,{{&deleteConditionParams}};
		',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('7.1','主表分页列表-子表片段','MATER_PAGE_FRAGMENT','v_join := ''{{&tableJoinRelation}}'';',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
    ('1.2','主表新增-子表片段-1对N','MATER_ADD_FREGMANT_1=n','
		--保存1=N子表 {{&childTableName}} 数据
		FOR childObject IN SELECT jsonb_array_elements(jsonData->''{{&childAliasName}}'') value LOOP
			PERFORM {{&childAliasName}}_add(childObject.value ::jsonb || jsonb_build_object(''$id'',v_id));
		END LOOP;
		',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('5_V2','主表详情','MATER_DETAIL_V2','	FUNCTION get_by_id({{&pk}} varchar) RETURNS JSONB AS
	DECLARE
		v_result_json jsonb;
		v_execute_get_query_sql text;
	BEGIN
		IF trim({{&pk}}) IS NULL THEN
			RAISE EXCEPTION ''{{&pk}}不能为空'';
		END IF;

		--查询语句,其中查询条件和排序规则使用占位符
		v_execute_get_query_sql :=''{{&MASTER_GET_QUERY_SQL}}'';

		--进行详细查询，结果为json对象形式
		EXECUTE kesplus_platform.json.object_sql(format(v_execute_get_query_sql,format(''where "t1"."id" = %L'',id),'''')) INTO v_result_json;

		RETURN v_result_json;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN NULL;
	END get_by_id;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('6_V2','主表列表','MATER_LIST_V2','	FUNCTION list(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql text;
		v_orderby_sql text;
		v_result_json jsonb;
		v_error_data jsonb;
		v_execute_list_query_sql text;
	BEGIN
		--构建查询条件
		v_condition_sql := ''where ''|| kesplus_platform.search_model.getConditionSql(jsonData, CONDITIONS);

		--构建排序规则
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');

		--查询语句，其中查询条件和排序规则使用占位符
		v_execute_list_query_sql :=''{{&MASTER_LIST_QUERY_SQL}}'';

		--进行列表查询，结果为json数组形式
		EXECUTE kesplus_platform.json.array_sql(format(v_execute_list_query_sql,v_condition_sql,nvl(v_orderby_sql,'' ''))) INTO v_result_json;

		RETURN v_result_json;
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END list;',NULL,1,'0',NULL,NULL);
INSERT INTO kesplus_app.kesplus_code_template ("id","name","code","content","description","type","pid","create_time","update_time") VALUES
	 ('7_V2','主表分页列表','MATER_PAGE_V2','	FUNCTION page(jsonData jsonb) RETURNS JSONB AS
	DECLARE
		v_condition_sql varchar;
		v_orderby_sql text;
		v_result_json jsonb;
		v_error_data jsonb;
		v_execute_count_query_sql text;
		v_execute_page_query_sql text;
	BEGIN
		IF jsonData IS NULL THEN
			RAISE EXCEPTION ''请输入数据'';
		END IF;

		--构建查询条件
		v_condition_sql := ''where ''|| kesplus_platform.search_model.getConditionSql(jsonData, CONDITIONS);

		--构建排序规则
		v_orderby_sql := "kesplus_platform"."utils".get_order_by_sql(jsonData ->> ''orderColumns'');

		--数量统计查询语句,主子表为1=1关系,则只统计主表数量即可
		v_execute_count_query_sql :=''{{&MASTER_COUNT_QUERY_SQL}}'';

		--查询语句,其中查询条件和排序规则使用占位符
		v_execute_page_query_sql :=''{{&MASTER_PAGE_QUERY_SQL}}'';

		--进行分页查询
		SELECT kesplus_platform.page.page(jsonb_build_object(''countSql'',format(v_execute_count_query_sql,v_condition_sql),''querySql'',format(v_execute_page_query_sql,v_condition_sql,nvl(v_orderby_sql,'' '')  || '' limit $1 offset $2'')),(jsonData ->> ''pageIndex''),(jsonData ->> ''pageSize'')) INTO v_result_json;

		RETURN v_result_json;
		EXCEPTION
			WHEN OTHERS THEN
		 		v_error_data :=kesplus_platform.EXCEPTION.errdata(SQLSTATE);
				kesplus_platform.business_exception(v_error_data->>''code'',v_error_data->>''msg'');
	END page;',NULL,1,'0',NULL,NULL);