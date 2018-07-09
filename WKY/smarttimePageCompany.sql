select *
  from wky_company_working_time_v
  ;
  
select to_number( :hours_worked) as hours_worked
     , floor( to_number( :hours_worked) / 24) as days_worked
     , to_char( sysdate, 'YYYY')
  from dual
  ;
  
  
select * from wky_company_working_time_v  ;
  
select v.*
     , trunc( v.minutes_worked / 600) || ' d ' ||
       trunc( mod( v.minutes_worked, 600) / 60) || ' h ' ||
       mod( v.minutes_worked, 60) || ' mi' as time_worked
     , trunc( v.minutes_worked / 600) as days_time_worked
     , trunc( mod( v.minutes_worked, 600) / 60) as hours_time_worked
     , mod( v.minutes_worked, 60) as minutes_time_worked
  from (
        select wt.company_id, wt.company_name, sum( minutes_worked) as minutes_worked, sum( hours_worked) as hours_worked, sum( working_cost) as working_cost
          from wky_company_working_time_v wt
         where sysdate between nvl( wt.cost_start_date, sysdate -1) and nvl( wt.cost_end_date, sysdate +1)
           and to_char( wt.start_clock_time_dt, 'YYYY') = '2018'
         group by wt.company_id, wt.company_name
        order by wt.company_name
      ) v
 ;
 
 
 
 
select trunc(minutes/600)||' working days, '||trunc(mod(minutes,600)/60)||' working hours and '||mod(minutes,60)||' minutes'
from (select 1000 as minutes from dual)
;