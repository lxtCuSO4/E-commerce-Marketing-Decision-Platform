INSERT INTO kesplus_app.kesplus_sys_auth ("id","auth_type","schema_name","object_type","object_name","role_name","create_by","create_time","update_by","update_time","is_deleted","dept_id","current_company") VALUES
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','FUNCTIONS','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','PROCEDURES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','PACKAGES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','TABLES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','SEQUENCES','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','SCHEMA','${moduleSchema}','developer','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'USAGE','${moduleSchema}','SCHEMA','${moduleSchema}','jdbc','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','SCHEMA','${moduleSchema}','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','TABLES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'ALL','${moduleSchema}','ALL','SEQUENCES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','${moduleSchema}','ALL','FUNCTIONS','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','${moduleSchema}','ALL','PROCEDURES','base','0',SYSDATE,NULL,NULL,0,'0','0'),
	 (lower(sys_guid()),'EXECUTE','${moduleSchema}','ALL','PACKAGES','base','0',SYSDATE,NULL,NULL,0,'0','0');