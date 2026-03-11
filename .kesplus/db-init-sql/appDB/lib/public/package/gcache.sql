CREATE OR REPLACE PACKAGE "public"."gcache" AUTHID CURRENT_USER AS

	/**
	 * 获取全局缓存,结果为JSONB格式
	 */
	FUNCTION get_cache(key_ varchar) RETURN jsonb;
	/**
	 * 获取全局缓存的某一个属性,返回结果为字符串类型
	 * key_为缓存的key值,
	 * properties为缓存路径的数组格式,例如{"a", "b"}、{"d", "0", "c"}
	 */
	FUNCTION get_cache_properties(key_ varchar, properties varchar[]) RETURN TEXT;
	/**
	 * 判断缓存是否存在
	 * key_为缓存的key值,
	 */
	FUNCTION is_exists(key_ varchar) RETURN boolean;
	/**
	 * 设置全局缓存,
	 * key_为缓存的key值,
	 * value为缓存的值,目前只支持JSONB格式
	 * expireSeconds 为超时时间,单位为秒,目前无作用
	 */
	PROCEDURE set_cache(key_ varchar, value jsonb, expireSeconds int DEFAULT 300);
	/**
	 * 根据缓存key值移除全局缓存
	 * key_为缓存的key值,
	 */
	PROCEDURE clear_cache(key_ varchar);
	/**
	 * 根据缓存key值前缀移除缓存,
	 * prefixKey_为缓存key值的前缀
	 */
	PROCEDURE clear_cache_prefix(prefixKey_ varchar);
	/**
	 * 清除全部缓存
	 */
	PROCEDURE clear_all_cache;
	/**
	 * 设置缓存最大值
	 * 目前无缓存自动过期、清除机制,此配置无效
	 */
	PROCEDURE set_max_cache_size(maxSize int);
	/**
	 * 后台清除机制,暂未完成
	 */
	PROCEDURE backgrand_cleanup;
	
	MAX_CACHE_SIZE int := 20000;
END gcache;

CREATE OR REPLACE PACKAGE BODY "public"."gcache" AS WRAPPED
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
xLKaUlyCyo6gyjl9ugen
END;

