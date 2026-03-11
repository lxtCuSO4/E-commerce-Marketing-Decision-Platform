-- CREATE TYPE "session_attr";

CREATE TYPE "public"."session_attr" AS ENUM (
	'serviceCode',
	'schemaName',
	'moduleCode',
	'moduleId',
	'appCode',
	'appId',
	'url',
	'method',
	'ssoCode',
	'ip');
