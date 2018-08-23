select sysdate from dual;

-- drop objects
drop table wky_logistic_odr_statuses_lkp cascade constraints;
drop table wky_financial_odr_statuses_lkp cascade constraints;

-- create tables
create table wky_logistic_odr_statuses_lkp (
    id                             number not null constraint wky_logistic_odr_s_id_pk primary key,
    row_version                    integer not null,
    lookupcode                     varchar2(50) not null,
    language                       varchar2(5) default on null 'US' not null,
    lookupvalue                    varchar2(250),
    sortingsequence                number,
    active                         varchar2(1) default on null 'Y' not null,
    mapping_code                   varchar2(250),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_financial_odr_statuses_lkp (
    id                             number not null constraint wky_financial_odr_id_pk primary key,
    row_version                    integer not null,
    lookupcode                     varchar2(50) not null,
    language                       varchar2(5) default on null 'US' not null,
    lookupvalue                    varchar2(250),
    sortingsequence                number,
    active                         varchar2(1) default on null 'Y' not null,
    mapping_code                   varchar2(250),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;


-- triggers
create or replace trigger wky_financial_odr_statuses
    before insert or update 
    on wky_financial_odr_statuses_lkp
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
        :new.row_version := 1;
    elsif updating then
        :new.row_version := nvl(:old.row_version,0) + 1;
    end if;
    if inserting then
        :new.created := sysdate;
        :new.created_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
end wky_financial_odr_statuses;
/

create or replace trigger wky_logistic_odr_statuses_
    before insert or update 
    on wky_logistic_odr_statuses_lkp
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
        :new.row_version := 1;
    elsif updating then
        :new.row_version := nvl(:old.row_version,0) + 1;
    end if;
    if inserting then
        :new.created := sysdate;
        :new.created_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := nvl(sys_context('APEX$SESSION','APP_USER'),user);
end wky_logistic_odr_statuses_;
/


-- comments
comment on table wky_financial_odr_statuses_lkp is 'FOS: Financial order status';
comment on table wky_logistic_odr_statuses_lkp is 'LOS: Logistics order status';
-- load data
 
-- Generated by Quick SQL Tuesday August 21, 2018  15:06:01
 
/*
logistic_odr_statuses_lkp [LOS: Logistics order status]
  lookupcode vc(50) /nn
  language vc(5) /default US /nn
  lookupvalue vc(250)
  sortingsequence number
  active vc(1) /default Y /nn
  mapping_code vc(250)
  
financial_odr_statuses_lkp [FOS: Financial order status]
  lookupcode vc(50) /nn
  language vc(5) /default US /nn
  lookupvalue vc(250)
  sortingsequence number
  active vc(1) /default Y /nn
  mapping_code vc(250)

# settings = { prefix: "WKY", onDelete: "RESTRICT", PK: "TRIG", auditCols: true, rowVersion: true, drop: true, language: "EN", APEX: true }
*/


insert into wky_logistic_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'ORDER', 'US', 'Order', 1, 'Y');
insert into wky_logistic_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'PAID', 'US', 'Paid', 2, 'Y');
insert into wky_logistic_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'PLANNED', 'US', 'In production / Planned', 3, 'Y');
insert into wky_logistic_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'SHIPPED', 'US', 'Shipped', 4, 'Y');
insert into wky_logistic_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'ARRIVED', 'US', 'Arrived at customer', 5, 'Y');






insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'CANCELLED', 'US', 'Cancelled', 9, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'CANCREF', 'US', 'Cancelled and refunded', 10, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'NIS', 'US', 'Not in stock', 11, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RET', 'US', 'Returned', 12, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETANN', 'US', 'Return announced', 13, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETANNCAR', 'US', 'Return announced by carrier', 14, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETREC', 'US', 'Return received', 15, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETREC', 'US', 'Return received', 16, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETRECREF', 'US', 'Return received and refunded', 17, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'RETREF', 'US', 'Return refunded', 18, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'ISLAND', 'US', 'Island', 19, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'PFA', 'US', 'Pro forma account', 20, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'OC1', 'US', 'Order confirmed - 1st reminder', 21, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'OC2', 'US', 'Order confirmed - 2nd reminder', 22, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'NEVERPAID', 'US', 'Order never paid', 23, 'Y');
insert into wky_financial_odr_statuses_lkp ( lookupcode, language, lookupvalue, sortingsequence, active)
values ( 'DELETED', 'US', 'Deleted', 24, 'Y');
commit;