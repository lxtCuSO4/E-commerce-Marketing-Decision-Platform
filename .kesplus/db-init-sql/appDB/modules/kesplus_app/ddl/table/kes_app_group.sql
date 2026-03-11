-- "kesplus_app"."kes_app_group" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_app_group";

CREATE TABLE "kesplus_app"."kes_app_group" (
                                            "group_id" character varying(32 char) NOT NULL,
                                            "name" character varying(50 char) NULL,
                                            "pid" character varying(64 char) NULL,
                                            "create_time" date NULL,
                                            "group_code" character varying(100 char) NULL,
                                            "enabled" smallint NULL,
                                            "group_sort" integer NULL,
                                            "sub_count" smallint NULL,
                                            "create_by" character varying(255 char) NULL,
                                            "update_by" character varying(255 char) NULL,
                                            "update_time" date NULL,
                                            CONSTRAINT "kes_app_group_pkey" PRIMARY KEY (group_id)
);