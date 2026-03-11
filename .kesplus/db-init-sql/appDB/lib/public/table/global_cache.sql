	    CREATE UNLOGGED TABLE "public"."global_cache" (
	    	"key" TEXT PRIMARY KEY,
	    	"value" JSONB,
	    	"expire_time" timestamp,
	    	"last_accessed" timestamp
	    );