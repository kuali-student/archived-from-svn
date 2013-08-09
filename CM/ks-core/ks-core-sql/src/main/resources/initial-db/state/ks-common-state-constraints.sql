CREATE UNIQUE INDEX KSEN_STATE_P ON KSEN_STATE
(ID   ASC)
/


ALTER TABLE KSEN_STATE
	ADD CONSTRAINT  KSEN_STATE_P PRIMARY KEY (ID)
/


CREATE  INDEX KSEN_STATE_IF1 ON KSEN_STATE
(LIFECYCLE_KEY   ASC)
/




CREATE UNIQUE INDEX KSEN_STATE_ATTR_P ON KSEN_STATE_ATTR
(ID   ASC)
/


ALTER TABLE KSEN_STATE_ATTR
	ADD CONSTRAINT  KSEN_STATE_ATTR_P PRIMARY KEY (ID)
/


CREATE  INDEX KSEN_STATE_ATTR_IF1 ON KSEN_STATE_ATTR
(OWNER_ID   ASC)
/





CREATE UNIQUE INDEX KSEN_STATE_LIFECYCLE_P ON KSEN_STATE_LIFECYCLE
(ID   ASC)
/


ALTER TABLE KSEN_STATE_LIFECYCLE
	ADD CONSTRAINT  KSEN_STATE_LIFECYCLE_P PRIMARY KEY (ID)
/


CREATE  INDEX KSEN_STATE_LIFECYCLE_I1 ON KSEN_STATE_LIFECYCLE
(REF_OBJECT_URI   ASC)
/


CREATE UNIQUE INDEX KSEN_STATE_LIFECYCLE_ATTR_P ON KSEN_STATE_LIFECYCLE_ATTR
(ID   ASC)
/


ALTER TABLE KSEN_STATE_LIFECYCLE_ATTR
	ADD CONSTRAINT  KSEN_STATE_LIFECYCLE_ATTR_P PRIMARY KEY (ID)
/


CREATE  INDEX KSEN_STATE_LIFECYCLE_ATTR_IF1 ON KSEN_STATE_LIFECYCLE_ATTR
(OWNER_ID   ASC)
/


ALTER TABLE KSEN_STATE
	ADD (CONSTRAINT KSEN_STATE_FK1 FOREIGN KEY (LIFECYCLE_KEY) REFERENCES KSEN_STATE_LIFECYCLE (ID))
/


ALTER TABLE KSEN_STATE_ATTR
	ADD (CONSTRAINT KSEN_STATE_ATTR_FK1 FOREIGN KEY (OWNER_ID) REFERENCES KSEN_STATE (ID))
/


ALTER TABLE KSEN_STATE_LIFECYCLE_ATTR
	ADD (CONSTRAINT KSEN_STATE_LIFECYCLE_ATTR_FK1 FOREIGN KEY (OWNER_ID) REFERENCES KSEN_STATE_LIFECYCLE (ID))
/
