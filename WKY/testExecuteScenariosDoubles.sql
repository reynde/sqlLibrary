select * from wky_orders odr where trunc( odr.orderdate) = trunc( to_date( '30082018', 'DDMMYYYY'));

declare
  l_new_odr_id number := 154725684035818041548158489396756762106 ; --154734434283314402269378160830077105721; -- 154432903844390098126853313626467129560;
begin

  wky_utilities.double_order_check( p_new_odr_id => l_new_odr_id);

end;


-- 31-08-2018: 3
select count(*)
  from wky_orders_potential_double
  ;
  
declare 
  l_date      date   := to_date( '30082018', 'DDMMYYYY');
  l_cnt       number := 0;
  
begin

  for r_dbl in (
                 select odr.id
                   from wky_orders odr
                  where trunc( odr.orderdate) = trunc( l_date)
               )
  loop
    l_cnt := l_cnt + 1;
    -- wky_utilities.double_order_check( p_new_odr_id => l_new_odr_id);
    
  end loop;

  dbms_output.put_line(l_cnt);
  
end;
