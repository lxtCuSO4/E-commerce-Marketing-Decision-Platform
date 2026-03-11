CREATE OR REPLACE PACKAGE "kesplus_platform"."db_obj_ddl" AUTHID CURRENT_USER AS
    /**
     * @Description 获取包的ddl语句
     * @param schemaName_ 模式名
     * @param pkgName_ 包名
     * @param type_ 导出类型 type_: header, body, all(header,body)
     * @Return text
     */
    function get_pkg_ddl(schemaName_ varchar,pkgName_ varchar,type_ varchar) return text;
    /**
     * @Description 获取包体内容（不包含create语句）json分别返回两部分（pkgspecsrc,pkgbodysrc）
     * @param schemaName_ 模式名
     * @param pkgName_ 包名
     * @Return json
     */
    function get_pkg_src(schemaName_ varchar,pkgName_ varchar) return json;
    /**
     * @Description 获取函数的完整ddl语句（多个函数名称相同的不能使用此方法）
     * @param schemaName_ 模式名
     * @param funName_ 函数名
     * @Return text
     */
    function get_fun_ddl(schemaName_ varchar,funName_ varchar) return text;
    /**
     * @Description 获取视图完整ddl语句
     * @param schemaName_ 模式名
     * @param viewName_ 函数名
     * @Return text
     */
    function get_view_ddl(schemaName_ varchar,viewName_ varchar, authStatus boolean default false) return text;
    /**
     * @Description 获取视图查询体内容（不包含create语句）
     * @param schemaName_ 模式名
     * @param viewName_ 函数名
     * @Return text
     */
    function get_view_src(schemaName_ varchar,viewName_ varchar) return text;
    /**
     * 根据schemaName遍历所有的table，然后关闭所有表的约束
     * 返回成功或者失败
     */
    FUNCTION disableConstraintBySchema(schemaNames_ varchar) return boolean ;
    /**
     * 根据schemaName遍历所有的table，然后启动所有表的约束
     * 返回成功或者失败
     */
    FUNCTION enableConstraintBySchema(schemaNames_ varchar) return boolean;
    FUNCTION alterConstraintBySchema(schemaNames_ varchar,opt varchar)  return boolean;
    BR VARCHAR := E'\n';
    TAB VARCHAR := E'\t';
    PKG_HEADER_TEMPLATE varchar := 'CREATE OR REPLACE PACKAGE "{{&schemaName}}"."{{&pkgName}}" AS';
    PKG_BODY_TEMPLATE varchar := 'CREATE OR REPLACE PACKAGE BODY "{{&schemaName}}"."{{&pkgName}}" AS';
    VIEW_TEMPLATE varchar := 'CREATE OR REPLACE VIEW %I.%I %s ' || chr(13) || chr(9) || ' AS ';
end;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."db_obj_ddl" AS WRAPPED
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
sdd/I3wTS+o0AgAAAAAAAAAAAAAAAAAAAAA=
END;

