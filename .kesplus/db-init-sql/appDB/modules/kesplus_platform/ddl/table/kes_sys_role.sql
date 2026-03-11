-- "kesplus_platform"."kes_sys_role" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_sys_role";

CREATE TABLE "kesplus_platform"."kes_sys_role" (
       "id" character varying(32 char) NOT NULL,
       "name" character varying(255 char) NULL,
       "create_time" date NULL,
       "level" smallint NULL,
       "description" character varying(255 char) NULL,
       "create_by" character varying(255 char) NULL,
       "update_by" character varying(255 char) NULL,
       "update_time" date NULL,
       "code" character varying(50 char) NULL,
       "role_sort" integer NULL,
       "permissions" text NULL,
       CONSTRAINT "kes_sys_role_pkey" PRIMARY KEY (id)
);