-- "kesplus_bug"."kes_question_comment" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_bug"."kes_question_comment";

CREATE TABLE "kesplus_bug"."kes_question_comment" (
	"comment_id" integer AUTO_INCREMENT,
	"question_id" integer NOT NULL,
	"operator_id" character varying(32 char) NULL,
	"del_flag" integer NULL,
	"create_id" character varying(32 char) NULL,
	"create_time" datetime NULL,
	"update_id" varchar NULL,
	"update_time" datetime NULL,
	"comment_info" text NULL,
	"operator_name" character varying(32 char) NULL,
	CONSTRAINT "con_kes_application_kes_question_comment_constraint_id" PRIMARY KEY (comment_id)
);
CREATE INDEX inxex_kes_application_kes_question_comment_create_time_index ON kesplus_bug.kes_question_comment USING btree (create_time);
CREATE INDEX inxex_kes_application_kes_question_comment_question_index ON kesplus_bug.kes_question_comment USING btree (question_id);