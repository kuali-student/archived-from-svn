--Add permission for DSC to edit final exam fields on create/edit CO views
insert into KRIM_ROLE_PERM_T (ROLE_PERM_ID, OBJ_ID, VER_NBR, ROLE_ID, PERM_ID, ACTV_IND) values (KRIM_ROLE_PERM_ID_S.NEXTVAL, SYS_GUID(), 1, (SELECT ROLE_ID FROM KRIM_ROLE_T where ROLE_NM = 'KS Department Schedule Coordinator - Org' and nmspc_cd = 'KS-ENR'), (SELECT perm_id from krim_perm_t where nm = 'Edit Group for delivery_and_assessment' and nmspc_cd = 'KS-ENR'), 'Y')
/
--Corrections to cases of letters
update ksem_enum_val_t set val = 'Standard Final Exam' where id = '61'
/
update ksem_enum_val_t set val = 'Alternate Final Assessment' where id = '62'
/
update ksem_enum_val_t set val = 'No Final Exam or Assessment' where id = '63'
/
--Remove unnecessary permission for final exam matrix checkbox
delete from krim_perm_attr_data_t where perm_id = 'KS-KRIM-PERM-1106'
/
delete from krim_perm_attr_data_t where perm_id = 'KS-KRIM-PERM-1107'
/
delete from krim_role_perm_t where perm_id = 'KS-KRIM-PERM-1106'
/
delete from krim_role_perm_t where perm_id = 'KS-KRIM-PERM-1107'
/
delete from krim_perm_t where perm_id = 'KS-KRIM-PERM-1106'
/
delete from krim_perm_t where perm_id = 'KS-KRIM-PERM-1107'
/
-- asdlkasd aslskjfas;lkdfjf sad;lkfsjd;lkjsj;aldkjfdsa ;ldkfjas;dlkfj
DECLARE TEMP NUMBER;
-- l;sakdjfs;aldkfj sa;ldkfjsa; ldfkjsa;ldkjfs ;ldkjsds;lkjsa;lkjfdsf
BEGIN
  SELECT COUNT(*) INTO TEMP FROM USER_TABLES WHERE TABLE_NAME = 'KSEN_SCHED_RQST_SET_ATTR';
        IF TEMP > 0 THEN EXECUTE IMMEDIATE 'DROP TABLE KSEN_SCHED_RQST_SET_ATTR CASCADE CONSTRAINTS PURGE'; END IF;
END;
/
DELETE KSEN_HOLD_ISSUE
/