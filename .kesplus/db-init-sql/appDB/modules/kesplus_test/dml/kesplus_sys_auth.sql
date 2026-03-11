INSERT INTO kesplus_app.kesplus_sys_auth ("id","auth_type","schema_name","object_type","object_name","role_name","create_by","create_time","update_by","update_time","is_deleted","dept_id","current_company") VALUES
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','FUNCTIONS','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','PROCEDURES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','PACKAGES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','TABLES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','SEQUENCES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','SCHEMA','kesplus_test','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'USAGE','kesplus_test','SCHEMA','kesplus_test','jdbc','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','SCHEMA','kesplus_test','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','TABLES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_test','ALL','SEQUENCES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_test','ALL','FUNCTIONS','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_test','ALL','PROCEDURES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_test','ALL','PACKAGES','base','0',SYSDATE,NULL,NULL,0,'0','0');