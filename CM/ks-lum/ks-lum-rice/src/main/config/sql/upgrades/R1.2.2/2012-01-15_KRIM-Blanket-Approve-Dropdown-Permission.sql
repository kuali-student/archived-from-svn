-- Create a new Permission template that is linked to the new Kim Typ that is specific to KS-SYS
INSERT INTO KRIM_PERM_TMPL_T (ACTV_IND,KIM_TYP_ID,NM,NMSPC_CD,OBJ_ID,PERM_TMPL_ID,VER_NBR, DESC_TXT)
  VALUES ('Y',(SELECT KIM_TYP_ID FROM KRIM_TYP_T WHERE NM='Document Type & Routing Node or State' AND NMSPC_CD='KR-SYS'),'Blanket Approve','KS-SYS',SYS_GUID(),KRIM_PERM_TMPL_ID_S.NEXTVAL,1, 'Used to Blanket Approve Kuali Student Documents')
/

--- Blanket Approve where Route status = R permission.
--- Permission  
INSERT INTO KRIM_PERM_T (ACTV_IND,DESC_TXT,NM,NMSPC_CD,OBJ_ID,PERM_ID,PERM_TMPL_ID,VER_NBR)
  VALUES ('Y','Blanket Approval at Route Status R.','Blanket Approve','KS-SYS',SYS_GUID(),KRIM_PERM_ID_S.NEXTVAL,KRIM_PERM_TMPL_ID_S.CURRVAL,1)
/

--- Permission Detail - Document Type Name
INSERT INTO KRIM_PERM_ATTR_DATA_T (ATTR_DATA_ID,ATTR_VAL,KIM_ATTR_DEFN_ID,KIM_TYP_ID,OBJ_ID,PERM_ID,VER_NBR)
  VALUES (KRIM_ATTR_DATA_ID_S.NEXTVAL,'KualiStudentDocument',
	(SELECT KIM_ATTR_DEFN_ID FROM KRIM_ATTR_DEFN_T WHERE NM='documentTypeName' AND NMSPC_CD='KR-WKFLW'),
	(SELECT KIM_TYP_ID FROM KRIM_TYP_T WHERE NM='Document Type & Routing Node or State' AND NMSPC_CD='KR-SYS'),sys_guid(),KRIM_PERM_ID_S.CURRVAL,1)
/
--- Permission Detail - Route Status
INSERT INTO KRIM_PERM_ATTR_DATA_T (ATTR_DATA_ID, VER_NBR,OBJ_ID,KIM_ATTR_DEFN_ID,KIM_TYP_ID,PERM_ID,ATTR_VAL)
   VALUES (KRIM_ATTR_DATA_ID_S.NEXTVAL, 1,sys_guid(),
          (SELECT KIM_ATTR_DEFN_ID FROM KRIM_ATTR_DEFN_T WHERE NM='routeStatusCode' AND NMSPC_CD='KR-WKFLW'),
          (SELECT KIM_TYP_ID FROM KRIM_TYP_T WHERE NM='Document Type & Routing Node or State' AND NMSPC_CD='KR-SYS'),KRIM_PERM_ID_S.CURRVAL,'R')
/
--- Assign to KS Admin Role 
INSERT INTO KRIM_ROLE_PERM_T (ACTV_IND,OBJ_ID,PERM_ID,ROLE_ID,ROLE_PERM_ID,VER_NBR)
  VALUES ('Y',sys_guid(),KRIM_PERM_ID_S.CURRVAL,(SELECT ROLE_ID FROM KRIM_ROLE_T WHERE NMSPC_CD='KS-SYS' AND ROLE_NM='Kuali Student CM Admin'),KRIM_ROLE_PERM_ID_S.NEXTVAL,1)
/


-- Blanket Approve where Route status = S permission. 
INSERT INTO KRIM_PERM_T (ACTV_IND,DESC_TXT,NM,NMSPC_CD,OBJ_ID,PERM_ID,PERM_TMPL_ID,VER_NBR)
  VALUES ('Y','Blanket Approval at Route Status S.','Blanket Approve','KS-SYS',SYS_GUID(),KRIM_PERM_ID_S.NEXTVAL,KRIM_PERM_TMPL_ID_S.CURRVAL,1)
/
--- Permission Detail - Document Type Name
INSERT INTO KRIM_PERM_ATTR_DATA_T (ATTR_DATA_ID,ATTR_VAL,KIM_ATTR_DEFN_ID,KIM_TYP_ID,OBJ_ID,PERM_ID,VER_NBR)
  VALUES (KRIM_ATTR_DATA_ID_S.NEXTVAL,'KualiStudentDocument',
	(SELECT KIM_ATTR_DEFN_ID FROM KRIM_ATTR_DEFN_T WHERE NM='documentTypeName' AND NMSPC_CD='KR-WKFLW'),
	(SELECT KIM_TYP_ID FROM KRIM_TYP_T WHERE NM='Document Type & Routing Node or State' AND NMSPC_CD='KR-SYS'),sys_guid(),KRIM_PERM_ID_S.CURRVAL,1)
/
--- Permission Detail - Route Status
INSERT INTO KRIM_PERM_ATTR_DATA_T (ATTR_DATA_ID, VER_NBR,OBJ_ID,KIM_ATTR_DEFN_ID,KIM_TYP_ID,PERM_ID,ATTR_VAL)
   VALUES (KRIM_ATTR_DATA_ID_S.NEXTVAL, 1,sys_guid(),
          (SELECT KIM_ATTR_DEFN_ID FROM KRIM_ATTR_DEFN_T WHERE NM='routeStatusCode' AND NMSPC_CD='KR-WKFLW'),
          (SELECT KIM_TYP_ID FROM KRIM_TYP_T WHERE NM='Document Type & Routing Node or State' AND NMSPC_CD='KR-SYS'),KRIM_PERM_ID_S.CURRVAL,'S')
/
-- Assign to KS Admin Role
INSERT INTO KRIM_ROLE_PERM_T (ACTV_IND,OBJ_ID,PERM_ID,ROLE_ID,ROLE_PERM_ID,VER_NBR)
  VALUES ('Y',sys_guid(),KRIM_PERM_ID_S.CURRVAL,(SELECT ROLE_ID FROM KRIM_ROLE_T WHERE NMSPC_CD='KS-SYS' AND ROLE_NM='Kuali Student CM Admin'),KRIM_ROLE_PERM_ID_S.NEXTVAL,1)
/
