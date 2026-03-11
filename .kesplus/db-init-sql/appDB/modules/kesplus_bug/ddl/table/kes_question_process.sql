-- "kesplus_bug"."kes_question_process" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_bug"."kes_question_process";

CREATE TABLE "kesplus_bug"."kes_question_process" (
	"process_id" integer AUTO_INCREMENT,
	"question_id" integer NOT NULL,
	"operator_id" character varying(32 char) NULL,
	"from_user_id" character varying(32 char) NULL,
	"to_user_id" character varying(32 char) NULL,
	"description" character varying(256 char) NULL,
	"del_flag" integer NULL,
	"create_id" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_id" character varying(32 char) NULL,
	"update_time" datetime NULL,
	"operator_name" character varying(32 char) NULL,
	"from_user_name" character varying(32 char) NULL,
	"to_user_name" character varying(32 char) NULL,
	"custom_descption" text NULL,
	CONSTRAINT "con_kes_application_kes_question_process_pk" PRIMARY KEY (process_id)
);
CREATE INDEX inxex_kes_application_kes_question_process_create_time_index ON kesplus_bug.kes_question_process USING btree (create_time);
CREATE INDEX inxex_kes_application_kes_question_process_operate_index ON kesplus_bug.kes_question_process USING btree (operator_id);
CREATE INDEX inxex_kes_application_kes_question_process_question_id_index ON kesplus_bug.kes_question_process USING btree (question_id);