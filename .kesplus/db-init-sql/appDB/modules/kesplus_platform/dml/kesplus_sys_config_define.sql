
INSERT INTO kesplus_platform.kesplus_sys_config_define ("id","code","name","description","data_type","input_type","data_source","data_info","mult_flag","scope_type","default_value","create_by","create_time","update_by","update_time") VALUES
	 ('1','gitUrl','系统git地址','系统git地址','varchar','input',0,NULL,false,4,'http://127.0.0.1','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('2','kes_plus.is_single_login','多点登录','1-禁止；0-允许','int','radio',1,'{
  "options": [
    {
      "title": "禁止",
      "value": 1
    },
    {
      "title": "允许",
      "value": 0
    }
  ]
}',false,4,'0','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('3','kes_plus.jwt_exp_minutes','token有效时长','单位分钟','int','input',0,NULL,false,4,'720','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('14','kes_plus.vs_jwt_exp_hours','token有效时长','单位小时','int','input',0,NULL,false,4,'240','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('4','kes_plus.env','当前系统环境',NULL,'int','checkbox',1,'{
  "options": [
    {
      "title": "DEV-开发环境",
      "value": 1
    },
    {
      "title": "UAT-测试环境",
      "value": 2
    },
    {
      "title": "DAT-预生产环境",
      "value": 3
    },
    {
      "title": "PROD-生产环境",
      "value": 4
    }
  ]
}',false,4,'1','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('5','kes_plus.login_error_count','登录错误锁定次数',NULL,'int','input',0,NULL,false,4,'5','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('6','kes_plus.jwt_priv_secret','业务端token加密因子','默认值为随机生成，其他各级组织可单独配置','varchar','input',0,NULL,false,2,'bnQEKKrd','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('7','kes_plus.jwt_pub_secret','开发端token加密因子','本平台所有应用应一致','varchar','input',0,NULL,false,4,'90ujfej_','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('8','kes_plus.prevent_developer','开发端登陆','建议生产环境按需开启，1-禁止；0-不禁止','int','radio',1,'{
  "options": [
    {
      "title": "禁止",
      "value": 1
    },
    {
      "title": "允许",
      "value": 0
    }
  ]
}',false,4,'0','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('9','kes_plus.user_default_pwd','默认密码','创建用户或者重置密码时使用','varchar','input',0,NULL,false,4,'1qaz@WSX','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
	 ('10','kes_plus.execute_type','业务接口执行类型','0-每次请求动态生成executeSql, 1-使用保存的executeSql','int','checkbox',1,'{
  "options": [
    {
      "title": "每次请求动态生产",
      "value": 0
    },
    {
      "title": "首次请求后保存",
      "value": 1
    }
  ]
}',false,4,'1','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
    ('11','kes_plus.token_check_ip','token校验ip','0-不校验, 1-校验','int','checkbox',1,'{
  "options": [
    {
      "title": "不校验",
      "value": 0
    },
    {
      "title": "校验",
      "value": 1
    }
  ]
}',false,4,'1','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE),
    ('12','kes_plus.prevent_kesplus_api','业务端禁止访问开发端接口','0-不禁止, 1-禁止','int','checkbox',1,'{
  "options": [
    {
      "title": "不禁止",
      "value": 0
    },
    {
      "title": "禁止",
      "value": 1
    }
  ]
}',false,4,'1','${currentUserId}',SYSDATE,'${currentUserId}',SYSDATE);