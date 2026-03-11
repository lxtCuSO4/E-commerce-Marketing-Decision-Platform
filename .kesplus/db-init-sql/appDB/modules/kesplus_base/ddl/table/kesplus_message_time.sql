CREATE TABLE "kesplus_base"."kesplus_message_time" (
	"user_id" varchar NOT NULL,
	"req_time" datetime NULL,
	CONSTRAINT "con_kesplus_base_kesplus_message_time_constraint_1" PRIMARY KEY (user_id)
);
COMMENT ON TABLE "kesplus_base"."kesplus_message_time" IS '用户通知消息';

-- Column comments

COMMENT ON COLUMN "kesplus_base"."kesplus_message_time"."user_id" IS '用户id';
COMMENT ON COLUMN "kesplus_base"."kesplus_message_time"."req_time" IS '获取时间';