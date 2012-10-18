
-- This Oracle script creates database objects in KSA schema.
-- It needs to be run by the schema owner
-- Creating sequence table

create table KSA.KSSA_SEQUENCE_TABLE ( SEQ_NAME varchar2(255 char) not null,  SEQ_VALUE number(10,0) not null, primary key (SEQ_NAME) ) ;

-- KSA config table

create table KSA.KSSA_CONFIG ( NAME varchar2(512) not null,  VALUE varchar2(1024), primary key (NAME) ) ;

-- KSA association tables for non-annotated associations

create table KSA.KSSA_ACNT_KYPR ( ACNT_ID_FK varchar2(45 char) not null, KYPR_ID_FK number(19,0) not null, primary key (ACNT_ID_FK, KYPR_ID_FK));
create table KSA.KSSA_LU_KYPR (LU_ID_FK number(19,0) not null, KYPR_ID_FK number(19,0) not null, primary key (LU_ID_FK, KYPR_ID_FK));


-- Creating base tables

create table KSA.KSSA_ACNT (TYPE varchar2(31 char) not null, ID varchar2(45 char) not null, CAN_AUTHENTICATE char(1 char), CREATION_DATE timestamp, CREDIT_LIMIT number(19,2), ENTITY_ID varchar2(45 char), IS_KIM_ACNT char(1 char), LAST_KIM_UPDATE timestamp, LATE1 number(19,2), LATE2 number(19,2), LATE3 number(19,2), DUE number(19,2), LATE_LAST_UPDATE timestamp, OUTSTANDING number(19,2), DATE_OF_BIRTH date, LATE_PERIOD_ID_FK number(19,0), ACNT_STATUS_TYPE_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_ACNT_PROTECTED_INFO (ID varchar2(45 char) not null, BANK_DETAILS varchar2(100 char), TAX_REFERENCE varchar2(45 char), BANK_TYPE_ID_FK number(19,0), ID_TYPE_ID_FK number(19,0), TAX_TYPE_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_ACNT_STATUS_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_ACTIVITY (id number(19,0) not null, ALTERED_ACNT_ID varchar2(45 char), CREATOR_ID varchar2(45 char), ALTERED_ENTITY_ID varchar2(256 char), ALTERED_ENTITY_PROPERTY varchar2(100 char), ALTERED_ENTITY_TYPE varchar2(256 char), IP varchar2(32 char), LOG_DETAIL varchar2(1024 char), NEW_ATTRIBUTE varchar2(4000 char), OLD_ATTRIBUTE varchar2(4000 char), CREATION_DATE timestamp, ACTIVITY_TYPE_ID_FK number(19,0), primary key (id));
create table KSA.KSSA_ACTIVITY_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_ALLOCATION (ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), AMNT number(19,2), IS_LOCKED char(1 char), TRN_ID_1_FK number(19,0), TRN_ID_2_FK number(19,0), primary key (ID));
create table KSA.KSSA_BANK_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_BATCH_RECEIPT (ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), BATCH_DATE timestamp, TOTAL_ACCEPTED_CREDITS number(19,2), TOTAL_ACCEPTED_DEBITS number(19,2), EXTERNAL_ID varchar2(255 char), TOTAL_ACCEPTED number(10,0), TOTAL_REJECTED number(10,0), TOTAL_TRANS number(10,0), RECEIPT_DATE timestamp, STATUS varchar2(1 char), TOTAL_VOLUME number(19,2), TOTAL_VOLUME_REJECTED number(19,2), INCOMING_XML_ID_FK number(19,0), OUTGOING_XML_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_BILL_AUTHORITY (ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), CREATOR_ID varchar2(45 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, PREFERRED_METHOD varchar2(1 char), RELEASE_AGREED_BY varchar2(45 char), RELEASE_AGREED_DATE timestamp, ELECTRONIC_CONTACT_ID_FK number(19,0), PERSON_NAME_ID_FK number(19,0), POSTAL_ADDRESS_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_CREDIT_PERMISSION (ID number(19,0) not null, ALLOWABLE_DEBIT_TYPE_MASK varchar2(20 char), PRIORITY number(10,0), TRANSACTION_TYPE_ID_FK varchar2(20 char), TRANSACTION_TYPE_SUB_CODE_FK number(10,0), primary key (ID));
create table KSA.KSSA_CURRENCY (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_DOCUMENT (ID number(19,0) not null, DOCUMENT clob, CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), EDIT_REASON varchar2(512 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, primary key (ID));
create table KSA.KSSA_ELECTRONIC_CONTACT (ID number(19,0) not null, CREATOR_ID varchar2(45 char), IS_DEFAULT char(1 char), EDITOR_ID varchar2(45 char), EMAIL_ADDRESS varchar2(255 char), KIM_EMAIL_ADDRESS_TYPE varchar2(45 char), KIM_PHONE_TYPE varchar2(45 char), LAST_UPDATE timestamp, PHONE_COUNTRY varchar2(5 char), PHONE_EXTN varchar2(10 char), PHONE_NUMBER varchar2(20 char), primary key (ID));
create table KSA.KSSA_ELECTRONIC_CONTACT_ACNT (ACNT_ID_FK varchar2(45 char) not null, ELECTRONIC_CONTACT_ID_FK number(19,0) not null, primary key (ACNT_ID_FK, ELECTRONIC_CONTACT_ID_FK));
create table KSA.KSSA_EXTERNAL_STATEMENT (ID number(19,0) not null, CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), EDITOR_ID varchar2(45 char), FROM_DATE timestamp, LAST_UPDATE timestamp, MIME_TYPE varchar2(45 char), IS_REDIRECT char(1 char), TO_DATE timestamp, UNIQUE_KEY varchar2(256 char), URI varchar2(256 char), ACNT_ID_FK varchar2(45 char), primary key (ID));
create table KSA.KSSA_FLAG_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), ACCESS_LEVEL number(10,0), primary key (ID));
create table KSA.KSSA_GL_BREAKDOWN (ID number(19,0) not null, BREAKDOWN number(19,2), GL_ACCOUNT varchar2(45 char), GL_OPERATION varchar2(1 char), TRANSACTION_TYPE_ID_FK varchar2(20 char), TRANSACTION_TYPE_SUB_CODE_FK number(10,0), GL_TYPE_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_GL_BREAKDOWN_OVERRIDE (ID number(19,0) not null, BREAKDOWN number(19,2), GL_ACCOUNT varchar2(45 char), TRANSACTION_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_GL_TRANSACTION (ID number(19,0) not null, AMOUNT number(19,2), TRANSACTION_DATE timestamp, GENERATED_TEXT varchar2(1024 char), GL_ACCOUNT_ID varchar2(45 char), GL_OPERATION varchar2(1 char), STATUS varchar2(1 char), TRANSMISSION_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_GL_TRANSMISSION (ID number(19,0) not null, AMOUNT number(19,2), BATCH_ID varchar2(100 char), EARLIEST_DATE timestamp, GL_ACCOUNT_ID varchar2(45 char), GL_OPERATION varchar2(1 char), LATEST_DATE timestamp, RECOGNITION_PERIOD varchar2(45 char), RESULT varchar2(2048 char), TRANSMISSION_DATE timestamp, primary key (ID));
create table KSA.KSSA_GL_TRANS_TRANSACTION (GL_TRANSACTION_ID_FK number(19,0) not null, TRANSACTION_ID_FK number(19,0) not null, primary key (GL_TRANSACTION_ID_FK, TRANSACTION_ID_FK));
create table KSA.KSSA_GL_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), GL_ASSET_ACCOUNT varchar2(45 char), GL_OPERATION_ON_CHARGE varchar2(1 char), primary key (ID));
create table KSA.KSSA_ID_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_INFORMATION (TYPE varchar2(31 char) not null, ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), ACCESS_LEVEL number(10,0), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), EDITOR_ID varchar2(45 char), EFFECTIVE_DATE timestamp, EXPIRATION_DATE timestamp, LAST_UPDATE timestamp, TEXT varchar2(4000 char), SEVERITY number(10,0), TRN_ID_FK number(19,0), NEXT_ID number(19,0), PREV_ID number(19,0), FLAG_TYPE_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_KYPR (TYPE varchar2(31 char) not null, ID number(19,0) not null, NAME varchar2(45 char), PREV_VALUE varchar2(256 char), VALUE varchar2(256 char), LEARNING_PERIOD_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_LANGUAGE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), LOCALE varchar2(20 char) not null unique, primary key (ID));
create table KSA.KSSA_LATE_PERIOD (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), DAYS_LATE1 number(10,0), DAYS_LATE2 number(10,0), DAYS_LATE3 number(10,0), IS_DEFAULT char(1 char), primary key (ID));
create table KSA.KSSA_LEARNING_PERIOD (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), START_DATE timestamp not null, END_DATE timestamp not null, primary key (ID));
create table KSA.KSSA_LU (ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), ADD_DATE timestamp, CAMPUS varchar2(45 char), CREDIT number(5,2), DROP_DATE timestamp, LU_LEVEL varchar2(256 char), STATUS varchar2(45 char), UNIT_CODE varchar2(45 char), UNIT_SECTION varchar2(45 char), LEARNING_PERIOD_ID_FK number(19,0), primary key (ID));
create table KSA.KSSA_PERSON_NAME (ID number(19,0) not null, CREATOR_ID varchar2(45 char), IS_DEFAULT char(1 char), EDITOR_ID varchar2(45 char), FIRST_NAME varchar2(100 char), KIM_NAME_TYPE varchar2(45 char), LAST_NAME varchar2(100 char), LAST_UPDATE timestamp, MIDDLE_NAME varchar2(100 char), SUFFIX varchar2(10 char), TITLE varchar2(10 char), primary key (ID));
create table KSA.KSSA_PERSON_NAME_ACNT (ACNT_ID_FK varchar2(45 char) not null, PERSON_NAME_ID_FK number(19,0) not null, primary key (ACNT_ID_FK, PERSON_NAME_ID_FK));
create table KSA.KSSA_POSTAL_ADDRESS (ID number(19,0) not null, CITY varchar2(100 char), COUNTRY_CODE varchar2(10 char), CREATOR_ID varchar2(45 char), IS_DEFAULT char(1 char), EDITOR_ID varchar2(45 char), KIM_ADDRESS_TYPE varchar2(45 char), LAST_UPDATE timestamp, POSTAL_CODE varchar2(12 char), STATE_CODE varchar2(5 char), LINE1 varchar2(100 char), LINE2 varchar2(100 char), LINE3 varchar2(100 char), primary key (ID));
create table KSA.KSSA_POSTAL_ADDRESS_ACNT (ACNT_ID_FK varchar2(45 char) not null, POSTAL_ADDRESS_ID_FK number(19,0) not null, primary key (ACNT_ID_FK, POSTAL_ADDRESS_ID_FK));
create table KSA.KSSA_REFUND (ID number(19,0) not null, ATTRIBUTE varchar2(1024 char), BATCH_ID varchar2(100 char), CREATION_DATE timestamp, REQUEST_DATE timestamp, STATEMENT varchar2(1024 char), STATUS varchar2(1 char), SYSTEM varchar2(100 char), AUTHORIZER_ID_FK varchar2(45 char), REFUND_TYPE_ID_FK number(19,0), REQUESTER_ID_FK varchar2(45 char), TRANSACTION_ID_FK number(19,0) not null unique, primary key (ID));
create table KSA.KSSA_REFUND_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), CREDIT_TYPE_ID varchar2(20 char), DEBIT_TYPE_ID varchar2(20 char), primary key (ID));
create table KSA.KSSA_ROLLUP (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_RULE_SET (ID varchar2(100 char) not null, RULE_SET clob not null, primary key (ID));
create table KSA.KSSA_TAG (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), ACCESS_LEVEL number(10,0), primary key (ID));
create table KSA.KSSA_TAX_TYPE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), primary key (ID));
create table KSA.KSSA_TRANSACTION (TYPE varchar2(31 char) not null, ID number(19,0) not null, ACNT_ID_FK varchar2(45 char), ALLOCATED number(19,2), AMNT number(19,2), CREATOR_ID varchar2(45 char), EFFECTIVE_DATE timestamp, EXTN_ID varchar2(45 char), GL_ENTRY_GENERATED char(1 char), IS_GL_OVERRIDDEN char(1 char), IS_INTERNAL_TRN char(1 char), LEDGER_DATE timestamp, LOCKED_ALLOCATED number(19,2), NATIVE_AMNT number(19,2), ORIG_DATE timestamp, RECOGNITION_DATE timestamp, STATEMENT_TXT varchar2(100 char), EXPIRATION_DATE timestamp, IS_EXPIRED char(1 char), CLEAR_DATE timestamp, REFUND_RULE varchar2(2000 char), IS_REFUNDABLE char(1 char), CURRENCY_ID_FK number(19,0), DOCUMENT_ID_FK number(19,0), GL_TYPE_ID_FK number(19,0), ROLLUP_ID_FK number(19,0), TRANSACTION_TYPE_ID_FK varchar2(20 char), TRANSACTION_TYPE_SUB_CODE_FK number(10,0), primary key (ID));
create table KSA.KSSA_TRANSACTION_MASK_ROLE (ID number(19,0) not null, CODE varchar2(100 char), CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), DESCRIPTION varchar2(2000 char), EDITOR_ID varchar2(45 char), LAST_UPDATE timestamp, NAME varchar2(100 char), ROLE_NAME varchar2(256 char), TYPE_MASK varchar2(512 char), primary key (ID));
create table KSA.KSSA_TRANSACTION_TYPE (TYPE varchar2(31 char) not null, ID varchar2(20 char) not null, SUB_CODE number(10,0) not null, CREATOR_ID varchar2(45 char), DEF_TRN_TXT varchar2(100 char), EDITOR_ID varchar2(45 char), END_DATE timestamp, LAST_UPDATE timestamp, START_DATE timestamp, AUTH_TXT varchar2(1000 char), CLEAR_PERIOD number(10,0), UNALLOCATED_GL_OPERATION varchar2(1 char), REFUND_RULE varchar2(2000 char), UNALLOCATED_GL_ACCOUNT varchar2(45 char), PRIORITY number(10,0), DEF_ROLLUP_ID_FK number(19,0), primary key (ID, SUB_CODE));
create table KSA.KSSA_TRANSACTION_TYPE_TAG (TRANSACTION_TYPE_ID_FK varchar2(20 char) not null, TRANSACTION_TYPE_SUB_CODE_FK number(10,0) not null, TAG_ID_FK number(19,0) not null);
create table KSA.KSSA_UI_STRING (ID varchar2(128 char) not null, LOCALE varchar2(20 char) not null, MAX_LENGTH number(10,0), IS_OVERRIDDEN char(1 char), TEXT varchar2(4000 char), primary key (ID, LOCALE));
create table KSA.KSSA_USER_PREF (ACNT_ID_FK varchar2(45 char) not null, NAME varchar2(256 char) not null, VALUE varchar2(1024 char), primary key (ACNT_ID_FK, NAME));
create table KSA.KSSA_XML (ID number(19,0) not null, CREATION_DATE timestamp, CREATOR_ID varchar2(45 char), XML_DOCUMENT clob, primary key (ID));