CREATE OR REPLACE PACKAGE "kesplus_workflow"."entity_record" AUTHID CURRENT_USER AS

	 TYPE act_re_deployment_record IS RECORD (
        id_   character varying(64 char),
        name_   character varying(255 char),
        deploy_time_   timestamp,
        source_   character varying(255 char),
        tenant_id_   character varying(64 char)
      );
      
      TYPE act_ge_bytearray_record IS RECORD (
       	id_ character varying(64 char) ,
	    rev_ integer ,
	    name_ character varying(255 char) ,
	    deployment_id_ character varying(64 char) ,
	    bytes_ bytea ,
	    generated_ boolean ,
	    tenant_id_ character varying(64 char) ,
	    type_ integer ,
	    create_time_ timestamp ,
	    root_proc_inst_id_ character varying(64 char) ,
	    removal_time_ timestamp
      );
      

	 TYPE act_re_procdef_record IS RECORD (
		id_ character varying(64 char) ,
		rev_ integer ,
		category_ character varying(255 char) ,
		name_ character varying(255 char) ,
		key_ character varying(255 char) ,
		version_ integer ,
		deployment_id_ character varying(64 char) ,
		resource_name_ character varying(4000 char) ,
		dgrm_resource_name_ character varying(4000 char) ,
		has_start_form_key_ boolean ,
		suspension_state_ integer ,
		tenant_id_ character varying(64 char) ,
		version_tag_ character varying(64 char) ,
		history_ttl_ integer ,
		startable_ boolean 
	);
	
	TYPE act_hi_varinst_record IS RECORD (
		id_ character varying(64 char) ,
		proc_def_key_ character varying(255 char) ,
		proc_def_id_ character varying(64 char) ,
		root_proc_inst_id_ character varying(64 char) ,
		proc_inst_id_ character varying(64 char) ,
		execution_id_ character varying(64 char) ,
		act_inst_id_ character varying(64 char) ,
		case_def_key_ character varying(255 char) ,
		case_def_id_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		case_execution_id_ character varying(64 char) ,
		task_id_ character varying(64 char) ,
		name_ character varying(255 char) ,
		var_type_ character varying(100 char) ,
		create_time_ timestamp without time zone ,
		rev_ integer ,
		bytearray_id_ character varying(64 char) ,
		double_ double precision ,
		long_ bigint ,
		text_ character varying(4000 char) ,
		text2_ character varying(4000 char) ,
		tenant_id_ character varying(64 char) ,
		state_ character varying(20 char) ,
		removal_time_ timestamp without time zone
	);

    TYPE act_hi_taskinst_record IS RECORD (
		id_ character varying(64 char) ,
		proc_def_key_ character varying(255 char) ,
		proc_def_id_ character varying(64 char) ,
		root_proc_inst_id_ character varying(64 char) ,	
		proc_inst_id_ character varying(64 char) ,
		execution_id_ character varying(64 char) ,
		case_def_key_ character varying(255 char) ,
		case_def_id_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		case_execution_id_ character varying(64 char) ,
		act_inst_id_ character varying(64 char) ,
		name_ character varying(255 char) ,
		parent_task_id_ character varying(64 char) ,
		description_ character varying(4000 char) ,
		owner_ character varying(255 char) ,
		assignee_ character varying(4000 char) ,
		start_time_ timestamp without time zone ,
		end_time_ timestamp without time zone ,
		duration_ bigint ,
		delete_reason_ character varying(4000 char) ,
		task_def_key_ character varying(255 char) ,
		priority_ integer ,
		due_date_ timestamp without time zone ,
		follow_up_date_ timestamp without time zone ,
		tenant_id_ character varying(64 char) ,
		removal_time_ timestamp without time zone 
	);	
	
	TYPE act_hi_procinst_record IS RECORD (
		id_ character varying(64 char)  ,
		proc_inst_id_ character varying(64 char)  ,
		business_key_ character varying(255 char) ,
		proc_def_key_ character varying(255 char) ,
		proc_def_id_ character varying(64 char)  ,
		start_time_ timestamp without time zone  ,
		end_time_ timestamp without time zone ,
		removal_time_ timestamp without time zone ,
		duration_ bigint ,
		start_user_id_ character varying(255 char) ,
		start_act_id_ character varying(255 char) ,
		end_act_id_ character varying(255 char) ,
		super_process_instance_id_ character varying(64 char) ,
		root_proc_inst_id_ character varying(64 char) ,
		super_case_instance_id_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		delete_reason_ character varying(4000 char) ,
		tenant_id_ character varying(64 char) ,
		state_ character varying(255 char)
	);

	TYPE act_hi_actinst_record IS RECORD (
		id_ character varying(64 char) ,
		parent_act_inst_id_ character varying(64 char) ,
		proc_def_key_ character varying(255 char) ,
		proc_def_id_ character varying(64 char) ,
		root_proc_inst_id_ character varying(64 char) ,
		proc_inst_id_ character varying(64 char) ,
		execution_id_ character varying(64 char) ,
		act_id_ character varying(255 char) ,
		task_id_ character varying(64 char) ,
		call_proc_inst_id_ character varying(64 char) ,
		call_case_inst_id_ character varying(64 char) ,
		act_name_ character varying(255 char) ,
		act_type_ character varying(255 char) ,
		assignee_ character varying(4000 char) ,
		start_time_ timestamp without time zone ,
		end_time_ timestamp without time zone ,
		duration_ bigint ,
		act_inst_state_ integer ,
		sequence_counter_ bigint ,
		tenant_id_ character varying(64 char) ,
		removal_time_ timestamp without time zone 
	);

	TYPE act_ru_execution_record IS RECORD (
		id_ character varying(64 char) ,
		rev_ integer ,
		root_proc_inst_id_ character varying(64 char) ,
		proc_inst_id_ character varying(64 char) ,
		business_key_ character varying(255 char) ,
		parent_id_ character varying(64 char) ,
		proc_def_id_ character varying(64 char) ,
		super_exec_ character varying(64 char) ,
		super_case_exec_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		act_id_ character varying(255 char) ,
		act_inst_id_ character varying(64 char) ,
		is_active_ boolean ,
		is_concurrent_ boolean ,
		is_scope_ boolean ,
		is_event_scope_ boolean ,
		suspension_state_ integer ,
		cached_ent_state_ integer ,
		sequence_counter_ bigint ,
		tenant_id_ character varying(64 char) 
	);

	
	TYPE act_ru_task_record IS RECORD (
		id_ character varying(64 char) ,
		rev_ integer ,
		execution_id_ character varying(64 char) ,
		proc_inst_id_ character varying(64 char) ,
		proc_def_id_ character varying(64 char) ,
		case_execution_id_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		case_def_id_ character varying(64 char) ,
		name_ character varying(255 char) ,
		parent_task_id_ character varying(64 char) ,
		description_ character varying(4000 char) ,
		task_def_key_ character varying(255 char) ,
		owner_ character varying(255 char) ,
		assignee_ character varying(4000 char) ,
		delegation_ character varying(500 char) ,
		priority_ integer ,
		create_time_ timestamp without time zone ,
		due_date_ timestamp without time zone ,
		follow_up_date_ timestamp without time zone ,
		suspension_state_ integer ,
		tenant_id_ character varying(64 char)
	);

	
	TYPE act_ru_variable_record IS RECORD (
		id_ character varying(64 char) ,
		rev_ integer ,
		type_ character varying(255 char) ,
		name_ character varying(255 char) ,
		execution_id_ character varying(64 char) ,
		proc_inst_id_ character varying(64 char) ,
		proc_def_id_ character varying(64 char) ,
		case_execution_id_ character varying(64 char) ,
		case_inst_id_ character varying(64 char) ,
		task_id_ character varying(64 char) ,
		batch_id_ character varying(64 char) ,
		bytearray_id_ character varying(64 char) ,
		double_ double precision ,
		long_ bigint ,
		text_ character varying(4000 char) ,
		text2_ character varying(4000 char) ,
		var_scope_ character varying(64 char) ,
		sequence_counter_ bigint ,
		is_concurrent_local_ boolean ,
		tenant_id_ character varying(64 char) 
	);


type modeler_record is record (
		id character varying(32 char) ,
		module_id character varying(32 char) ,
		tenant_id character varying(32 char) ,
		process_key character varying(64 char) ,
		process_name character varying(255 char) ,
		bytes_ bytea ,
		process_type smallint ,
		process_type_name character varying(255 char) ,
		deployed integer  ,
		enabled tinyint ,
		create_by character varying(32 char) ,
		create_time timestamp without time zone ,
		update_by character varying(32 char) ,
		update_time timestamp without time zone ,
		del tinyint ,
		biz_meta text ,
		dept_id character varying(32 char) ,
		module_code character varying(128 char) ,
		process_version integer
	);
    type modeler_version_record is record (
	    id character varying(32 char) ,
    	process_key character varying(64 char) ,
    	process_version integer  default 1,
    	bytes_ bytea ,
    	actived tinyint ,
    	create_by character varying(32 char) ,
    	create_time timestamp without time zone ,
    	update_by character varying(32 char),
    	update_time timestamp without time zone,
    	del tinyint ,
    	dept_id character varying(32 char),
    	module_code character varying(128 char),
    	process_type integer ,
    	process_name character varying(256 char) ,
    	process_def_id character varying(128 char) ,
    	variables json ,
    	process_flows jsonb ,
    	process_title character varying(255 char)
    );


	TYPE process_record IS RECORD (
	    id character varying(32 char) ,
		form_code character varying(64 char) ,
		business_id character varying(64 char) ,
		form_role_id character varying(64 char) ,
		process_key character varying(64 char) ,
		process_instance_id character varying(64 char) ,
		root_process_instance_id character varying(64 char) ,
		parent_process_instance_id character varying(64 char)  ,
		submit_user_id character varying(32 char) ,
		submit_user_name character varying(64 char) ,
		submit_time timestamp without time zone ,
		complete_user_id character varying(32 char) ,
		complete_time timestamp without time zone ,
		process_status character varying(32 char)  ,
		dept_id character varying(32 char)  ,
		dept_name character varying(64 char)  ,
		module_code character varying(128 char)  ,
		process_result integer ,
		process_version integer ,
		start_node_id varchar ,
		start_node_name varchar ,
		end_node_id varchar ,
		end_node_name varchar ,
		config_id varchar ,
		title character varying(255 char) ,
		variables json ,
		path character varying(500 char) ,
		form_vue character varying(255 char) ,
		form_type integer ,
		process_variables json ,
		end_flows jsonb ,
		create_time timestamp without time zone ,
		process_type integer ,
		process_name character varying(256 char)
	);
	TYPE task_record IS RECORD (
		    id character varying(32 char) ,
	    	process_instance_id character varying(64 char)  ,
	    	execution_id character varying(64 char) ,
	    	create_by character varying(32 char)  ,
	    	create_time timestamp without time zone  ,
	    	task_def_key character varying(64 char) ,
	    	prev_task_def_key character varying(64 char) ,
	    	task_status smallint ,
	    	task_result character varying(32 char) ,
	    	complete_time timestamp without time zone ,
	    	handler_id character varying(32 char) ,
	    	handler_name character varying(64 char) ,
	    	handler_dept_id character varying(32 char)  ,
	    	handler_dept_name character varying(64 char) ,
	    	
	    	owner_id character varying(32 char) ,
	    	owner_name character varying(64 char) ,
	    	owner_dept_id character varying(32 char)  ,
	    	owner_dept_name character varying(64 char) ,
	    	
	    	dept_id character varying(32 char)  ,
	    	module_code character varying(128 char)  ,
	    	task_id character varying(64 char)  ,
	    	task_name character varying(128 char) ,
	    	prefix_id character varying(64 char)  ,
	    	can_retract integer ,
	    	op_status smallint  ,
	    	update_by varchar ,
	    	update_time timestamp without time zone ,
	    	variables json ,
	    	task_flows jsonb
	);


	TYPE task_assignee_record IS RECORD (
		    id character varying(32 char) ,
	    	task_id character varying(32 char) ,
	    	assignee_id character varying(32 char) ,
	    	assignee_name character varying(64 char) ,
	    	assignee_dept_id character varying(32 char)  ,
	    	assignee_dept_name character varying(64 char) ,
	    	delegation_id character varying(500 char) ,
	    	delegation_name character varying(500 char) ,
	    	delegation_dept_id character varying(500 char)  ,
	    	delegation_dept_name character varying(500 char) ,
	    	task_op_id character varying(64 char)
	);

	TYPE log_record IS RECORD (
	    id character varying(32 char),
		process_instance_id character varying(64 char),
		execution_id character varying(64 char) ,
		task_id character varying(64 char) ,
		handle_type smallint  ,
		handle_result smallint  ,
		create_by character varying(32 char),
		create_time timestamp without time zone,
		handle_time timestamp without time zone,
		handler_id character varying(32 char),
		handler_name character varying(64 char),
		handler_dept_id character varying(32 char) ,
		handler_dept_name character varying(64 char) ,
		handle_opinions json ,
		dept_id character varying(32 char)  ,
		module_code character varying(128 char)  ,
		task_def_key character varying(64 char) ,
		task_name character varying(128 char) ,
		task_op_id varchar
	);


	TYPE pending_record IS RECORD (
		id character varying(32 char) ,
		module_code character varying(50 char) ,
		dept_id character varying(32 char) ,
		type character varying(64 char) ,
		title character varying(256 char) ,
		path character varying(500 char) ,
		create_time timestamp without time zone ,
		create_by character varying(32 char) ,

		submit_user_id character varying(32 char) ,
        submit_user_name character varying(64 char) ,
        submit_time timestamp without time zone ,
        submit_dept_id character varying(32 char) ,
        submit_dept_name character varying(64 char),

		update_time timestamp without time zone ,
		update_by character varying(32 char) ,
		status tinyint ,
		variables json ,
		pending_key character varying(128 char) ,
		pending_id character varying(128 char) ,
		task_def_key character varying(64 char) ,
        task_id character varying(64 char),
        task_name character varying(128 char),
		complete_time timestamp without time zone ,
		business_id character varying(32 char) ,
		form_vue character varying(255 char) ,
		real_name character varying(256 char) ,
	    process_type integer ,
	    process_instance_id character varying(64 char) ,
	    process_status character varying(32 char) ,
	    dept_name character varying(64 char),
	    category character varying(64 char),
	    has_open tinyint,
	    can_batch tinyint
	);

	TYPE pending_assign_record IS RECORD (
		id character varying(32 char) ,
		module_code character varying(50 char) ,
		dept_id character varying(32 char) ,
		pending_id character varying(32 char) ,
		
		assignee_id character varying(32 char) ,
		assignee_dept_id character varying(32 char) ,
		assignee_name character varying(32 char) ,
		assignee_dept_name character varying(128 char) ,
		
    	delegation_id character varying(500 char) ,
    	delegation_dept_id character varying(500 char)  ,
    	delegation_name character varying(500 char) ,
    	delegation_dept_name character varying(500 char) ,
    	
		create_time timestamp without time zone ,
		create_by character varying(32 char) ,
		update_time timestamp without time zone ,
		update_by character varying(32 char)
	);

	TYPE pending_his_record IS RECORD (
		id character varying(32 char) ,
		module_code character varying(50 char) ,
		dept_id character varying(32 char) ,
		type character varying(64 char) ,
		title character varying(256 char) ,
		path character varying(500 char) ,
		create_time timestamp without time zone ,
		create_by character varying(32 char) ,

		submit_user_id character varying(32 char) ,
        submit_user_name character varying(64 char) ,
        submit_time timestamp without time zone ,
        submit_dept_id character varying(32 char) ,
        submit_dept_name character varying(64 char),

		update_time timestamp without time zone ,
		update_by character varying(32 char) ,
		
		handler_id character varying(32 char) ,
		handler_dept_id character varying(32 char) ,
		handler_name character varying(32 char) ,
		handler_dept_name character varying(128 char) ,
		
    	owner_id character varying(32 char) ,
    	owner_name character varying(64 char) ,
    	owner_dept_id character varying(32 char)  ,
    	owner_dept_name character varying(64 char) ,
		
		status tinyint ,
		variables json ,
		pending_key character varying(128 char) ,
		pending_id character varying(128 char) ,
        task_def_key character varying(64 char) ,
        task_id character varying(64 char),
        task_name character varying(128 char),
		complete_time timestamp without time zone ,
		business_id varchar ,
		form_vue character varying(255 char) ,
		real_name character varying(256 char) ,
	    process_type integer ,
	    process_instance_id character varying(64 char) ,
	    process_status character varying(32 char) ,
	    dept_name character varying(64 char),
	    category character varying(64 char),
        has_open tinyint,
	    can_batch tinyint
	);
END;

CREATE OR REPLACE PACKAGE BODY "kesplus_workflow"."entity_record" AS


END;