-- "kesplus_base"."kesplus_user_ding" definition

-- Drop table

-- DROP TABLE "kesplus_base"."kesplus_user_ding";

CREATE TABLE "kesplus_base"."kesplus_user_ding" (
    "id" varchar NOT NULL,
	"user_id" varchar NULL,
	"ding_id" varchar NULL,
	"name" varchar NULL,
	"username" varchar NULL,
	"phone" varchar NULL,
	"email" varchar NULL,
	CONSTRAINT "con_kesplus_base_kesplus_user_ding_constraint_1" PRIMARY KEY (id)
);
CREATE INDEX inxex_kesplus_base_kesplus_user_ding_index_1 ON kesplus_base.kesplus_user_ding USING btree (user_id);
COMMENT ON TABLE "kesplus_base"."kesplus_user_ding" IS '用户钉钉映射表';