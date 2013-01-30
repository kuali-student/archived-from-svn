TRUNCATE TABLE KREW_RULE_T DROP STORAGE
/
INSERT ALL
  INTO KREW_RULE_T (ACTVN_DT,ACTV_IND,CUR_IND,DACTVN_DT,DLGN_IND,DOC_TYP_NM,FRC_ACTN,FRM_DT,NM,OBJ_ID,RULE_BASE_VAL_DESC,RULE_ID,RULE_TMPL_ID,RULE_VER_NBR,TMPL_RULE_IND,TO_DT,VER_NBR)
  VALUES (TO_DATE( '20080801155902', 'YYYYMMDDHH24MISS' ),1,1,TO_DATE( '21000101000000', 'YYYYMMDDHH24MISS' ),0,'SendNotificationRequest',1,TO_DATE( '20080801155902', 'YYYYMMDDHH24MISS' ),'SendNotificationRequest.Reviewers','6166CBA1BBE9644DE0404F8189D86C09','Notification Request Reviewers','1044','1023',0,0,TO_DATE( '21000101000000', 'YYYYMMDDHH24MISS' ),0)
SELECT * FROM DUAL
/
