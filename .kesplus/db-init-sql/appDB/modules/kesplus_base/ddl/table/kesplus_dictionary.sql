-- "kesplus_base"."kesplus_dictionary" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_dictionary";

CREATE TABLE "kesplus_base"."kesplus_dictionary" (
	"id" character varying(32 char) NOT NULL,
	"code" character varying(64 char) NOT NULL,
	"dictionary_id" character varying(32 char) NOT NULL,
	"name" character varying(100 char) NOT NULL,
	"short_name" character varying(100 char) NULL,
	"description" character varying(255 char) NULL,
	"val" character varying(255 char) NULL,
	"pid" character varying(32 char) NOT NULL DEFAULT '0'::varchar,
	"module_id" character varying(32 char) NULL DEFAULT 0,
	"sort" integer NULL DEFAULT 0,
	"dictionary_level" integer NULL DEFAULT 0,
	"filters" json NULL,
	"enabled" smallint NOT NULL DEFAULT 1,
	"val_type" character varying(8 char) NULL,
	"create_by" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_by" character varying(32 char) NULL,
	"update_time" date NULL,
	"dept_id" character varying(32 char) NULL DEFAULT 0,
	"dictionary_tree" json NULL,
	"labels" varchar[] NULL,
	CONSTRAINT "pk_base_dictionary" PRIMARY KEY (id)
);

CREATE INDEX k_code_val ON kesplus_base.kesplus_dictionary USING btree (code);
CREATE UNIQUE INDEX uk_code_val ON kesplus_base.kesplus_dictionary USING btree (code, val);
CREATE UNIQUE INDEX uk_pid_name ON kesplus_base.kesplus_dictionary USING btree (pid, name);
