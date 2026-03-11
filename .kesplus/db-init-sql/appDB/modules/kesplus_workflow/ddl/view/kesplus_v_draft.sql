-- "kesplus_workflow"."kesplus_v_draft" source

CREATE OR REPLACE VIEW "kesplus_workflow"."kesplus_v_draft"
AS SELECT kesplus_draft.id,
    kesplus_draft.form_name,
    kesplus_draft.form_path,
    kesplus_draft.title,
    kesplus_draft.create_by_name,
    kesplus_draft.create_by,
    kesplus_draft.config_name,
    kesplus_draft.create_time,
    kesplus_draft.update_time
   FROM kesplus_workflow.kesplus_draft;