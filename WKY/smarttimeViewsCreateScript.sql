create or replace view wky_company_working_time_v
as
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
         , emp.first_name as first_name
         , emp.last_name as last_name
         --
         , wb.file_id as csvs_file_id
         , wb.start_clock_time as start_clock_time -- varchar2
         , wb.start_clock_time_dt as start_clock_time_dt -- date
         , wb.end_clock_time as end_clock_time -- varchar2
         , wb.end_clock_time_dt as end_clock_time_dt -- date
         , ( wb.end_clock_time_dt - wb.start_clock_time_dt ) as days_worked
         , ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 as hours_worked
         , ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 as minutes_worked
         , ( ( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ) -
           mod( ( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ), 60) ) /60  -- Hours
           || ':' 
           ||  round( mod(( ( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24 * 60 ), 60))  -- Minutes
           as hh_mi_worked
         , wb.clock_type as clock_type
         --
         , ( emp.hourly_rate * (( wb.end_clock_time_dt - wb.start_clock_time_dt ) * 24) )as working_cost
      from wky_companies_lkp cpy
         , wky_employee_info_v emp
         , wky_smarttime_work_break_v wb
     where cpy.id = emp.cpe_id 
       and emp.smarttime_employee_id = wb.smarttime_employee_id
       and wb.clock_type = 'WORK'
    ;
    
create or replace force editionable view wky_employee_info_v
as  
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
                   , ect.id as ect_id
                   , ect.contracttype
                   , ect.start_date as cost_start_date
                   , ect.end_date as cost_end_date
                   , ect.hourly_rate
                   , ect.additional_rates
                   --
                   , case when instr( epe.name, ',') > 0
                       then substr( epe.name, instr( epe.name, ',')+2) 
                       else ''
                     end as first_name
                   , case when instr( epe.name, ',') > 0
                       then substr( epe.name, 1, instr( epe.name, ',')-1) 
                       else epe.name
                     end as last_name
                from wky_employees epe
                   , wky_departments dpt
                   , wky_companies_lkp cpe
                   , wky_employee_costs ect
               where epe.department_id = dpt.id
                 and dpt.companies_lkp_id = cpe.id (+)
                 and ect.employee_id = epe.id
                 and ect.start_date = (
                                        select max( start_date)
                                          from wky_employee_costs
                                         where employee_id = epe.id
                                      );