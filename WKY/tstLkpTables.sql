





select * from wky_carriertypes_lkp; -- 2 OK
select * from wky_carrierpreferances_lkp; -- 0 OK
select * from wky_contractrecordingtypes_lkp; -- 0 OK
select * from wky_daysofweek_lkp; -- 7 OK
select * from wky_deliveryforms_lkp; -- 2 OK
select * from wky_ticketstatuses_lkp; -- 7 OK
select * from wky_languages_lkp; -- 12 OK
select * from wky_orderstatuses_lkp; -- 10 OK
select * from wky_packagetypes_lkp; -- 0 OK
select * from wky_paymentmethods_lkp; -- 5 OK
select * from wky_paymentstatuses_lkp; -- 7 OK
select * from wky_returnvalues_lkp; -- 0 OK
select * from wky_shipmentstatuses_lkp; -- 0 OK
select * from wky_companies_lkp; -- 3 OK


select * from wky_mail_statuses_lkp; -- 0 LOAD 6 trigger done
select * from wky_complaint_actions_lkp; -- 0 LOAD 11 trigger done
select * from wky_complaint_reasons_lkp; -- NEW CREATE LOAD 20 trigger done
select * from wky_contact_types_lkp; -- NEW CREATE LOAD 5 trigger done
select * from wky_return_reasons_lkp; -- NEW CREATE LOAD 11 trigger done
select * from wky_tickettype_lkp; -- 8 CHECK VALUES OK (trigger ok)





-- creating triggers
create or replace editionable trigger WKY_MAIL_STATUSES_LKP_BIU before
  insert or update on wky_mail_statuses_lkp
  for each row
begin
  if
    :new.id is null
  then
    :new.id := to_number(
      sys_guid()
    , 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    );
  end if;

  if
    inserting
  then
    :new.row_version := 1;
  elsif updating then
    :new.row_version := nvl(
      :old.row_version
    , 0
    ) + 1;
  end if;

  if
    inserting
  then
    :new.created := sysdate;
    :new.created_by := nvl(
      sys_context(
        'APEX$SESSION'
      , 'APP_USER'
      )
    , user
    );
  end if;

  :new.updated := sysdate;
  :new.updated_by := nvl(
    sys_context(
      'APEX$SESSION'
    , 'APP_USER'
    )
  , user
  );
end wky_mail_statuses_lkp_biu;
/

create or replace editionable trigger WKY_COMPLAINT_ACTIONS_LKP_ before
  insert or update on wky_complaint_actions_lkp
  for each row
begin
  if
    :new.id is null
  then
    :new.id := to_number(
      sys_guid()
    , 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    );
  end if;

  if
    inserting
  then
    :new.row_version := 1;
  elsif updating then
    :new.row_version := nvl(
      :old.row_version
    , 0
    ) + 1;
  end if;

  if
    inserting
  then
    :new.created := sysdate;
    :new.created_by := nvl(
      sys_context(
        'APEX$SESSION'
      , 'APP_USER'
      )
    , user
    );
  end if;

  :new.updated := sysdate;
  :new.updated_by := nvl(
    sys_context(
      'APEX$SESSION'
    , 'APP_USER'
    )
  , user
  );
end wky_complaint_actions_lkp_;
/

create or replace editionable trigger WKY_COMPLAINT_REASONS_LKP_BIU before
  insert or update on wky_complaint_reasons_lkp
  for each row
begin
  if
    :new.id is null
  then
    :new.id := to_number(
      sys_guid()
    , 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    );
  end if;

  if
    inserting
  then
    :new.row_version := 1;
  elsif updating then
    :new.row_version := nvl(
      :old.row_version
    , 0
    ) + 1;
  end if;

  if
    inserting
  then
    :new.created := sysdate;
    :new.created_by := nvl(
      sys_context(
        'APEX$SESSION'
      , 'APP_USER'
      )
    , user
    );
  end if;

  :new.updated := sysdate;
  :new.updated_by := nvl(
    sys_context(
      'APEX$SESSION'
    , 'APP_USER'
    )
  , user
  );
end wky_complaint_reasons_lkp_biu;
/

create or replace editionable trigger WKY_CONTACT_TYPES_LKP_BIU before
  insert or update on wky_contact_types_lkp
  for each row
begin
  if
    :new.id is null
  then
    :new.id := to_number(
      sys_guid()
    , 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    );
  end if;

  if
    inserting
  then
    :new.row_version := 1;
  elsif updating then
    :new.row_version := nvl(
      :old.row_version
    , 0
    ) + 1;
  end if;

  if
    inserting
  then
    :new.created := sysdate;
    :new.created_by := nvl(
      sys_context(
        'APEX$SESSION'
      , 'APP_USER'
      )
    , user
    );
  end if;

  :new.updated := sysdate;
  :new.updated_by := nvl(
    sys_context(
      'APEX$SESSION'
    , 'APP_USER'
    )
  , user
  );
end wky_contact_types_lkp_biu;
/

create or replace editionable trigger WKY_RETURN_REASONS_LKP_BIU before
  insert or update on wky_return_reasons_lkp
  for each row
begin
  if
    :new.id is null
  then
    :new.id := to_number(
      sys_guid()
    , 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    );
  end if;

  if
    inserting
  then
    :new.row_version := 1;
  elsif updating then
    :new.row_version := nvl(
      :old.row_version
    , 0
    ) + 1;
  end if;

  if
    inserting
  then
    :new.created := sysdate;
    :new.created_by := nvl(
      sys_context(
        'APEX$SESSION'
      , 'APP_USER'
      )
    , user
    );
  end if;

  :new.updated := sysdate;
  :new.updated_by := nvl(
    sys_context(
      'APEX$SESSION'
    , 'APP_USER'
    )
  , user
  );
end wky_return_reasons_lkp_biu;
/