INSERT INTO kesplus_platform.kesplus_sys_filter ("id","filter_code","filter_name","filter_order","include_urls","exclude_urls","post_method","complete_method","filter_type","filter_version","filter_status","create_time","create_by","update_time","update_by","is_deleted") VALUES
	 ('9', 'DRAFT_DELETE', '删除草稿', 9978, '/**', NULL, NULL, '"kesplus_platform".remove_draft(request,response)', '1', 'PROD.1.0.0', '1', SYSDATE, NULL, NULL, NULL, 0);

