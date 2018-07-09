select * -- 86 -- 316
  from wky_smarttime_csvs
 where smarttime_employee_id in ( 1, 7, 12)
  ;
  
select *
  from wky_smarttime_csvs
 where smarttime_employee_id not in (select smarttime_employee_id from wky_employees)
  ;
  
select *
  from wky_employees
  ;
  
update wky_smarttime_csvs c
   set c.ect_id = (
                    select ec.id
                      from wky_employees e
                         , wky_employee_costs ec
                     where e.id = ec.employee_id
                       and e.smarttime_employee_id = c.smarttime_employee_id
                  )
 where c.smarttime_employee_id = 1
                ;
                
                
                
                
                
                
                    select count(*)
                      from wky_employees e
                         , wky_employee_costs ec
                     where e.id = ec.employee_id
                       --and e.smarttime_employee_id = c.smarttime_employee_id
                       and e.smarttime_employee_id = 1;
                       
                    
declare
  l_cnt number := 0;
  l_cnt_emp number := 0;
  
begin
  
  for r in (
            select distinct csvs.smarttime_employee_id
              from wky_smarttime_csvs csvs
             where csvs.ect_id is null
               --and csvs.smarttime_employee_id in ( 1, 7, 12)
             order by csvs.smarttime_employee_id
           )
  loop
    
    update wky_smarttime_csvs c
       set c.ect_id = (
                        select ec.id
                          from wky_employees e
                             , wky_employee_costs ec
                         where e.id = ec.employee_id
                           and e.smarttime_employee_id = c.smarttime_employee_id
                      )
     where c.smarttime_employee_id = r.smarttime_employee_id
     ;
  
    l_cnt_emp := sql%rowcount;
    l_cnt := l_cnt + l_cnt_emp;
    
    dbms_output.put_line( l_cnt_emp || ' rows updated for ' || r.smarttime_employee_id);    
    
  end loop;

  commit;
  dbms_output.put_line( ' ');  
  dbms_output.put_line( l_cnt || ' rows updated in total');

end;