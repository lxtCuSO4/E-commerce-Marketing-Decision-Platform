INSERT INTO kesplus_base.kesplus_module_component ("id","name","code","sql_content","columns","params","mappings","module_id") VALUES
	 ('1','用户部门','user','						SELECT
							u."id",
							u."username",
							u."real_name" as "realName",
							u."phone",
							u."email",
							d."dept_name" as "deptName",
							d."dept_code" as "deptCode"
						FROM "kesplus_base"."kesplus_user" u
						JOIN kesplus_base."kesplus_user_dept" AS ud ON u."id" = ud."user_id"
						JOIN "kesplus_base".kesplus_dept AS d ON ud."current_dept_id" = d."id" ','{"email": "邮箱", "phone": "手机号码", "deptCode": "部门编号", "deptName": "部门名称", "realName": "姓名", "username": "账号"}',NULL,'{{&mappingAlias}}."{{&optionColumn}}" = {{&componentAlias}}."id"','dfb8894291c34ac28e3458bba277e0ff');
INSERT INTO kesplus_base.kesplus_module_component ("id","name","code","sql_content","columns","params","mappings","module_id") VALUES
	 ('2','字典','dict','						SELECT
							d."val",
							d."code",
							d."name"
						FROM kesplus_base."kesplus_dictionary" AS d','{"name": "字典名称"}','{"dictCode": "字段编号"}','({{&mappingAlias}}."{{&optionColumn}}")::varchar = {{&componentAlias}}."val" AND {{&componentAlias}}."code" = ''{{&dictCode}}''','dfb8894291c34ac28e3458bba277e0ff');
INSERT INTO kesplus_base.kesplus_module_component ("id","name","code","sql_content","columns","params","mappings","module_id") VALUES
	 ('4','部门','dept','						SELECT
							d."dept_name" as "deptName",
							d."dept_code" as "deptCode",
							d."id"
						FROM "kesplus_base".kesplus_dept AS d','{"deptCode": "部门编号", "deptName": "部门名称"}',NULL,'{{&mappingAlias}}."{{&optionColumn}}" = {{&componentAlias}}."id"','dfb8894291c34ac28e3458bba277e0ff');
INSERT INTO kesplus_base.kesplus_module_component ("id","name","code","sql_content","columns","params","mappings","module_id") VALUES
	 ('5','文件','file','						SELECT
							"id",
							"file_name" as "fileName",
							"file_type" as "fileType",
							"file_suffix" as "fileSuffix",
							"create_time" as "createTime",
							"file_size" as "fileSize",
							"file_parent_full_path" as "fileSrc"
						FROM "kesplus_app"."sys_file" ','{"fileSrc": "文件链接", "fileName": "文件名称", "fileSize": "文件大小", "fileType": "文件类型", "createTime": "上传时间", "fileSuffix": "文件拓展名"}',NULL,'{{&mappingAlias}}."{{&optionColumn}}" = {{&componentAlias}}."id"','dfb8894291c34ac28e3458bba277e0ff');