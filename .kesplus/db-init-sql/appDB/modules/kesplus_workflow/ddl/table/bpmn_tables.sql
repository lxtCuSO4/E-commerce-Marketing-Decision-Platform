-- "kesplus_workflow"."act_ge_property" definition

-- drop table

-- drop table "kesplus_workflow"."act_ge_property";

create table "kesplus_workflow"."act_ge_property" (
	"name_" character varying(64 char) not null,
	"value_" character varying(300 char) null,
	"rev_" integer null,
	constraint "act_ge_property_pkey" primary key (name_)
);


-- "kesplus_workflow"."act_ge_schema_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_ge_schema_log";

create table "kesplus_workflow"."act_ge_schema_log" (
	"id_" character varying(64 char) not null,
	"timestamp_" timestamp without time zone null,
	"version_" character varying(255 char) null,
	constraint "act_ge_schema_log_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_hi_actinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_actinst";

create table "kesplus_workflow"."act_hi_actinst" (
	"id_" character varying(64 char) not null,
	"parent_act_inst_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) not null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) not null,
	"execution_id_" character varying(64 char) not null,
	"act_id_" character varying(255 char) not null,
	"task_id_" character varying(64 char) null,
	"call_proc_inst_id_" character varying(64 char) null,
	"call_case_inst_id_" character varying(64 char) null,
	"act_name_" character varying(255 char) null,
	"act_type_" character varying(255 char) not null,
	"assignee_" character varying(255 char) null,
	"start_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"duration_" bigint null,
	"act_inst_state_" integer null,
	"sequence_counter_" bigint null,
	"tenant_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_actinst_pkey" primary key (id_)
);
create index act_idx_hi_actinst_root_pi on "kesplus_workflow".act_hi_actinst using btree (root_proc_inst_id_);
create index act_idx_hi_act_inst_comp on "kesplus_workflow".act_hi_actinst using btree (execution_id_, act_id_, end_time_, id_);
create index act_idx_hi_act_inst_end on "kesplus_workflow".act_hi_actinst using btree (end_time_);
create index act_idx_hi_act_inst_procinst on "kesplus_workflow".act_hi_actinst using btree (proc_inst_id_, act_id_);
create index act_idx_hi_act_inst_proc_def_key on "kesplus_workflow".act_hi_actinst using btree (proc_def_key_);
create index act_idx_hi_act_inst_rm_time on "kesplus_workflow".act_hi_actinst using btree (removal_time_);
create index act_idx_hi_act_inst_start_end on "kesplus_workflow".act_hi_actinst using btree (start_time_, end_time_);
create index act_idx_hi_act_inst_stats on "kesplus_workflow".act_hi_actinst using btree (proc_def_id_, proc_inst_id_, act_id_, end_time_, act_inst_state_);
create index act_idx_hi_act_inst_tenant_id on "kesplus_workflow".act_hi_actinst using btree (tenant_id_);
create index act_idx_hi_ai_pdefid_end_time on "kesplus_workflow".act_hi_actinst using btree (proc_def_id_, end_time_);


-- "kesplus_workflow"."act_hi_attachment" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_attachment";

create table "kesplus_workflow"."act_hi_attachment" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"user_id_" character varying(255 char) null,
	"name_" character varying(255 char) null,
	"description_" character varying(4000 char) null,
	"type_" character varying(255 char) null,
	"task_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"url_" character varying(4000 char) null,
	"content_id_" character varying(64 char) null,
	"tenant_id_" character varying(64 char) null,
	"create_time_" timestamp without time zone null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_attachment_pkey" primary key (id_)
);
create index act_idx_hi_attachment_content on "kesplus_workflow".act_hi_attachment using btree (content_id_);
create index act_idx_hi_attachment_procinst on "kesplus_workflow".act_hi_attachment using btree (proc_inst_id_);
create index act_idx_hi_attachment_rm_time on "kesplus_workflow".act_hi_attachment using btree (removal_time_);
create index act_idx_hi_attachment_root_pi on "kesplus_workflow".act_hi_attachment using btree (root_proc_inst_id_);
create index act_idx_hi_attachment_task on "kesplus_workflow".act_hi_attachment using btree (task_id_);


-- "kesplus_workflow"."act_hi_batch" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_batch";

create table "kesplus_workflow"."act_hi_batch" (
	"id_" character varying(64 char) not null,
	"type_" character varying(255 char) null,
	"total_jobs_" integer null,
	"jobs_per_seed_" integer null,
	"invocations_per_job_" integer null,
	"seed_job_def_id_" character varying(64 char) null,
	"monitor_job_def_id_" character varying(64 char) null,
	"batch_job_def_id_" character varying(64 char) null,
	"tenant_id_" character varying(64 char) null,
	"create_user_id_" character varying(255 char) null,
	"start_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_batch_pkey" primary key (id_)
);
create index act_hi_bat_rm_time on "kesplus_workflow".act_hi_batch using btree (removal_time_);


-- "kesplus_workflow"."act_hi_caseactinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_caseactinst";

create table "kesplus_workflow"."act_hi_caseactinst" (
	"id_" character varying(64 char) not null,
	"parent_act_inst_id_" character varying(64 char) null,
	"case_def_id_" character varying(64 char) not null,
	"case_inst_id_" character varying(64 char) not null,
	"case_act_id_" character varying(255 char) not null,
	"task_id_" character varying(64 char) null,
	"call_proc_inst_id_" character varying(64 char) null,
	"call_case_inst_id_" character varying(64 char) null,
	"case_act_name_" character varying(255 char) null,
	"case_act_type_" character varying(255 char) null,
	"create_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"duration_" bigint null,
	"state_" integer null,
	"required_" boolean null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_hi_caseactinst_pkey" primary key (id_)
);
create index act_idx_hi_cas_a_i_comp on "kesplus_workflow".act_hi_caseactinst using btree (case_act_id_, end_time_, id_);
create index act_idx_hi_cas_a_i_create on "kesplus_workflow".act_hi_caseactinst using btree (create_time_);
create index act_idx_hi_cas_a_i_end on "kesplus_workflow".act_hi_caseactinst using btree (end_time_);
create index act_idx_hi_cas_a_i_tenant_id on "kesplus_workflow".act_hi_caseactinst using btree (tenant_id_);


-- "kesplus_workflow"."act_hi_caseinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_caseinst";

create table "kesplus_workflow"."act_hi_caseinst" (
	"id_" character varying(64 char) not null,
	"case_inst_id_" character varying(64 char) not null,
	"business_key_" character varying(255 char) null,
	"case_def_id_" character varying(64 char) not null,
	"create_time_" timestamp without time zone not null,
	"close_time_" timestamp without time zone null,
	"duration_" bigint null,
	"state_" integer null,
	"create_user_id_" character varying(255 char) null,
	"super_case_instance_id_" character varying(64 char) null,
	"super_process_instance_id_" character varying(64 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_hi_caseinst_case_inst_id__key" unique (case_inst_id_),
	constraint "act_hi_caseinst_pkey" primary key (id_)
);
create index act_idx_hi_cas_i_buskey on "kesplus_workflow".act_hi_caseinst using btree (business_key_);
create index act_idx_hi_cas_i_close on "kesplus_workflow".act_hi_caseinst using btree (close_time_);
create index act_idx_hi_cas_i_tenant_id on "kesplus_workflow".act_hi_caseinst using btree (tenant_id_);


-- "kesplus_workflow"."act_hi_comment" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_comment";

create table "kesplus_workflow"."act_hi_comment" (
	"id_" character varying(64 char) not null,
	"type_" character varying(255 char) null,
	"time_" timestamp without time zone not null,
	"user_id_" character varying(255 char) null,
	"task_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"action_" character varying(255 char) null,
	"message_" character varying(4000 char) null,
	"full_msg_" bytea null,
	"tenant_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_comment_pkey" primary key (id_)
);
create index act_idx_hi_comment_procinst on "kesplus_workflow".act_hi_comment using btree (proc_inst_id_);
create index act_idx_hi_comment_rm_time on "kesplus_workflow".act_hi_comment using btree (removal_time_);
create index act_idx_hi_comment_root_pi on "kesplus_workflow".act_hi_comment using btree (root_proc_inst_id_);
create index act_idx_hi_comment_task on "kesplus_workflow".act_hi_comment using btree (task_id_);


-- "kesplus_workflow"."act_hi_decinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_decinst";

create table "kesplus_workflow"."act_hi_decinst" (
	"id_" character varying(64 char) not null,
	"dec_def_id_" character varying(64 char) not null,
	"dec_def_key_" character varying(255 char) not null,
	"dec_def_name_" character varying(255 char) null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"case_def_key_" character varying(255 char) null,
	"case_def_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"act_inst_id_" character varying(64 char) null,
	"act_id_" character varying(255 char) null,
	"eval_time_" timestamp without time zone not null,
	"removal_time_" timestamp without time zone null,
	"collect_value_" double precision null,
	"user_id_" character varying(255 char) null,
	"root_dec_inst_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"dec_req_id_" character varying(64 char) null,
	"dec_req_key_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_hi_decinst_pkey" primary key (id_)
);
create index act_idx_hi_dec_inst_act on "kesplus_workflow".act_hi_decinst using btree (act_id_);
create index act_idx_hi_dec_inst_act_inst on "kesplus_workflow".act_hi_decinst using btree (act_inst_id_);
create index act_idx_hi_dec_inst_ci on "kesplus_workflow".act_hi_decinst using btree (case_inst_id_);
create index act_idx_hi_dec_inst_id on "kesplus_workflow".act_hi_decinst using btree (dec_def_id_);
create index act_idx_hi_dec_inst_key on "kesplus_workflow".act_hi_decinst using btree (dec_def_key_);
create index act_idx_hi_dec_inst_pi on "kesplus_workflow".act_hi_decinst using btree (proc_inst_id_);
create index act_idx_hi_dec_inst_req_id on "kesplus_workflow".act_hi_decinst using btree (dec_req_id_);
create index act_idx_hi_dec_inst_req_key on "kesplus_workflow".act_hi_decinst using btree (dec_req_key_);
create index act_idx_hi_dec_inst_rm_time on "kesplus_workflow".act_hi_decinst using btree (removal_time_);
create index act_idx_hi_dec_inst_root_id on "kesplus_workflow".act_hi_decinst using btree (root_dec_inst_id_);
create index act_idx_hi_dec_inst_root_pi on "kesplus_workflow".act_hi_decinst using btree (root_proc_inst_id_);
create index act_idx_hi_dec_inst_tenant_id on "kesplus_workflow".act_hi_decinst using btree (tenant_id_);
create index act_idx_hi_dec_inst_time on "kesplus_workflow".act_hi_decinst using btree (eval_time_);


-- "kesplus_workflow"."act_hi_dec_in" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_dec_in";

create table "kesplus_workflow"."act_hi_dec_in" (
	"id_" character varying(64 char) not null,
	"dec_inst_id_" character varying(64 char) not null,
	"clause_id_" character varying(64 char) null,
	"clause_name_" character varying(255 char) null,
	"var_type_" character varying(100 char) null,
	"bytearray_id_" character varying(64 char) null,
	"double_" double precision null,
	"long_" bigint null,
	"text_" character varying(4000 char) null,
	"text2_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"create_time_" timestamp without time zone null,
	"root_proc_inst_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_dec_in_pkey" primary key (id_)
);
create index act_idx_hi_dec_in_clause on "kesplus_workflow".act_hi_dec_in using btree (dec_inst_id_, clause_id_);
create index act_idx_hi_dec_in_inst on "kesplus_workflow".act_hi_dec_in using btree (dec_inst_id_);
create index act_idx_hi_dec_in_rm_time on "kesplus_workflow".act_hi_dec_in using btree (removal_time_);
create index act_idx_hi_dec_in_root_pi on "kesplus_workflow".act_hi_dec_in using btree (root_proc_inst_id_);


-- "kesplus_workflow"."act_hi_dec_out" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_dec_out";

create table "kesplus_workflow"."act_hi_dec_out" (
	"id_" character varying(64 char) not null,
	"dec_inst_id_" character varying(64 char) not null,
	"clause_id_" character varying(64 char) null,
	"clause_name_" character varying(255 char) null,
	"rule_id_" character varying(64 char) null,
	"rule_order_" integer null,
	"var_name_" character varying(255 char) null,
	"var_type_" character varying(100 char) null,
	"bytearray_id_" character varying(64 char) null,
	"double_" double precision null,
	"long_" bigint null,
	"text_" character varying(4000 char) null,
	"text2_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"create_time_" timestamp without time zone null,
	"root_proc_inst_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_dec_out_pkey" primary key (id_)
);
create index act_idx_hi_dec_out_inst on "kesplus_workflow".act_hi_dec_out using btree (dec_inst_id_);
create index act_idx_hi_dec_out_rm_time on "kesplus_workflow".act_hi_dec_out using btree (removal_time_);
create index act_idx_hi_dec_out_root_pi on "kesplus_workflow".act_hi_dec_out using btree (root_proc_inst_id_);
create index act_idx_hi_dec_out_rule on "kesplus_workflow".act_hi_dec_out using btree (rule_order_, clause_id_);


-- "kesplus_workflow"."act_hi_detail" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_detail";

create table "kesplus_workflow"."act_hi_detail" (
	"id_" character varying(64 char) not null,
	"type_" character varying(255 char) not null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"case_def_key_" character varying(255 char) null,
	"case_def_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"task_id_" character varying(64 char) null,
	"act_inst_id_" character varying(64 char) null,
	"var_inst_id_" character varying(64 char) null,
	"name_" character varying(255 char) not null,
	"var_type_" character varying(64 char) null,
	"rev_" integer null,
	"time_" timestamp without time zone not null,
	"bytearray_id_" character varying(64 char) null,
	"double_" double precision null,
	"long_" bigint null,
	"text_" character varying(4000 char) null,
	"text2_" character varying(4000 char) null,
	"sequence_counter_" bigint null,
	"tenant_id_" character varying(64 char) null,
	"operation_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	"initial_" boolean null,
	constraint "act_hi_detail_pkey" primary key (id_)
);
create index act_idx_hi_detail_act_inst on "kesplus_workflow".act_hi_detail using btree (act_inst_id_);
create index act_idx_hi_detail_bytear on "kesplus_workflow".act_hi_detail using btree (bytearray_id_);
create index act_idx_hi_detail_case_exec on "kesplus_workflow".act_hi_detail using btree (case_execution_id_);
create index act_idx_hi_detail_case_inst on "kesplus_workflow".act_hi_detail using btree (case_inst_id_);
create index act_idx_hi_detail_name on "kesplus_workflow".act_hi_detail using btree (name_);
create index act_idx_hi_detail_proc_def_key on "kesplus_workflow".act_hi_detail using btree (proc_def_key_);
create index act_idx_hi_detail_proc_inst on "kesplus_workflow".act_hi_detail using btree (proc_inst_id_);
create index act_idx_hi_detail_rm_time on "kesplus_workflow".act_hi_detail using btree (removal_time_);
create index act_idx_hi_detail_root_pi on "kesplus_workflow".act_hi_detail using btree (root_proc_inst_id_);
create index act_idx_hi_detail_task_bytear on "kesplus_workflow".act_hi_detail using btree (bytearray_id_, task_id_);
create index act_idx_hi_detail_task_id on "kesplus_workflow".act_hi_detail using btree (task_id_);
create index act_idx_hi_detail_tenant_id on "kesplus_workflow".act_hi_detail using btree (tenant_id_);
create index act_idx_hi_detail_time on "kesplus_workflow".act_hi_detail using btree (time_);
create index act_idx_hi_detail_var_inst_id on "kesplus_workflow".act_hi_detail using btree (var_inst_id_);


-- "kesplus_workflow"."act_hi_ext_task_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_ext_task_log";

create table "kesplus_workflow"."act_hi_ext_task_log" (
	"id_" character varying(64 char) not null,
	"timestamp_" timestamp without time zone not null,
	"ext_task_id_" character varying(64 char) not null,
	"retries_" integer null,
	"topic_name_" character varying(255 char) null,
	"worker_id_" character varying(255 char) null,
	"priority_" bigint null default 0,
	"error_msg_" character varying(4000 char) null,
	"error_details_id_" character varying(64 char) null,
	"act_id_" character varying(255 char) null,
	"act_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	"state_" integer null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_ext_task_log_pkey" primary key (id_)
);
create index act_hi_ext_task_log_procdef on "kesplus_workflow".act_hi_ext_task_log using btree (proc_def_id_);
create index act_hi_ext_task_log_procinst on "kesplus_workflow".act_hi_ext_task_log using btree (proc_inst_id_);
create index act_hi_ext_task_log_proc_def_key on "kesplus_workflow".act_hi_ext_task_log using btree (proc_def_key_);
create index act_hi_ext_task_log_rm_time on "kesplus_workflow".act_hi_ext_task_log using btree (removal_time_);
create index act_hi_ext_task_log_root_pi on "kesplus_workflow".act_hi_ext_task_log using btree (root_proc_inst_id_);
create index act_hi_ext_task_log_tenant_id on "kesplus_workflow".act_hi_ext_task_log using btree (tenant_id_);
create index act_idx_hi_exttasklog_errordet on "kesplus_workflow".act_hi_ext_task_log using btree (error_details_id_);


-- "kesplus_workflow"."act_hi_identitylink" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_identitylink";

create table "kesplus_workflow"."act_hi_identitylink" (
	"id_" character varying(64 char) not null,
	"timestamp_" timestamp without time zone not null,
	"type_" character varying(255 char) null,
	"user_id_" character varying(255 char) null,
	"group_id_" character varying(255 char) null,
	"task_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"operation_type_" character varying(64 char) null,
	"assigner_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_identitylink_pkey" primary key (id_)
);
create index act_idx_hi_ident_link_rm_time on "kesplus_workflow".act_hi_identitylink using btree (removal_time_);
create index act_idx_hi_ident_link_task on "kesplus_workflow".act_hi_identitylink using btree (task_id_);
create index act_idx_hi_ident_lnk_group on "kesplus_workflow".act_hi_identitylink using btree (group_id_);
create index act_idx_hi_ident_lnk_proc_def_key on "kesplus_workflow".act_hi_identitylink using btree (proc_def_key_);
create index act_idx_hi_ident_lnk_root_pi on "kesplus_workflow".act_hi_identitylink using btree (root_proc_inst_id_);
create index act_idx_hi_ident_lnk_tenant_id on "kesplus_workflow".act_hi_identitylink using btree (tenant_id_);
create index act_idx_hi_ident_lnk_timestamp on "kesplus_workflow".act_hi_identitylink using btree (timestamp_);
create index act_idx_hi_ident_lnk_user on "kesplus_workflow".act_hi_identitylink using btree (user_id_);


-- "kesplus_workflow"."act_hi_incident" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_incident";

create table "kesplus_workflow"."act_hi_incident" (
	"id_" character varying(64 char) not null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"create_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"incident_msg_" character varying(4000 char) null,
	"incident_type_" character varying(255 char) not null,
	"activity_id_" character varying(255 char) null,
	"failed_activity_id_" character varying(255 char) null,
	"cause_incident_id_" character varying(64 char) null,
	"root_cause_incident_id_" character varying(64 char) null,
	"configuration_" character varying(255 char) null,
	"history_configuration_" character varying(255 char) null,
	"incident_state_" integer null,
	"tenant_id_" character varying(64 char) null,
	"job_def_id_" character varying(64 char) null,
	"annotation_" character varying(4000 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_incident_pkey" primary key (id_)
);
create index act_idx_hi_incident_create_time on "kesplus_workflow".act_hi_incident using btree (create_time_);
create index act_idx_hi_incident_end_time on "kesplus_workflow".act_hi_incident using btree (end_time_);
create index act_idx_hi_incident_procinst on "kesplus_workflow".act_hi_incident using btree (proc_inst_id_);
create index act_idx_hi_incident_proc_def_key on "kesplus_workflow".act_hi_incident using btree (proc_def_key_);
create index act_idx_hi_incident_rm_time on "kesplus_workflow".act_hi_incident using btree (removal_time_);
create index act_idx_hi_incident_root_pi on "kesplus_workflow".act_hi_incident using btree (root_proc_inst_id_);
create index act_idx_hi_incident_tenant_id on "kesplus_workflow".act_hi_incident using btree (tenant_id_);


-- "kesplus_workflow"."act_hi_job_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_job_log";

create table "kesplus_workflow"."act_hi_job_log" (
	"id_" character varying(64 char) not null,
	"timestamp_" timestamp without time zone not null,
	"job_id_" character varying(64 char) not null,
	"job_duedate_" timestamp without time zone null,
	"job_retries_" integer null,
	"job_priority_" bigint null default 0,
	"job_exception_msg_" character varying(4000 char) null,
	"job_exception_stack_id_" character varying(64 char) null,
	"job_state_" integer null,
	"job_def_id_" character varying(64 char) null,
	"job_def_type_" character varying(255 char) null,
	"job_def_configuration_" character varying(255 char) null,
	"act_id_" character varying(255 char) null,
	"failed_act_id_" character varying(255 char) null,
	"execution_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"process_instance_id_" character varying(64 char) null,
	"process_def_id_" character varying(64 char) null,
	"process_def_key_" character varying(255 char) null,
	"deployment_id_" character varying(64 char) null,
	"sequence_counter_" bigint null,
	"tenant_id_" character varying(64 char) null,
	"hostname_" character varying(255 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_job_log_pkey" primary key (id_)
);
create index act_idx_hi_job_log_ex_stack on "kesplus_workflow".act_hi_job_log using btree (job_exception_stack_id_);
create index act_idx_hi_job_log_job_conf on "kesplus_workflow".act_hi_job_log using btree (job_def_configuration_);
create index act_idx_hi_job_log_job_def_id on "kesplus_workflow".act_hi_job_log using btree (job_def_id_);
create index act_idx_hi_job_log_procdef on "kesplus_workflow".act_hi_job_log using btree (process_def_id_);
create index act_idx_hi_job_log_procinst on "kesplus_workflow".act_hi_job_log using btree (process_instance_id_);
create index act_idx_hi_job_log_proc_def_key on "kesplus_workflow".act_hi_job_log using btree (process_def_key_);
create index act_idx_hi_job_log_rm_time on "kesplus_workflow".act_hi_job_log using btree (removal_time_);
create index act_idx_hi_job_log_root_pi on "kesplus_workflow".act_hi_job_log using btree (root_proc_inst_id_);
create index act_idx_hi_job_log_tenant_id on "kesplus_workflow".act_hi_job_log using btree (tenant_id_);


-- "kesplus_workflow"."act_hi_op_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_op_log";

create table "kesplus_workflow"."act_hi_op_log" (
	"id_" character varying(64 char) not null,
	"deployment_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"case_def_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"task_id_" character varying(64 char) null,
	"job_id_" character varying(64 char) null,
	"job_def_id_" character varying(64 char) null,
	"batch_id_" character varying(64 char) null,
	"user_id_" character varying(255 char) null,
	"timestamp_" timestamp without time zone not null,
	"operation_type_" character varying(64 char) null,
	"operation_id_" character varying(64 char) null,
	"entity_type_" character varying(30 char) null,
	"property_" character varying(64 char) null,
	"org_value_" character varying(4000 char) null,
	"new_value_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	"category_" character varying(64 char) null,
	"external_task_id_" character varying(64 char) null,
	"annotation_" character varying(4000 char) null,
	constraint "act_hi_op_log_pkey" primary key (id_)
);
create index act_idx_hi_op_log_entity_type on "kesplus_workflow".act_hi_op_log using btree (entity_type_);
create index act_idx_hi_op_log_op_type on "kesplus_workflow".act_hi_op_log using btree (operation_type_);
create index act_idx_hi_op_log_procdef on "kesplus_workflow".act_hi_op_log using btree (proc_def_id_);
create index act_idx_hi_op_log_procinst on "kesplus_workflow".act_hi_op_log using btree (proc_inst_id_);
create index act_idx_hi_op_log_rm_time on "kesplus_workflow".act_hi_op_log using btree (removal_time_);
create index act_idx_hi_op_log_root_pi on "kesplus_workflow".act_hi_op_log using btree (root_proc_inst_id_);
create index act_idx_hi_op_log_task on "kesplus_workflow".act_hi_op_log using btree (task_id_);
create index act_idx_hi_op_log_timestamp on "kesplus_workflow".act_hi_op_log using btree (timestamp_);
create index act_idx_hi_op_log_user_id on "kesplus_workflow".act_hi_op_log using btree (user_id_);


-- "kesplus_workflow"."act_hi_procinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_procinst";

create table "kesplus_workflow"."act_hi_procinst" (
	"id_" character varying(64 char) not null,
	"proc_inst_id_" character varying(64 char) not null,
	"business_key_" character varying(255 char) null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) not null,
	"start_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"removal_time_" timestamp without time zone null,
	"duration_" bigint null,
	"start_user_id_" character varying(255 char) null,
	"start_act_id_" character varying(255 char) null,
	"end_act_id_" character varying(255 char) null,
	"super_process_instance_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"super_case_instance_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"delete_reason_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"state_" character varying(255 char) null,
	constraint "act_hi_procinst_proc_inst_id__key" unique (proc_inst_id_),
	constraint "act_hi_procinst_pkey" primary key (id_)
);
create index act_idx_hi_pi_pdefid_end_time on "kesplus_workflow".act_hi_procinst using btree (proc_def_id_, end_time_);
create index act_idx_hi_pro_inst_end on "kesplus_workflow".act_hi_procinst using btree (end_time_);
create index act_idx_hi_pro_inst_proc_def_key on "kesplus_workflow".act_hi_procinst using btree (proc_def_key_);
create index act_idx_hi_pro_inst_proc_time on "kesplus_workflow".act_hi_procinst using btree (start_time_, end_time_);
create index act_idx_hi_pro_inst_rm_time on "kesplus_workflow".act_hi_procinst using btree (removal_time_);
create index act_idx_hi_pro_inst_root_pi on "kesplus_workflow".act_hi_procinst using btree (root_proc_inst_id_);
create index act_idx_hi_pro_inst_tenant_id on "kesplus_workflow".act_hi_procinst using btree (tenant_id_);
create index act_idx_hi_pro_i_buskey on "kesplus_workflow".act_hi_procinst using btree (business_key_);


-- "kesplus_workflow"."act_hi_taskinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_taskinst";

create table "kesplus_workflow"."act_hi_taskinst" (
	"id_" character varying(64 char) not null,
	"task_def_key_" character varying(255 char) null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"case_def_key_" character varying(255 char) null,
	"case_def_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"act_inst_id_" character varying(64 char) null,
	"name_" character varying(255 char) null,
	"parent_task_id_" character varying(64 char) null,
	"description_" character varying(4000 char) null,
	"owner_" character varying(255 char) null,
	"assignee_" character varying(255 char) null,
	"start_time_" timestamp without time zone not null,
	"end_time_" timestamp without time zone null,
	"duration_" bigint null,
	"delete_reason_" character varying(4000 char) null,
	"priority_" integer null,
	"due_date_" timestamp without time zone null,
	"follow_up_date_" timestamp without time zone null,
	"tenant_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_taskinst_pkey" primary key (id_)
);
create index act_idx_hi_taskinstid_procinst on "kesplus_workflow".act_hi_taskinst using btree (id_, proc_inst_id_);
create index act_idx_hi_taskinst_procinst on "kesplus_workflow".act_hi_taskinst using btree (proc_inst_id_);
create index act_idx_hi_taskinst_root_pi on "kesplus_workflow".act_hi_taskinst using btree (root_proc_inst_id_);
create index act_idx_hi_task_inst_end on "kesplus_workflow".act_hi_taskinst using btree (end_time_);
create index act_idx_hi_task_inst_proc_def_key on "kesplus_workflow".act_hi_taskinst using btree (proc_def_key_);
create index act_idx_hi_task_inst_rm_time on "kesplus_workflow".act_hi_taskinst using btree (removal_time_);
create index act_idx_hi_task_inst_start on "kesplus_workflow".act_hi_taskinst using btree (start_time_);
create index act_idx_hi_task_inst_tenant_id on "kesplus_workflow".act_hi_taskinst using btree (tenant_id_);


-- "kesplus_workflow"."act_hi_varinst" definition

-- drop table

-- drop table "kesplus_workflow"."act_hi_varinst";

create table "kesplus_workflow"."act_hi_varinst" (
	"id_" character varying(64 char) not null,
	"proc_def_key_" character varying(255 char) null,
	"proc_def_id_" character varying(64 char) null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"execution_id_" character varying(64 char) null,
	"act_inst_id_" character varying(64 char) null,
	"case_def_key_" character varying(255 char) null,
	"case_def_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"task_id_" character varying(64 char) null,
	"name_" character varying(255 char) not null,
	"var_type_" character varying(100 char) null,
	"create_time_" timestamp without time zone null,
	"rev_" integer null,
	"bytearray_id_" character varying(64 char) null,
	"double_" double precision null,
	"long_" bigint null,
	"text_" character varying(80000 char) null,
	"text2_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"state_" character varying(20 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_hi_varinst_pkey" primary key (id_)
);
create index act_idx_hi_casevar_case_inst on "kesplus_workflow".act_hi_varinst using btree (case_inst_id_);
create index act_idx_hi_procvar_name_type on "kesplus_workflow".act_hi_varinst using btree (name_, var_type_);
create index act_idx_hi_procvar_proc_inst on "kesplus_workflow".act_hi_varinst using btree (proc_inst_id_);
create index act_idx_hi_varinst_act_inst_id on "kesplus_workflow".act_hi_varinst using btree (act_inst_id_);
create index act_idx_hi_varinst_bytear on "kesplus_workflow".act_hi_varinst using btree (bytearray_id_);
create index act_idx_hi_varinst_name on "kesplus_workflow".act_hi_varinst using btree (name_);
create index act_idx_hi_varinst_rm_time on "kesplus_workflow".act_hi_varinst using btree (removal_time_);
create index act_idx_hi_varinst_root_pi on "kesplus_workflow".act_hi_varinst using btree (root_proc_inst_id_);
create index act_idx_hi_var_inst_proc_def_key on "kesplus_workflow".act_hi_varinst using btree (proc_def_key_);
create index act_idx_hi_var_inst_tenant_id on "kesplus_workflow".act_hi_varinst using btree (tenant_id_);
create index act_idx_hi_var_pi_name_type on "kesplus_workflow".act_hi_varinst using btree (proc_inst_id_, name_, var_type_);
create index act_idx_hi_var_inst_execution_id on "kesplus_workflow".act_hi_varinst using btree (execution_id_);

-- "kesplus_workflow"."act_id_group" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_group";

create table "kesplus_workflow"."act_id_group" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"name_" character varying(255 char) null,
	"type_" character varying(255 char) null,
	constraint "act_id_group_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_id_info" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_info";

create table "kesplus_workflow"."act_id_info" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"user_id_" character varying(64 char) null,
	"type_" character varying(64 char) null,
	"key_" character varying(255 char) null,
	"value_" character varying(255 char) null,
	"password_" bytea null,
	"parent_id_" character varying(255 char) null,
	constraint "act_id_info_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_id_tenant" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_tenant";

create table "kesplus_workflow"."act_id_tenant" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"name_" character varying(255 char) null,
	constraint "act_id_tenant_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_id_user" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_user";

create table "kesplus_workflow"."act_id_user" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"first_" character varying(255 char) null,
	"last_" character varying(255 char) null,
	"email_" character varying(255 char) null,
	"pwd_" character varying(255 char) null,
	"salt_" character varying(255 char) null,
	"lock_exp_time_" timestamp without time zone null,
	"attempts_" integer null,
	"picture_id_" character varying(64 char) null,
	constraint "act_id_user_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_re_camformdef" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_camformdef";

create table "kesplus_workflow"."act_re_camformdef" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"key_" character varying(255 char) not null,
	"version_" integer not null,
	"deployment_id_" character varying(64 char) null,
	"resource_name_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_re_camformdef_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_re_case_def" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_case_def";

create table "kesplus_workflow"."act_re_case_def" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"category_" character varying(255 char) null,
	"name_" character varying(255 char) null,
	"key_" character varying(255 char) not null,
	"version_" integer not null,
	"deployment_id_" character varying(64 char) null,
	"resource_name_" character varying(4000 char) null,
	"dgrm_resource_name_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	"history_ttl_" integer null,
	constraint "act_re_case_def_pkey" primary key (id_)
);
create index act_idx_case_def_tenant_id on "kesplus_workflow".act_re_case_def using btree (tenant_id_);


-- "kesplus_workflow"."act_re_decision_req_def" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_decision_req_def";

create table "kesplus_workflow"."act_re_decision_req_def" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"category_" character varying(255 char) null,
	"name_" character varying(255 char) null,
	"key_" character varying(255 char) not null,
	"version_" integer not null,
	"deployment_id_" character varying(64 char) null,
	"resource_name_" character varying(4000 char) null,
	"dgrm_resource_name_" character varying(4000 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_re_decision_req_def_pkey" primary key (id_)
);
create index act_idx_dec_req_def_tenant_id on "kesplus_workflow".act_re_decision_req_def using btree (tenant_id_);


-- "kesplus_workflow"."act_re_deployment" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_deployment";

create table "kesplus_workflow"."act_re_deployment" (
	"id_" character varying(64 char) not null,
	"name_" character varying(255 char) null,
	"deploy_time_" timestamp without time zone null,
	"source_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_re_deployment_pkey" primary key (id_)
);
create index act_idx_deployment_name on "kesplus_workflow".act_re_deployment using btree (name_);
create index act_idx_deployment_tenant_id on "kesplus_workflow".act_re_deployment using btree (tenant_id_);


-- "kesplus_workflow"."act_re_procdef" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_procdef";

create table "kesplus_workflow"."act_re_procdef" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"category_" character varying(255 char) null,
	"name_" character varying(255 char) null,
	"key_" character varying(255 char) not null,
	"version_" integer not null,
	"deployment_id_" character varying(64 char) null,
	"resource_name_" character varying(4000 char) null,
	"dgrm_resource_name_" character varying(4000 char) null,
	"has_start_form_key_" boolean null,
	"suspension_state_" integer null,
	"tenant_id_" character varying(64 char) null,
	"version_tag_" character varying(64 char) null,
	"history_ttl_" integer null,
	"startable_" boolean not null default true,
	constraint "act_re_procdef_pkey" primary key (id_)
);
create index act_idx_procdef_deployment_id on "kesplus_workflow".act_re_procdef using btree (deployment_id_);
create index act_idx_procdef_tenant_id on "kesplus_workflow".act_re_procdef using btree (tenant_id_);
create index act_idx_procdef_ver_tag on "kesplus_workflow".act_re_procdef using btree (version_tag_);


-- "kesplus_workflow"."act_ru_authorization" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_authorization";

create table "kesplus_workflow"."act_ru_authorization" (
	"id_" character varying(64 char) not null,
	"rev_" integer not null,
	"type_" integer not null,
	"group_id_" character varying(255 char) null,
	"user_id_" character varying(255 char) null,
	"resource_type_" integer not null,
	"resource_id_" character varying(255 char) null,
	"perms_" integer null,
	"removal_time_" timestamp without time zone null,
	"root_proc_inst_id_" character varying(64 char) null,
	constraint "act_ru_authorization_pkey" primary key (id_),
	constraint "act_uniq_auth_group" unique (type_, group_id_, resource_type_, resource_id_),
	constraint "act_uniq_auth_user" unique (type_, user_id_, resource_type_, resource_id_)
);
create index act_idx_auth_group_id on "kesplus_workflow".act_ru_authorization using btree (group_id_);
create index act_idx_auth_resource_id on "kesplus_workflow".act_ru_authorization using btree (resource_id_);
create index act_idx_auth_rm_time on "kesplus_workflow".act_ru_authorization using btree (removal_time_);
create index act_idx_auth_root_pi on "kesplus_workflow".act_ru_authorization using btree (root_proc_inst_id_);


-- "kesplus_workflow"."act_ru_filter" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_filter";

create table "kesplus_workflow"."act_ru_filter" (
	"id_" character varying(64 char) not null,
	"rev_" integer not null,
	"resource_type_" character varying(255 char) not null,
	"name_" character varying(255 char) not null,
	"owner_" character varying(255 char) null,
	"query_" text not null,
	"properties_" text null,
	constraint "act_ru_filter_pkey" primary key (id_)
);


-- "kesplus_workflow"."act_ru_jobdef" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_jobdef";

create table "kesplus_workflow"."act_ru_jobdef" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"proc_def_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"act_id_" character varying(255 char) null,
	"job_type_" character varying(255 char) not null,
	"job_configuration_" character varying(255 char) null,
	"suspension_state_" integer null,
	"job_priority_" bigint null,
	"tenant_id_" character varying(64 char) null,
	"deployment_id_" character varying(64 char) null,
	constraint "act_ru_jobdef_pkey" primary key (id_)
);
create index act_idx_jobdef_proc_def_id on "kesplus_workflow".act_ru_jobdef using btree (proc_def_id_);
create index act_idx_jobdef_tenant_id on "kesplus_workflow".act_ru_jobdef using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_meter_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_meter_log";

create table "kesplus_workflow"."act_ru_meter_log" (
	"id_" character varying(64 char) not null,
	"name_" character varying(64 char) not null,
	"reporter_" character varying(255 char) null,
	"value_" bigint null,
	"timestamp_" timestamp without time zone null,
	"milliseconds_" bigint null default 0,
	constraint "act_ru_meter_log_pkey" primary key (id_)
);
create index act_idx_meter_log on "kesplus_workflow".act_ru_meter_log using btree (name_, timestamp_);
create index act_idx_meter_log_ms on "kesplus_workflow".act_ru_meter_log using btree (milliseconds_);
create index act_idx_meter_log_name_ms on "kesplus_workflow".act_ru_meter_log using btree (name_, milliseconds_);
create index act_idx_meter_log_report on "kesplus_workflow".act_ru_meter_log using btree (name_, reporter_, milliseconds_);
create index act_idx_meter_log_time on "kesplus_workflow".act_ru_meter_log using btree (timestamp_);


-- "kesplus_workflow"."act_ru_task_meter_log" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_task_meter_log";

create table "kesplus_workflow"."act_ru_task_meter_log" (
	"id_" character varying(64 char) not null,
	"assignee_hash_" bigint null,
	"timestamp_" timestamp without time zone null,
	constraint "act_ru_task_meter_log_pkey" primary key (id_)
);
create index act_idx_task_meter_log_time on "kesplus_workflow".act_ru_task_meter_log using btree (timestamp_);


-- "kesplus_workflow"."act_ge_bytearray" definition

-- drop table

-- drop table "kesplus_workflow"."act_ge_bytearray";

create table "kesplus_workflow"."act_ge_bytearray" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"name_" character varying(255 char) null,
	"deployment_id_" character varying(64 char) null,
	"bytes_" bytea null,
	"generated_" boolean null,
	"tenant_id_" character varying(64 char) null,
	"type_" integer null,
	"create_time_" timestamp without time zone null,
	"root_proc_inst_id_" character varying(64 char) null,
	"removal_time_" timestamp without time zone null,
	constraint "act_ge_bytearray_pkey" primary key (id_),
	constraint "act_fk_bytearr_depl" foreign key (deployment_id_) references "kesplus_workflow".act_re_deployment(id_)
);
create index act_idx_bytearray_name on "kesplus_workflow".act_ge_bytearray using btree (name_);
create index act_idx_bytearray_rm_time on "kesplus_workflow".act_ge_bytearray using btree (removal_time_);
create index act_idx_bytearray_root_pi on "kesplus_workflow".act_ge_bytearray using btree (root_proc_inst_id_);
create index act_idx_bytear_depl on "kesplus_workflow".act_ge_bytearray using btree (deployment_id_);


-- "kesplus_workflow"."act_id_membership" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_membership";

create table "kesplus_workflow"."act_id_membership" (
	"user_id_" character varying(64 char) not null,
	"group_id_" character varying(64 char) not null,
	constraint "act_id_membership_pkey" primary key (user_id_, group_id_),
	constraint "act_fk_memb_group" foreign key (group_id_) references "kesplus_workflow".act_id_group(id_),
	constraint "act_fk_memb_user" foreign key (user_id_) references "kesplus_workflow".act_id_user(id_)
);
create index act_idx_memb_group on "kesplus_workflow".act_id_membership using btree (group_id_);
create index act_idx_memb_user on "kesplus_workflow".act_id_membership using btree (user_id_);


-- "kesplus_workflow"."act_id_tenant_member" definition

-- drop table

-- drop table "kesplus_workflow"."act_id_tenant_member";

create table "kesplus_workflow"."act_id_tenant_member" (
	"id_" character varying(64 char) not null,
	"tenant_id_" character varying(64 char) not null,
	"user_id_" character varying(64 char) null,
	"group_id_" character varying(64 char) null,
	constraint "act_id_tenant_member_pkey" primary key (id_),
	constraint "act_uniq_tenant_memb_group" unique (tenant_id_, group_id_),
	constraint "act_uniq_tenant_memb_user" unique (tenant_id_, user_id_),
	constraint "act_fk_tenant_memb" foreign key (tenant_id_) references "kesplus_workflow".act_id_tenant(id_),
	constraint "act_fk_tenant_memb_group" foreign key (group_id_) references "kesplus_workflow".act_id_group(id_),
	constraint "act_fk_tenant_memb_user" foreign key (user_id_) references "kesplus_workflow".act_id_user(id_)
);
create index act_idx_tenant_memb on "kesplus_workflow".act_id_tenant_member using btree (tenant_id_);
create index act_idx_tenant_memb_group on "kesplus_workflow".act_id_tenant_member using btree (group_id_);
create index act_idx_tenant_memb_user on "kesplus_workflow".act_id_tenant_member using btree (user_id_);


-- "kesplus_workflow"."act_re_decision_def" definition

-- drop table

-- drop table "kesplus_workflow"."act_re_decision_def";

create table "kesplus_workflow"."act_re_decision_def" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"category_" character varying(255 char) null,
	"name_" character varying(255 char) null,
	"key_" character varying(255 char) not null,
	"version_" integer not null,
	"deployment_id_" character varying(64 char) null,
	"resource_name_" character varying(4000 char) null,
	"dgrm_resource_name_" character varying(4000 char) null,
	"dec_req_id_" character varying(64 char) null,
	"dec_req_key_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	"history_ttl_" integer null,
	"version_tag_" character varying(64 char) null,
	constraint "act_re_decision_def_pkey" primary key (id_),
	constraint "act_fk_dec_req" foreign key (dec_req_id_) references "kesplus_workflow".act_re_decision_req_def(id_)
);
create index act_idx_dec_def_req_id on "kesplus_workflow".act_re_decision_def using btree (dec_req_id_);
create index act_idx_dec_def_tenant_id on "kesplus_workflow".act_re_decision_def using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_batch" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_batch";

create table "kesplus_workflow"."act_ru_batch" (
	"id_" character varying(64 char) not null,
	"rev_" integer not null,
	"type_" character varying(255 char) null,
	"total_jobs_" integer null,
	"jobs_created_" integer null,
	"jobs_per_seed_" integer null,
	"invocations_per_job_" integer null,
	"seed_job_def_id_" character varying(64 char) null,
	"batch_job_def_id_" character varying(64 char) null,
	"monitor_job_def_id_" character varying(64 char) null,
	"suspension_state_" integer null,
	"configuration_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	"create_user_id_" character varying(255 char) null,
	constraint "act_ru_batch_pkey" primary key (id_),
	constraint "act_fk_batch_job_def" foreign key (batch_job_def_id_) references "kesplus_workflow".act_ru_jobdef(id_),
	constraint "act_fk_batch_monitor_job_def" foreign key (monitor_job_def_id_) references "kesplus_workflow".act_ru_jobdef(id_),
	constraint "act_fk_batch_seed_job_def" foreign key (seed_job_def_id_) references "kesplus_workflow".act_ru_jobdef(id_)
);
create index act_idx_batch_job_def on "kesplus_workflow".act_ru_batch using btree (batch_job_def_id_);
create index act_idx_batch_monitor_job_def on "kesplus_workflow".act_ru_batch using btree (monitor_job_def_id_);
create index act_idx_batch_seed_job_def on "kesplus_workflow".act_ru_batch using btree (seed_job_def_id_);


-- "kesplus_workflow"."act_ru_case_execution" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_case_execution";

create table "kesplus_workflow"."act_ru_case_execution" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"case_inst_id_" character varying(64 char) null,
	"super_case_exec_" character varying(64 char) null,
	"super_exec_" character varying(64 char) null,
	"business_key_" character varying(255 char) null,
	"parent_id_" character varying(64 char) null,
	"case_def_id_" character varying(64 char) null,
	"act_id_" character varying(255 char) null,
	"prev_state_" integer null,
	"current_state_" integer null,
	"required_" boolean null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_case_execution_pkey" primary key (id_),
	constraint "act_fk_case_exe_case_def" foreign key (case_def_id_) references "kesplus_workflow".act_re_case_def(id_),
	constraint "act_fk_case_exe_case_inst" foreign key (case_inst_id_) references "kesplus_workflow".act_ru_case_execution(id_),
	constraint "act_fk_case_exe_parent" foreign key (parent_id_) references "kesplus_workflow".act_ru_case_execution(id_)
);
create index act_idx_case_exec_buskey on "kesplus_workflow".act_ru_case_execution using btree (business_key_);
create index act_idx_case_exec_tenant_id on "kesplus_workflow".act_ru_case_execution using btree (tenant_id_);
create index act_idx_case_exe_case_def on "kesplus_workflow".act_ru_case_execution using btree (case_def_id_);
create index act_idx_case_exe_case_inst on "kesplus_workflow".act_ru_case_execution using btree (case_inst_id_);
create index act_idx_case_exe_parent on "kesplus_workflow".act_ru_case_execution using btree (parent_id_);


-- "kesplus_workflow"."act_ru_case_sentry_part" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_case_sentry_part";

create table "kesplus_workflow"."act_ru_case_sentry_part" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"case_inst_id_" character varying(64 char) null,
	"case_exec_id_" character varying(64 char) null,
	"sentry_id_" character varying(255 char) null,
	"type_" character varying(255 char) null,
	"source_case_exec_id_" character varying(64 char) null,
	"standard_event_" character varying(255 char) null,
	"source_" character varying(255 char) null,
	"variable_event_" character varying(255 char) null,
	"variable_name_" character varying(255 char) null,
	"satisfied_" boolean null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_case_sentry_part_pkey" primary key (id_),
	constraint "act_fk_case_sentry_case_exec" foreign key (case_exec_id_) references "kesplus_workflow".act_ru_case_execution(id_),
	constraint "act_fk_case_sentry_case_inst" foreign key (case_inst_id_) references "kesplus_workflow".act_ru_case_execution(id_)
);
create index act_idx_case_sentry_case_exec on "kesplus_workflow".act_ru_case_sentry_part using btree (case_exec_id_);
create index act_idx_case_sentry_case_inst on "kesplus_workflow".act_ru_case_sentry_part using btree (case_inst_id_);


-- "kesplus_workflow"."act_ru_execution" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_execution";

create table "kesplus_workflow"."act_ru_execution" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"root_proc_inst_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"business_key_" character varying(255 char) null,
	"parent_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"super_exec_" character varying(64 char) null,
	"super_case_exec_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"act_id_" character varying(255 char) null,
	"act_inst_id_" character varying(64 char) null,
	"is_active_" boolean null,
	"is_concurrent_" boolean null,
	"is_scope_" boolean null,
	"is_event_scope_" boolean null,
	"suspension_state_" integer null,
	"cached_ent_state_" integer null,
	"sequence_counter_" bigint null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_execution_pkey" primary key (id_),
	constraint "act_fk_exe_parent" foreign key (parent_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_exe_procdef" foreign key (proc_def_id_) references "kesplus_workflow".act_re_procdef(id_),
	constraint "act_fk_exe_procinst" foreign key (proc_inst_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_exe_super" foreign key (super_exec_) references "kesplus_workflow".act_ru_execution(id_)
);
create index act_idx_exec_buskey on "kesplus_workflow".act_ru_execution using btree (business_key_);
create index act_idx_exec_tenant_id on "kesplus_workflow".act_ru_execution using btree (tenant_id_);
create index act_idx_exe_parent on "kesplus_workflow".act_ru_execution using btree (parent_id_);
create index act_idx_exe_procdef on "kesplus_workflow".act_ru_execution using btree (proc_def_id_);
create index act_idx_exe_procinst on "kesplus_workflow".act_ru_execution using btree (proc_inst_id_);
create index act_idx_exe_root_pi on "kesplus_workflow".act_ru_execution using btree (root_proc_inst_id_);
create index act_idx_exe_super on "kesplus_workflow".act_ru_execution using btree (super_exec_);


-- "kesplus_workflow"."act_ru_ext_task" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_ext_task";

create table "kesplus_workflow"."act_ru_ext_task" (
	"id_" character varying(64 char) not null,
	"rev_" integer not null,
	"worker_id_" character varying(255 char) null,
	"topic_name_" character varying(255 char) null,
	"retries_" integer null,
	"error_msg_" character varying(4000 char) null,
	"error_details_id_" character varying(64 char) null,
	"lock_exp_time_" timestamp without time zone null,
	"suspension_state_" integer null,
	"execution_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"proc_def_key_" character varying(255 char) null,
	"act_id_" character varying(255 char) null,
	"act_inst_id_" character varying(64 char) null,
	"tenant_id_" character varying(64 char) null,
	"priority_" bigint null default 0,
	"last_failure_log_id_" character varying(64 char) null,
	constraint "act_ru_ext_task_pkey" primary key (id_),
	constraint "act_fk_ext_task_error_details" foreign key (error_details_id_) references "kesplus_workflow".act_ge_bytearray(id_),
	constraint "act_fk_ext_task_exe" foreign key (execution_id_) references "kesplus_workflow".act_ru_execution(id_)
);
create index act_idx_ext_task_err_details on "kesplus_workflow".act_ru_ext_task using btree (error_details_id_);
create index act_idx_ext_task_exec on "kesplus_workflow".act_ru_ext_task using btree (execution_id_);
create index act_idx_ext_task_priority on "kesplus_workflow".act_ru_ext_task using btree (priority_);
create index act_idx_ext_task_tenant_id on "kesplus_workflow".act_ru_ext_task using btree (tenant_id_);
create index act_idx_ext_task_topic on "kesplus_workflow".act_ru_ext_task using btree (topic_name_);


-- "kesplus_workflow"."act_ru_incident" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_incident";

create table "kesplus_workflow"."act_ru_incident" (
	"id_" character varying(64 char) not null,
	"rev_" integer not null,
	"incident_timestamp_" timestamp without time zone not null,
	"incident_msg_" character varying(4000 char) null,
	"incident_type_" character varying(255 char) not null,
	"execution_id_" character varying(64 char) null,
	"activity_id_" character varying(255 char) null,
	"failed_activity_id_" character varying(255 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"cause_incident_id_" character varying(64 char) null,
	"root_cause_incident_id_" character varying(64 char) null,
	"configuration_" character varying(255 char) null,
	"tenant_id_" character varying(64 char) null,
	"job_def_id_" character varying(64 char) null,
	"annotation_" character varying(4000 char) null,
	constraint "act_ru_incident_pkey" primary key (id_),
	constraint "act_fk_inc_cause" foreign key (cause_incident_id_) references "kesplus_workflow".act_ru_incident(id_),
	constraint "act_fk_inc_exe" foreign key (execution_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_inc_job_def" foreign key (job_def_id_) references "kesplus_workflow".act_ru_jobdef(id_),
	constraint "act_fk_inc_procdef" foreign key (proc_def_id_) references "kesplus_workflow".act_re_procdef(id_),
	constraint "act_fk_inc_procinst" foreign key (proc_inst_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_inc_rcause" foreign key (root_cause_incident_id_) references "kesplus_workflow".act_ru_incident(id_)
);
create index act_idx_inc_causeincid on "kesplus_workflow".act_ru_incident using btree (cause_incident_id_);
create index act_idx_inc_configuration on "kesplus_workflow".act_ru_incident using btree (configuration_);
create index act_idx_inc_exid on "kesplus_workflow".act_ru_incident using btree (execution_id_);
create index act_idx_inc_job_def on "kesplus_workflow".act_ru_incident using btree (job_def_id_);
create index act_idx_inc_procdefid on "kesplus_workflow".act_ru_incident using btree (proc_def_id_);
create index act_idx_inc_procinstid on "kesplus_workflow".act_ru_incident using btree (proc_inst_id_);
create index act_idx_inc_rootcauseincid on "kesplus_workflow".act_ru_incident using btree (root_cause_incident_id_);
create index act_idx_inc_tenant_id on "kesplus_workflow".act_ru_incident using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_job" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_job";

create table "kesplus_workflow"."act_ru_job" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"type_" character varying(255 char) not null,
	"lock_exp_time_" timestamp without time zone null,
	"lock_owner_" character varying(255 char) null,
	"exclusive_" boolean null,
	"execution_id_" character varying(64 char) null,
	"process_instance_id_" character varying(64 char) null,
	"process_def_id_" character varying(64 char) null,
	"process_def_key_" character varying(255 char) null,
	"retries_" integer null,
	"exception_stack_id_" character varying(64 char) null,
	"exception_msg_" character varying(4000 char) null,
	"failed_act_id_" character varying(255 char) null,
	"duedate_" timestamp without time zone null,
	"repeat_" character varying(255 char) null,
	"repeat_offset_" bigint null default 0,
	"handler_type_" character varying(255 char) null,
	"handler_cfg_" character varying(4000 char) null,
	"deployment_id_" character varying(64 char) null,
	"suspension_state_" integer not null default 1,
	"job_def_id_" character varying(64 char) null,
	"priority_" bigint null default 0,
	"sequence_counter_" bigint null,
	"tenant_id_" character varying(64 char) null,
	"create_time_" timestamp without time zone null,
	"last_failure_log_id_" character varying(64 char) null,
	constraint "act_ru_job_pkey" primary key (id_),
	constraint "act_fk_job_exception" foreign key (exception_stack_id_) references "kesplus_workflow".act_ge_bytearray(id_)
);
create index act_idx_job_exception on "kesplus_workflow".act_ru_job using btree (exception_stack_id_);
create index act_idx_job_execution_id on "kesplus_workflow".act_ru_job using btree (execution_id_);
create index act_idx_job_handler on "kesplus_workflow".act_ru_job using btree (handler_type_, handler_cfg_);
create index act_idx_job_handler_type on "kesplus_workflow".act_ru_job using btree (handler_type_);
create index act_idx_job_job_def_id on "kesplus_workflow".act_ru_job using btree (job_def_id_);
create index act_idx_job_procinst on "kesplus_workflow".act_ru_job using btree (process_instance_id_);
create index act_idx_job_tenant_id on "kesplus_workflow".act_ru_job using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_task" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_task";

create table "kesplus_workflow"."act_ru_task" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"execution_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"case_def_id_" character varying(64 char) null,
	"name_" character varying(255 char) null,
	"parent_task_id_" character varying(64 char) null,
	"description_" character varying(4000 char) null,
	"task_def_key_" character varying(255 char) null,
	"owner_" character varying(255 char) null,
	"assignee_" character varying(255 char) null,
	"delegation_" character varying(500 char) null,
	"priority_" integer null,
	"create_time_" timestamp without time zone null,
	"due_date_" timestamp without time zone null,
	"follow_up_date_" timestamp without time zone null,
	"suspension_state_" integer null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_task_pkey" primary key (id_),
	constraint "act_fk_task_case_def" foreign key (case_def_id_) references "kesplus_workflow".act_re_case_def(id_),
	constraint "act_fk_task_case_exe" foreign key (case_execution_id_) references "kesplus_workflow".act_ru_case_execution(id_),
	constraint "act_fk_task_exe" foreign key (execution_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_task_procdef" foreign key (proc_def_id_) references "kesplus_workflow".act_re_procdef(id_),
	constraint "act_fk_task_procinst" foreign key (proc_inst_id_) references "kesplus_workflow".act_ru_execution(id_)
);
create index act_idx_task_assignee on "kesplus_workflow".act_ru_task using btree (assignee_);
create index act_idx_task_case_def_id on "kesplus_workflow".act_ru_task using btree (case_def_id_);
create index act_idx_task_case_exec on "kesplus_workflow".act_ru_task using btree (case_execution_id_);
create index act_idx_task_create on "kesplus_workflow".act_ru_task using btree (create_time_);
create index act_idx_task_exec on "kesplus_workflow".act_ru_task using btree (execution_id_);
create index act_idx_task_owner on "kesplus_workflow".act_ru_task using btree (owner_);
create index act_idx_task_procdef on "kesplus_workflow".act_ru_task using btree (proc_def_id_);
create index act_idx_task_procinst on "kesplus_workflow".act_ru_task using btree (proc_inst_id_);
create index act_idx_task_tenant_id on "kesplus_workflow".act_ru_task using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_variable" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_variable";

create table "kesplus_workflow"."act_ru_variable" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"type_" character varying(255 char) not null,
	"name_" character varying(255 char) not null,
	"execution_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"case_execution_id_" character varying(64 char) null,
	"case_inst_id_" character varying(64 char) null,
	"task_id_" character varying(64 char) null,
	"batch_id_" character varying(64 char) null,
	"bytearray_id_" character varying(64 char) null,
	"double_" double precision null,
	"long_" bigint null,
	"text_" character varying(80000 char) null,
	"text2_" character varying(4000 char) null,
	"var_scope_" character varying(64 char) null,
	"sequence_counter_" bigint null,
	"is_concurrent_local_" boolean null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_variable_pkey" primary key (id_),
	constraint "act_uniq_variable" unique (var_scope_, name_),
	constraint "act_fk_var_batch" foreign key (batch_id_) references "kesplus_workflow".act_ru_batch(id_),
	constraint "act_fk_var_bytearray" foreign key (bytearray_id_) references "kesplus_workflow".act_ge_bytearray(id_),
	constraint "act_fk_var_case_exe" foreign key (case_execution_id_) references "kesplus_workflow".act_ru_case_execution(id_),
	constraint "act_fk_var_case_inst" foreign key (case_inst_id_) references "kesplus_workflow".act_ru_case_execution(id_),
	constraint "act_fk_var_exe" foreign key (execution_id_) references "kesplus_workflow".act_ru_execution(id_),
	constraint "act_fk_var_procinst" foreign key (proc_inst_id_) references "kesplus_workflow".act_ru_execution(id_)
);
create index act_idx_batch_id on "kesplus_workflow".act_ru_variable using btree (batch_id_);
create index act_idx_variable_task_id on "kesplus_workflow".act_ru_variable using btree (task_id_);
create index act_idx_variable_task_name_type on "kesplus_workflow".act_ru_variable using btree (task_id_, name_, type_);
create index act_idx_variable_tenant_id on "kesplus_workflow".act_ru_variable using btree (tenant_id_);
create index act_idx_var_bytearray on "kesplus_workflow".act_ru_variable using btree (bytearray_id_);
create index act_idx_var_case_exe on "kesplus_workflow".act_ru_variable using btree (case_execution_id_);
create index act_idx_var_case_inst_id on "kesplus_workflow".act_ru_variable using btree (case_inst_id_);
create index act_idx_var_exe on "kesplus_workflow".act_ru_variable using btree (execution_id_);
create index act_idx_var_procinst on "kesplus_workflow".act_ru_variable using btree (proc_inst_id_);


-- "kesplus_workflow"."act_ru_event_subscr" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_event_subscr";

create table "kesplus_workflow"."act_ru_event_subscr" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"event_type_" character varying(255 char) not null,
	"event_name_" character varying(255 char) null,
	"execution_id_" character varying(64 char) null,
	"proc_inst_id_" character varying(64 char) null,
	"activity_id_" character varying(255 char) null,
	"configuration_" character varying(255 char) null,
	"created_" timestamp without time zone not null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_event_subscr_pkey" primary key (id_),
	constraint "act_fk_event_exec" foreign key (execution_id_) references "kesplus_workflow".act_ru_execution(id_)
);
create index act_idx_event_subscr on "kesplus_workflow".act_ru_event_subscr using btree (execution_id_);
create index act_idx_event_subscr_config_ on "kesplus_workflow".act_ru_event_subscr using btree (configuration_);
create index act_idx_event_subscr_evt_name on "kesplus_workflow".act_ru_event_subscr using btree (event_name_);
create index act_idx_event_subscr_tenant_id on "kesplus_workflow".act_ru_event_subscr using btree (tenant_id_);


-- "kesplus_workflow"."act_ru_identitylink" definition

-- drop table

-- drop table "kesplus_workflow"."act_ru_identitylink";

create table "kesplus_workflow"."act_ru_identitylink" (
	"id_" character varying(64 char) not null,
	"rev_" integer null,
	"group_id_" character varying(255 char) null,
	"type_" character varying(255 char) null,
	"user_id_" character varying(255 char) null,
	"task_id_" character varying(64 char) null,
	"proc_def_id_" character varying(64 char) null,
	"tenant_id_" character varying(64 char) null,
	constraint "act_ru_identitylink_pkey" primary key (id_),
	constraint "act_fk_athrz_procedef" foreign key (proc_def_id_) references "kesplus_workflow".act_re_procdef(id_),
	constraint "act_fk_tskass_task" foreign key (task_id_) references "kesplus_workflow".act_ru_task(id_)
);
create index act_idx_athrz_procedef on "kesplus_workflow".act_ru_identitylink using btree (proc_def_id_);
create index act_idx_ident_lnk_group on "kesplus_workflow".act_ru_identitylink using btree (group_id_);
create index act_idx_ident_lnk_user on "kesplus_workflow".act_ru_identitylink using btree (user_id_);
create index act_idx_tskass_task on "kesplus_workflow".act_ru_identitylink using btree (task_id_);