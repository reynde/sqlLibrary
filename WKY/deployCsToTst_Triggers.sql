--------------------------------------------------------
--  File created - woensdag-mei-23-2018   
--------------------------------------------------------
--select sysdate from dual;
---------------------------
--New TRIGGER
--WKY_ZIPCODE_CARRIER_COSTS_
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_ZIPCODE_CARRIER_COSTS_"
  BEFORE INSERT OR UPDATE ON "WKY_ZIPCODE_CARRIER_COSTS"
  REFERENCING FOR EACH ROW
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
end wky_zipcode_carrier_costs_;
/
---------------------------
--New TRIGGER
--WKY_MAIL_LOGS_BIU
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_MAIL_LOGS_BIU"
  BEFORE INSERT OR UPDATE ON "WKY_MAIL_LOGS"
  REFERENCING FOR EACH ROW
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
end wky_mail_logs_biu;
/
---------------------------
--New TRIGGER
--WKY_COUNTRY_CARRIER_COSTS_
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_COUNTRY_CARRIER_COSTS_"
  BEFORE INSERT OR UPDATE ON "WKY_COUNTRY_CARRIER_COSTS"
  REFERENCING FOR EACH ROW
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
end wky_country_carrier_costs_;
/
