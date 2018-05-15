select count(*), lxw_action from wky_articles group by lxw_action;
select count(*), lxw_action from wky_bill_of_materials group by lxw_action;
select count(*), lxw_action from wky_orders group by lxw_action;
select count(*), lxw_action from wky_group_of_goods group by lxw_action;
select count(*), lxw_action from wky_customers group by lxw_action;
select count(*), lxw_action from wky_depots group by lxw_action;
select count(*), lxw_action from wky_depot_postalcodes group by lxw_action;
select count(*), lxw_action from wky_saleschannel_delivery_time group by lxw_action;
select count(*), lxw_action from wky_production_location group by lxw_action;
select count(*), lxw_action from wky_packages group by lxw_action;
select count(*), lxw_action from wky_complaints group by lxw_action;
select count(*), lxw_action from wky_complaintconcerningarticle group by lxw_action;
select count(*), lxw_action from wky_carriers group by lxw_action;
select count(*), lxw_action from wky_cargoplace group by lxw_action;
select count(*), lxw_action from wky_mail_htmlemails group by lxw_action;



select *
  from int_lexware_fk_auftrag
  ;
  
select o.ordernumber, c.ct_type
  from wky_complaints c
     , wky_orders o
 where ct_type is null
   and c.odr_id = o.id
 ;
 
select count(*) -- odr_id
  from wky_complaints
 where ct_type is null and odr_id is null
 ;
 
 
 
udpate wky_orders
   set lxw_auftragsnr = ()
 where 
 ;
 
select ordernumber, lxw_auftragsnr, lxw_sheetnr
  from wky_orders
  where lxw_auftragsnr is not null and lxw_auftragsnr not like 'A%'
  ;
 
select pk, auftragsnr, bestellnr, appdata
  from int_mysql_lkwplanung_auftrag
  ;
  
select sheetnr, auftragsnr, bestellnr, szuserdefined5
     , l.*
  from int_lexware_fk_auftrag l
 where szuserdefined5 is not null
   and l.auftragsnr like 'N%'
   and l.szuserdefined5 = '440558811'
  ;
 
select * -- ordernumber, lxw_auftragsnr, lxw_sheetnr
  from wky_orders
 where ordernumber = '440558811'
 --lxw_sheetnr = 2178637
 ;
 
 
 select max(datum_zahlung), min(datum_zahlung) from int_lexware_fk_auftrag;
 select max(AUFTRAGSDATUM), min(AUFTRAGSDATUM) from int_mysql_lkwplanung_auftrag;
 
 
 
select count(*)
  from int_lexware_fk_auftrag
 where datum_zahlung between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
 and auftragsnr not in
     ( select auftragsnr 
       from int_mysql_lkwplanung_auftrag
       where AUFTRAGSDATUM between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
       )
; 

select count(*)
  from int_mysql_lkwplanung_auftrag
  where AUFTRAGSDATUM between to_date('03112017','ddmmyyyy') and to_date('05052018','ddmmyyyy')
  and auftragsnr not in 
         (select auftragsnr from  int_lexware_fk_auftrag
           where datum_zahlung between to_date('03112017','ddmmyyyy') and to_date('05052018','ddmmyyyy'));
 

select * from int_mysql_reklamation_hauptartikel where id = 43128;
select * from int_mysql_reklamation_artikel where id = 24750; 
select * from wky_complaintconcerningarticle;

select id, artikelnr
     , (select reklamation_id from int_mysql_reklamation_hauptartikel where id = reklamation_hauptartikel_id ) as reklamation_id
  from int_mysql_reklamation_artikel 
 where id = 24750
 ;

select count(*) from int_mysql_reklamation_artikel;

  select 
      (select i.id from wky_articles i where i.articlenumber = a.artikelnr) as ate_id,
      null as oce_id,
      (select i.id from wky_complaints i where i.lxw_id = (select reklamation_id from int_mysql_reklamation_hauptartikel where id = a.reklamation_hauptartikel_id )) as cpt_id,
      null as status,
      id,
      'INSERT',
      sysdate,
      menge,
      reklamationsgrund
  FROM int_mysql_reklamation_artikel a
  where (select reklamation_id from int_mysql_reklamation_hauptartikel where id = a.reklamation_hauptartikel_id ) in (select i.lxw_id  from wky_complaints i)
    and not exists (select lxw_id from wky_complaintconcerningarticle where lxw_id = a.id)
  ;
  
  
  
  
  
  
  
-- Don't exist in Lex, Exist in Lkw
select lkw.auftragsnr, lkw.auftragsdatum, lkw.pk, lkw.kundennr, lkw.bestellnr
     , lkw.*
  from int_mysql_lkwplanung_auftrag lkw
 where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('05052018','ddmmyyyy')
   and lkw.auftragsnr not in  
         ( select lex.auftragsnr 
             from int_lexware_fk_auftrag lex
            where lex.datum_zahlung between to_date('03112017','ddmmyyyy') and to_date('05052018','ddmmyyyy')
         );
           
           
-- Don't exist in Lkw, Exist in Lex
select lex.sheetnr, lex.auftragsnr, lex.kundennr
     , lex.*
  from int_lexware_fk_auftrag lex
 where lex.datum_zahlung between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
   and lex.auftragsnr not in
         ( select lkw.auftragsnr 
             from int_mysql_lkwplanung_auftrag lkw
            where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
         ) 
; 

     
           
           

select *
  from wky_deliveryforms_lkp;           
           