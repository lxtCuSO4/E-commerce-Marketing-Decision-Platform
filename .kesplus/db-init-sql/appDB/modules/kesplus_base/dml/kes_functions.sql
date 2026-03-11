INSERT INTO kesplus_base.kes_functions ("id","category","directory_code","name","schema_name","return_type","owner_name","parameters","app_id","module_id","parent_id","content","create_time","update_time","is_rest","api_directory_id","method","module_path","api_path","return_value_type","tenant_id","auth_status","role_ids","remark","update_by","create_by","obj_type","sort_num","api_title") VALUES ('10c27f33ac6a4972a443800a660ecf31',5,'functions','biz_by_pending_done','kesplus_base',NULL,NULL,'[{"paramId": "paramId-1731053931938", "dataType": "varchar", "required": 0, "paramName": "nodeKey", "paramType": "IN"}, {"paramId": "paramId-1731053932138", "dataType": "varchar", "required": 0, "paramName": "bizType", "paramType": "IN"}, {"paramId": "paramId-1731053932312", "dataType": "varchar", "required": 0, "paramName": "bizId", "paramType": "IN"}]','88415b05aa35431c8e5b9ee61fd72b52','dfb8894291c34ac28e3458bba277e0ff','3','create or replace function "kesplus_base"."biz_by_pending_done"(nodeKey varchar,bizType varchar,bizId varchar) return boolean as
/**
 * @Description
 * @Param nodeKey
 * @Param bizType
 * @Param bizId
 * @Return boolean
 */
declare
  v_user_id varchar;
  v_dept_id varchar;
begin
  --当前用户id
  v_user_id := kesplus_platform.user(''userId'');
  v_dept_id := kesplus_platform.user(''deptId'');
  PERFORM 1 FROM "kesplus_workflow"."kes_app_pending_his" kaph
  JOIN "kesplus_workflow"."kes_bpmn_task" kbt ON kaph."pending_key" = kbt."id" AND kbt."task_def_key" = nodeKey
  WHERE kaph."type" = bizType AND kaph."business_id" = bizId;
  return FOUND;
end;','''2024-11-08 16:14:31''',NULL,0,NULL,NULL,NULL,NULL,'boolean','0',1,NULL,NULL,NULL,'${currentUserId}','obj',NULL,NULL);
INSERT INTO kesplus_base.kes_functions ("id","category","directory_code","name","schema_name","return_type","owner_name","parameters","app_id","module_id","parent_id","content","create_time","update_time","is_rest","api_directory_id","method","module_path","api_path","return_value_type","tenant_id","auth_status","role_ids","remark","update_by","create_by","obj_type","sort_num","api_title") VALUES ('c79d6d07822a4faca04f83f885dbf972',5,'functions','biz_by_pending_todo','kesplus_base',NULL,NULL,'[{"paramId": "paramId-1731053863644", "dataType": "varchar", "required": 0, "paramName": "nodeKey", "paramType": "IN"}, {"paramId": "paramId-1731053863828", "dataType": "varchar", "required": 0, "paramName": "bizType", "paramType": "IN"}, {"paramId": "paramId-1731053864013", "dataType": "varchar", "required": 0, "paramName": "bizId", "paramType": "IN"}]','88415b05aa35431c8e5b9ee61fd72b52','dfb8894291c34ac28e3458bba277e0ff','3','create or replace function "kesplus_base"."biz_by_pending_todo"(nodeKey varchar,bizType varchar,bizId varchar) return boolean as
/**
 * @Description
 * @Param nodeKey
 * @Param bizType
 * @Param bizId
 * @Return JSON
 */
declare
  v_user_id varchar;
  v_dept_id varchar;
begin
  --当前用户id
  v_user_id := kesplus_platform.user(''userId'');
  v_dept_id := kesplus_platform.user(''deptId'');
  PERFORM 1 FROM "kesplus_workflow"."kes_app_pending" kap
  JOIN "kesplus_workflow"."kes_app_pending_assign" kapa ON kap."id" = kapa."pending_id" AND kapa."assignee_id" = v_user_id AND kapa."assignee_dept_id" = v_dept_id
  JOIN "kesplus_workflow"."kes_bpmn_task" kbt ON kap."pending_key" = kbt."id" AND kbt."task_def_key" = nodeKey
  WHERE kap."type" = bizType AND kap."business_id" = bizId;
  return FOUND;
end;','''2024-11-08 16:13:36''',NULL,0,NULL,NULL,NULL,NULL,'boolean','0',1,NULL,NULL,NULL,'${currentUserId}','obj',NULL,NULL);
INSERT INTO kesplus_base.kes_functions ("id","category","directory_code","name","schema_name","return_type","owner_name","parameters","app_id","module_id","parent_id","content","create_time","update_time","is_rest","api_directory_id","method","module_path","api_path","return_value_type","tenant_id","auth_status","role_ids","remark","update_by","create_by","obj_type","sort_num","api_title") VALUES ('36db5116374941fdb6addfcde6b17f5f',5,'procedures','refresh_mv','kesplus_base',NULL,NULL,'[]','22618d2757ab45198ecfdc2dc397caff','dfb8894291c34ac28e3458bba277e0ff','4','create or replace procedure "kesplus_base"."refresh_mv"()  as
/**
 * @Description

 *
 */
declare

begin
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_userrole" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_urole" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_user_restful" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_policy" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_role" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_user_permission" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_restful" FORCE;
    --REFRESH MATERIALIZED VIEW "kesplus_base"."kesplus_v_user_info" FORCE;
end;','''2025-01-16 20:00:52''',NULL,0,NULL,NULL,NULL,NULL,'NONE','0',1,NULL,NULL,NULL,'546508b9842c4e3698a1f2d3ae6fa917','obj',NULL,NULL);


INSERT INTO kesplus_base.kes_functions ("id","category","directory_code","name","schema_name","return_type","owner_name","parameters","app_id","module_id","parent_id","content","create_time","update_time","is_rest","api_directory_id","method","module_path","api_path","return_value_type","tenant_id","auth_status","role_ids","remark","update_by","create_by","obj_type","sort_num","api_title") VALUES ('dbcfa45de7db43a5b96fac5fa2164876',5,'procedures','refresh_auth','kesplus_base',NULL,NULL,'[]','d93177b3945143b2993bf5e172826bac','dfb8894291c34ac28e3458bba277e0ff','4','CREATE OR REPLACE PROCEDURE "kesplus_base"."refresh_auth"()  AS
/**
 * @Description

 *
 */
DECLARE
    v_init boolean;
    v_app_id varchar;
BEGIN
    SELECT id INTO v_app_id FROM kesplus_platform."kes_application" ka;

    IF NOT exists(select 1 from kesplus_base.kes_jobs j WHERE j."code"= ''kesplus_init'' AND j."app_id" = v_app_id) THEN
        CALL kesplus_platform.sys_auth.kesplus_init();

        UPDATE kesplus_base.kes_jobs j SET j."app_id"  = v_app_id WHERE j."code" = ''kesplus_init'';
    ELSE
        CALL kesplus_platform.sys_auth.kesplus_init(FALSE);
    END IF;

END;','''2025-04-02 20:50:45''','''2025-04-02 20:50:45''',0,NULL,NULL,NULL,NULL,'NONE',NULL,1,NULL,NULL,'546508b9842c4e3698a1f2d3ae6fa917','546508b9842c4e3698a1f2d3ae6fa917','obj',NULL,NULL);

