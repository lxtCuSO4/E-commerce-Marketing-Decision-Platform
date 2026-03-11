CREATE OR REPLACE PACKAGE "kesplus_base"."kesplus_pkg_sso_functions" AUTHID CURRENT_USER AS
	 /**
     * @Description 加密数据使用base64格式解密
     * @param resourceCode 第三方平台编码
     * @param accessToken token
     * @param ssoData 请求数据
     * @param res 解密结果
     */
	PROCEDURE base64_decrypt_from(resourceCode text, accessToken text, ssoData INOUT text, res OUT jsonb);
	/**
     * @Description 使用base64格式加密
     * @param resourceCode 第三方平台编码
     * @param encryptToken 加密token
     * @param ssoResult 加密后数据
     */
	PROCEDURE base64_encrypt_to(resourceCode text, ssoResult INOUT text, encryptToken OUT text) ;
    /**
     * @Description 请求数据解密
     * @param ssoData 解密数据
     */
	PROCEDURE decrypt_sso_data(ssoData INOUT text);
    /**
     * @Description 返回数据加密
     * @param ssoResult 加密后数据
     */
	PROCEDURE encrypt_sso_result(ssoResult INOUT text);
END;

CREATE OR REPLACE PACKAGE BODY "kesplus_base"."kesplus_pkg_sso_functions" AS WRAPPED
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
+aF8aifqfjOFbEqzvuIS5D1IVE6s
END;

