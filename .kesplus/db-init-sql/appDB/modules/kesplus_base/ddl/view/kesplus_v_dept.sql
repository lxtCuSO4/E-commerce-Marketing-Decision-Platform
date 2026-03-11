-- "kesplus_base"."kesplus_v_dept" source

CREATE OR REPLACE VIEW "kesplus_base"."kesplus_v_dept"
AS SELECT kad.id,
    kad.dept_name AS name,
    kad.dept_code AS code,
    kad.pid,
    kad.tree_sort AS treeSort,
    kad.tree_path AS treePath,
    kad.tree_level AS treeLevel,
    kad.enabled AS status,
    kad.dept_code AS deptCode,
    kad.dept_name AS deptName,
    kad.dept_short_name AS deptShortName,
    kad.dept_common_name AS deptCommonName,
    kad.dept_former_name AS deptFormerName,
    kad.dept_type AS deptType,
    kad.classify,
    kad.manager_user_id AS managerUserId,
    kau.real_name AS manager,
    kau.phone AS managerPhone,
    kau.email AS managerEmail,
    kad.dept_position AS deptPosition,
    kad.contract_user_id AS contractUserId,
    kau0.real_name AS contractPersion,
    kau0.phone AS contractPhone,
    kau0.email AS contractEmail,
    kad.dept_responsibility AS deptResponsibility,
    kad.company_id AS companyId,
    kac.dept_name AS companyName,
    kap.dept_name AS parentName,
    kad.enabled,
    kad."expansion" ->> 'divisionId' AS "division_id",
    NVL(duc.userCount, int8(0)) AS userCount
   FROM kesplus_base.kesplus_dept kad
     LEFT JOIN kesplus_base.kesplus_user kau ON kad.manager_user_id::text = kau.id::text
     LEFT JOIN kesplus_base.kesplus_user kau0 ON kad.contract_user_id::text = kau0.id::text
     LEFT JOIN kesplus_base.kesplus_dept kap ON kad.pid::text = kap.id::text
     LEFT JOIN kesplus_base.kesplus_dept kac ON kad.company_id::text = kac.id::text
     LEFT JOIN ( SELECT kt.id AS deptId,
            count(kt.id) AS userCount
           FROM kesplus_base.kesplus_dept kt
             JOIN kesplus_base.kesplus_dept kt0 ON regexp_like(kt0.tree_path, '^'::text || kt.tree_path)
             JOIN kesplus_base.kesplus_user_dept kaud ON kaud.current_dept_id::text = kt0.id::text
          GROUP BY kt.id) duc ON kad.id::text = duc.deptId::text;