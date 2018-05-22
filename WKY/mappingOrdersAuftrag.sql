select pk, auftragsnr, bestellnr
  from int_mysql_lkwplanung_auftrag
  order by 3
  ;
  
  
select sheetnr, auftragsnr, bestellnr, szuserdefined5 -- A20180406-273494374
  from int_lexware_fk_auftrag
where szuserdefined5 = '443754316'
  order by 3
  ;


select sheetnr, auftragsnr, bestellnr, szuserdefined5 -- 507187 records
  from int_lexware_fk_auftrag
 where bestellnr not in (select  auftragsnr
                        from int_mysql_lkwplanung_auftrag)
                        ;

select *
  from wky_orders
 where ordernumber = '443754316';
 
select * -- 273494374
  from int_afterbuy_orders
 where orderid = '443754316'
 ;
  ;

/*

Auftragsnr = invoice number (wky_account)

Bestellnr = ordernumber (wky_orders) (for not afterbuy) (via int-afterbuy-orders table)
Bestellnr = szuserdefined5 (wky_orders) (for afterbuy)



*/




select *
  from wky_return_reasons_lkp;