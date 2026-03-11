-- "kesplus_workflow"."kes_bpmn_task_flow_log" definition

-- Drop table

-- DROP TABLE "kesplus_workflow"."kes_bpmn_task_flow_log";

CREATE TABLE "kesplus_workflow"."kes_bpmn_task_flow_log" (
	"request_id" character varying(64 char) NOT NULL,
	"request_type" character varying(256 char) NULL,
	"request_number" integer NULL,
	"business_id" character varying(64 char) NULL,
	"process_id" character varying(64 char) NULL,
	"flow_text" text NULL,
	"handler_id" character varying(32 char) NULL,
	"handler_name" character varying(64 char) NULL,
	"create_time" timestamp without time zone NULL,
	CONSTRAINT "pk_kes_bpmn_task_flow_log" PRIMARY KEY (request_id)
);