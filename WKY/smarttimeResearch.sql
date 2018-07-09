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
   
   
select *
  from wky_working_hours
  ;
  
select *
  from wky_smarttime_csvs
 where 1=1
   and smarttime_employee_id = 1144
   and rnd_date between to_date('28012018','ddmmyyyy') and to_date('04022018','ddmmyyyy')
 order by rnd_date, rnd_time
  ;
  

  
select to_char( stv.clock_time, 'DD/MM/YYYY HH24:MI') as clock_time
     , stv.*
  from wky_smarttime_csvs_v stv
 where smarttime_employee_id = 1144
   and trunc(clock_time) = to_date( '16/01/2018', 'DD/MM/YYYY')
 order by stv.clock_time
 ;
 
select *
  from wky_smarttime_workday_v wv
 where wv.smarttime_employee_id = 1144
   and wv.start_clock_time like '15-JAN%'
 order by wv.start_clock_time
 ;
 
 
 
 
-- view WKY_SMARTTIME_WORKDAY_V
  select smarttime_employee_id, employee, department_id, start_clock_time,
       lpad(sum_hours+trunc(sum_mins/60),2,'0') || ':' || lpad(mod(sum_mins,60),2,'0') as day_time_work
from (
select smarttime_employee_id, employee, department_id, end_of_day,
       to_char(start_clock_time,'DD-MON-YYYY HH24:MI') as start_clock_time,       
       to_char(end_clock_time,'DD-MON-YYYY HH24:MI') as end_clock_time,        
       case when hours is not null then lpad(hours,2,'0')||':'|| lpad(mins,2,'0') end as clock_time,
       clock_type,
       hours, mins,
       sum(case when clock_type = 'WORK' then hours end) over (partition by smarttime_employee_id order by start_clock_time) as sum_hours,
       sum(case when clock_type = 'WORK' then mins end) over (partition by smarttime_employee_id order by start_clock_time) as sum_mins
from (
select smarttime_employee_id, employee, department_id, clock_time as start_clock_time,
       lead(clock_time) over (partition by smarttime_employee_id order by clock_time) as end_clock_time,
       trunc(24*mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)) as hours,
       trunc( mod(mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)*24,1)*60) as mins,
       case
       when trunc(clock_time) <> lead(clock_time) over (partition by smarttime_employee_id, trunc(clock_time) order by clock_time) 
       then 'NO' else 'YES' end as end_of_day,
       case
       when mod(row_number() over (partition by smarttime_employee_id order by clock_time),2) = 0       
       then 'BREAK'
       else 'WORK'
       end as clock_type
  from wky_smarttime_csvs_v
  where smarttime_employee_id = 1144
--   and trunc(clock_time) in (to_date( '15/01/2018', 'DD/MM/YYYY'), to_date( '16/01/2018', 'DD/MM/YYYY'))
) 
)
where end_of_day='YES'
order by smarttime_employee_id, start_clock_time;


-- new view work vs break
select file_id, smarttime_employee_id, employee, department_id, 
       to_char(start_clock_time,'DD-MON-YYYY HH24:MI') as start_clock_time,       
       to_char(end_clock_time,'DD-MON-YYYY HH24:MI') as end_clock_time,        
       case when hours is not null then lpad(hours,2,'0')||':'|| lpad(mins,2,'0') end as clock_time,
       clock_type,
       hours, mins,
       sum(case when clock_type = 'WORK' then hours end) over (partition by smarttime_employee_id, trunc(start_clock_time) order by start_clock_time) as sum_hours,
       sum(case when clock_type = 'WORK' then mins end) over (partition by smarttime_employee_id, trunc(start_clock_time) order by start_clock_time) as sum_mins
from (
select file_id, smarttime_employee_id, employee, department_id, clock_time as start_clock_time , to_char( clock_time, 'DD-MM-YYYY HH24:MI') as start_clock_time_hh,
       lead(clock_time) over (partition by smarttime_employee_id order by clock_time) as end_clock_time, to_char(lead(clock_time) over (partition by smarttime_employee_id order by clock_time), 'DD-MM-YYYY HH24:MI') as end_clock_time_hh,
       trunc(24*mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)) as hours,
       trunc( mod(mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)*24,1)*60) as mins,
       case
       when mod(row_number() over (partition by smarttime_employee_id order by clock_time),2) = 0       
       then 'BREAK'
       else 'WORK'
       end as clock_type       
  from wky_smarttime_csvs_v
  where smarttime_employee_id = 1144
   and trunc(clock_time) between to_date( '28/01/2018', 'DD/MM/YYYY') and to_date( '04/02/2018', 'DD/MM/YYYY')
)   ;
--

  select * from wky_smarttime_csvs where smarttime_employee_id = 1144 and rnd_date between to_date( '28012018', 'DDMMYYYY') and to_date( '04022018', 'DDMMYYYY') order by rnd_date;
  insert into wky_smarttime_csvs (smarttime_employee_id, rnd_date, rnd_time, employee, department_id, department, hour, minute, status) values (1144, to_date( '02022018', 'DDMMYYYY'), 0, 'Dahnin, Ahmad', 32, 'Säge', 0, 0, 'RVE ADDED');
  select * from wky_smarttime_csvs where status = 'RVE ADDED';
  
-- New view DAY
select smarttime_employee_id, employee, department_id, workday, sum(hours) hh, sum(mins)
from (
select smarttime_employee_id, employee, department_id, trunc(clock_time) as workday, clock_time as start_clock_time , to_char( clock_time, 'DD-MM-YYYY HH24:MI') as start_clock_time_hh,
       lead(clock_time) over (partition by smarttime_employee_id order by clock_time) as end_clock_time, to_char(lead(clock_time) over (partition by smarttime_employee_id order by clock_time), 'DD-MM-YYYY HH24:MI') as end_clock_time_hh,
       trunc(24*mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)) as hours,
       trunc( mod(mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)*24,1)*60) as mins,
       case
       when mod(row_number() over (partition by smarttime_employee_id order by clock_time),2) = 0       
       then 'BREAK'
       else 'WORK'
       end as clock_type       
  from wky_smarttime_csvs_v  
) 
where clock_type='WORK'
--  and trunc(start_clock_time) in (to_date( '15/01/2018', 'DD/MM/YYYY'), to_date( '16/01/2018', 'DD/MM/YYYY'))
  and smarttime_employee_id = 1144  
group by smarttime_employee_id, employee, department_id, workday
order by workday;



   
   
select smarttime_employee_id, employee, department_id, trunc(start_clock_time), sum(hours) hh, sum(mins) min
from (
select smarttime_employee_id, employee, department_id, 
       to_char(start_clock_time,'DD-MON-YYYY HH24:MI') as start_clock_time,       
       to_char(end_clock_time,'DD-MON-YYYY HH24:MI') as end_clock_time,        
       case when hours is not null then lpad(hours,2,'0')||':'|| lpad(mins,2,'0') end as clock_time,
       clock_type,
       hours, mins,
       sum(case when clock_type = 'WORK' then hours end) over (partition by smarttime_employee_id order by start_clock_time) as sum_hours,
       sum(case when clock_type = 'WORK' then mins end) over (partition by smarttime_employee_id order by start_clock_time) as sum_mins
from (
select smarttime_employee_id, employee, department_id, clock_time as start_clock_time,
       lead(clock_time) over (partition by smarttime_employee_id order by clock_time) as end_clock_time,
       trunc(24*mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)) as hours,
       trunc( mod(mod(lead(clock_time) over (partition by smarttime_employee_id order by clock_time) - clock_time,1)*24,1)*60) as mins,
       case
       when mod(row_number() over (partition by smarttime_employee_id,  order by clock_time),2) = 0
            and lead(clock_time) over (partition by smarttime_employee_id order by clock_time) is null
       then 'END_OF_DAY'
       when mod(row_number() over (partition by smarttime_employee_id order by clock_time),2) = 0       
       then 'BREAK'
       else 'WORK'
       end as clock_type
  from wky_smarttime_csvs_v
  where smarttime_employee_id = 1144
   and trunc(clock_time) in (to_date( '15/01/2018', 'DD/MM/YYYY'), to_date( '16/01/2018', 'DD/MM/YYYY'))
)   
) group by smarttime_employee_id, employee, department_id, trunc(start_clock_time)