-- Creating constraints

alter table KSA.KSSA_ACNT add constraint FKB8F79251AE7C54D4 foreign key (ACNT_STATUS_TYPE_ID_FK) references KSA.KSSA_ACNT_STATUS_TYPE;
alter table KSA.KSSA_ACNT add constraint FKB8F7925156D383B8 foreign key (LATE_PERIOD_ID_FK) references KSA.KSSA_LATE_PERIOD;
alter table KSA.KSSA_ACNT_PROTECTED_INFO add constraint FKEF75726D2C28B62A foreign key (BANK_TYPE_ID_FK) references KSA.KSSA_BANK_TYPE;
alter table KSA.KSSA_ACNT_PROTECTED_INFO add constraint FKEF75726DACFC7690 foreign key (TAX_TYPE_ID_FK) references KSA.KSSA_TAX_TYPE;
alter table KSA.KSSA_ACTIVITY add constraint FK7D1E4778D043544A foreign key (ACTIVITY_TYPE_ID_FK) references KSA.KSSA_ACTIVITY_TYPE;
alter table KSA.KSSA_ALLOCATION add constraint FKC2912B0998518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_ALLOCATION add constraint FKC2912B09ED7E538 foreign key (TRN_ID_2_FK) references KSA.KSSA_TRANSACTION;
alter table KSA.KSSA_ALLOCATION add constraint FKC2912B09ED770D9 foreign key (TRN_ID_1_FK) references KSA.KSSA_TRANSACTION;
alter table KSA.KSSA_CREDIT_PERMISSION add constraint FK1F74048CBC57B259 foreign key (TRANSACTION_TYPE_ID_FK, TRANSACTION_TYPE_SUB_CODE_FK) references KSA.KSSA_TRANSACTION_TYPE;
alter table KSA.KSSA_ELECTRONIC_CONTACT add constraint FK77758E6698518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_GL_BREAKDOWN add constraint FKF48BE710AE27AC92 foreign key (TRANSACTION_TYPE_ID_FK, TRANSACTION_TYPE_SUB_CODE_FK) references KSA.KSSA_TRANSACTION_TYPE;
alter table KSA.KSSA_GL_BREAKDOWN add constraint FKF48BE710FA70171C foreign key (GL_TYPE_ID_FK) references KSA.KSSA_GL_TYPE;
alter table KSA.KSSA_INFORMATION add constraint FKD2A2E003DBB2002A foreign key (FLAG_TYPE_ID_FK) references KSA.KSSA_FLAG_TYPE;
alter table KSA.KSSA_INFORMATION add constraint FKD2A2E00316BC312E foreign key (NEXT_ID) references KSA.KSSA_INFORMATION;
alter table KSA.KSSA_INFORMATION add constraint FKD2A2E00395ACD1EE foreign key (PREV_ID) references KSA.KSSA_INFORMATION;
alter table KSA.KSSA_INFORMATION add constraint FKD2A2E00398518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_INFORMATION add constraint FKD2A2E003FE6E074B foreign key (TRN_ID_FK) references KSA.KSSA_TRANSACTION;
alter table KSA.KSSA_PERSON_NAME add constraint FK45AEC02C98518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_POSTAL_ADDRESS add constraint FKC90A760998518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_TRANSACTION add constraint FKDCED3DB598518DD2 foreign key (ACNT_ID_FK) references KSA.KSSA_ACNT;
alter table KSA.KSSA_TRANSACTION add constraint FKDCED3DB5FB9EC59 foreign key (CURRENCY_ID_FK) references KSA.KSSA_CURRENCY;
alter table KSA.KSSA_TRANSACTION add constraint FKDCED3DB590ED3EED foreign key (DOCUMENT_ID_FK) references KSA.KSSA_DOCUMENT;
alter table KSA.KSSA_TRANSACTION add constraint FKDCED3DB5CE008744 foreign key (TRANSACTION_TYPE_ID_FK, TRANSACTION_TYPE_SUB_CODE_FK) references KSA.KSSA_TRANSACTION_TYPE;
alter table KSA.KSSA_TRANSACTION add constraint FKDCED3DB5F7D721E7 foreign key (ROLLUP_ID_FK) references KSA.KSSA_ROLLUP;
alter table KSA.KSSA_TRANSACTION_TYPE add constraint FK81104B8496077E1 foreign key (DEF_ROLLUP_ID_FK) references KSA.KSSA_ROLLUP;
alter table KSA.KSSA_TRANSACTION_TYPE_TAG add constraint FKA1635C3F47AB5D71 foreign key (TAG_ID_FK) references KSA.KSSA_TAG;
alter table KSA.KSSA_TRANSACTION_TYPE_TAG add constraint FKA1635C3FCE008744 foreign key (TRANSACTION_TYPE_ID_FK, TRANSACTION_TYPE_SUB_CODE_FK) references KSA.KSSA_TRANSACTION_TYPE;
