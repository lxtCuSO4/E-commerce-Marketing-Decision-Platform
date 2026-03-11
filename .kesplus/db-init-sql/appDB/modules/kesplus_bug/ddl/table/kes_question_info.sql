-- "kesplus_bug"."kes_question_info" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_bug"."kes_question_info";

CREATE TABLE "kesplus_bug"."kes_question_info" (
	"question_id" integer AUTO_INCREMENT,
	"project_id" character varying(32 char) NULL,
	"project_module_id" character varying(32 char) NULL,
	"question_title" character varying(32 char) NULL,
	"question_type_id" integer NULL DEFAULT 1,
	"question_priority_id" integer NULL DEFAULT 2,
	"question_severity_id" integer NULL DEFAULT 2,
	"start_time" datetime NULL,
	"end_time" datetime NULL,
	"question_descr" text NULL,
	"status" integer NULL,
	"del_flag" integer NULL DEFAULT 1,
	"create_id" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_id" character varying(32 char) NULL,
	"update_time" datetime NULL,
	"focus_user_id" character varying(256 char) NULL,
	"cc_user_id" character varying(256 char) NULL,
	"to_user_id" character varying(256 char) NULL,
	"solve_user_id" character varying(32 char) NULL,
	"solve_time" datetime NULL,
	"audit_user_id" character varying(32 char) NULL,
	"audit_time" datetime NULL,
	"review_user_id" character varying(32 char) NULL,
	"review_time" datetime NULL,
	"delay_user_id" character varying(32 char) NULL,
	"delay_time" datetime NULL,
	"close_user_id" character varying(32 char) NULL,
	"close_time" datetime NULL,
	"parent_id" integer NULL,
	"charge_user_id" character varying(256 char) NULL,
	"create_name" character varying(32 char) NULL,
	"update_name" character varying(32 char) NULL,
	"focus_user_name" character varying(256 char) NULL,
	"to_user_name" character varying(256 char) NULL,
	"cc_user_name" character varying(256 char) NULL,
	"solve_user_name" character varying(32 char) NULL,
	"audit_user_name" character varying(32 char) NULL,
	"review_user_name" character varying(32 char) NULL,
	"delay_user_name" character varying(32 char) NULL,
	"close_user_name" character varying(32 char) NULL,
	"order_no" integer NULL DEFAULT 0,
	"question_source" integer NULL DEFAULT 0,
	"attachment_url" text NULL,
	"project_module_name" character varying(32 char) NULL,
	"question_no" character varying(128 char) NULL,
	"type" character varying(20 char) NOT NULL,
	"user_info" json NULL,
	CONSTRAINT "con_kes_application_kes_question_info_pk" PRIMARY KEY (question_id)
);
CREATE INDEX inxex_kes_application_kes_question_info_cc_user_index ON kesplus_bug.kes_question_info USING btree (cc_user_id);
CREATE INDEX inxex_kes_application_kes_question_info_creator_index ON kesplus_bug.kes_question_info USING btree (create_id);
CREATE INDEX inxex_kes_application_kes_question_info_status_index ON kesplus_bug.kes_question_info USING btree (status);
CREATE INDEX inxex_kes_application_kes_question_info_to_user_index ON kesplus_bug.kes_question_info USING btree (to_user_id);