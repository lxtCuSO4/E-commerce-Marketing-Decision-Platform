INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('1', '所有人', 'findUser', 'user', true, '0', 1, 'DECLARE
	variables$ json := :variables_;
	ids$ varchar;
BEGIN
	 ids$ := ''-1'';
	:result_ := ids$;
END;', '所有人', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('2', '当前操作人', 'currentUser', 'user', true, '0', 2, 'DECLARE
	variables$ json := :variables_;
	ids$ varchar;
BEGIN
	 ids$ := "kesplus_platform".user(''userId'');
	:result_ := ids$;
END;', '当前操作人', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('3', '当前操作人部门', 'currentUserDept', 'dept', true, '0', 3, 'DECLARE
	variables$ json := :variables_;
	ids$ varchar;
BEGIN
	 ids$ := "kesplus_platform".user(''deptId'');
	:result_ := ids$;
END;', '当前操作人部门', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('4', '当前操作人部门角色', 'currentUserDeptRole', 'role', true, '0', 4, 'DECLARE
	variables$ json := :variables_;
	ids$ varchar;
BEGIN
	 ids$ := "kesplus_platform".user(''deptId'');
	:result_ := ids$;
END;', '当前操作人部门角色', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('5', '当前操作人部门岗位', 'currentuserDeptJob', 'position', true, '0', 5, 'DECLARE
	variables$ json := :variables_;
	ids$ varchar;
BEGIN
	 ids$ := "kesplus_platform".user(''deptId'');
	:result_ := ids$;
END;', '当前操作人部门岗位', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('6', '当前操作人上级部门', 'currentUserSuperDept', 'dept', true, '0', 6, 'DECLARE
	variables$ json := :variables_;
	deptId$ varchar;
	ids$ varchar;
BEGIN
	deptId$ := "kesplus_platform".user(''deptId'');
	SELECT kt."pid" INTO ids$
	FROM "kesplus_base"."kesplus_dept" kt
	WHERE kt."id" = deptId$;
	:result_ := ids$;
END;', '当前操作人上级部门', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('8', '当前操作人上级部门岗位', 'currentuserSuperDeptJob', 'position', true, '0', 8, 'DECLARE
	variables$ json := :variables_;
	deptId$ varchar;
	ids$ varchar;
BEGIN
	deptId$ := "kesplus_platform".user(''deptId'');
	SELECT kt."pid" INTO ids$
	FROM "kesplus_base"."kesplus_dept" kt
	WHERE kt."id" = deptId$;
	:result_ := ids$;
END;', '当前操作人上级部门岗位', NULL, '0', NULL, NULL, NULL, '0');
INSERT INTO "kesplus_base"."kes_app_selector_relation"
("id", "title", "key", "type", "isLeaf", "pid", "sort", "anonymous_block", "desc", "tree_path", "create_by", "create_time", "update_by", "update_time", "dept_id")
VALUES('7', '当前操作人上级部门角色', 'currentUserSuperDeptRole', 'role', true, '0', 7, 'DECLARE
	variables$ json := :variables_;
	deptId$ varchar;
	ids$ varchar;
BEGIN
	deptId$ := "kesplus_platform".user(''deptId'');
	SELECT kt."pid" INTO ids$
	FROM "kesplus_base"."kesplus_dept" kt
	WHERE kt."id" = deptId$;
	:result_ := ids$;
END;', '当前操作人上级部门角色', NULL, '0', NULL, NULL, NULL, '0');
