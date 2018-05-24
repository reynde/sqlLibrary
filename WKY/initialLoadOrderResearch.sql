         select
                case when l.auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else o.oss_id end as oss_id,
              'UPDATE' as LXW_ACTION,
              sysdate  as LXW_DATE,
              l.sheetnr  as lxw_sheetnr,
              l.auftragsnr as lxw_auftragsnr,
              l.bestellnr as lxw_bestellnr
          from int_lexware_fk_auftrag l, wky_orders o
          where (o.ordernumber = l.szuserdefined5 and l.system_created >= to_date( '01012016', 'DDMMYYYY') ) -- and rownum<2 )
             or (o.ordernumber = l.bestellnr and l.system_created >= to_date( '01012016', 'DDMMYYYY') ) -- and rownum<2 )
          ;
          
          
          /*
          
          
  update wky_orders o
    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR, lxw_auftragsnr, lxw_bestellnr) = 
          (SELECT
               case when l.auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else o.oss_id end as oss_id,
              'UPDATE' as LXW_ACTION,
              sysdate  as LXW_DATE,
              l.sheetnr  as lxw_sheetnr,
              l.auftragsnr as lxw_auftragsnr,
              l.bestellnr as lxw_bestellnr
          from int_lexware_fk_auftrag l
          where (o.ordernumber = l.szuserdefined5 and l.system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
             or (o.ordernumber = l.bestellnr and l.system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
          )
    where o.ordernumber in (select szuserdefined5 from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') )
       or o.ordernumber in (select bestellnr from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') );

          
          */

select count(*), lxw_action from wky_orders group by lxw_action;  

select datum_erfassung, system_created from int_lexware_fk_auftrag where datum_erfassung is null;
          
declare
  l_cnt number := 0;
  
begin
  for r in (
                select case when l.auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else null end as oss_id
                     , 'UPDATE' as lxw_action
                     , sysdate  as lxw_date
                     , l.sheetnr  as lxw_sheetnr
                     , l.auftragsnr as lxw_auftragsnr
                     , l.bestellnr as lxw_bestellnr
                     , l.szuserdefined5 as lxw_szuserdefined5
                  from int_lexware_fk_auftrag l
                 where l.datum_erfassung >= to_date( '01012016', 'DDMMYYYY')
                   --and l.sheetnr = 2178642
           )
  loop
    l_cnt := l_cnt + 1;
    update wky_orders o
       set o.oss_id = nvl( r.oss_id, oss_id)
         , o.lxw_action = r.lxw_action
         , o.lxw_date = r.lxw_date
         , o.lxw_sheetnr = r.lxw_sheetnr
         , o.lxw_auftragsnr = r.lxw_auftragsnr
         , o.lxw_bestellnr = r.lxw_bestellnr
     where ( o.ordernumber = r.lxw_bestellnr or
             o.ordernumber = r.lxw_szuserdefined5
           );
     
    if l_cnt >= 500
    then
      l_cnt := 0;
      --commit;
    end if;
  end loop;
  
  -- commit;
  
end;
  
  
  
  
  
  
  
  
-- OLD CODE

begin
    --
    -- WKY_ORDERS: ordernumber = bestellnr in case it comes from NOT Aftrebuy interface
    --             szuserdefined5 = bestellnr in case it comes from Afterbuy interface
    --  Source can be found in WKY_ORDERS.restsource (= or != 'Afterbuy')
    --
--    update wky_orders
--    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR, lxw_auftragsnr) = 
--          (SELECT
--               case when auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else oss_id end as oss_id,
--              'UPDATE' as LXW_ACTION,
--              sysdate  as LXW_DATE,
--              sheetnr  as lxw_sheetnr,
--              auftragsnr as lxw_auftragsnr
--          from int_lexware_fk_auftrag
--          where ordernumber = szuserdefined5 and system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
--    where ordernumber in (select szuserdefined5 from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') );
  update wky_orders o
    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR, lxw_auftragsnr, lxw_bestellnr) = 
          (SELECT
               case when l.auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else o.oss_id end as oss_id,
              'UPDATE' as LXW_ACTION,
              sysdate  as LXW_DATE,
              l.sheetnr  as lxw_sheetnr,
              l.auftragsnr as lxw_auftragsnr,
              l.bestellnr as lxw_bestellnr
          from int_lexware_fk_auftrag l
          where (o.ordernumber = l.szuserdefined5 and l.system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
             or (o.ordernumber = l.bestellnr and l.system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
          )
    where o.ordernumber in (select szuserdefined5 from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') )
       or o.ordernumber in (select bestellnr from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') );

  commit;
end;
