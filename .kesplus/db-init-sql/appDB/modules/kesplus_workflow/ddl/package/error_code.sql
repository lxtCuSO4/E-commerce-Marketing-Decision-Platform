CREATE OR REPLACE PACKAGE "kesplus_workflow"."error_code" AUTHID CURRENT_USER AS
    WORKFLOW_ASSIGNEES_NULL CONSTANT TEXT := 'kesplus_workflow_1000';
    WORKFLOW_ASSIGNEES_PATH_NULL CONSTANT TEXT := 'kesplus_workflow_1001';
    WORKFLOW_PENDING_NO_EXISTS CONSTANT TEXT := 'kesplus_workflow_1002';
    WORKFLOW_PENDING_COMPLETED CONSTANT TEXT := 'kesplus_workflow_1003'; 
    WORKFLOW_PENDING_NO_PERMISSION CONSTANT TEXT := 'kesplus_workflow_1004'; 



    FLOW_ID_NULL CONSTANT TEXT := 'kesplus_workflow_1008';
    FORM_NO_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1009';
    FORM_ID_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1010';
    MISSING_PARAMETERS CONSTANT TEXT := 'kesplus_workflow_1011';
    UNDEFINED_PROCESS_DEFINITION CONSTANT TEXT := 'kesplus_workflow_1012'; 
    OPINIONS_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1013'; 
    TASK_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1014';  
    PROCESS_ID_EXISTS CONSTANT TEXT := 'kesplus_workflow_1015';
    PROCESS_NOT_PUBLISH CONSTANT TEXT := 'kesplus_workflow_1016';
    PROCESS_VARIABLE_EMPTY CONSTANT TEXT := 'kesplus_workflow_1017';
    PROCESS_NOT_SPECIFIED CONSTANT TEXT := 'kesplus_workflow_1018'; 
    APPROVER_NOT_SPECIFIED CONSTANT TEXT := 'kesplus_workflow_1019'; 
    USERS_NOT_NULL CONSTANT TEXT := 'kesplus_workflow_1020'; 
    PREV_TASK_OP_ID_NULL CONSTANT TEXT := 'kesplus_workflow_1021'; 
    REJECTFIRSTTASK_NOT_SUPPORT CONSTANT TEXT := 'kesplus_workflow_1022'; 
    START_PROCESS_FAIL CONSTANT TEXT := 'kesplus_workflow_1023'; 
    CALLBACK_ERROR CONSTANT TEXT := 'kesplus_workflow_1024'; 
    NOT_SUPPORT_WITHDRAW CONSTANT TEXT := 'kesplus_workflow_1025'; 
    ENTER_DATA_NULL CONSTANT TEXT := 'kesplus_workflow_1026'; 
    SELECT_DELETE_DATA CONSTANT TEXT := 'kesplus_workflow_1027'; 
    PUBLISHED_PROCESS_NOT_DELETE CONSTANT TEXT := 'kesplus_workflow_1028'; 
    ACTIVE_PROCESS_NOT_DELETE CONSTANT TEXT := 'kesplus_workflow_1029'; 
    ID_NOT_NULL CONSTANT TEXT := 'kesplus_workflow_1030'; 
    MODELER_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1031'; 
    PROCESS_TYPE_ERROR CONSTANT TEXT := 'kesplus_workflow_1032'; 
    ACTIVE_PROCESS_NOT_UPDATE CONSTANT TEXT := 'kesplus_workflow_1033'; 
    PROCESS_VERSION_ERROR CONSTANT TEXT := 'kesplus_workflow_1034'; 
    PROCESS_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1035'; 
    FORM_CODE_NOT_NULL CONSTANT TEXT := 'kesplus_workflow_1036'; 
    PROCESS_DEFINITION_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1037'; 
    PROCESS_DEFINITION_ERROR CONSTANT TEXT := 'kesplus_workflow_1038'; 
    PROCESS_KEY_NOT_NULL CONSTANT TEXT := 'kesplus_workflow_1039'; 
    MODELER_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1040'; 
    PARSER_EX_ERROR CONSTANT TEXT := 'kesplus_workflow_1041'; 
    KESBPMNDATA_SUBMIT_ERROR CONSTANT TEXT := 'kesplus_workflow_1042'; 
    CONDITION_IS_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1043'; 
    TASKID_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1044'; 
    TASKID_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1045'; 
    TASKDEFKEY_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1046'; 
    NEXTTASKNODE_ERROR CONSTANT TEXT := 'kesplus_workflow_1047'; 
    ENDNODE_IS_NULL CONSTANT TEXT := 'kesplus_workflow_1048'; 
    PROCESS_DEFINITION_NOT_NULL CONSTANT TEXT := 'kesplus_workflow_1049'; 
    NEXTTASKDEF_ERROR CONSTANT TEXT := 'kesplus_workflow_1050'; 
    NEXTTASKDEFKEY_MORE CONSTANT TEXT := 'kesplus_workflow_1051'; 
    PROCESS_INSTANCE_ID_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1052'; 
    ASSIGNEE_USER_NOT_EXISTS CONSTANT TEXT := 'kesplus_workflow_1053'; 
    CALCULATE_ERROR CONSTANT TEXT := 'kesplus_workflow_1054'; 
    USER_TASK_ERROR CONSTANT TEXT := 'kesplus_workflow_1055'; 
    USER_REJECT_TASK_ERROR CONSTANT TEXT := 'kesplus_workflow_1056'; 
 
    PROCEDURE exception(v_code TEXT,v_cn_msg TEXT,v_en_msg TEXT);
    
    PROCEDURE exception(v_code text, v_array varchar[],v_cn_msg TEXT,v_en_msg TEXT);
    
    PROCEDURE exception(v_code text, v_msg text,v_cn_msg TEXT,v_en_msg TEXT);
    PROCEDURE insert_i18n(v_code text, v_cn_msg TEXT,v_en_msg TEXT);
    
    PROCEDURE business_exception(v_code TEXT,v_msg TEXT,v_desc TEXT);
end;

CREATE OR REPLACE PACKAGE BODY "kesplus_workflow"."error_code" AS WRAPPED
rOhwj9PN78kXGwfnpCVd4r2yIbw7NxicK60WtYkm4qGpo0g2ehQ2y81wbMch
WfvAbhgDFUEez1ujA/YAx4Yd7eODGCYX3bEpSKxD2uvssijMogaJZnXq2N9u
ohmqg1ATm9k4Sqh/WfKaPySVIjh9OARNMygVvFWhhT+qQWnz++AxcwuxwEUW
NUUNFeuny8hnz73D/w8LriAgc7T7ckqObZDniiuSLpfmuLfK3PT2DuGYygfG
drRa018f7Fo5Hailzt716brf9Jv3HdkXoOnSx1LYBjalcQ6HepBSEDhuljr9
MJsv2Ib3B0PhHw/JaN3wz4IlNqiF0n21TxQHeUFkfXblNRcUcdNVxuiFecm3
3iHX99AHKAEogxLS4tyqM9qRU4u1rCpc1k6Xx7vqioa1id1aIh5HB/7guUjG
g5NWUXn3kNjALIeJMs6InieeJ09H34FDhqGyu+Yx6JJSIREt3/YZZzLb/q48
c7Z6h/lNNJCVy1fT0hQ1g+rV+Zr7YdZlwbFXUTZFF9FuIjn0uTf78acNiZXY
PC6h62IbzbWDEIBBHUD+PRBbPpbbNL+Xa+mIgfrdDQAQRlzPdIRVq7GF9rEU
+9U5r3R4LF0NLZBP/XJYJ4LlI9haOyxieONT1ua2UM+aJrVqeGhQmaYm+NCs
clBvubslfU2Yv4oX7NJPLRhEB02OOEgm5qb/g82MU1+j34FDhqGyu+Yx6JJS
IREt3/YZZzLb/q48c7Z6h/lNNJALbn+e1oMeHXV19IPbAah+mxeQq82P5id0
jjGzu3VWodD2ztWfZEJHqeetatrII2207Va4j/8Cqrga1DrrG8h7dAw4gcWA
2J2xJNeg+KXaQum6dbnKy+qPr3SV2jUrgSpxaq6N6T49pksj84Hk05DFDZKB
lmPz/nggg8u9tglnycvDg+CowJO99snyKfAQnwsRM/DoN+iT2yz8UCsPoYnl
aRBJh3FYIAx/mvqg/1WWrjJc+kT2TPvwrYHL6EEytYYJXT9ajTq4/MzQ3ulo
TbaObgSOnBJh8x16b6ooH18D5wLpcZlY8KLpDASk1NkR1Xsd0vvD5vAW9jKD
XE2UMeXRIK6/cRPFdOgezYgB65ImSYXVcvCz04lR68pelsNDCQsX8ssDqtli
ZlWM2QIRaa0skbcWNPwQKokZs2p7aoPcDlY6zfQvfHdgZumThCC3EKA/MehW
54nqFxojs5Zs6U2JNOfi+rw/EKmlYwjtTNRDlJpnYGzamhqPdT7gPHC3UNXT
2RcGysZP8D6CPHF/zALzrLQJPKvOs3j7g8xFbPceEbq00y1F6dQVSiPQQd69
dsLVWUm5IP2HCJ7/JlxX4aAWc3rhoPt7fnA2rPiQYfVPTqcNiZXYPC6h62Ib
zbWDEIBBHUD+PRBbPpbbNL+Xa+mI71qPuTiJNQe3Dp1jkcuWDvqzMP+P/v7i
9/0ltVvNMGYwSFCzUXEjrit5Lf3KKZXcIZnd4iVkyCshwSbBtKxMfEkH+UM2
VKXXfIj6xln7gch8mNwEMPI0Eyv6JCd2Iivodsy2OPRyTYIPRfa8o50bmn2b
XTmkm7uEt88K+nDZFEuyY4gBhCHJQyezQAGn6Qahbdskx5qe7U49rYPm6ATM
7w+kC5Q2I1RAhjkEWi61NvsbSJOCc74MKd3SbycxSxNGNVFvD0yR0uvF84OS
bxFOIdcpr2Plesfo5nzWuduGeeL21vll879R5zICF7xa9v1Arx5v/W2gPFmy
wCWN7Uz6rqC6H7uuHKl8ETZUoLOhkmIoeM62l34UEDM/0emSHlPnKDcYJlzb
nXgnVNdNM02JE1QWJzk8L76/N4ujz3fDJ/QiOhrpwcERbs5+QG6VvBOqHkub
wwqISNynm4nL+grv/s6+lGYwgvuvzt+CA1pEy4MCAqxBWOd3VO1O53xmJ1gW
UzGustM8TgQkvtTX++Ko+A==
END;

