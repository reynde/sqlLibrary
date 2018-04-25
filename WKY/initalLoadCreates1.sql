-- drop objects
--drop table wky_depots cascade constraints;
drop table wky_depot_postalcodes cascade constraints;
--drop table wky_saleschannel_delivery_time cascade constraints;
--drop table wky_production_location cascade constraints;
--drop table wky_mail_htmlemails cascade constraints;


-- create tables
create table wky_depots (
    id                             number not null constraint wky_depots_id_pk primary key,
    row_version                    integer not null,
    depot_name                     varchar2(50) not null,
    crr_id                         number
                                   constraint wky_depots_crr_id_fk
                                   references wky_carriers not null,
    spedition                      varchar2(20) not null,
    lxw_pk                         number(22,10),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_depot_postalcodes (
    id                             number not null constraint wky_depot_postalco_id_pk primary key,
    row_version                    integer not null,
    dpt_id                         number
                                   constraint wky_depot_postalco_dpt_id_fk
                                   references wky_depots not null,
    cty_id                         number
                                   constraint wky_depot_postalco_cty_id_fk
                                   references wky_countries not null,
    postalcode_start               varchar2(10) not null,
    postalcode_end                 varchar2(10) not null,
    lxw_pk                         number(22,10),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_saleschannel_delivery_time (
    id                             number not null constraint wky_saleschannel_d_id_pk primary key,
    row_version                    integer not null,
    scl_id                         number
                                   constraint wky_saleschannel_d_scl_id_fk
                                   references wky_saleschannels not null,
    shipping_method                varchar2(20) not null,
    cty_id                         number
                                   constraint wky_saleschannel_d_cty_id_fk
                                   references wky_countries not null,
    start_date                     date not null,
    end_date                       date not null,
    days_min                       number(22,2) not null,
    days_max                       number(22,2) not null,
    lxw_pk                         number(22,10),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_production_location (
    id                             number not null constraint wky_production_loc_id_pk primary key,
    row_version                    integer not null,
    name                           varchar2(20) not null,
    status                         number(22,1) not null,
    deleted                        number(22,1),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;

create table wky_mail_htmlemails (
    id                             number not null constraint wky_mail_htmlemail_id_pk primary key,
    row_version                    integer not null,
    status                         varchar2(30) not null,
    cty_id                         number
                                   constraint wky_mail_htmlemail_cty_id_fk
                                   references wky_countries not null,
    subject                        varchar2(500) not null,
    text                           clob not null,
    lxw_pk                         number(22,10),
    created                        date not null,
    created_by                     varchar2(255) not null,
    updated                        date not null,
    updated_by                     varchar2(255) not null
)
;


-- triggers
create or replace trigger wky_depots_biu
    before insert or update 
    on wky_depots
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
end wky_depots_biu;
/

create or replace trigger wky_depot_postalcodes_biu
    before insert or update 
    on wky_depot_postalcodes
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
end wky_depot_postalcodes_biu;
/

create or replace trigger wky_mail_htmlemails_biu
    before insert or update 
    on wky_mail_htmlemails
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
end wky_mail_htmlemails_biu;
/

create or replace trigger wky_production_location_bi
    before insert or update 
    on wky_production_location
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
end wky_production_location_bi;
/

create or replace trigger wky_saleschannel_delivery_
    before insert or update 
    on wky_saleschannel_delivery_time
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
end wky_saleschannel_delivery_;
/


-- indexes
create index wky_depots_i1 on wky_depots (crr_id);
create index wky_depot_postalcodes_i1 on wky_depot_postalcodes (cty_id);
create index wky_depot_postalcodes_i2 on wky_depot_postalcodes (dpt_id);
create index wky_mail_htmlemails_i1 on wky_mail_htmlemails (cty_id);
create index wky_saleschannel_delivery_t_i1 on wky_saleschannel_delivery_time (cty_id);
create index wky_saleschannel_delivery_t_i2 on wky_saleschannel_delivery_time (scl_id);

-- comments
comment on table wky_depots is 'DPT';
comment on table wky_depot_postalcodes is 'DPE';
-- load data
 
-- Generated by Quick SQL Tuesday April 24, 2018  19:18:57
 
/*
depots [DPT]
  depot_name vc50 /nn
  crr_id /fk wky_carriers  /nn
  spedition vc20  /nn
  lxw_pk num(22,10) 

depot_postalcodes [DPE]
  dpt_id /fk wky_depots /nn
  cty_id /fk wky_countries  /nn
  postalcode_start vc10 /nn
  postalcode_end vc10 /nn
  lxw_pk num(22,10)

saleschannel_delivery_times
  scl_id /fk wky_saleschannels /nn
  shipping_method vc20 /nn
  cty_id /fk wky_countries /nn
  start_date /nn
  end_date /nn
  days_min num(22,2) /nn
  days_max num (22,2) /nn
  lxw_pk num(22,10)

production_location
  name vc20 /nn
  status num(22,1) /nn
  deleted num(22,1)

mail_htmlemails
  status vc30 /nn
  cty_id /fk wky_countries /nn
  subject vc500 /nn
  text clob /nn
  lxw_pk num(22,10)

# settings = { prefix: "WKY", onDelete: "RESTRICT", PK: "TRIG", auditCols: true, rowVersion: true, drop: true, APEX: true }
*/

