INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
	 ('1','gitUrl','http://10.12.13.119',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('2','kes_plus.is_single_login','0',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('3','kes_plus.jwt_exp_minutes','60',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('4','kes_plus.env','1',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('5','kes_plus.login_error_count','5',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('6','kes_plus.jwt_priv_secret',lower(sys_guid()),1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('7','kes_plus.jwt_pub_secret','1',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('8','kes_plus.prevent_developer','0',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('9','kes_plus.user_default_pwd','SyFuZ2Iyc2U=',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('10','kes_plus.execute_type','1',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('11','kes_plus.token_check_ip','0',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
	 ('12','kes_plus.prevent_kesplus_api','0',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('13','klog.log_level','1',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('14','kes_plus.vs_jwt_exp_hours','30',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('15','kes_plus.sql_injection_check','0',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('16','kes_plus.sql_injection_reg','(SELECT|UPDATE|DELETE|INSERT|DROP|GRANT|CREATE|REVOKE|EXEC|EXECUTE|CALL|PERFORM|UNION|ALTER|REGEXP|LIKE)[\s]+|(CHR\([\d]+\))|[\'''';\\]+|(--)|(/\*(?:[^*]|(?:\*+[^*/]))*\*+/)',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('17','kes_plus.password_version','1',1,'0','${currentUserId}',SYSDATE,NULL,NULL,0),
     ('18','kes_plus.audit_status', 'true', 1, '0', '0',SYSDATE, NULL, NULL, 0),
     ('19','kes_plus.auth_code_skip', '0', 1, '0', '0',SYSDATE, NULL, NULL, 0),
     ('20','kes_plus.has_menu_mapping', '1', 1, '0', '0',SYSDATE, NULL, NULL, 0);


INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('21','switch.license','1',1,'0','0',SYSDATE,NULL,NULL,0);

 INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('22','kes_plus.dept_id_type','0',1,'0','0',SYSDATE,NULL,NULL,0),
    ('23','kes_plus.dept_expansion', '[{"fieldName":"divisionId","label":"所属事业部id"},{"fieldName":"divisionName","label":"所属事业部"},{"fieldName":"budgetDeptId","label":"预算部门id"},{"fieldName":"budgetDeptName","label":"预算部门"},{"fieldName":"majorDeptId","label":"一级部门id"},{"fieldName":"majorDeptName","label":"一级部门"},{"fieldName":"ga_dept_type","label":"所属事业部分类"},{"fieldName":"ga_shipping_type","label":""},{"fieldName":"ga_sign_type","label":"签约方总代"}]', 1, '0', '0',SYSDATE, NULL, NULL, 0);

INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('24','kes_plus.stop_user_login','0',1,'0','0',SYSDATE,NULL,NULL,0);

INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('25','kes_plus.mobile_user_agent','[^*]*?((something)|(kesplus))[^*]*?',1,'0','0',SYSDATE,NULL,NULL,0);

INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('26','kes_plus.jwt_mobile_days','14',1,'0','0',SYSDATE,NULL,NULL,0);

INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('27','kes_plus.record_login','1',1,'0','0',SYSDATE,NULL,NULL,0);


INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES ('28','kesplus.region','{
          "北京市": 1,
          "天津市": 1,
          "河北省": 1,
          "吉林省": 1,
          "黑龙江省": 1,
          "辽宁省": 1,
          "内蒙古自治区": 1,
          "重庆市": 2,
          "陕西省": 2,
          "四川省": 2,
          "贵州省": 2,
          "云南省": 2,
          "甘肃省": 2,
          "青海省": 2,
          "宁夏回族自治区": 2,
          "西藏自治区": 2,
          "广东省": 3,
          "福建省": 3,
          "江西省": 3,
          "海南省": 3,
          "广西壮族自治区": 3,
          "上海市": 5,
          "湖北省": 4,
          "山西省": 4,
          "安徽省": 5,
          "浙江省": 5,
          "山东省": 4,
          "湖南省": 4,
          "江苏省": 5,
          "河南省": 4,
          "新疆维吾尔自治区": 6
        }',1,'0','0','''2025-05-21 20:12:59''',NULL,NULL,0);


INSERT INTO kesplus_platform.kesplus_sys_config ("id","config_key","config_value","scope","scope_id","create_by","create_time","update_by","update_time","is_deleted") VALUES
    ('29','kesplus.region_manage','{
  "1bbd915a7c5d48e0a455253f3bc28669": 4,
  "1d38e0dddd484a678d54a53ddc47760d": 3,
  "76cd82f0e4a84963893ffc64ab9bbfb7": 2,
  "7db74a1c19c84f58a63c090174c02507": 5,
  "c6f903bc48a343368479b257bd837991": 1,
  "e02905cdb3f443539706f37cfe1df2c1": 6
}',1,'0','0',SYSDATE,NULL,NULL,0);

