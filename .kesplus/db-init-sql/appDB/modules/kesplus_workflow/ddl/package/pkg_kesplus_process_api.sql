CREATE OR REPLACE PACKAGE "kesplus_workflow"."pkg_kesplus_process_api" AUTHID CURRENT_USER AS
    PROCEDURE log(v_request_id varchar,v_request_type varchar,v_request_name varchar,v_request_api_id varchar,v_request_method_id varchar ,v_flow_text TEXT) ;
    
	/**
     * plsql-api
	 * 流程执行操作
	 * 提供给业务表单调用
	 * @param formData 表单信息,包括流程信息
	 * @param callbackProcedureName 业务表单回调函数完整名称
	 */
	PROCEDURE execute_process(formData jsonb, callbackProcedureName varchar);
	
	/**
     * plsql-api
     * "kesplus_workflow"."pkg_kesplus_process_api".operation_process_instance
	 * @Description 流程操作
	 * @param processInstanceId 流程实例id
	 * @param op 流程操作 termination/invalid/activate/reBackFirst/suspend/recovery/pressTodo催办
	 * termination 终止流程
	 * invalid 作废流程
	 * activate 激活
	 * reBackFirst 撤销
	 * suspend 挂起-挂起/恢复
	 * recovery 恢复-挂起/恢复
	 * pressTodo催办
	 * @param reason 流程操作原因
	 * RETURN 返回json
	 */
	FUNCTION operation_process_instance(v_process_instance_id varchar,v_op varchar,v_reason varchar) RETURN JSON;
	/*
	 * plsql-api
	 * 根据task_id获取执行人相关信息
	 * 提供给业务表单调用
	 * @param v_task_id 任务id
	 * */
	FUNCTION get_his_assignee_by_task_id(v_task_id varchar) RETURNS jsonb;
	/**
	 * plsql-api
     * 获取表单配置信息-表单配置
     * v_process_instance_id 流程实例id
     * v_current_element_def_key 节点id
     */
	FUNCTION get_current_config(v_process_instance_id varchar, v_current_element_def_key varchar) RETURNS JSONB;
	  /**
	 * plsql-api
     * 通过节点标识获取当前节点信息(一个节点)
     * @v_wf_process：流程定义
     * @v_current_element_def_key：节点标识
     * return 当前节点信息(一个节点)
     */
	FUNCTION get_current_element(v_process_instance_id varchar, v_current_element_def_key varchar) RETURNS JSONB;
	
	PROCEDURE flash_variable_text2(v_process_instance_id varchar,v_current_element_def_key varchar);
	/*
	 * plsql-api
	 * 超时自动提交
	 * */
	PROCEDURE timeout_automatic_submit();
	
	/*
	 * plsql-api
	 * 自动发起流程
	 * v_ref_process_instance_id 来源表单对应process_instance_id
	 * v_to_form_code 当前发起表单formcode
	 * v_to_form_procedure_name 当前发起表单对应函数存储过程
	 * 
	 * */
	PROCEDURE automatic_flow_process_start(v_ref_process_instance_id varchar,v_to_form_code varchar,v_to_form_procedure_name varchar);
	/*
	 * plsql-api
	 * 自动发起流程
	 * v_request_user_id 当前发起人
	 * v_form_code 当前发起表单formcode
	 * v_form_add_procedure_name 当前发起表单对应函数存储过程
	 * v_form 当前发起表单对应数据
	 * */
	PROCEDURE automatic_flow_process_start(v_request_user_id varchar,v_form_code varchar,v_form_add_procedure_name varchar,v_form jsonb);
	
	/*
	 * plsql-api
	 * 自动办理流程
	 * v_process_instance_id 流程实例id
	 * */
	PROCEDURE automatic_flow_process_execute(v_process_instance_id varchar);
	/**
	 * plsql-api
	 * 刷新流程发起人
	 */
	PROCEDURE flash_submit_user(v_process_instance_id varchar,v_user_id varchar);
	/*
	 * plsql-api
	 * 根据process_instance_id发送通知
	 * 提供给业务表单调用
	 * @param v_process_instance_id 流程实例id
	 * @param v_reason 通知意见
	 * @param v_user_id 通知接收人
	 * */
	PROCEDURE notice_message(v_process_instance_id varchar, v_reason varchar,v_user_id varchar);
	/**
	 * plsql-api
	 * 获取待办信息
	 */
	FUNCTION get_pending_todo(v_process_instance_id varchar,v_user_id varchar) RETURN JSON;
	
	/**
	 * restful-api接口实现/kesplus_workflow/log/currentAndNext
	 * 废弃
	 * @Description 获取当前任务节点及下一任务节点
	 * @param configId 配置id
	 * @param processId 流程实例id
	 * @param taskId varchar 流程任务id
	 * RETURN 返回流程实例操作日志
	 */
	FUNCTION current_and_next_task(configId varchar,processId varchar, taskId varchar) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/deployment
	 * @Description 流程模板部署
	 * @param processKey 流程编号/流程标识
	 * @param tenantId 租户id
	 * RETURN 返回流程编号/流程定义id/租户
	 */
	FUNCTION deployment(processKey varchar, tenantId varchar) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/process/currentAndVariables
	 * @Description 获取当前流程节点及流程变量
	 * @param configId 配置id
	 * @param processId 流程实例id
	 * RETURN 返回当前流程节点及流程变量
	 */
	FUNCTION listVariablesByProcess(configId varchar,processId varchar) RETURN JSON;
	
	/**
	 * restful-api接口实现/kesplus_workflow/task/currentAndVariables
	 * @Description 获取当前任务节点及流程变量
	 * @param taskId 流程任务id
	 * RETURN 返回当前任务节点及流程变量
	 */
	FUNCTION listVariablesByTask(taskId varchar) RETURN JSON;
	
	/**
	 * restful-api接口实现/kesplus_workflow/process/handlers
	 * @Description 获取当前流程所有操作过的用户
	 * @param processId 流程实例id
	 * RETURN 获取当前流程所有操作过的用户
	 */
	FUNCTION listUsersByProcess(processId varchar) RETURN JSON ;
	/**
	 * restful-api接口实现/kesplus_workflo/mock/start
	 * @Description 流程预启动
	 * @param configId 流程配置id
	 * @param processId 流程实例id
	 * @param variables 流程变量/参数
	 * RETURN 返回当前节点及后续节点相关信息
	 */
	FUNCTION mockStartProcess(configId varchar,processId varchar,variables JSON) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/mock/complete
	 * @Description 流程预提交
	 * @param taskId 流程任务id
	 * @param variables 流程变量/参数
	 * RETURN 返回当前节点及后续节点相关信息
	 */
	FUNCTION mockCompleteTask(taskId varchar, variables json) RETURN JSON;
	  /**
     * restful-api接口实现/kesplus_workflow/instance/op
	 * @Description 流程操作
	 * @param processInstanceId 流程实例id
	 * @param op 流程操作
	 * @param reason 流程操作原因
	 * RETURN 返回json
	 */
	FUNCTION op_process_instance(processInstanceId varchar,op varchar,reason varchar) RETURN JSON;
	
	/**
	 * restful-api接口实现/kesplus_workflow/task/op
	 * @Description 任务操作
	 * 主要两种情况
	 * 撤回操作
	 * 已阅操作
	 * @param taskOpId 审批人审批操作记录id
	 * @param op 流程操作
	 * @param reason 流程操作原因
	 * @return json
	 */
	FUNCTION op_task(taskOpId varchar,op varchar,reason varchar) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/task/todo/batch_op
	 * @Description 待办任务_节点操作
	 * @param jsonData 上下文信息
	 * @return json
	 */
	FUNCTION op_todo_task(jsonData text) RETURN JSON ;
	/**
	 * restful-api接口实现/kesplus_workflow/task/todo/op
	 * @Description 待办任务_节点批量操作
	 * 主要三种情况
	 * 批量办理
	 * 批量退回上一步
	 * 批量退回申请人
	 * @param jsonData 上下文信息
	 * @return json
	 */
	FUNCTION batch_op_todo_task(jsonData text) RETURN JSON ;
	
	
	/**
	* restful-api接口实现/kesplus_workflow/modeler/add
	* @Description 模板定义_新增
	* @param text jsonData 实体参数
	* @return json 模板定义数据
	*/
    FUNCTION add_modeler(jsonData text) RETURN JSON;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/del
	* @Description 模板定义_删除
	* @param varchar ids 模板定义多个id
	* @return boolean 操作结果
	*/
    FUNCTION del_modelers(ids varchar) RETURN boolean;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/update
	* @Description 模板定义_更新
	* @param text jsonData 实体参数
	* @return json 模板定义数据
	*/
    FUNCTION update_modeler(jsonData text) RETURN JSON;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/detail
	* @Description 模板定义_详情
	* @param text 模板定义id 
	* @return json 模板定义数据
	*/
    FUNCTION get_modeler_by_id(id_ varchar) RETURN JSON;
	
	/**
	* restful-api接口实现/kesplus_workflow/modeler/content
	* @Description 模板定义_根据流程标识查询内容
	* @param 流程标识
	* @return 模板定义内容
	*/
    FUNCTION get_xml_content(processKey varchar) RETURN varchar;
    
	/**
	* restful-api接口实现/kesplus_workflow/modeler/disable
	* @Description 模板定义_启用或挂起
	* @param id_ 模板定义id 
	* @param enabled 启用或挂起标志
	* @return boolean 操作结果
	*/
    FUNCTION disabled_modeler(id_ varchar, enabled int) RETURN boolean;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/page
	* @Description 模板定义_分页查询
	* @param text jsonData 查询条件
	* @return JSON 分页查询列表
	*/
    FUNCTION page_modeler(jsonData text) RETURN JSON;
    
    /**
	* restful-api接口实现/kesplus_workflow/modeler/simple/page
	* @Description 模板定义_分页查询
	* @param text jsonData 查询条件
	* @return JSON 分页查询列表
	*/
    FUNCTION page_simple_modeler(jsonData text) RETURN JSON;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/list/config
	@Description 模板定义_获取流程配置
	* @param formCode 表单编号
	* @return json 流程配置
	*/
    FUNCTION list_config_by_form(formCode varchar) RETURN JSON;
	
     /**
      * restful-api接口实现/kesplus_workflow/modeler/page/process_form_config
	  @Description 模板定义_获取可发起流程的流程配置列表(流程已启用/已发布/已配置表单)
	* @param jsonData 
	* @return json 可发起流程的流程配置列表
	*/
    FUNCTION page_process_form_config(jsonData text) RETURN JSON;
	
    /**
	 * restful-api接口实现/kesplus_workflow/modeler/variables	
	 * @Description 模板定义_获取公共流程参数
	 * @return json 公共流程参数
	 */
    FUNCTION list_process_variables() RETURN JSON;
    /**
	 * restful-api接口实现/kesplus_workflow/modeler/buttons
	 * @Description 模板定义_获取流程按钮
	 * @return json 流程按钮
	 */
    FUNCTION list_process_buttons() RETURN JSON;
	
	
     /**
	 * restful-api接口实现/kesplus_workflow/modeler/version/detail
	 * @Description 模板定义版本_详情
	 * @param processKey 流程标识
	 * @param processVersion 流程版本
	 * @return json流程模板详情
	 */
    FUNCTION get_modeler_by_version(processKey varchar, processVersion int) RETURN JSON;
	/**
	* restful-api接口实现/kesplus_workflow/modeler/version/del
	* @Description 模板定义版本_删除
	* @param varchar ids 模板定义版本多个id
	* @return boolean 操作结果
	*/
    FUNCTION del_modeler_versions(ids varchar) RETURN boolean;
	
	/**
	* restful-api接口实现/kesplus_workflow/modeler/version/page
	* @Description 模板定义版本_分页
	* @param text jsonData 查询条件
	* @return JSON 分页查询列表
	*/
    FUNCTION page_modeler_versions(jsonData text) RETURN JSON;
    /**
	 * restful-api接口实现/kesplus_workflow/modeler/version/active
	 * @Description 模板定义版本_激活
	 * @param id 模板定义版本id
	 * @return boolean 操作结果
	 */
    FUNCTION active_modeler_versions(id varchar) RETURN boolean;
   
    /**
	 * restful-api接口实现/kesplus_workflow/modeler/version/get_process_modeler_and_form_config
	 * @Description 模板定义版本_获取流程信息及表单配置信息
	 * @param id 模板定义版本id
	 * @return boolean 操作结果
	 */
    FUNCTION get_process_modeler_and_form_config(id varchar) RETURN JSON;
    
    /**
	 * restful-api接口实现/kesplus_workflow/modeler/version/change_process_modeler_and_form_config
	 * @Description 模板定义版本_修改流程信息及表单配置信息
	 * @param id 模板定义版本id
	 * @return boolean 操作结果
	 */
    FUNCTION change_process_modeler_and_form_config(jsonData text) RETURN boolean;
    
    /**
	 * restful-api接口实现/kesplus_workflow/instance/detail
	 * @Description 获取流程详细定义信息(返回base64的xml数据)
	 * 优先通过processInstanceId流程实例id获取当前实例的详细定义信息(返回base64的xml数据)
	 * 最低通过processDefId流程定义id获取当前实例的详细定义信息(返回base64的xml数据)
	 * @param processInstanceId 流程实例id
	 * @param processDefId 流程定义id
	 * RETURN 返回base64的xml数据
	 */
	FUNCTION get_process_bpmn(processInstanceId varchar, processDefId varchar,formCode varchar :='')RETURN TEXT;
	/**
	 * restful-api接口实现/kesplus_workflow/instance/log
	 * @Description 获取流程操作记录
	 * @param processInstanceId 流程实例id
	 * RETURN 返回流程操作记录
	 */
	FUNCTION get_process_detail(processInstanceId varchar,formCode varchar :='')RETURN JSON;
	FUNCTION page_by_ops(jsonData TEXT) RETURN JSON ;
	FUNCTION page_pending_todo_by_ops(jsonData TEXT) RETURN JSON ;
	/**
     * restful-api接口实现/kesplus_workflow/starter/page
	 * @Description 分页查询我发起的流程列表
	 * @param jsonData : 查询条件
	 * RETURN 返回我发起的流程列表表
	 */
	FUNCTION page_by_starter(jsonData TEXT) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/log/flows
	 * @Description 流程图
	 * @param processInstanceId : 查询条件
	 * RETURN 流程图
	 */
	FUNCTION get_process_instance_flows(processInstanceId varchar) RETURN jsonb;
	/**
     * restful-api接口实现/kesplus_workflow/pending/current/todo/page
	 * @Description 分页查询待办任务列表
	 * @param jsonData : 查询条件
	 * RETURN 返回待办任务列表
	 */
	FUNCTION page_pending_todo(jsonData TEXT) RETURN JSON;
	/**
	 * restful-api接口实现/kesplus_workflow/pending/current/done/page
	 * @Description 分页查询已办任务列表
	 * @param jsonData : 查询条件
	 * RETURN 返回已办任务列表
	 */
	FUNCTION page_pending_done(jsonData TEXT) RETURN JSON;
	
	/**
	 * restful-api接口实现	/kesplus_workflow/pending/detail
	 * @Description 查询办理详情
	 * @param id : 查询条件id
	 * @param taskOpId taskOpId
	 * @param pendingType pendingType
	 * RETURN 返回办理详情
	 */
	FUNCTION get_pending_by_id(id varchar,taskOpId varchar,pendingType varchar) RETURN JSON;
	/**
	 * restful-api接口实现	/kesplus_workflow/pending/one
	 * @Description 查询办理已办详情
	 * @param processInstanceId : 查询条件processInstanceId
	 * @param userId userId
	 * RETURN 返回查询办理已办详情
	 */
	FUNCTION get_pending_by_business_id(businessId varchar,userId varchar) RETURN JSON ;
	
	/**
	 * restful-api接口实现	/kesplus_workflow/pending/statistics
	 * @Description 查询统一待办统计数据
	 * RETURN 返回查询统一待办统计数据
	 */
	FUNCTION get_statistics_with_pending() RETURN JSON;
	
	FUNCTION add_setting_delegation(jsonData text) RETURN JSON;
	FUNCTION del_setting_delegations(jsonData text) RETURN boolean ;
	FUNCTION update_setting_delegation(jsonData text) RETURN JSON;
	FUNCTION page_setting_delegation(jsonData TEXT) RETURN JSON;
	FUNCTION get_setting_delegation_by_id(id_ varchar) RETURN JSON;
	
	FUNCTION add_setting_comment(jsonData text) RETURN JSON;
	FUNCTION get_setting_comment(commentType varchar,processKey varchar) RETURN JSON;
	
	/**
	 * restful-api接口实现/kesplus_workflow/log/add_log
	 * 写日志
	 * @Description 写日志
	 * @param jsonData 日志内容
	 * RETURN 
	 */
	FUNCTION add_log(jsonData text) RETURN JSON;
END;

CREATE OR REPLACE PACKAGE BODY "kesplus_workflow"."pkg_kesplus_process_api" AS WRAPPED
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
END;

