-- "kesplus_app"."kes_app_container" definition

-- Drop table

DROP TABLE IF EXISTS "kesplus_app"."kes_app_container";

CREATE TABLE "kesplus_app"."kes_app_container" (
                                                "id" integer NOT NULL,
                                                "userid" integer NULL,
                                                CONSTRAINT "kes_app_container_pkey" PRIMARY KEY (id)
);
COMMENT ON COLUMN "kesplus_app"."kes_app_container"."userid" IS '用户ID';