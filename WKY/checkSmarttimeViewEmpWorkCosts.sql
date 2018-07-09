select sysdate from dual;

--create or replace force editionable view wky_emp_work_costs_v
--as 
  select ( v.hourly_rate / 60 ) * nvl( v.minutes_worked, 0) as working_cost
         , to_char( v.start_time, 'DD-MM-YYYY HH24:MI') as real_start_time
         , to_char( v.end_time, 'DD-MM-YYYY HH24:MI') as real_end_time
         , v.minutes_worked / 60 as hours_worked
         , to_char( v.start_time, 'q') as quarter
         , v.EPE_ID,v.EMPLOYEE_NAME,v.SMARTTIME_EMPLOYEE_ID,v.LEXWARE_EMPLOYEE_ID,v.MANAGER,v.EMPLOYEE_STATUS,v.DPT_ID,v.DEPARTMENT_NAME,v.LEGACY_DEPARTMENT_ID,v.DEPARTMENT_STATUS,v.CPE_ID,v.COMPANY_NAME,v.CONTRACTTYPE,v.COST_START_DATE,v.COST_END_DATE,v.HOURLY_RATE,v.ADDITIONAL_RATES,/*v.WHR_ID,*/v.START_TIME,v.END_TIME,v.WORK_TYPE,v.MINUTES_WORKED,v.WEEK_NUMBER
      from (
              select epe.id as epe_id
                   , epe.name as employee_name
                   , epe.smarttime_employee_id
                   , epe.lexware_employee_id
                   , epe.manager
                   , epe.status as employee_status
                   , dpt.id as dpt_id
                   , dpt.name as department_name
                   , dpt.legacy_department_id
                   , dpt.status as department_status
                   , cpe.id as cpe_id
                   , cpe.name as company_name
                   , ect.contracttype
                   , ect.start_date as cost_start_date
                   , ect.end_date as cost_end_date
                   , ect.hourly_rate
                   , ect.additional_rates
                   --, whr.id as whr_id
                   , whr.start_clock_time_dt as start_time
                   , whr.end_clock_time_dt as end_time
                   , whr.clock_type as work_type
                   , ( whr.end_clock_time_dt - whr.start_clock_time_dt ) * 24 * 60 as minutes_worked
                   , to_char( whr.start_clock_time_dt, 'IW') as week_number
                from wky_employees epe
                   , wky_departments dpt
                   , wky_companies_lkp cpe
                   , wky_employee_costs ect
                   , wky_smarttime_work_break_v whr -- wky_working_hours whr
               where epe.department_id = dpt.id
                 and dpt.companies_lkp_id = cpe.id (+)
                 and ect.employee_id = epe.id
                 and ect.start_date = (
                                        select max( start_date)
                                          from wky_employee_costs
                                         where employee_id = epe.id
                                      )
                 and whr.employee_cost_id = ect.id
           ) v;