CREATE TABLE "kesplus_base"."kesplus_message_subscribe" (
	"id" character varying(32 char) NOT NULL,
	"user_id" character varying(32 char) NULL,
	"config" jsonb NULL,
	"create_time" datetime NULL,
	"update_time" datetime NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_subscribe_constraint_1" PRIMARY KEY (id),
	CONSTRAINT "con_kesplus_base_kesplus_message_subscribe_constraint_2" UNIQUE (user_id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_subscribe" IS '消息订阅';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_subscribe"."user_id" IS '用户名';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_subscribe"."config" IS '订阅配置';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_subscribe"."create_time" IS '创建时间';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_subscribe"."update_time" IS '更新时间';