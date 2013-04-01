-- insert new org org relation type that makes the parent the first one defined in the releation
INSERT INTO KSOR_ORG_ORG_RELTN_TYPE (EFF_DT,NAME,OBJ_ID,ORG_HIRCHY,REV_DESCR,REV_NAME,TYPE_DESC,TYPE_KEY,VER_NBR)
  VALUES (TO_DATE( '20000101000000', 'YYYYMMDDHH24MISS' ),
'is Curriculum Parent of',
SYS_GUID(),
'kuali.org.hierarchy.Curriculum',
'Indicates that this organization is the Child of another organization in the Curriculum Hierarchy',
'is Curriculum Child of',
'Indicates that this organization is the Parent of another organization in the Curriculum Hierarchy',
'kuali.org.Parent2CurriculumChild',0)
/
