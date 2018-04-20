select *
  from int_lexware_fk_artikel
  ;
  
select *
  from int_lexware_fk_stueckliste
  ;
  
select *
  from int_lexware_fk_auftrag
  ;
  
select *
  from int_lexware_fk_warengruppe
  ;
  
select *
  from wky_articles
  ;
  
select *
  from wky_bill_of_materials
  ;
  
  select * from wky_orderstatuses_lkp
  ;
  
select *
  from wky_orders
  ;
  
select *
  from wky_group_of_goods
  ;
    
select count(*), lxw_action
  from wky_articles
 group by lxw_action
  ;
  
select count(*), lxw_action
  from wky_bill_of_materials
 group by lxw_action
  ;
  
select count(*), lxw_action
  from wky_orders
 group by lxw_action
  ;
  
select *
  from wky_orders
 where lxw_sheetnr is not null;
  
select count(*), lxw_action
  from wky_group_of_goods
 group by lxw_action
  ;