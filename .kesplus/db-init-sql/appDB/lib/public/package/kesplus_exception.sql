CREATE OR REPLACE PACKAGE "public"."kesplus_exception" AUTHID CURRENT_USER AS
	platform_exception Exception;
	PRAGMA EXCEPTION_INIT (platform_exception, -20999) ;
	author_exception Exception;
	PRAGMA EXCEPTION_INIT (author_exception, -20998) ;
	db_exception Exception;
	PRAGMA EXCEPTION_INIT (db_exception, -20997) ;
	business_exception Exception;
	PRAGMA EXCEPTION_INIT (business_exception, -20900) ;
END ;

CREATE OR REPLACE PACKAGE BODY "public"."kesplus_exception" AS WRAPPED
AAGR5C6aNGZ+VWyAAF5Aww==
END;

