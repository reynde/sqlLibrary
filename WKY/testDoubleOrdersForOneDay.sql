declare 
  l_date       date   := to_date( '31082018', 'DDMMYYYY');
  l_cnt_odrs   number := 0;
  l_cnt_before number := 0;
  l_cnt_after  number := 0;
  l_cnt_dbls   number := 0;
  
begin

  select count(*) into l_cnt_before from wky_orders_potential_double;

  for r_dbl in (
                 select odr.id
                   from wky_orders odr
                  where trunc( odr.orderdate) = trunc( l_date)
               )
  loop
    l_cnt_odrs := l_cnt_odrs + 1;
    wky_utilities.double_order_check( p_new_odr_id => r_dbl.id);
    
  end loop;
  
  select count(*) into l_cnt_after from wky_orders_potential_double;
  l_cnt_dbls := l_cnt_after - l_cnt_before;

  dbms_output.put_line('Orders checked: ' || l_cnt_odrs);
  dbms_output.put_line('Doubles found : ' || l_cnt_dbls);
  
end;


select * from wky_orders odr where trunc( odr.orderdate) = trunc( to_date( '30082018', 'DDMMYYYY'));
                  
  select count(*) from wky_orders_potential_double;
  
  
                 select odr.id
                   from wky_orders odr
                  where trunc( odr.orderdate) = trunc( to_date( '31082018', 'DDMMYYYY'))
                  ;
                  
    select *
      from wky_orders
     where id in (155130624070207408310833478777638120456, 155130624070214661865751166552686357512, 155144401951822801936317284420082649367);