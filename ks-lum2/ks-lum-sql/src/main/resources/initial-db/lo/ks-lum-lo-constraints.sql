
ALTER TABLE KSLO_ATTR
    ADD CONSTRAINT KSLO_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO (ID)
/


ALTER TABLE KSLO_LO
    ADD CONSTRAINT KSLO_LO_FK1 FOREIGN KEY (RT_DESCR_ID)
    REFERENCES KSLO_RICH_TEXT_T (ID)
/

ALTER TABLE KSLO_LO
    ADD CONSTRAINT KSLO_LO_FK2 FOREIGN KEY (LOTYPE_ID)
    REFERENCES KSLO_LO_TYPE (ID)
/

ALTER TABLE KSLO_LO
    ADD CONSTRAINT KSLO_LO_FK3 FOREIGN KEY (LO_REPO_ID)
    REFERENCES KSLO_LO_REPOSITORY (ID)
/



ALTER TABLE KSLO_LO_CATEGORY
    ADD CONSTRAINT KSLO_LO_CATEGORY_FK1 FOREIGN KEY (RT_DESCR_ID)
    REFERENCES KSLO_RICH_TEXT_T (ID)
/

ALTER TABLE KSLO_LO_CATEGORY
    ADD CONSTRAINT KSLO_LO_CATEGORY_FK2 FOREIGN KEY (LO_REPO_ID)
    REFERENCES KSLO_LO_REPOSITORY (ID)
/

ALTER TABLE KSLO_LO_CATEGORY
    ADD CONSTRAINT KSLO_LO_CATEGORY_FK3 FOREIGN KEY (LO_CATEGORY_TYPE_ID)
    REFERENCES KSLO_LO_CATEGORY_TYPE (ID)
/


ALTER TABLE KSLO_LO_CATEGORY_ATTR
    ADD CONSTRAINT KSLO_LO_CATEGORY_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_CATEGORY (ID)
/



ALTER TABLE KSLO_LO_CATEGORY_TYPE_ATTR
    ADD CONSTRAINT KSLO_LO_CATEGORY_TYPE_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_CATEGORY_TYPE (ID)
/


ALTER TABLE KSLO_LO_JN_LOCATEGORY
    ADD CONSTRAINT KSLO_LO_JN_LOCATEGORY_FK1 FOREIGN KEY (LOCATEGORY_ID)
    REFERENCES KSLO_LO_CATEGORY (ID)
/

ALTER TABLE KSLO_LO_JN_LOCATEGORY
    ADD CONSTRAINT KSLO_LO_JN_LOCATEGORY_FK2 FOREIGN KEY (LO_ID)
    REFERENCES KSLO_LO (ID)
/


ALTER TABLE KSLO_LO_RELTN
    ADD CONSTRAINT KSLO_LO_RELTN_FK1 FOREIGN KEY (LO_LO_RELATION_TYPE_ID)
    REFERENCES KSLO_LO_RELTN_TYPE (ID)
/

ALTER TABLE KSLO_LO_RELTN
    ADD CONSTRAINT KSLO_LO_RELTN_FK2 FOREIGN KEY (RELATED_LO_ID)
    REFERENCES KSLO_LO (ID)
/

ALTER TABLE KSLO_LO_RELTN
    ADD CONSTRAINT KSLO_LO_RELTN_FK3 FOREIGN KEY (LO_ID)
    REFERENCES KSLO_LO (ID)
/


ALTER TABLE KSLO_LO_RELTN_ATTR
    ADD CONSTRAINT KSLO_LO_RELTN_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_RELTN (ID)
/



ALTER TABLE KSLO_LO_RELTN_TYPE_ATTR
    ADD CONSTRAINT KSLO_LO_RELTN_TYPE_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_RELTN_TYPE (ID)
/


ALTER TABLE KSLO_LO_REPOSITORY
    ADD CONSTRAINT KSLO_LO_REPOSITORY_FK1 FOREIGN KEY (LO_ROOT_ID)
    REFERENCES KSLO_LO (ID)
/

ALTER TABLE KSLO_LO_REPOSITORY
    ADD CONSTRAINT KSLO_LO_REPOSITORY_FK2 FOREIGN KEY (RT_DESCR_ID)
    REFERENCES KSLO_RICH_TEXT_T (ID)
/


ALTER TABLE KSLO_LO_REPOSITORY_ATTR
    ADD CONSTRAINT KSLO_LO_REPOSITORY_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_REPOSITORY (ID)
/



ALTER TABLE KSLO_LO_TYPE_ATTR
    ADD CONSTRAINT KSLO_LO_TYPE_ATTR_FK1 FOREIGN KEY (OWNER)
    REFERENCES KSLO_LO_TYPE (ID)
/
