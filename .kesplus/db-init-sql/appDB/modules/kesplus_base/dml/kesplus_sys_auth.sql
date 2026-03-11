INSERT INTO kesplus_app.kesplus_sys_auth ("id","auth_type","schema_name","object_type","object_name","role_name","create_by","create_time","update_by","update_time","is_deleted","dept_id","current_company") VALUES
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','FUNCTIONS','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','PROCEDURES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','PACKAGES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','TABLES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','SEQUENCES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','SCHEMA','kesplus_base','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'USAGE','kesplus_base','SCHEMA','kesplus_base','jdbc','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','SCHEMA','kesplus_base','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','TABLES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_base','ALL','SEQUENCES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_base','ALL','FUNCTIONS','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_base','ALL','PROCEDURES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_base','ALL','PACKAGES','base','0',SYSDATE,NULL,NULL,0,'0','0');