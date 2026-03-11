
CREATE TABLE "${moduleSchema}"."kesplus_module_restful_permission" (
    "id" character varying(32 char) NOT NULL,
	"restful_id" character varying(32 char) NULL,
	"permission_id" character varying(32 char) NULL,
	"create_time" date NULL,
	"update_time" date NULL,
	"create_by" character varying(32 char) NULL,
	"update_by" character varying(32 char) NULL,
	"module_id" character varying(32 char) NULL,
	"dept_id" character varying(32 char) NULL,
	"tenant_id" character varying(32 char) NULL,
	CONSTRAINT "pk_module_restful_permission" PRIMARY KEY (id)
);

