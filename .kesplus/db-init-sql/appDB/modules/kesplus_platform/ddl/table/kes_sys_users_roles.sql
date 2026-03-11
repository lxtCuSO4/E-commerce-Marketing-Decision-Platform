-- "kesplus_platform"."kes_sys_users_roles" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_platform"."kes_sys_users_roles";

CREATE TABLE "kesplus_platform"."kes_sys_users_roles" (
                                              "id" character varying(32 char) NOT NULL,
                                              "user_id" character varying(32 char) NULL,
                                              "role_ids" character varying(2000 char) NULL,
                                              "app_id" character varying(32 char) NULL,
                                              "create_time" date NULL,
                                              CONSTRAINT "kes_plus_users_roles_pkey" PRIMARY KEY (id)
);