--KSENROLL-12066 Load future session exam periods - Spring exam periods fix 
UPDATE KSEN_ATP A
   set A.Start_Dt = TO_DATE('20140512000000', 'YYYYMMDDHH24MISS'),
       A.End_Dt   = TO_DATE('20140519000000', 'YYYYMMDDHH24MISS')
 WHERE A.ID = 'kuali.atp.ExamPeriod.2014Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20150511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20150518000000', 'YYYYMMDDHH24MISS')
 WHERE A.ID = 'kuali.atp.ExamPeriod.2015Spring'
/
 
UPDATE KSEN_ATP A
   set A.Start_Dt = TO_DATE('20160512000000', 'YYYYMMDDHH24MISS'),
       A.End_Dt   = TO_DATE('20160519000000', 'YYYYMMDDHH24MISS')
 WHERE A.ID = 'kuali.atp.ExamPeriod.2016Spring'
/
 
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20170511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20170518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID ='kuali.atp.ExamPeriod.2017Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20180511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20180518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID ='kuali.atp.ExamPeriod.2018Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20190513000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20190520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID ='kuali.atp.ExamPeriod.2019Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20200511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20200518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2020Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20210511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20210518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2021Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20220511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20220518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID ='kuali.atp.ExamPeriod.2022Spring'
/
  
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20230511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20230518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2023Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20130511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20130520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2013Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20120511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20120518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2012Spring'
/
UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20100511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20100518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2010Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20110511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20110518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2011Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20090511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20090518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2009Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20080511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20080519000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2008Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20070511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20070518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2007Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20060511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20060518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2006Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20050511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20050518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2005Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20040511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20040518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2004Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20030511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20030519000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2003Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20020511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20020520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2002Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20010511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20010518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2001Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('20000511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('20000518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.2000Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19990511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19990518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1999Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19980511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19980518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1998Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19970511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19970519000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1997Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19960511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19960520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1996Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19950511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19950518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1995Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19940511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19940518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1994Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19930511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19930518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1993Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19920511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19920518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1992Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19910511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19910520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1991Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19900511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19900518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1990Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19890511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19890518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1989Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19880511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19880518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1988Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19870511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19870518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1987Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19860511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19860519000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1986Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19850511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19850520000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1985Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19840511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19840518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1984Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19830511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19830518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1983Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19820511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19820518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1982Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19810511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19810518000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1981Spring'
/

UPDATE KSEN_ATP A
  set A.Start_Dt = TO_DATE('19800511000000', 'YYYYMMDDHH24MISS'),
      A.End_Dt   = TO_DATE('19800519000000', 'YYYYMMDDHH24MISS')
WHERE A.ID = 'kuali.atp.ExamPeriod.1980Spring'
/