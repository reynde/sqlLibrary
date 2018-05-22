-- Script send to Dimi for OpenQuestions mappings
-- 22-05-2018 11:00

-- Mapping 1: Bestellnr to WKY_ORDERS
select sysdate from dual;

begin
    --
    -- WKY_ORDERS: ordernumber = bestellnr in case it comes from NOT Aftrebuy interface
    --             szuserdefined5 = bestellnr in case it comes from Afterbuy interface
    --  Source can be found in WKY_ORDERS.restsource (= or != 'Afterbuy')
    --
    update wky_orders
    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR, lxw_auftragsnr) = 
          (SELECT
               case when auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else oss_id end as oss_id,
              'UPDATE' as LXW_ACTION,
              sysdate  as LXW_DATE,
              sheetnr  as lxw_sheetnr,
              auftragsnr as lxw_auftragsnr
          from int_lexware_fk_auftrag
          where ordernumber = szuserdefined5 and system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
    where ordernumber in (select szuserdefined5 from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') );
  commit;
end;

-- Mapping 2: WKY_ACCOUNTS, previously known as "MinusAccounts"
select sysdate from dual;

begin
  --
  -- WKY_ACCOUNTS filled from lkw_planung_auftrag
  --  All orders from int_mysql_lkwplanung_auftrag, that also exist in WKY_ORDERS (WKY_ORDERS.lxw_auftragsnr) ook INSERT or UPDATE
  --  in WKY_ACCOUNTS: auftragsnr = WKY_ACCOUNTS.invoice_number
  --                   odr_id = WKY_ORDERS.id
  --                   cpt_id = WKY_COMPLAINTS.id
  --                   scl_id = WKY_SALESCHANNELS.id (also on WKY_ORDERS)
  --                   CRY_id = WKY_CURRENCIES.id (also on WKY_ORDERS)
  commit;
  
end;