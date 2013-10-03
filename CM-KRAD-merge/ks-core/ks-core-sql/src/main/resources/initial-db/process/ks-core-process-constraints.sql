

ALTER TABLE KSEN_PROCESS_ATTR
    ADD CONSTRAINT KSEN_PROC_ATTR_FK1 FOREIGN KEY (OWNER_ID)
    REFERENCES KSEN_PROCESS (ID)
/



ALTER TABLE KSEN_PROCESS_CATEGORY_ATTR
    ADD CONSTRAINT KSEN_PROC_CAT_ATTR_FK1 FOREIGN KEY (OWNER_ID)
    REFERENCES KSEN_PROCESS_CATEGORY (ID)
/


ALTER TABLE KSEN_PROCESS_CATEGORY_RELTN
    ADD CONSTRAINT KSEN_PROC_CAT_RELTN_FK1 FOREIGN KEY (PROCESS_ID)
    REFERENCES KSEN_PROCESS (ID)
/

ALTER TABLE KSEN_PROCESS_CATEGORY_RELTN
    ADD CONSTRAINT KSEN_PROC_CAT_RELTN_FK2 FOREIGN KEY (PROCESS_CATEGORY_ID)
    REFERENCES KSEN_PROCESS_CATEGORY (ID)
/


ALTER TABLE KSEN_PROCESS_CHECK
    ADD CONSTRAINT KSEN_PROC_CHECK_FK1 FOREIGN KEY (CHILD_PROCESS_ID)
    REFERENCES KSEN_PROCESS (ID)
/


ALTER TABLE KSEN_PROCESS_CHECK_ATTR
    ADD CONSTRAINT KSEN_PROC_CHECK_ATTR_FK1 FOREIGN KEY (OWNER_ID)
    REFERENCES KSEN_PROCESS_CHECK (ID)
/


ALTER TABLE KSEN_PROCESS_INSTRN
    ADD CONSTRAINT KSEN_PROC_INSTRN_FK2 FOREIGN KEY (PROCESS_ID)
    REFERENCES KSEN_PROCESS (ID)
/

ALTER TABLE KSEN_PROCESS_INSTRN
    ADD CONSTRAINT KSEN_PROC_INSTN_FK1 FOREIGN KEY (CHECK_ID)
    REFERENCES KSEN_PROCESS_CHECK (ID)
/


ALTER TABLE KSEN_PROCESS_INSTRN_AAT
    ADD CONSTRAINT KSEN_PROC_INSTRN_FK1 FOREIGN KEY (PROCESS_INSTRN_ID)
    REFERENCES KSEN_PROCESS_INSTRN (ID)
/


ALTER TABLE KSEN_PROCESS_INSTRN_ATTR
    ADD CONSTRAINT KSEN_PROC_INSTRN_ATTR_FK1 FOREIGN KEY (OWNER_ID)
    REFERENCES KSEN_PROCESS_INSTRN (ID)
/

