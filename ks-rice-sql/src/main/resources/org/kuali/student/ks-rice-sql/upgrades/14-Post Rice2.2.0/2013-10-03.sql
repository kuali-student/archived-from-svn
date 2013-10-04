--
-- KSENROLL-9987 set defaultPermissionTypeService for all ks custom types.
-- 
UPDATE  KRIM_TYP_T SET SRVC_NM = 'defaultPermissionTypeService' WHERE NMSPC_CD = 'KS-SYS' and SRVC_NM IS NULL 
