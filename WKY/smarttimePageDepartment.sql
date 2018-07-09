select v.department_id, :P32_DEPARTMENT_ID
     , trunc( v.minutes_worked / 600) || ' d ' ||
       trunc( mod( v.minutes_worked, 600) / 60) || ' h ' ||
       mod( v.minutes_worked, 60) || ' mi' as time_worked
     , trunc( v.minutes_worked / 600) as days_time_worked
     , trunc( mod( v.minutes_worked, 600) / 60) as hours_time_worked
     , mod( v.minutes_worked, 60) as minutes_time_worked
  from (
        select wt.department_id, wt.department_name, sum( minutes_worked) as minutes_worked, sum( hours_worked) as hours_worked, sum( working_cost) as working_cost
          from wky_company_working_time_v wt
         where sysdate between nvl( wt.cost_start_date, sysdate -1) and nvl( wt.cost_end_date, sysdate +1)
           and to_char( wt.start_clock_time_dt, 'YYYY') = '2018'
         group by wt.department_id, wt.department_name
        order by wt.department_name
       ) v
 where 1=1
--   and v.department_id like '%' || :p32_department_id || '%'
   and v.department_id in (135070372995789685417664965082274768487, 135070372995197311766053796786668742247, 135070372995055867445158885173228119655)
 ;
 
 
 /*
 135070372995789685417664965082274768487:135070372995197311766053796786668742247:135070372995055867445158885173228119655
 */