INSERT INTO "kesplus_platform"."kesplus_sys_version" ("id","version_code","version_name","version_desc","version_type","version_status","effect_time","create_time","create_by","update_time","update_by","is_deleted") VALUES
	 ('1','1.0.0','初始版本','第一个版本',1,'1',NULL,SYSDATE,'1',SYSDATE,'1',0),
	 ('2','DEV.1.0.0','开发版本','开发初始版本',1,'1',NULL,SYSDATE,'1',SYSDATE,'1',0),
	 ('3','UAT.1.0.0','测试版本','测试初始版本',2,'1',NULL,SYSDATE,'1',SYSDATE,'1',0),
	 ('4','DAT.1.0.0','预生产版本','预生产初始版本',3,'1',NULL,SYSDATE,'1',SYSDATE,'1',0),
	 ('5','PROD.1.0.0','生产版本','生产版本版本',4,'1',NULL,SYSDATE,'1',SYSDATE,'1',0);