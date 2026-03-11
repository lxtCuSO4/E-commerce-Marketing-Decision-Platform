INSERT INTO kesplus_app.kesplus_sys_auth ("id","auth_type","schema_name","object_type","object_name","role_name","create_by","create_time","update_by","update_time","is_deleted","dept_id","current_company") VALUES
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','FUNCTIONS','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','PROCEDURES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','PACKAGES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','TABLES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','SEQUENCES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','SCHEMA','kesplus_bug','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'USAGE','kesplus_bug','SCHEMA','kesplus_bug','jdbc','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','SCHEMA','kesplus_bug','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','TABLES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','kesplus_bug','ALL','SEQUENCES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_bug','ALL','FUNCTIONS','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_bug','ALL','PROCEDURES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','kesplus_bug','ALL','PACKAGES','base','0',SYSDATE,NULL,NULL,0,'0','0');