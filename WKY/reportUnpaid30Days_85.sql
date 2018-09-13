select odr.id as odr_id, odr.ordernumber, odr.orderdate
     , oss.lookupvalue, oss.lookupcode
  from wky_orders odr
     , wky_orderstatuses_lkp oss
 where odr.oss_id = oss.id
   and oss.lookupcode not in ( 'PAYED', 'PROD', 'PICKED', 'PACKED', 'SCANNED', 'SHIPPED', 'DELIV')
   and odr.orderdate < sysdate-30
 ;
 
 
select odr.ordernumber
     , odr.orderdate
     , odr.totalprice
     , odr.oss_order_status
     , odr.los_order_status
     , odr.sales_channel
     , odr.firstname
     , odr.lastname
     , odr.phonenumber
     , odr.emailaddress
     , odr.deliveryaddresscity
     , odr.deliverycountry
     , odr.ctr_id
     , odr.odr_id
  from wky_orders_v odr
 where odr.orderdate < sysdate - 30
   and odr.oss_order_status_code not in ( 'PAYED', 'PROD', 'PICKED', 'PACKED', 'SCANNED', 'SHIPPED', 'DELIV')
 ;
 
select *
  from wky_orderstatuses_lkp
  ;
  
select *
 from rve_test;
 
 
 delete rve_test;
 
 commit;