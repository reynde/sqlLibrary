select sysdate from dual;


select odr.order_source
     , odr.odr_id
     , odr.ordernumber
     , odr.orderdate
     , odr.orderdate_ts
     , odr.totalprice
     , odr.vatcustomernumber
     , odr.vatrate
     , odr.vatvalue
     , odr.odr_description
     , odr.odr_note
     , odr.shipping_minimum_date
     , odr.shipping_maximum_date
     , odr.oss_id
     , odr.oss_order_status
     , odr.los_id
     , odr.los_order_status
     , odr.dfm_id
     , odr.delivery_form
     , odr.cry_id
     , odr.currency
     , odr.scl_id
     , odr.sales_channel
     , odr.company
     , odr.companytaxcode
     , odr.lastname
     , odr.deliveryaddresscity
     , odr.deliveryaddresszipcode
     , odr.prefix
     , odr.firstname
     , odr.middlename
     , odr.ctr_id
     , odr.eec_flag
  from wky_orders_v odr
 where
   exists( select 1
        from wky_island_postalcodes p, wky_countries c
       where p.cty_id = c.id
         and c.id = nvl( odr.delcty_id, c.id)
         and ((p.start_postalcode like substr( odr.deliveryaddresszipcode, 1, length( p.start_postalcode)) || '%' and c.iso_code = 'GB')
              or (p.start_postalcode = odr.deliveryaddresszipcode and nvl(c.iso_code,'XX') <> 'GB') )
         and rownum < 2)
 
 --wky_utilities.is_island( p_cty_id => odr.delcty_id, p_zipcode => odr.deliveryaddresszipcode) = 'Y'
   --;