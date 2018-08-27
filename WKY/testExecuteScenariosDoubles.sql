select * from wky_orders where ordernumber like '555123%';

declare
  l_new_odr_id number := 154734434283314402269378160830077105721; -- 154432903844390098126853313626467129560;
begin

  wky_utilities.double_order_check( p_new_odr_id => l_new_odr_id);

end;



select *
  from wky_orders_potential_double
  ;
  
