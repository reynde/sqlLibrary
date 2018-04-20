select *
  from wky_bill_of_materials
  ;
  
select artikelnr, unterartikelnr, menge
  from int_lexware_fk_stueckliste
 where 1=1
  ;
  
insert into wky_bill_of_materials( ate_id, part_id, quantity)
select artikelnr, unterartikelnr, menge
  from int_lexware_fk_stueckliste
  ;
  
declare





begin

  




end;