-- 创建
create or replace type PUBLIC.bean as object (
                                      obj json,
                                      constructor function bean(_data json) returns self as result,
                                      member procedure set(field varchar, value varchar),
                                      member procedure remove(field varchar),
                                      --返回原始数据
                                      member function get(field varchar) return varchar,
                                      member function getString(field varchar) return varchar,
                                      member function getInteger(field varchar) return integer,
                                      member function getJson(field varchar) return json,
                                      --返回引用形式防止SQL注入
                                      member function quoteLiteral(field varchar) return varchar,
                                      member function quoteNullable(field varchar) return varchar,
                                      member function quoteIdent(field varchar) return varchar,
                                      --模糊匹配
                                      member function like(field varchar) return varchar,
                                      member function rightLike(field varchar) return varchar,
                                      member function leftLike(field varchar) return varchar,
                                      --空判断
                                      member function isNull(field varchar) return boolean,
                                      member function isNotNull(field varchar) return boolean
                                      );



create or replace type body PUBLIC.bean as
    constructor function bean(_data json) returns self as result as
    begin
        obj := _data;
        return;
    end;
    member function get(field varchar) return varchar as
    begin
        if (obj ->> field) is null then
            return null;
        end if;
        if char_length(obj ->> field) =0  then
            return null;
        end if;
        return obj::json ->> field;
    end;

    member function getString(field varchar) return varchar as
    begin
        if (obj ->> field) is null  then
            return null;
        end if;
        if char_length(obj ->> field) =0  then
            return null;
        end if;
        return (obj::json ->> field)::varchar;
    end;

    member function getInteger(field varchar) return integer as
    begin
        return (obj::json ->> field)::integer;
    end;

    member procedure set(field varchar, value varchar) as
    declare
    begin
        obj := obj::jsonb - field;
        obj := obj::jsonb||jsonb_build_object(field, value);
    end;

    member procedure remove(field varchar) as
    begin
        obj := obj::jsonb - field;
    end;
        /**
         * 返回json bean对象
         */
    member function getJson(field varchar) return json as
    begin
    return obj::json -> field;
    end;

    member function quoteLiteral(field varchar) return varchar as
    begin
        return quote_literal(obj ->> field);
    end;
    member function quoteNullable(field varchar) return varchar as
    begin
        return quote_nullable(obj ->> field);
    end;
    member function quoteIdent(field varchar) return varchar as
    begin
        return quote_ident(obj ->> field);
    end;

    member function like(field varchar) return varchar as
    begin
        if get(field) is null then
            return null;
        else
            return chars.quote_literal_like((obj ->> field));
        end if;
    end;

    member function rightLike(field varchar) return varchar as
    begin
        if get(field) is null then
            return null;
        else
            return chars.quote_literal_like((obj ->> field),'r');
        end if;
    end;

    member function leftLike(field varchar) return varchar as
    begin
        if get(field) is null then
            return null;
        else
            return chars.quote_literal_like((obj ->> field),'l');
        end if;
    end;

    member function isNull(field varchar) return boolean as
    begin
        if get(field) is null then
            return true;
        end if;
        return false;
    end;

    member function isNotNull(field varchar) return boolean as
    begin
        if get(field) is null then
            return false;
        end if;
        return true;
    end;
end;
