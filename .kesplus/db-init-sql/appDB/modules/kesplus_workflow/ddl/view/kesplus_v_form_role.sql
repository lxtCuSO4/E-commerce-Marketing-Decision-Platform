-- "kesplus_workflow"."kesplus_v_form_role" source

CREATE OR REPLACE VIEW "kesplus_workflow"."kesplus_v_form_role"
AS SELECT t.id,
    t.form_id,
    t.role_id,
    format('wf:%s:%s'::text, ka.code, t.form_id) AS db_form_role,
    format('r:%s:%s'::text, ka.code, kbr.id) AS db_role
   FROM kesplus_workflow.kesplus_workflow_form_role t
     JOIN kesplus_platform.kes_application ka ON 1 = 1
     JOIN kesplus_base.kesplus_base_role kbr ON t.role_id::text = kbr.id::text AND  kbr."role_type" = 0 AND kbr."obj_type" ='obj'
  ORDER BY t.create_time DESC, t.id;