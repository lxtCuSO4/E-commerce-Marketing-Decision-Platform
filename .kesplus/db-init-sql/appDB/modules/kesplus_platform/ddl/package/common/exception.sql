-- "kesplus_platform"."exception" definition

CREATE OR REPLACE PACKAGE "kesplus_platform"."exception" AUTHID CURRENT_USER AS

    error_template text := '{"code":%s,"message":"%s"}';
    /**
     * @Description 设置异常返回信息
     * @Examples raise exception '%',"kesplus_platform".exception.set(code,message);
     * @param code 错误码
     * @param message 错误描述信息
     * @Return text
     */
    function set(code int,message varchar) return text;

    /**
     * 异常编码
     */
    TYPE_PLATFORM CONSTANT INT := -20999;
    TYPE_AUTHOR CONSTANT integer := -20998;
	TYPE_DB CONSTANT integer := -20997;
	TYPE_BUSINESS CONSTANT integer := -20900;


    /**
     * @Description 获取格式化异常信息
     * @Return jsonb
     */
    FUNCTION errdata(state_ TEXT) RETURN jsonb;

    /**
     * @Description 格式化堆栈信息
     * @param stack 堆栈文本
     * @Return TEXT
     */
    FUNCTION handle_stack_info(stack TEXT) RETURN TEXT;
end;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."exception" AS
    /**
     * @Description 设置异常返回信息
     * @Examples raise exception '%',"kesplus_platform".exception.set(code,message);
     * @param code 错误码
     * @param message 错误描述信息
     * @Return text
     */
    function set(code int,message varchar) return text as
    declare
        res text;
    begin
        res := format(error_template,code,message);
        --raise exception '%',res;
    return res;
    end;

    /**
     * @Description 获取格式化异常信息
     * @Return jsonb
     */
    FUNCTION errdata(state_ TEXT) RETURN jsonb AS
	DECLARE
        v_code TEXT;
        v_msg TEXT;
        v_desc TEXT;
        v_stack TEXT;
        json_data_ jsonb;
        msg_ TEXT;
    BEGIN
        v_msg := SQLERRM ;
        v_code := state_;
        IF v_msg LIKE 'ERRCODE-%' THEN
        	v_msg := SUBSTR(v_msg, INSTR(v_msg, ':') + 1);
        END IF;
        v_msg := trim(v_msg);

        --判断是否json格式字符串
        IF v_msg ~ '^\{.*\}$' THEN
        	json_data_ := v_msg::jsonb;
            IF json_data_ ->> 'code' is not null AND json_data_ ->> 'msg' is not null THEN
                v_msg := json_data_ ->> 'msg';
                v_code := json_data_ ->> 'code';
                v_desc := json_data_ ->> 'desc';
        	END IF;
        END IF;
        v_stack := handle_stack_info(dbms_utility.format_error_backtrace);
        RETURN jsonb_build_object('code',v_code,'msg',v_msg,'desc',v_desc,'stack',v_stack) ;
    END;

    /**
     * @Description 格式化堆栈信息
     * @param stack 堆栈文本
     * @Return TEXT
     */
    FUNCTION handle_stack_info(stack TEXT) RETURN TEXT AS
	DECLARE
    TYPE stack_type IS TABLE OF TEXT;
        stack_arr stack_type;
        stack_res TEXT;
        index_ integer;
    BEGIN
        IF stack IS NULL THEN
	    	RETURN '';
        END IF;
        index_ := charindex('pg_catalog.raise_application_error', stack, 6);
        IF index_ > 5 then
            stack := SUBSTR(stack,1,index_-5);
        END IF;
        SELECT regexp_split_to_table(stack,  E'\n') BULK COLLECT INTO stack_arr;
        FOR i IN stack_arr.first..stack_arr.LAST LOOP
            IF length(trim(stack_arr[i])) <= 3
                OR CONTAINS(stack_arr[i], 'pg_catalog.raise_application_error')
                OR CONTAINS(stack_arr[i], 'kesplus_platform.router_exception')
                OR CONTAINS(stack_arr[i], 'kesplus_platform.business_exception')
                OR CONTAINS(stack_arr[i], 'kesplus_platform.exception') THEN
                CONTINUE;
            ELSIF i != stack_arr.first AND i < stack_arr.LAST AND CONTAINS(stack_arr[i], 'anonymous block') AND CONTAINS(stack_arr[i+1], 'kesplus_platform.router_util') THEN
                EXIT;
            ELSIF i < stack_arr.LAST AND stack_arr[i] = stack_arr[i+1] THEN
                CONTINUE;
            ELSE
                IF stack_res IS NULL THEN
            		stack_res := stack_arr[i];
                ELSE
            		stack_res := stack_res||chr(10) ||stack_arr[i];
                END IF;
            END IF;
        END LOOP;
        RETURN stack_res;
    END;
end;;
