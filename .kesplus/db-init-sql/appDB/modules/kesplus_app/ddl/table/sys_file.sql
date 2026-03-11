-- "kesplus_app"."sys_file" definition

-- Drop table
CREATE TABLE "kesplus_app"."sys_file" (
                                   "id" character varying(32 char) NOT NULL,
                                   "file_name" character varying(512 char) NULL DEFAULT 0,
                                   "parent_id" character varying(32 char) NULL,
                                   "file_type" character varying(8 char) NOT NULL,
                                   "file_parent_full_path" character varying(512 char) NULL,
                                   "file_suffix" character varying(20 char) NULL,
                                   "app_id" character varying(32 char) NULL,
                                   "tenant_id" character varying(32 char) NULL,
                                   "version" character varying(4 char) NULL,
                                   "remark" character varying(255 char) NULL,
                                   "create_time" date NULL,
                                   "update_time" date NULL,
                                   "file_size" varchar(128) null,
                                   CONSTRAINT "sys_file_pkey" PRIMARY KEY (id)
);
CREATE INDEX index_file_search ON "kesplus_app".sys_file USING btree (tenant_id, app_id, file_name, parent_id);