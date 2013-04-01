-- KSAP_ATP to KSEN_ATP Data Migration
INSERT INTO KSEN_ATP
SELECT a.id, a.obj_id, NVL(a.type,'type.null'), NVL(a.state,'null.state'), a.name, NVL(r.plain,''),
    NVL(r.plain,''), a.id, NVL(a.end_dt,to_date('2012/09/12','YYYY/MM/DD')), NVL(a.start_dt,to_date('2012/09/12','YYYY/MM/DD')),
    NULL, a.ver_nbr, NVL(a.createtime,to_date('2012/09/12','YYYY/MM/DD')), NVL(a.createid,'CMATPUPGRADE'), a.updatetime, a.updateid
FROM
    KSAP_ATP a,
    KSAP_RICH_TEXT_T r
WHERE
    a.rt_descr_id=r.id
AND a.id not in (SELECT id FROM KSEN_ATP)
/
