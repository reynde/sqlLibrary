select *
  from rve_orders
 where to_char( order_number) like '9999_'
  ;
  
select *
  from rve_order_lines
 where order_id in (    select id
                          from rve_orders
                         where to_char( order_number) like '9999_'
                   ) 
  ;