
CREATE TABLE "kesplus_base"."kesplus_login_record" (
    "id" character varying(32 char) NOT NULL,
    "rid" character varying(32 char) NOT NULL,
    "user_id" character varying(255 char) NOT NULL,
    "current_dept_id" character varying(32 char) NOT NULL,
    "real_name" character varying(32 char) NOT NULL,
    "username" character varying(32 char) NOT NULL,
    "expired_second" bigint NOT NULL,
    "logout" boolean NOT NULL DEFAULT FALSE,
    "expired" boolean NOT NULL DEFAULT FALSE,
    "create_time" date NOT NULL,
    "expired_time" date NOT NULL,
    "login_type" SMALLINT NOT NULL,
    "user_agent" SMALLINT NOT NULL,
    "auth_method" SMALLINT NOT NULL,
    "ip_address" varchar(255) NULL,
    "expansion" jsonb NULL,
    "update_time" date NULL,
    CONSTRAINT "pk_login_record_id" PRIMARY KEY (id)
);
