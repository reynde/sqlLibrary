select *
  from wky_accounts
  ;
  
/*
Alle orders 
*/

select *
  from int_lexware_fk_auftrag
 where auftragsnr like 'R%'
  ;

select *
  from int_mysql_lkwplanung_auftrag
 where auftragsnr like 'R%'
  ;