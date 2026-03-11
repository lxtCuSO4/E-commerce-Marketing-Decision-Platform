CREATE OR REPLACE PACKAGE "kesplus_platform"."crud_multiple_util" AUTHID CURRENT_USER AS


    /**
     * @Description 生成主子表(一对一关系)SELECT 语句的字段部分
     * @name columns_select
     * @Examples call kesplus_platform.crud_multiple_util.columns_select(
      	'[
      		{"schemaName":"kesplus_base", "tableName":"kesplus_user", "alias":"u", "mainTable":true, "columns":[{"columnName":"id"},{"columnName":"username"},{"columnName":"password"},{"columnName":"email"}]},
			{"schemaName":"kesplus_base", "tableName":"kesplus_user_dept", "alias":"ud", "columnKey":"dept", "mainTable":false, "columns":[{"columnName":"id", "columnAlias":"deptMappingId"}, {"columnName":"current_dept_id", "columnAlias":"deptId1"}]}
		]', false);
     * @param tablesRelationship IN JSONB 主子表关联关系,包括表模式名,表名,别名,是否主表,子表对象别名,列(包括表列名和映射后的列别名);其中别名默认值“模式名.表名”,子表对象别名默认为“模式名_表名”的驼峰展示形式,列别名默认为驼峰展示形式
     * @param tile IN boolean default true 是否平铺展示,如果为true,则主表和子表所有字段均平铺展示,若为false,则主表字段平铺展示,子表字段组合成json对象展示
     * @param TEXT IN TEXT 字段列表,例如“a."id" as "aid", JSON_BUILD_OBJECT(b."id" as "bid") as "bb"”或者“a."id" as "aid", b."id" as "bid"”
     */
	FUNCTION columns_select(tablesRelationship jsonb, tile boolean DEFAULT TRUE) RETURN TEXT;
    /**
     * @Description 生成主子表查询语句
     * @name generate_sql
     * @Examples SELECT kesplus_platform.crud_multiple_util.generate_sql('[...]', 'table'/'form', 'WHERE ...', 'ORDER BY ...', 'LIMIT 10 OFFSET 1', TRUE/FALSE);
     * @param configs IN JSONB 表单配置
     * @param genType IN varchar 生成的sql类型：form为表单数据,1=1子表数据以对象形式展示；table为列表或分页数据,1=1子表数据平铺展示；其它展示所有字段,且1=1子表平铺展示
     * @param whereSql IN varchar WHERE条件,字段建议加上表的别名。例如：WHERE t1."name" = '123' AND t2."obj"->>'id' = '123'
     * @param orderBySql IN varchar 排序。例如 ORDER BY t1."age" desc
     * @param pageSql IN varchar 分页。例如：LIMIT 10   或者  LIMIT 10 OFFSET 11
     * @param withAllChildren IN boolean default FALSE 是否含有1=N子表数据
     */
	FUNCTION generate_sql(configs jsonb, genType varchar, whereSql varchar DEFAULT NULL, orderBySql varchar DEFAULT NULL, pageSql varchar DEFAULT NULL, withAllChildren boolean DEFAULT FALSE) RETURN jsonb;
    /**
     * @Description 生成单表查询语句
     * @name generate_single_sql
     * @Examples SELECT kesplus_platform.crud_multiple_util.generate_single_sql('{...}', 'table'/'form', 'WHERE ...', 'ORDER BY ...', 'LIMIT 10 OFFSET 1');
     * @param configs IN JSONB 表单配置
     * @param genType IN varchar 生成的sql类型：form为表单数据；table为列表或分页数据；其它展示所有字段
     * @param whereSql IN varchar WHERE条件,字段建议加上表的别名。例如：WHERE t1."name" = '123' AND t2."obj"->>'id' = '123'
     * @param orderBySql IN varchar 排序。例如 ORDER BY t1."age" desc
     * @param pageSql IN varchar 分页。例如：LIMIT 10   或者  LIMIT 10 OFFSET 11
     */
	FUNCTION generate_single_sql(configs jsonb, genType varchar, whereSql varchar DEFAULT NULL, orderBySql varchar DEFAULT NULL, pageSql varchar DEFAULT NULL) RETURN jsonb;
END crud_multiple_util;

CREATE OR REPLACE PACKAGE BODY "kesplus_platform"."crud_multiple_util" AS WRAPPED
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
5GXG
END;

