INSERT INTO kesplus_workflow.kesplus_module ("id","module_name","module_path","module_code","module_icon","remark","create_time","create_by","update_time","update_by","app_id","type","enabled","child_api","tenant_id","status","charge_by","sort","module_version") VALUES
	 ('aa428946184940fd91ed903e6791b095','流程管理','/kesplus_workflow','kesplus_workflow',NULL,NULL,SYSDATE,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,NULL,'546508b9842c4e3698a1f2d3ae6fa917',0,1,NULL,'0',1,'546508b9842c4e3698a1f2d3ae6fa917',2,'V2.0');


INSERT INTO kesplus_base.kesplus_base_menu ("id","code","title","icon","classify","url","outer_link","component","hidden_flag","enabled","params","properties","create_by","create_time","update_by","update_time","tenant_id","module_id","dept_id","parent_id","sort_num","obj_type") VALUES
    ('aa428946184940fd91ed903e6791b095',NULL,'流程管理','Operation',NULL,NULL,NULL,NULL,false,1,NULL,NULL,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'0','aa428946184940fd91ed903e6791b095','0','0',1,'dir');


INSERT INTO "kesplus_base"."kesplus_base_permission" ("id","module_code","dept_id","name","code","obj_type","parent_id","status","create_by","create_time","update_by","update_time","module_id","remark","sort_num") VALUES
	 ('aa428946184940fd91ed903e6791b095','kesplus_workflow','0','流程管理',NULL,'dir','0','1','aa428946184940fd91ed903e6791b095',SYSDATE,'aa428946184940fd91ed903e6791b095','2024-04-03 10:58:39','aa428946184940fd91ed903e6791b095',NULL,NULL);


INSERT INTO kesplus_base.kesplus_base_policy ("id","code","name","db_role_code","description","enabled","params","tables","create_by","create_time","update_by","update_time","dept_id","module_id","tenant_id","parent_id","obj_type","sort_num") VALUES
	 ('aa428946184940fd91ed903e6791b095', NULL,'流程管理', NULL, '流程管理', 1, NULL, NULL, NULL, SYSDATE, NULL, SYSDATE,'0', 'aa428946184940fd91ed903e6791b095','0', '0', 'dir', NULL);

INSERT INTO kesplus_base.kesplus_base_role ("id","name","code","description","global_flag","role_level","data_scope","classify","role_type","hidden_flag","db_role_code","enabled","create_by","create_time","update_by","update_time","tenant_id","module_id","dept_id","obj_type","parent_id","sort_num") VALUES
	 ('aa428946184940fd91ed903e6791b095','流程管理',NULL,NULL,false,-1,NULL,2,1,false,NULL,1,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'0','aa428946184940fd91ed903e6791b095','0','dir','0',4);




