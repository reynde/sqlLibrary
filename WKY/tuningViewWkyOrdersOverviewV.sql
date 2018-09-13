create or replace force editionable view WKY_ORDER_OVERVIEW_V
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
  , case
        when row_number() over(
          partition by odr.id
          order by
            odr.id desc
        ) = 1 then
          odr.totalprice
        else
          0
      end
    as total_order_price
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
  , oss.lookupvalue as oss_order_status
  , oss.lookupcode as oss_order_status_code
  , odr.los_id
  , los.lookupvalue as los_order_status
  , los.lookupcode as los_order_status_code
  , odr.dfm_id
  , dfm.lookupvalue as delivery_form
  , odr.cry_id
  , cry.currencyname as currency
  , odr.scl_id
  , scl.saleschannelname as sales_channel
  , odr.shipping_amount
  , odr.shipping_tax_amount
       -- Orderscontainarticle
  , oce.quantity as ate_quantity
  , oce.unitprice as ate_unitprice
  , oce.tax_percent as ate_tax_percent
  , oce.tax_amount as ate_tax_amount
       -- Article
  , ate.articlenumber
  , ate.articlename
  , ate.description as ate_description
  , ate.shipping_minimum_date as ate_shipping_minimum_date
  , ate.shipping_maximum_date as ate_shipping_maximum_date
  , ate.canbeordered
  , ate.eos
  , ate.weight
  , ate.volume
  , ate.length
  , ate.width
  , ate.height
  , ate.iscomposed
  , ate.composedarticlenumber
  , ate.standardnumberofpackages
  , ate.ispart
  , ate.partnumber
  , ate.ispartwoodpiece
  , ate.woodpiecenumber
  , ate.woodtype
  , ate.status as ate_status
  , ate.dfm_id as ate_dfm_id
  , atedfm.lookupvalue as ate_delivery_form
  , ate.cte_id
  , cte.lookupvalue as ate_carrier_type
  , ate.atp_id
  , atp.articletypename as ate_article_type
  , ate.sre_id
  , sre.serialname as ate_serial_name
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
  , ctr.lge_id
  , lge.lookupvalue as customer_language
       -- Technical ID columns and audit info
  , odr.id as odr_id
  , odr.row_version as odr_row_version
  , odr.created as odr_created
  , odr.created_by as odr_created_by
  , odr.updated as odr_updated
  , odr.updated_by as odr_updated_by
  , oce.id as oce_id
  , oce.row_version as oce_row_version
  , oce.created as oce_created
  , oce.created_by as oce_created_by
  , oce.updated as oce_updated
  , oce.updated_by as oce_updated_by
  , ate.id as ate_id
  , ate.row_version as ate_row_version
  , ate.created as ate_created
  , ate.created_by as ate_created_by
  , ate.updated as ate_updated
  , ate.updated_by as ate_updated_by
  , ctr.id as ctr_id
  , ctr.row_version as ctr_row_version
  , ctr.created as ctr_created
  , ctr.created_by as ctr_created_by
  , ctr.updated as ctr_updated
  , ctr.updated_by as ctr_updated_by
  from
    wky_orders odr
  , wky_orderscontainarticle oce
  , wky_articles ate
  , wky_customers ctr
  , wky_orderstatuses_lkp oss
  , wky_logistic_odr_statuses_lkp los
  , wky_deliveryforms_lkp dfm
  , wky_currencies cry
  , wky_saleschannels scl
  , wky_deliveryforms_lkp atedfm
  , wky_carriertypes_lkp cte
  , wky_articletypes atp
  , wky_series sre
  , wky_countries delcty
  , wky_languages_lkp lge
  where
    odr.id = oce.odr_id
    and   ate.id = oce.ate_id
    and   ctr.id = odr.ctr_id
    and odr.oss_id = oss.id (+)
    and odr.los_id = los.id (+)
    and odr.dfm_id = dfm.id (+)
    and odr.cry_id = cry.id (+)
    and odr.scl_id = scl.id (+)
    and ate.dfm_id = atedfm.id (+)
    and ate.cte_id = cte.id (+)
    and ate.atp_id = atp.id (+)
    and ate.sre_id = sre.id (+)
    and ctr.delcty_id = delcty.id (+)
    and ctr.lge_id = lge.id (+)
--
   and odr.ordernumber = 'FR0000227808'
;

select *
  from all_objects
 where object_name like 'WKY%'
   and status <> 'VALID'
   ;