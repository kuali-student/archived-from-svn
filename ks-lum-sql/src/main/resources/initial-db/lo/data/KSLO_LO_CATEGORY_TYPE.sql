TRUNCATE TABLE KSLO_LO_CATEGORY_TYPE DROP STORAGE
/
INSERT ALL
  INTO KSLO_LO_CATEGORY_TYPE (DESCR,EFF_DT,ID,NAME,OBJ_ID,VER_NBR)
  VALUES ('Accreditation',TO_DATE( '20080101000000', 'YYYYMMDDHH24MISS' ),'loCategoryType.accreditation','Accreditation','F475938A00DC461CB67C62C94A53E550',0)
  INTO KSLO_LO_CATEGORY_TYPE (DESCR,EFF_DT,ID,NAME,OBJ_ID,VER_NBR)
  VALUES ('Skill',TO_DATE( '20080101000000', 'YYYYMMDDHH24MISS' ),'loCategoryType.skillarea','Skill','A72827C7B2884C20A4879822D39841D8',0)
  INTO KSLO_LO_CATEGORY_TYPE (DESCR,EFF_DT,ID,NAME,OBJ_ID,VER_NBR)
  VALUES ('Subject',TO_DATE( '20080101000000', 'YYYYMMDDHH24MISS' ),'loCategoryType.subject','Subject','5498FE8008CB4CBEBDC9EB970470B38A',0)
SELECT * FROM DUAL
/
