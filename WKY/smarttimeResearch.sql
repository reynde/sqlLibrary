select *
  from wky_emp_work_costs_v
 where smarttime_employee_id = 38
   and dpt_id = :P91_DEPT
   --and to_date( real_start_time, 'DD-MM-YYYY HH24:MI') between to_date( '01022018 00:00', 'DDMMYYYY HH24:MI') and to_date( '01022018 23:59', 'DDMMYYYY HH24:MI') /* DAY */
   --and start_time between trunc( sysdate, 'yyyy') and add_months( trunc( sysdate, 'yyyy'), 12) -1 /* YEAR */
  ;
  
  
  
  
  
  select trunc( sysdate, 'yyyy')
       , add_months( trunc( sysdate, 'yyyy'), 12) -1
       , to_char( sysdate, 'q') quarter_number
       , trunc( sysdate, 'q') as start_quarter
       , add_months( trunc( sysdate, 'q'), 3)-1 as end_quarter
    from dual
    ;
    
select to_char(sysdate, 'yyyy') -1
  from dual;
  
  select * from wky_emp_work_costs_v;
  
 select sum( working_cost), sum( hours_worked), dpt_id 
  from wky_emp_work_costs_v
 where 1=1
   and dpt_id = nvl( :p91_dept, dpt_id)
   and to_char( start_time, 'YYYY') = nvl( :p91_year, to_char( sysdate, 'YYYY'))
   and to_char( start_time, 'q') = nvl( :p91_quarter, to_char( sysdate, 'q'))
 group by dpt_id
   ;