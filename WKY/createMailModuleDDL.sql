-- drop objects
drop table wky_brands cascade constraints;
drop table wky_sales_channel_types cascade constraints;
drop table wky_mail_template_types cascade constraints;
drop table wky_mail_templates cascade constraints;
drop table wky_scl_mail_template_types cascade constraints;
drop table wky_mail_parameters cascade constraints;
drop table wky_mail_loggings cascade constraints;

-- create tables
create table wky_brands (
    id                             number not null constraint wky_brands_id_pk primary key,
    row_version                    integer not null,
    name                           varchar2(255)
                                   constraint wky_brands_name_unq unique not null,
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_sales_channel_types (
    id                             number not null constraint wky_sales_channel_id_pk primary key,
    row_version                    integer not null,
    name                           varchar2(255)
                                   constraint wky_sales_channel_name_unq unique not null,
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_mail_template_types (
    id                             number not null constraint wky_mail_template_id_pk primary key,
    row_version                    integer not null,
    name                           varchar2(255),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_mail_templates (
    id                             number not null constraint wky_mail_templates_id_pk primary key,
    row_version                    integer not null,
    name                           varchar2(255) not null,
    code                           varchar2(255) not null,
    subject                        varchar2(255),
    html_header                    clob,
    html_body                      clob not null,
    html_footer                    clob,
    plain_text                     clob not null,
    comments                       varchar2(4000),
    lge_id                         number
                                   constraint wky_mail_templates_lge_id_fk
                                   references wky_languages_lkp not null,
    cty_id                         number
                                   constraint wky_mail_templates_cty_id_fk
                                   references wky_countries not null,
    mte_id                         number
                                   constraint wky_mail_templates_mte_id_fk
                                   references wky_mail_template_types,
    brd_id                         number
                                   constraint wky_mail_templates_brd_id_fk
                                   references wky_brands not null,
    ste_id                         number
                                   constraint wky_mail_templates_ste_id_fk
                                   references wky_sales_channel_types not null,
    default_to                     varchar2(255),
    default_cc                     varchar2(255),
    default_bcc                    varchar2(255),
    default_from                   varchar2(255),
    default_reply_to               varchar2(255),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_scl_mail_template_types (
    id                             number not null constraint wky_scl_mail_templ_id_pk primary key,
    row_version                    integer not null,
    scl_id                         number
                                   constraint wky_scl_mail_templ_scl_id_fk
                                   references wky_saleschannels,
    mte_id                         number
                                   constraint wky_scl_mail_templ_mte_id_fk
                                   references wky_mail_template_types,
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_mail_parameters (
    id                             number not null constraint wky_mail_parameter_id_pk primary key,
    row_version                    integer not null,
    parameter_name                 varchar2(50) not null,
    parameter_value                varchar2(250) not null,
    active_flag                    varchar2(1) default on null 'Y' not null,
    language                       varchar2(5) default on null 'US' not null,
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_mail_loggings (
    id                             number not null constraint wky_mail_loggings_id_pk primary key,
    row_version                    integer not null,
    mail_id                        number not null,
    ctr_id                         number
                                   constraint wky_mail_loggings_ctr_id_fk
                                   references wky_customers,
    odr_id                         number
                                   constraint wky_mail_loggings_odr_id_fk
                                   references wky_orders,
    mtp_id                         number
                                   constraint wky_mail_loggings_mtp_id_fk
                                   references wky_mail_templates,
    mail_to                        varchar2(4000) not null,
    mail_cc                        varchar2(4000),
    mail_bcc                       varchar2(4000),
    mail_from                      varchar2(4000) not null,
    mail_reply_to                  varchar2(4000),
    mail_language                  varchar2(5) not null,
    date_sent                      date not null,
    subject                        varchar2(500),
    message_body                   clob,
    message_body_html              clob,
    postmark_feedback              varchar2(200),
    remarks                        varchar2(4000),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;


-- triggers
create or replace trigger wky_brands_biu
    before insert or update 
    on wky_brands
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
end wky_brands_biu;
/

create or replace trigger wky_mail_loggings_biu
    before insert or update 
    on wky_mail_loggings
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
end wky_mail_loggings_biu;
/

create or replace trigger wky_mail_parameters_biu
    before insert or update 
    on wky_mail_parameters
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
end wky_mail_parameters_biu;
/

create or replace trigger wky_mail_templates_biu
    before insert or update 
    on wky_mail_templates
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
end wky_mail_templates_biu;
/

create or replace trigger wky_mail_template_types_bi
    before insert or update 
    on wky_mail_template_types
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
end wky_mail_template_types_bi;
/

create or replace trigger wky_sales_channel_types_bi
    before insert or update 
    on wky_sales_channel_types
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
end wky_sales_channel_types_bi;
/

create or replace trigger wky_scl_mail_template_type
    before insert or update 
    on wky_scl_mail_template_types
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
end wky_scl_mail_template_type;
/


-- indexes
create index wky_mail_loggings_i1 on wky_mail_loggings (ctr_id);
create index wky_mail_loggings_i2 on wky_mail_loggings (mtp_id);
create index wky_mail_loggings_i3 on wky_mail_loggings (odr_id);
create index wky_mail_templates_i1 on wky_mail_templates (brd_id);
create index wky_mail_templates_i2 on wky_mail_templates (cty_id);
create index wky_mail_templates_i3 on wky_mail_templates (lge_id);
create index wky_mail_templates_i4 on wky_mail_templates (mte_id);
create index wky_mail_templates_i5 on wky_mail_templates (ste_id);
create index wky_scl_mail_template_types_i1 on wky_scl_mail_template_types (mte_id);
create index wky_scl_mail_template_types_i2 on wky_scl_mail_template_types (scl_id);

-- comments
comment on table wky_brands is 'BRD';
comment on table wky_mail_loggings is 'MLS';
comment on table wky_mail_parameters is 'MPR';
comment on table wky_mail_templates is 'MTP';
comment on table wky_mail_template_types is 'MTE: probably obsolete';
comment on table wky_sales_channel_types is 'STE';
comment on table wky_scl_mail_template_types is 'SME';
comment on column wky_mail_loggings.mail_id is 'References the mail ID used by apex_mail package';
comment on column wky_mail_templates.cty_id is 'Template per country. E.g. Belgium one template with 3 language sections in it';
comment on column wky_mail_templates.lge_id is 'Identifies main language, as template is per cpountry, not per language';
comment on column wky_mail_templates.mte_id is 'Probably obsolete';
-- load data
 
-- Generated by Quick SQL Friday September 28, 2018  12:58:04
 
/*
brands [BRD]
 name vc(255) /unique /nn

sales_channel_types [STE]
 name /unique /nn 

mail_template_types [MTE: probably obsolete]
 name
 
mail_templates [MTP]
 name vc(255) /nn 
 code vc(255) /nn
 subject vc(255)
 html_header clob 
 html_body clob /nn
 html_footer clob 
 plain_text clob /nn
 comments vc(4000)
 lge_id /fk wky_languages_lkp /nn [Identifies main language, as template is per cpountry, not per language]
 cty_id /fk wky_countries /nn [Template per country. E.g. Belgium one template with 3 language sections in it]
 mte_id /fk mail_template_types [Probably obsolete]
 brd_id /fk brands /nn
 ste_id /fk sales_channel_types /nn
 default_to vc(255)
 default_cc vc(255)
 default_bcc vc(255)
 default_from vc(255)
 default_reply_to vc(255)

scl_mail_template_types [SME]
 scl_id /fk wky_saleschannels
 mte_id /fk mail_template_types
 
mail_parameters [MPR]
  parameter_name vc(50) /nn
  parameter_value vc(250) /nn
  active_flag vc(1) /nn /default Y
  language vc(5) /default US /nn
  
mail_loggings [MLS]
  mail_id /nn [References the mail ID used by apex_mail package]
  ctr_id /fk wky_customers
  odr_id /fk wky_orders
  mtp_id /fk mail_templates
  mail_to vc(4000) /nn
  mail_cc vc(4000)
  mail_bcc vc(4000)
  mail_from vc(4000) /nn
  mail_reply_to vc(4000)
  mail_language vc(5) /nn
  date_sent /nn
  subject vc(500)
  message_body clob
  message_body_html clob
  postmark_feedback vc(200)
  remarks vc(4000)

# settings = { prefix: "wky", onDelete: "RESTRICT", PK: "TRIG", auditCols: true, rowVersion: true, drop: true, language: "EN", APEX: true }
*/
