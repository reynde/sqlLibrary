         select id, '*'||rtrim('SMARTTIME_EMPLOYEE_ID')||'*' as trimmeke
            from wky_file_types
           where file_type = 'SmartTime';
           
           
           
            insert into wky_smarttime_csvs 
                ( file_id
                , smarttime_employee_id
                , lexware_employee_id
                , rnd_date
                , rnd_time
                , employee
                , department_id
                , department
                , hour
                , minute
                , status
                ) 
            values 
                ( '15151515'
                , '1000002'
                , '1000165'
                , to_date( '20180102', 'YYYYMMDD')
                , '352'
                , 'Simoni, RnD'
                , '1'
                , 'Buchhaltung'
                , '5'
                , '52'
                , 'PARSED'
                );           
                
select *
  from wky_smarttime_csvs
 where employee like '%RnD%'
  ;
  
delete wky_smarttime_csvs
 where employee like '%RnD%'
  ;
  
commit;