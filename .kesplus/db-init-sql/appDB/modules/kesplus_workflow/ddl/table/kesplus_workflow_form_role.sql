CREATE TABLE "kesplus_workflow"."kesplus_workflow_form_role" (
    "id" character varying(64 char) NULL,
	"form_id" character varying(64 char) NOT NULL,
	"role_id" character varying(64 char) NOT NULL,
	"db_role_code" character varying(64 char) NULL,
	"create_by" character varying(64 char) NULL,
	"create_time" datetime NULL,
	"update_by" character varying(64 char) NULL,
	"update_time" datetime NULL
);

CREATE INDEX wf_form_index ON kesplus_workflow.kesplus_workflow_form_role USING btree (form_id);
CREATE UNIQUE INDEX wf_form_role_pk ON kesplus_workflow.kesplus_workflow_form_role USING btree (id);