-- KSAP_DT_RANGE_TYPE to KSEN_TYPE
INSERT INTO KSEN_TYPE
SELECT type_key, obj_id, nvl(name,' '), type_desc, type_desc, eff_dt, expir_dt, 'http://student.kuali.org/wsdl/atp/MilestoneInfo',
    'http://student.kuali.org/wsdl/atp/AtpService', nvl(ver_nbr,0), to_date('2012/09/12','YYYY/MM/DD'), 'CMMSTONEUPGRADE', null, null
FROM KSAP_DT_RANGE_TYPE WHERE type_key NOT IN (SELECT TYPE_KEY FROM KSEN_TYPE)
/

-- KSAP_MLSTN_TYPE to KSEN_TYPE
INSERT INTO KSEN_TYPE
SELECT type_key, obj_id, nvl(name,' '), type_desc, type_desc, eff_dt, expir_dt, 'http://student.kuali.org/wsdl/atp/MilestoneInfo',
    'http://student.kuali.org/wsdl/atp/AtpService', nvl(ver_nbr,0), to_date('2012/09/12','YYYY/MM/DD'), 'CMMSTONEUPGRADE', null, null
FROM KSAP_MLSTN_TYPE WHERE type_key NOT IN (SELECT TYPE_KEY FROM KSEN_TYPE)
/
