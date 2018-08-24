--Tables
ALTER TABLE "WKY_CUSTOMERS" ADD ("MANUAL_ADDED" VARCHAR2(1 CHAR) DEFAULT 'N');
COMMENT ON COLUMN "WKY_CUSTOMERS"."MANUAL_ADDED" IS 'Used for manualy adding customers trought ORACLE kundencervice application';

CREATE TABLE "WKY_EEC_COUNTRIES" 
   (	"ID" NUMBER NOT NULL ENABLE,
	"ROW_VERSION" NUMBER(*,0) NOT NULL ENABLE,
	"CTY_ID" NUMBER NOT NULL ENABLE,
	"START_DATE" DATE NOT NULL ENABLE,
	"END_DATE" DATE,
	"EEC_FLAG" VARCHAR2(1) NOT NULL ENABLE,
	"CREATED" DATE NOT NULL ENABLE,
	"CREATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	"UPDATED" DATE NOT NULL ENABLE,
	"UPDATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	CONSTRAINT "WKY_EEC_COUNTRIES_ID_PK" PRIMARY KEY ("ID") ENABLE,
	CONSTRAINT "WKY_EEC_COUNTRIES_CTY_ID_FK" FOREIGN KEY ("CTY_ID")
	 REFERENCES "WKY_COUNTRIES" ("ID") ENABLE
   );
  COMMENT ON TABLE "WKY_EEC_COUNTRIES" IS 'ECY: identifies if country is in or not in the EEC';

CREATE TABLE "WKY_LOGISTIC_ODR_STATUSES_LKP" 
   (	"ID" NUMBER NOT NULL ENABLE,
	"ROW_VERSION" NUMBER(*,0) NOT NULL ENABLE,
	"LOOKUPCODE" VARCHAR2(50) NOT NULL ENABLE,
	"LANGUAGE" VARCHAR2(5) DEFAULT 'US' NOT NULL ENABLE,
	"LOOKUPVALUE" VARCHAR2(250),
	"SORTINGSEQUENCE" NUMBER,
	"ACTIVE" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
	"MAPPING_CODE" VARCHAR2(250),
	"CREATED" DATE NOT NULL ENABLE,
	"CREATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	"UPDATED" DATE NOT NULL ENABLE,
	"UPDATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	CONSTRAINT "WKY_LOGISTIC_ODR_S_ID_PK" PRIMARY KEY ("ID") ENABLE
   );
  COMMENT ON TABLE "WKY_LOGISTIC_ODR_STATUSES_LKP" IS 'LOS: Logistics order status';
  
CREATE TABLE "WKY_FINANCIAL_ODR_STATUSES_LKP" 
   (	"ID" NUMBER NOT NULL ENABLE,
	"ROW_VERSION" NUMBER(*,0) NOT NULL ENABLE,
	"LOOKUPCODE" VARCHAR2(50) NOT NULL ENABLE,
	"LANGUAGE" VARCHAR2(5) DEFAULT 'US' NOT NULL ENABLE,
	"LOOKUPVALUE" VARCHAR2(250),
	"SORTINGSEQUENCE" NUMBER,
	"ACTIVE" VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
	"MAPPING_CODE" VARCHAR2(250),
	"CREATED" DATE NOT NULL ENABLE,
	"CREATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	"UPDATED" DATE NOT NULL ENABLE,
	"UPDATED_BY" VARCHAR2(255) NOT NULL ENABLE,
	CONSTRAINT "WKY_FINANCIAL_ODR_ID_PK" PRIMARY KEY ("ID") ENABLE
   );
  COMMENT ON TABLE "WKY_FINANCIAL_ODR_STATUSES_LKP" IS 'FOS: Financial order status';  

ALTER TABLE "WKY_ORDERS" ADD ("FOS_ID" NUMBER);
ALTER TABLE "WKY_ORDERS" ADD ("LOS_ID" NUMBER);
ALTER TABLE "WKY_ORDERS" ADD ("MANUAL_ADDED" VARCHAR2(1 CHAR) DEFAULT 'N');
ALTER TABLE "WKY_ORDERS" ADD ("VAT_FREE" VARCHAR2(1));
ALTER TABLE "WKY_ORDERS" ADD ("VAT_FREE_REASON" VARCHAR2(250));
ALTER TABLE "WKY_ORDERS" ADD ("VAT_VIES_CONSULTATION_DATE" DATE);
ALTER TABLE "WKY_ORDERS" ADD ("VAT_VIES_CONSULTATION_NUMBER" VARCHAR2(50));
ALTER TABLE "WKY_ORDERS" ADD CONSTRAINT "WKY_ORDERS_FOS" FOREIGN KEY ("FOS_ID") REFERENCES "WKY_FINANCIAL_ODR_STATUSES_LKP"("ID") ENABLE;
ALTER TABLE "WKY_ORDERS" ADD CONSTRAINT "WKY_ORDERS_LOS" FOREIGN KEY ("LOS_ID") REFERENCES "WKY_LOGISTIC_ODR_STATUSES_LKP"("ID") ENABLE;
COMMENT ON COLUMN "WKY_ORDERS"."DELIVERY_DATE" IS 'Date that goods arrive at end customer';
COMMENT ON COLUMN "WKY_ORDERS"."FOOTER_TEXT" IS 'In lexware is called FK_AUFTRAG.texte_fusstext';
COMMENT ON COLUMN "WKY_ORDERS"."FOS_ID" IS 'Financial order status ID FK field';
COMMENT ON COLUMN "WKY_ORDERS"."HEADER_TEXT" IS 'In lexware is called FK_AUFTRAG.texte_kopftext';
COMMENT ON COLUMN "WKY_ORDERS"."LOS_ID" IS 'Logistic order status ID FK field';
COMMENT ON COLUMN "WKY_ORDERS"."LXW_AUFTRAGSNR" IS 'Copy of the Auftragsnr from the INT table';
COMMENT ON COLUMN "WKY_ORDERS"."MANUAL_ADDED" IS 'Used for manualy adding customers trought ORACLE kundencervice application';
COMMENT ON COLUMN "WKY_ORDERS"."ORDER_SOURCE" IS 'If null than is regular order, B)Back order, R)Return order';
COMMENT ON COLUMN "WKY_ORDERS"."SHIPPING_DATE" IS 'Date that goods leave Wickey';
COMMENT ON COLUMN "WKY_ORDERS"."VAT_FREE_REASON" IS 'Reason why this order has been made VAT FREE';
COMMENT ON COLUMN "WKY_ORDERS"."VAT_VIES_CONSULTATION_NUMBER" IS 'Number identified from Stauerambt Saarlouis validation';



--Triggers
---------------------------
--New TRIGGER
--WKY_EEC_COUNTRIES_BIU
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_EEC_COUNTRIES_BIU"
  BEFORE INSERT OR UPDATE ON "WKY_EEC_COUNTRIES"
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
end wky_eec_countries_biu;
/
---------------------------
--New TRIGGER
--WKY_FINANCIAL_ODR_STATUSES
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_FINANCIAL_ODR_STATUSES"
  BEFORE INSERT OR UPDATE ON "WKY_FINANCIAL_ODR_STATUSES_LKP"
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
end wky_financial_odr_statuses;
/
---------------------------
--New TRIGGER
--WKY_LOGISTIC_ODR_STATUSES_
---------------------------
  CREATE OR REPLACE TRIGGER "WKY_LOGISTIC_ODR_STATUSES_"
  BEFORE INSERT OR UPDATE ON "WKY_LOGISTIC_ODR_STATUSES_LKP"
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
end wky_logistic_odr_statuses_;
/

--Views
CREATE OR REPLACE FORCE VIEW "WKY_COUNTRIES_V" 
 ( "CTY_ID", "COUNTRYNAME", "ISO_CODE", "LANGUAGE", "ECY_ID", "EEC_START_DATE", "EEC_END_DATE", "CURRENT_EEC_FLAG"
  )  AS 
  select cty.id as cty_id, cty.countryname, cty.iso_code, cty.language
     , ecy.id as ecy_id, ecy.start_date as eec_start_date, ecy.end_date as eec_end_date, nvl( ecy.eec_flag, 'Y') as current_eec_flag
  from wky_countries cty
     , wky_eec_countries ecy
 where cty.id = ecy.cty_id (+)
   and sysdate between nvl( ecy.start_date, sysdate) and nvl( ecy.end_date, sysdate);

CREATE OR REPLACE FORCE VIEW "WKY_CURRENT_EEC_COUNTRIES_V" 
 ( "ID", "ROW_VERSION", "COUNTRYNAME", "STATUS", "CREATED", "UPDATED", "CREATED_BY", "UPDATED_BY", "ISO_CODE", "LANGUAGE", "EEC_FLAG", "START_DATE", "END_DATE"
  )  AS 
  select cty."ID",cty."ROW_VERSION",cty."COUNTRYNAME",cty."STATUS",cty."CREATED",cty."UPDATED",cty."CREATED_BY",cty."UPDATED_BY",cty."ISO_CODE",cty."LANGUAGE"
     , ecy.eec_flag, ecy.start_date, ecy.end_date
  from wky_countries cty
     , wky_eec_countries ecy 
 where cty.id = ecy.cty_id(+)
   and nvl( ecy.eec_flag, 'Y') = 'Y'
   and sysdate between nvl( ecy.start_date, sysdate) and nvl( ecy.end_date, sysdate);

CREATE OR REPLACE FORCE VIEW "WKY_CURRENT_NONEEC_COUNTRIES_V" 
 ( "ID", "ROW_VERSION", "COUNTRYNAME", "STATUS", "CREATED", "UPDATED", "CREATED_BY", "UPDATED_BY", "ISO_CODE", "LANGUAGE", "EEC_FLAG", "START_DATE", "END_DATE"
  )  AS 
  select cty."ID",cty."ROW_VERSION",cty."COUNTRYNAME",cty."STATUS",cty."CREATED",cty."UPDATED",cty."CREATED_BY",cty."UPDATED_BY",cty."ISO_CODE",cty."LANGUAGE"
     , ecy.eec_flag, ecy.start_date, ecy.end_date
  from wky_countries cty
     , wky_eec_countries ecy 
 where cty.id = ecy.cty_id(+)
   and nvl( ecy.eec_flag, 'Y') = 'N'
   and sysdate between nvl( ecy.start_date, sysdate) and nvl( ecy.end_date, sysdate);

CREATE OR REPLACE FORCE VIEW "WKY_ORDERS_V" 
 ( "ORDERNUMBER", "ORDERDATE", "ORDERDATE_TS", "TOTALPRICE", "VATVALUE", "VATRATE", "VATCUSTOMERNUMBER", "ODR_DESCRIPTION", "ODR_NOTE", "REST_STATUS", "SHIPPING_MINIMUM_DATE", "SHIPPING_MAXIMUM_DATE", "ORDER_SOURCE", "OSS_ID", "OSS_ORDER_STATUS", "DFM_ID", "DELIVERY_FORM", "CRY_ID", "CURRENCY", "SCL_ID", "SALES_CHANNEL", "SHIPPING_AMOUNT", "SHIPPING_TAX_AMOUNT", "FIRSTNAME", "LASTNAME", "PREFIX", "MIDDLENAME", "COMPANY", "COMPANYTAXCODE", "PHONENUMBER", "EMAILADDRESS", "IBAN", "DELIVERYADDRESSSTREETNAME", "DELIVERYADDRESSHOUSENUMBER", "DELIVERYADDRESSZIPCODE", "DELIVERYADDRESSCITY", "DELIVERYREGION", "DELCTY_ID", "DELIVERYCOUNTRY", "EEC_FLAG", "LGE_ID", "CUSTOMER_LANGUAGE", "ODR_ID", "ODR_ROW_VERSION", "ODR_CREATED", "ODR_CREATED_BY", "ODR_UPDATED", "ODR_UPDATED_BY", "CTR_ID", "CTR_ROW_VERSION", "CTR_CREATED", "CTR_CREATED_BY", "CTR_UPDATED", "CTR_UPDATED_BY"
  )  AS 
  select -- Order
       odr.ordernumber  
     , odr.orderdate
     , to_char( odr.orderdate, 'DD-MM-YYYY HH24:MI:SS') as orderdate_ts
     , odr.totalprice
     , odr.vatvalue
     , odr.vatrate
     , odr.vatcustomernumber
     , odr.description as odr_description
     , odr.note as odr_note
     , odr.status as rest_status
     , odr.shipping_minimum_date
     , odr.shipping_maximum_date
     , nvl( odr.rest_source, 'Manual entry') as order_source
     , odr.oss_id
     , ( select lookupvalue from wky_orderstatuses_lkp
         where active = 'Y' and id = odr.oss_id
       ) as oss_order_status
     , odr.dfm_id
     , ( select lookupvalue from wky_deliveryforms_lkp
         where active = 'Y' and id = odr.dfm_id
       ) as delivery_form
     , odr.cry_id
     , ( select currencyname from wky_currencies
         where id = odr.cry_id
       ) as currency
     , odr.scl_id
     , ( select saleschannelname from wky_saleschannels
         where id = odr.scl_id
       ) as sales_channel
     , odr.shipping_amount
     , odr.shipping_tax_amount
       -- Customer
     , ctr.firstname
     , ctr.lastname
     , ctr.prefix
     , ctr.middlename
     , ctr.company
     , ctr.companytaxcode
     , ctr.phonenumber
     , ctr.emailaddress
     , ctr.iban
     , ctr.deliveryaddressstreetname
     , ctr.deliveryaddresshousenumber
     , ctr.deliveryaddresszipcode
     , ctr.deliveryaddresscity
     , ctr.deliveryregion
     , ctr.delcty_id
     , ( select countryname from wky_countries
         where id = ctr.delcty_id and nvl( language, 'US') = 'US'
       ) as deliverycountry
     , ( select current_eec_flag from wky_countries_v
         where cty_id = ctr.delcty_id
       )as eec_flag
     , ctr.lge_id
     , ( select lookupvalue from wky_languages_lkp
         where id = ctr.lge_id and nvl( language, 'US') = 'US'
       ) as customer_language
       -- Technical ID columns and audit info
     , odr.id as odr_id
     , odr.row_version as odr_row_version
     , odr.created as odr_created
     , odr.created_by as odr_created_by
     , odr.updated as odr_updated
     , odr.updated_by as odr_updated_by
     , ctr.id as ctr_id
     , ctr.row_version as ctr_row_version
     , ctr.created as ctr_created
     , ctr.created_by as ctr_created_by
     , ctr.updated as ctr_updated
     , ctr.updated_by as ctr_updated_by
  from wky_orders odr
     , wky_customers ctr
 where odr.ctr_id = ctr.id;

--Indexes


---------------------------
--New INDEX
--WKY_EEC_COUNTRIES_I1
---------------------------
  CREATE INDEX "WKY_EEC_COUNTRIES_I1" ON "WKY_EEC_COUNTRIES" ("CTY_ID");
---------------------------
--New INDEX
--WKY_ORDERS_I7
---------------------------
  create index "WKY_ORDERS_I7" on "WKY_ORDERS" ("ORDERDATE");
