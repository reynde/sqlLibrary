select * from dual;

select *
  from wky_companies_lkp
  ;
  
select *
  from wky_smarttime_csvs
 where smarttime_employee_id = 1
  ;
  
select *
  from wky_smarttime_csvs_v
 where smarttime_employee_id = 1
  ;
  
select *
  from wky_employee_info_v
  ;
  
select *
  from wky_smarttime_work_break_v wb
  ;
  
  
select cpy.id as company_id
     , cpy.name as company_name
     --
     , emp.epe_id as employee_id
     , emp.employee_name as employee_name
     , emp.smarttime_employee_id as smarttime_employee_id
     , emp.dpt_id as department_id
     , emp.department_name as department_name
     , emp.ect_id as employee_cost_id
     , emp.contracttype as contract_type
     , emp.cost_start_date as cost_start_date
     , emp.cost_end_date as cost_end_date
     , emp.hourly_rate as cost_hourly_rate
     , emp.additional_rates as cost_additional_rates
     --
     , wb.file_id as csvs_file_id
     , wb.start_clock_time as start_clock_time -- varchar2
     , wb.start_clock_time_dt as start_clock_time_dt -- date
     , wb.end_clock_time as end_clock_time -- varchar2
     , wb.end_clock_time_dt as end_clock_time_dt -- date
     , ( wb.end_clock_time_dt - wb.start_clock_time_dt ) as days_worked
     , ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 as hours_worked
     , ( ( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ) -
       mod( ( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ), 60) ) /60  -- Hours
       || ':' 
       ||  round( mod(( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ), 60))  -- Minutes
       as hh_mi_worked
     , wb.clock_type as clock_type
  from wky_companies_lkp cpy
     , wky_employee_info_v emp
     , wky_smarttime_work_break_v wb
 where cpy.id = emp.cpe_id 
   and emp.smarttime_employee_id = wb.smarttime_employee_id
   and wb.clock_type = 'WORK'
   --
   and cpy.id = 133963741854501510859300528160066144672 -- Wickey GmbH & Co KG 
   --
 order by cpy.id, emp.dpt_id, emp.smarttime_employee_id
  ;
  
  
select *
  from wky_company_working_time_v
 order by company_id, department_id, employee_id
 ;
 
select to_char( sysdate, 'YYYY') as year
     , to_char( sysdate, 'Q') as quarter
     , to_char( sysdate, 'MM') as month
     , to_char( sysdate, 'IW') as week
  from dual
  ;
  


  
-- LOV YEARS_LOV  
select extract(year from sysdate) - (level-5) as years 
  from dual 
connect by level <=10 
order by years
;

-- LOV QUARTER_LOV  
select level as month_d 
     , level as month_r
  from dual 
connect by level <= 12
order by 1
;


select to_char( to_date( '30-12-2021', 'DD-MM-YYYY'), 'IW')
  from dual
  ;
  
select add_months( trunc( sysdate, 'YEAR'), 12)-1, to_char( add_months( trunc( sysdate, 'YEAR'), 12)-1, 'IW')
  from dual;
  
select next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Sunday') last_sunday, to_char( next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Sunday'), 'IW') last_su_week
     , next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Monday') last_monday, to_char( next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Monday'), 'IW') last_mo_week
     , greatest(  to_char( next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Monday'), 'IW'), to_char( next_day(to_date(:input_year || '-12-24', 'yyyy-mm-dd'), 'Sunday'), 'IW') ) nbr_weeks_in_year
  from dual;
  
-- LOV WEEKS_LOV
select level as week_d
     , level as week_r
  from dual
connect by level <= greatest(  to_char( next_day(to_date( to_char( sysdate, 'YYYY') || '-12-24', 'yyyy-mm-dd'), 'Monday'), 'IW'), to_char( next_day(to_date( to_char( sysdate, 'YYYY') || '-12-24', 'yyyy-mm-dd'), 'Sunday'), 'IW') )
;