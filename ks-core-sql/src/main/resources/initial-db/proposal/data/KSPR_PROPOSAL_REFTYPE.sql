TRUNCATE TABLE KSPR_PROPOSAL_REFTYPE DROP STORAGE
/
INSERT INTO KSPR_PROPOSAL_REFTYPE (EFF_DT,NAME,OBJ_ID,TYPE_DESC,TYPE_KEY,VER_NBR)
  VALUES (TO_DATE( '20000101000000', 'YYYYMMDDHH24MISS' ),'Clu Proposal Reference','EEFBFD0AB3024EC89DAEBA81B90E265D','Clu proposal reference type','kuali.proposal.referenceType.clu',0)
/
