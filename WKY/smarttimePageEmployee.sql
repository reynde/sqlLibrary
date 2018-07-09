select v.*
     , trunc( v.minutes_worked / 600) || ' d ' ||
       trunc( mod( v.minutes_worked, 600) / 60) || ' h ' ||
       mod( v.minutes_worked, 60) || ' mi' as time_worked
     , trunc( v.minutes_worked / 600) as days_time_worked
     , trunc( mod( v.minutes_worked, 600) / 60) as hours_time_worked
     , mod( v.minutes_worked, 60) as minutes_time_worked
  from (
        select wt.employee_id, wt.employee_name, wt.first_name, wt.last_name, wt.department_id, wt.department_name, sum( minutes_worked) as minutes_worked, sum( hours_worked) as hours_worked, sum( working_cost) as working_cost
          from wky_company_working_time_v wt
         where sysdate between nvl( wt.cost_start_date, sysdate -1) and nvl( wt.cost_end_date, sysdate +1)
           and to_char( wt.start_clock_time_dt, 'YYYY') = :p32_year
         group by wt.employee_id, wt.employee_name, wt.first_name, wt.last_name, wt.department_id, wt.department_name
        order by wt.department_name, wt.employee_name
      ) v
 where ( v.department_id = nvl( :p32_employee_department_id, v.department_id) or
        v.employee_id = nvl( :P32_EMPLOYEE_ID, v.employee_id)
       )
  ;
 
  
select *
  from wky_company_working_time_v wt
  ;
  
select *
  from wky_smarttime_csvs
  ;