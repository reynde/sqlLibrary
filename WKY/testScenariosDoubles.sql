-- Overview potential doubles on DEV environment:
select dbl.id, dbl.verified_flag, new.ordernumber as new_ordernumber, exg.ordernumber as exg_ordernumber 
     , new.odr_id as new_odr_id, new.lastname as new_lastname, new.firstname as new_firstname
     , new.orderdate as new_orderdate, new.orderdate_ts as new_orderdate_ts, new.totalprice as new_totalprice, new.odr_description as new_odr_description
       -- 
     , exg.odr_id as exg_odr_id, exg.lastname as exg_lastname, exg.firstname as exg_firstname
     , exg.orderdate as exg_orderdate, exg.orderdate_ts as exg_orderdate_ts, exg.totalprice as exg_totalprice, exg.odr_description as exg_odr_description
  from wky_orders_potential_double dbl
     , wky_orders_v new
     , wky_orders_v exg
 where dbl.new_odr_id = new.odr_id
   and dbl.existing_odr_id = exg.odr_id
   --and dbl.verified_flag = 'N'
   ;
   
update wky_orders_potential_double set verified_flag = 'N' where id = 154726882388509036484161086886125402096;
update wky_orders_potential_double set verified_flag = 'N' where id = 154734623193949129113523616899939322961;
update wky_orders_potential_double set verified_flag = 'N' where id = 154734623193950338039343231529114029137;

-- Existing record
select odr_id, ordernumber, oss_order_status
  from wky_orders_v
 where ordernumber in ( '55512300', '55512301')
 ;
 
update wky_orders set oss_id = (select id from wky_orderstatuses_lkp where lookupcode = 'RECEIVED' ) where id = 154435518874826269482474038543776368797;
update wky_orders set oss_id = (select id from wky_orderstatuses_lkp where lookupcode = 'RECEIVED' ) where id = 154432903844390098126853313626467129560;
 
-- New record
select odr_id, ordernumber, oss_order_status
  from wky_orders_v
 where ordernumber in ( '55512301', '55512302')
 ;