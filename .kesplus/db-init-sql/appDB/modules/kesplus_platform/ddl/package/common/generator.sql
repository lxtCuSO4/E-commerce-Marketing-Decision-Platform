CREATE OR REPLACE PACKAGE "kesplus_platform"."generator" AUTHID CURRENT_USER AS
    

    PKG_HEADER_TEMPLATE text :=
'CREATE OR REPLACE PACKAGE "{{&schemaname}}"."{{&pkgname}}" AUTHID CURRENT_USER AS
    function add(jsonData json) return json;
    procedure add(jsonData json);
    procedure del({{&pk}}s varchar);
    procedure del_by_condition(jsonData json);
    function update(jsonData json) return json;
    procedure update_by_condition(jsonData json);
    function get_by_id({{&pk}}_ varchar) return json;
    function get_by_condition(jsonData json) return json;
    function list(jsonData json) return json;
    function page(jsonData json) return json;
    function is_exists({{&pk}}_ varchar) return boolean;
    /*工作流表单回调存储过程定义*/
    PROCEDURE workflowCallback (flowContent JSONB);
    TB_NAME VARCHAR := ''{{&tablename}}'';
    PK_COLUMN_NAME VARCHAR := ''{{&pk}}'';
    CONDITIONS JSON := ''{{&conditions}}''::JSON;
end;';
    PKG_BODY_TEMPLATE text :=
'CREATE OR REPLACE PACKAGE BODY "{{&schemaname}}"."{{&pkgname}}" AS
    /**
     * @Description 新增 (已发布RESTful:/{{&schemaname}}/{{&tablename}}/add)
     * @param jsonData json信息
     * @Return 返回id
     */
    function add(jsonData json) return json as
    declare
    	_data jsonb;
    	id varchar := lower(sys_guid());
        moduleCode$ varchar;
    begin
        moduleCode$:=jsonData ->>''moduleCode'';

        IF trim(moduleCode$) is null THEN
            moduleCode$ :=kesplus_platform.session(''serviceCode'');
        END IF;

	    _data := jsonData::jsonb || jsonb_build_object(''{{&pk}}'',id,''moduleCode'',moduleCode$);
        call kesplus_platform.crud.save(''{{&schemaname}}'',TB_NAME,_data);

        --调用工作流处理逻辑*/
        --CALL "kesplus_workflow"."pkg_kesplus_process_api".execute_process(_data::jsonb,''{{&schemaname}}.{{&pkgname}}.workflowCallback'');

        return json_build_object(''{{&pk}}'',id);
     end;

    /**
	 * @Description 新增(无返回值)
	 * @param jsonData json信息
	 */
    procedure add(jsonData json) as
    declare
    	_data jsonb;
    	id varchar := lower(sys_guid());
        moduleCode$ varchar;
    begin
        moduleCode$:=jsonData ->>''moduleCode'';

        IF trim(moduleCode$) is null THEN
            moduleCode$ :=kesplus_platform.session(''serviceCode'');
        END IF;

	    _data := jsonData::jsonb || jsonb_build_object(''{{&pk}}'',id,''moduleCode'',moduleCode$);
        call kesplus_platform.crud.save(''{{&schemaname}}'',TB_NAME,_data);

     end;

    /**
     * @Description 删除（支持批量删除） (已发布RESTful:/{{&schemaname}}/{{&tablename}}/del)
     * @param {{&pk}}s 主键，多个{{&pk}}使用逗号分隔
     * @Return
     */
    procedure del({{&pk}}s varchar) as
    begin
        call kesplus_platform.crud.del(''{{&schemaname}}'',TB_NAME,PK_COLUMN_NAME,{{&pk}}s);
    end;

    /**
     * @Description 根据条件删除
     * @param jsonData 条件数据
     * @Return
     */
    procedure del_by_condition(jsonData json) AS
    declare
    	delete_sql TEXT := ''delete from "%s"."%s" where %s'';
    	condition_sql TEXT;
    begin
	    --获取删除条件
		condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,CONDITIONS);

		--执行删除语句 无条件将删除全部数据。
	    execute format(delete_sql,''{{&schemaname}}'',TB_NAME,condition_sql);
    end;

    /**
     * @Description 更新 (已发布RESTful:/{{&schemaname}}/{{&tablename}}/update)
     * @param jsonData json信息
     * @Return json
     */
    function update(jsonData json) return json as
    begin
	    if trim(jsonData::jsonb->>''{{&pk}}'') is null then
            "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_app".error_code.KESPLUS_FORMDATA_CAN_NOT_BE_EMPTY_1006, array[''{{&pk}}'']);
        end if;

        call kesplus_platform.crud.update(''{{&schemaname}}'',TB_NAME,PK_COLUMN_NAME,jsonData);

        --调用工作流处理逻辑
        --CALL "kesplus_workflow"."pkg_kesplus_process_api".execute_process(jsonData::jsonb,''{{&schemaname}}.{{&pkgname}}.workflowCallback'');

        return json_build_object(''{{&pk}}'',jsonData ->> ''{{&pk}}'');
     end;

    /**
     * @Description 根据查询条件更新
     * @param jsonData json信息 示例：{"conditionData":{"name":"beijing"},"updateData":{"name":"shanghai","address":"中国"}}
     * @Return json
     */
     procedure update_by_condition(jsonData json) as
     declare
     	condition_data JSON; --条件数据
     	update_data JSON; --更新数据
     	set_clause TEXT;
     	_sql TEXT;
     begin

	 	condition_data := jsonData -> ''conditionData'';
	 	update_data := jsonData -> ''updateData'';

	 	--构建查询条件
	 	_sql := kesplus_platform.search_model.getConditionSql(condition_data,CONDITIONS);

	 	with json_entries as (
	 		select key,value from json_each_text(update_data)
	 	)
	 	select array_to_string(
	 	    array_agg(quote_ident(kesplus_platform.utils.camel_to_underline(key)) || '' = '' || quote_literal(value)),'','')
	 	into set_clause
	 	from json_entries;

        if set_clause is null then
            "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_platform".error_code.KESPLUS_GENERATOR_UPDATE_DATA_NULL);
        end if;

        if _sql is null then
            "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_platform".error_code.KESPLUS_GENERATOR_CONDITION_DATA_NULL);
        end if;

	 	execute format(''update "{{&schemaname}}"."{{&tablename}}" set %s where %s'',set_clause,_sql);
	 end;


    /**
     * @Description 根据主键查询详情 (已发布RESTful:/{{&schemaname}}/{{&tablename}}/detail)
     * @param {{&pk}}_ 主键
     * @Return json
     */
    function get_by_id({{&pk}}_ varchar) returns json as
    declare
        result_json json;
    begin
        return kesplus_platform.crud.get_by_id(''{{&schemaname}}'',TB_NAME,PK_COLUMN_NAME,{{&pk}}_);

    exception when no_data_found then
        return null;
    end;

    /**
     * @Description 根据条件查询详情
     * @jsonData 查询条件 {"whereColumns":"column1,column2","queryValues":"val1,val2"}
     * @Return json
     */
    function get_by_condition(jsonData json) return json AS
    declare
        whereColumns text[];
        queryValues text[];
    BEGIN
	    --获取查询条件 逗号分隔转数组
	    whereColumns := string_to_array(jsonData ->> ''whereColumns'','','');
	    queryValues := string_to_array(jsonData ->> ''queryValues'','','');

        --查询数据
	    return kesplus_platform.crud.get_one(''{{&schemaname}}'',TB_NAME,whereColumns,queryValues);

    exception when too_many_rows then
        "kesplus_platform"."exception"("kesplus_platform"."exception".TYPE_PLATFORM, "kesplus_platform".error_code.KESPLUS_GENERATOR_GET_MORE_ERROR);
     end;

    /**
     * @Description 列表查询  (已发布RESTful:/{{&schemaname}}/{{&tablename}}/list)
     * @param jsonData json信息查询条件
     * @Return json
     */
    function list(jsonData json) returns json as
    declare
        condition_sql varchar;
        execute_sql varchar;
        result_json json;
    begin
        --构建查询语句
        execute_sql := "kesplus_platform"."crud_util".select(''{{&schemaname}}'', TB_NAME);

        --拼接查询条件
        condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,CONDITIONS);
		execute_sql := format(''%s where %s'',execute_sql,condition_sql);

        execute kesplus_platform.json.array_sql(execute_sql) into result_json;
        return result_json;
    end;

    /**
     * @Description 分页查询 (已发布RESTful:/{{&schemaname}}/{{&tablename}}/page)
     * @param jsonData json信息查询条件
     * @Return json
     */
    function page(jsonData json) returns json as
    declare
        condition_sql varchar;
        execute_sql text;
        result_json json;
        _bean bean;
        orderby_sql varchar;
    begin
        _bean.obj := jsonData;

        --构建查询语句
        execute_sql := "kesplus_platform"."crud_util".select(''{{&schemaname}}'', TB_NAME);

        --拼接查询条件
		condition_sql := kesplus_platform.search_model.getConditionSql(jsonData,CONDITIONS);
		execute_sql := format(''%s where %s'',execute_sql,condition_sql);

	    --处理排序
		orderby_sql := "kesplus_platform"."utils".get_order_by_sql(_bean.getString(''orderColumns''));
		execute_sql := execute_sql || orderby_sql;

        select kesplus_platform.page.list(execute_sql,_bean.getInteger(''pageIndex''),_bean.getInteger(''pageSize'')) into result_json;
        return result_json;
    end;

    /**
     * @Description 根据主键查询记录是否存在
     * @param {{&pk}}_ 主键{{&pk}}
     * @Return true or false
     */
    function is_exists({{&pk}}_ varchar) return boolean as
    BEGIN

		perform 1 from "{{&schemaname}}"."{{&tablename}}" where "{{&pk}}" = {{&pk}}_;
		if found then
			return true;
		end if;

		return false;
	end;

    /**
     * @Description 工作流表单回调存储过程实现
     * @param flowContent 流程上下文信息
     */
	PROCEDURE workflowCallback(flowContent JSONB) AS
	DECLARE
		businessId$ varchar;
		processInstanceId$ varchar;
		processStatus$ varchar;
	BEGIN
	    /*表单id*/
	    businessId$ := flowContent ->>''business_id'';
	    /*流程实例id*/
	    processInstanceId$ := flowContent ->>''process_instance_id'';
	    processStatus$ := flowContent ->>''process_status'';

	    /*流程启动后*/
	    IF processStatus$ = ''start'' THEN
	      /*表单更新操作*/
	      /*示例如下，请根据实际业务需求进行调整*/
		  /*
		  update "{{&tablename}}" set status=2,process_id=processInstanceId$ where id= businessId$;
		  */
	    END IF;

	     /*流程完成后*/
	    IF processStatus$ = ''end'' THEN
	      /*表单更新操作*/
	      /*示例如下，请根据实际业务需求进行调整*/
		  /*
		   update "{{&tablename}}" set status=4 where id= businessId$;
		  */
	    END IF;

	    /*流程撤回后*/
	    IF processStatus$ = ''cancel'' THEN
	      /*表单更新操作*/
	      /*示例如下，请根据实际业务需求进行调整*/
		  /*
		  update "{{&tablename}}" set status=5,process_id=null where id= businessId$;
		  */
	    END IF;

	END;


end;';

    /**
     * 获得CRUD包
     */
    function get_crud_package(jsonData varchar) return text[];
    /**
     * 根据参数信息生成注释格式
     */
    FUNCTION comment_text(code varchar,params JSON,description TEXT,returnType varchar) RETURN TEXT;
end;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."generator" AS WRAPPED
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
END;

