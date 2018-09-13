select sysdate from dual;

create or replace force editionable view WKY_ORDERS_V
as
  select
     -- Order
    odr.ordernumber
  , odr.orderdate
  , to_char(
      odr.orderdate
    , 'DD-MM-YYYY HH24:MI:SS'
    ) as orderdate_ts
  , odr.totalprice
  , odr.vatvalue
  , odr.vatrate
  , odr.vatcustomernumber
  , odr.description as odr_description
  , odr.note as odr_note
  , odr.status as rest_status
  , odr.shipping_minimum_date
  , odr.shipping_maximum_date
  , nvl(
      odr.rest_source
    , 'Manual entry'
    ) as order_source
  , odr.oss_id
  , fos.lookupvalue as oss_order_status
  , fos.lookupcode as oss_order_status_code
  , odr.los_id
  , los.lookupvalue as los_order_status
  , los.lookupcode as los_order_status_code
  , odr.dfm_id
  , dfm.lookupvalue as delivery_form
  , dfm.lookupcode as delivery_form_code
  , odr.cry_id
  , cry.currencyname as currency
  , odr.scl_id
  , scl.saleschannelname as sales_channel
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
  , delcty.countryname as deliverycountry
  , delcty.current_eec_flag as eec_flag
  , ctr.lge_id
  , lge.lookupvalue as customer_language
  , lge.lookupcode as customer_language_code
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
  from
    wky_orders odr
  , wky_customers ctr
  , wky_orderstatuses_lkp fos
  , wky_logistic_odr_statuses_lkp los
  , wky_deliveryforms_lkp dfm
  , wky_currencies cry
  , wky_saleschannels scl
  , wky_countries_v delcty
  , wky_languages_lkp lge
  where odr.ctr_id = ctr.id
    and odr.oss_id = fos.id (+)
    and odr.los_id = los.id (+)
    and odr.dfm_id = dfm.id (+)
    and odr.cry_id = cry.id (+)
    and odr.scl_id = scl.id (+)
    and ctr.delcty_id = delcty.cty_id (+)
    and ctr.lge_id = lge.id (+)
    ;
    
    
select * from all_objects where object_name like 'WKY%' and status <> 'VALID';