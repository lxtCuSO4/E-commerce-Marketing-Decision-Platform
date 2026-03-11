CREATE OR REPLACE PACKAGE "kesplus_platform"."response_code" AUTHID CURRENT_USER AS
	/**
	 * Õ®”√∑µªÿ
	 */
	SUCCESS CONSTANT TEXT := '200'; 
	FAIL CONSTANT TEXT := '500'; 
	NO_PERMISSION CONSTANT TEXT := 'kesplus_token_5010';  
	/**
	 *
	 */
	WITHOUT_LOGIN CONSTANT TEXT := 'kesplus_token_401';
	TOKEN_EXPIRED CONSTANT TEXT := 'kesplus_token_601';
	TOKEN_ILLEGAL CONSTANT TEXT := 'kesplus_token_603';
	/**
	 *
	 */
    NOT_FOUND_API CONSTANT TEXT := 'kesplus_router_301';
	NOT_SUPPORT_SQL_FUNCTION CONSTANT TEXT := 'kesplus_router_2001';
	MISS_REQUIRED_PARAM CONSTANT TEXT := 'kesplus_router_2002';
	FUNCTION_NAME_ANALYSIS_ERROR CONSTANT TEXT := 'kesplus_router_2003';
	NO_DEFINE_FUNCTION CONSTANT TEXT := 'kesplus_router_2004';
	EXECUTE_FAIL CONSTANT TEXT := 'kesplus_router_2005';
    NULL_SQL_RESULT CONSTANT TEXT := 'kesplus_router_2006';
    QUERY_NO_ROWS CONSTANT TEXT := 'kesplus_router_3001';
END;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."response_code" AS WRAPPED
I/HnejJ4IvYHChEGp8PloA==
END;

