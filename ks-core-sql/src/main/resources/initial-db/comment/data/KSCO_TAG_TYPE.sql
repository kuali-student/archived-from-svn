TRUNCATE TABLE KSCO_TAG_TYPE DROP STORAGE
/
INSERT INTO KSCO_TAG_TYPE (EFF_DT,NAME,OBJ_ID,TYPE_DESC,TYPE_KEY,VER_NBR)
  VALUES (TO_DATE( '20000101000000', 'YYYYMMDDHH24MISS' ),'Default','12A50145DB9448A199A26848B1F5CE54','Default tag type','tagType.default',0)
/
