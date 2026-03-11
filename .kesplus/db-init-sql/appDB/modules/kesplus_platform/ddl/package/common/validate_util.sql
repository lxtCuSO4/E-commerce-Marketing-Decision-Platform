CREATE OR REPLACE PACKAGE "kesplus_platform"."validate_util" AUTHID CURRENT_USER AS
    /**
     * 判断是否为数字或英文字母
     */
    FUNCTION isCharDigit(str text) RETURNS boolean;
    /**
     * 判断是否为日期
     */
    function isDate(str text) returns boolean;
    /**
     * 判断是否为数字
     */
    function isDigit(str text) returns boolean;
    /**
     * 判断是否为json类型(数字类型处理有问题)
     */
    function isJson(str text) returns boolean;
    /**
     * 判断是否为time类型
     */
    function isTime(str text) returns boolean;
    /**
     * 判断是否为timestamp类型
     */
    function isTimestamp(str text) returns boolean;
    FUNCTION isCommonResult(res jsonb) RETURN boolean;
    /**
     * 密码规则校验
     * 必须包含字母和数字,至少一个大写字母、一个小写字母和一个特殊字符，长度至少包含8个字符，
     */
    function password_check(str text) return boolean;
    /**
     * 字符校验
     * 字母开头、不能全部为数字,不能有特殊字符
     */
    function text_check(str text) return boolean;
     /**
     * 判断手机号格式是否正确
     */
    function is_phone_number(str text) return boolean;
     /**
     * 判断邮箱格式是否正确
     */
    function is_email(str text) return boolean;
     /**
     * 检查输入数据是否为期待长度
     */
    function is_correct_length(input_data text,expected_length integer) return boolean;
end;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."validate_util" AS WRAPPED
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
vz9t4qlmrcd7B9vjfbR8nJuDbw4k
END;

