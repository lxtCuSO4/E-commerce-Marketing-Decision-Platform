INSERT INTO kesplus_base.kesplus_module ("id","module_name","module_path","module_code","module_icon","remark","create_time","create_by","update_time","update_by","app_id","type","enabled","child_api","tenant_id","status","charge_by","sort","module_version", "parent_id") VALUES
	 ('dfb8894291c34ac28e3458bba277e0ff','系统管理','/kesplus_base','kesplus_base','Setting',NULL,SYSDATE,'${currentUserId}',NULL,NULL,'${currentUserId}',0,1,'/sys/app/directory','0',1,'${currentUserId}',1,'V3.1', '0');

INSERT INTO kesplus_base.kesplus_base_menu ("id","code","title","icon","classify","url","outer_link","component","hidden_flag","enabled","params","properties","create_by","create_time","update_by","update_time","tenant_id","module_id","dept_id","parent_id","sort_num","obj_type") VALUES
	 ('dfb8894291c34ac28e3458bba277e0ff',NULL,'系统管理','Setting',NULL,NULL,NULL,NULL,false,1,NULL,NULL,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'546508b9842c4e3698a1f2d3ae6fa917',SYSDATE,'0','dfb8894291c34ac28e3458bba277e0ff','0','0',1,'dir');

INSERT INTO kesplus_base.kesplus_base_permission ("id","module_code","dept_id","name","code","obj_type","parent_id","status","create_by","create_time","update_by","update_time","module_id","remark") VALUES
	 ('dfb8894291c34ac28e3458bba277e0ff','kesplus_base','${currentDeptId}','系统管理',NULL,'dir','0','1','${currentUserId}',SYSDATE,'${currentUserId}','2024-04-03 10:58:39','dfb8894291c34ac28e3458bba277e0ff',NULL);

INSERT INTO kesplus_base.kesplus_base_policy ("id","code","name","db_role_code","description","enabled","params","tables","create_by","create_time","update_by","update_time","dept_id","module_id","tenant_id","parent_id","obj_type","sort_num") VALUES
	 ('dfb8894291c34ac28e3458bba277e0ff', NULL,'系统管理', NULL, '系统管理', 1, NULL, NULL, NULL, SYSDATE, NULL, SYSDATE,'0', 'dfb8894291c34ac28e3458bba277e0ff','0', '0', 'dir', NULL);

INSERT INTO kesplus_base.kesplus_base_role ("id","name","code","description","global_flag","role_level","data_scope","classify","role_type","hidden_flag","db_role_code","enabled","create_by","create_time","update_by","update_time","tenant_id","module_id","dept_id","obj_type","parent_id","sort_num") VALUES
    ('dfb8894291c34ac28e3458bba277e0ff','系统管理',NULL,NULL,false,-1,NULL,2,1,false,NULL,1,'${currentUserId}',SYSDATE,NULL,NULL,'0','dfb8894291c34ac28e3458bba277e0ff',NULL,'dir','0', 1);
INSERT INTO kesplus_base.kesplus_base_role ("id","name","code","description","global_flag","role_level","data_scope","classify","role_type","hidden_flag","db_role_code","enabled","create_by","create_time","update_by","update_time","tenant_id","module_id","dept_id","obj_type","parent_id","sort_num") VALUES
    ('4fc4d87dcab3488cb3d7487a58928af3','开发管理角色','developmentRole','拥有开发的业务应用的所有功能数据权限',true,1,'0',2,2,false,NULL,1,'${currentUserId}',SYSDATE,NULL,NULL,'0','dfb8894291c34ac28e3458bba277e0ff','0','obj','dfb8894291c34ac28e3458bba277e0ff',3);


