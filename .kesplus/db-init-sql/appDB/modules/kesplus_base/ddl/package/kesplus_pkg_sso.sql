CREATE OR REPLACE PACKAGE "kesplus_base"."kesplus_pkg_sso" AUTHID CURRENT_USER AS
    /**
     * @Description 新增配置
     * @param jsonData 配置信息
     * @Return 配置详情
     */
	FUNCTION add(jsonData text) RETURN JSONB ;
    /**
     * @Description 修改配置
     * @param jsonData 配置信息
     * @Return 配置详情
     */
	FUNCTION update(jsonData text)RETURN JSONB ;
    /**
     * @Description 删除配置
     * @param id 配置id
     * @Return boolean
     */
	FUNCTION delete(id text) RETURN boolean;
    /**
     * @Description 获取配置
     * @param id 配置id
     * @Return 配置信息
     */
	FUNCTION get_sso_config(id text) RETURN JSONB;
    /**
     * @Description 配置详情
     * @param id 配置id
     * @Return 配置详情
     */
	FUNCTION get_by_id(id text) RETURN JSONB;
    /**
     * @Description 列表查询配置
     * @param blurry 查询内容
     * @param type 类型
     * @param enabled 状态
     * @param page 当前页
     * @param size 每页个数
     * @Return 岗位列表
     */
	FUNCTION page_sso_config(page int, SIZE int, blurry text, TYPE int, enabled int) RETURN JSONB;
    /**
     * @Description 使用base64格式解密
     * @param resourceCode 第三方平台编码
     * @param encryptToken 加密token
     * @Return 解密数据
     */
	FUNCTION decrypt_from_token(resourceCode text, accessToken text) RETURN JSONB;
    /**
     * @Description 加密数据使用base64格式解密
     * @param resourceCode 第三方平台编码
     * @param accessToken token
     * @param ssoData 请求数据
     * @param res 解密结果
     */
	PROCEDURE decrypt_from(resourceCode text, accessToken text, ssoData INOUT text, res OUT jsonB);
    /**
     * @Description 使用base64格式加密
     * @param resourceCode 第三方平台编码
     * @param 加密后数据
     */
	FUNCTION encrypt_to_token(resourceCode text) RETURN text;
    /**
     * @Description 使用base64格式加密
     * @param resourceCode 第三方平台编码
     * @param encryptToken 加密token
     * @param ssoResult 加密后数据
     */
	PROCEDURE encrypt_to(resourceCode text, ssoResult INOUT text, encryptToken OUT text);
    /**
     * @Description 变更配置状态
     * @param resourceCode 第三方平台编码
     * @param encryptToken 加密token
     * @Return 解密数据
     */
	FUNCTION change_sso_enabled(id text, enabled int) RETURN boolean;
    /**
     * @Description 获取模式名
     * @Return 模式数组
     */
	FUNCTION list_schemas() RETURN text[];
    /**
     * @Description 获取模式下包名
     * @param schemaName 模式名
     * @param configType 配置类型
     * @Return 包名数组
     */
	FUNCTION list_packages(schemaName text, configType int) RETURN text[];
    /**
     * @Description 获取包下的函数或存储过程
     * @param schemaName 模式名
     * @param configType 配置类型
     * @param packageName 包名
     * @Return 函数名数组
     */
	FUNCTION list_functions(schemaName text, packageName text, configType int) RETURN text[];
    /**
     * @Description 数据唯一校验
     */
	PROCEDURE check_unique(beanObj JSONB, TYPE int DEFAULT 0);
END;

CREATE OR REPLACE PACKAGE BODY "kesplus_base"."kesplus_pkg_sso" AS WRAPPED
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
9Tk=
END;

