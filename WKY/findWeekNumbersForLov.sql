-- Find first day of quarter
   -- Inputs are: YEAR , QUARTER
   select :year, :quarter
        , case 
            when :quarter = '1' then to_date('0101'||:year, 'DDMMYYYY')
            when :quarter = '2' then to_date('0104'||:year, 'DDMMYYYY')
            when :quarter = '3' then to_date('0107'||:year, 'DDMMYYYY')
            when :quarter = '4' then to_date('0110'||:year, 'DDMMYYYY')
          end as quarter_first_day
     from dual;
     
-- Find last day of quarter
   -- Inputs are: YEAR , QUARTER
   select :year, :quarter
        , case 
            when :quarter = '1' then to_date('3103'||:year, 'DDMMYYYY')
            when :quarter = '2' then to_date('3006'||:year, 'DDMMYYYY')
            when :quarter = '3' then to_date('3009'||:year, 'DDMMYYYY')
            when :quarter = '4' then to_date('3112'||:year, 'DDMMYYYY')
          end as quarter_last_day
     from dual;
     
-- Find week of first day of quarter
-- Find week of last day of quarter
   -- Inputs are: YEAR , QUARTER
   select selected_year, selected_quarter
        , to_char( quarter_first_day, 'IW') as quarter_first_week
        , to_char( quarter_last_day, 'IW') as quarter_last_week
     from (
           select :year as selected_year, :quarter as selected_quarter
                , case 
                    when :quarter = '1' then to_date('0101'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('0104'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('0107'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('0110'||:year, 'DDMMYYYY')
                  end as quarter_first_day
                , case 
                    when :quarter = '1' then to_date('3103'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('3006'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('3009'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('3112'||:year, 'DDMMYYYY')
                  end as quarter_last_day
             from dual
          )
          ;
          
-- Find first month of quarter
-- Find last month of quarter
   -- Inputs are YEAR, QUARTER
   select selected_year, selected_quarter
        , to_char( quarter_first_day, 'MM') as quarter_first_month
        , to_char( quarter_last_day, 'MM') as quarter_last_month
     from (
           select :year as selected_year, :quarter as selected_quarter
                , case 
                    when :quarter = '1' then to_date('0101'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('0104'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('0107'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('0110'||:year, 'DDMMYYYY')
                  end as quarter_first_day
                , case 
                    when :quarter = '1' then to_date('3103'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('3006'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('3009'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('3112'||:year, 'DDMMYYYY')
                  end as quarter_last_day
             from dual
          );
     
-- Find first day of month
-- Find last day of month
   -- Inputs are: YEAR , MONTH
   select :year as selected_year, :month as selected_month
        , case 
            when :month = '01' then to_date('0101'||:year, 'DDMMYYYY')
            when :month = '02' then to_date('0102'||:year, 'DDMMYYYY')
            when :month = '03' then to_date('0103'||:year, 'DDMMYYYY')
            when :month = '04' then to_date('0104'||:year, 'DDMMYYYY')
            when :month = '05' then to_date('0105'||:year, 'DDMMYYYY')
            when :month = '06' then to_date('0106'||:year, 'DDMMYYYY')
            when :month = '07' then to_date('0107'||:year, 'DDMMYYYY')
            when :month = '08' then to_date('0108'||:year, 'DDMMYYYY')
            when :month = '09' then to_date('0109'||:year, 'DDMMYYYY')
            when :month = '10' then to_date('0110'||:year, 'DDMMYYYY')
            when :month = '11' then to_date('0111'||:year, 'DDMMYYYY')
            when :month = '12' then to_date('0112'||:year, 'DDMMYYYY')
          end as month_first_day
        , case 
            when :month = '01' then to_date('3101'||:year, 'DDMMYYYY')
            when :month = '02' then to_date('0103'||:year, 'DDMMYYYY') -1
            when :month = '03' then to_date('3103'||:year, 'DDMMYYYY')
            when :month = '04' then to_date('3004'||:year, 'DDMMYYYY')
            when :month = '05' then to_date('3105'||:year, 'DDMMYYYY')
            when :month = '06' then to_date('3006'||:year, 'DDMMYYYY')
            when :month = '07' then to_date('3107'||:year, 'DDMMYYYY')
            when :month = '08' then to_date('3108'||:year, 'DDMMYYYY')
            when :month = '09' then to_date('3009'||:year, 'DDMMYYYY')
            when :month = '10' then to_date('3110'||:year, 'DDMMYYYY')
            when :month = '11' then to_date('3011'||:year, 'DDMMYYYY')
            when :month = '12' then to_date('3112'||:year, 'DDMMYYYY')
          end as month_last_day
     from dual;
   
-- Find week of first day of month
-- Find week of last day of month
   -- Inputs are: YEAR , MONTH
   select selected_year, selected_month
        , to_char( month_first_day, 'IW') as month_first_week
        , to_char( month_last_day, 'IW') as month_last_week
     from (
           select :year as selected_year, :month as selected_month
                , case 
                    when :month = '01' then to_date('0101'||:year, 'DDMMYYYY')
                    when :month = '02' then to_date('0102'||:year, 'DDMMYYYY')
                    when :month = '03' then to_date('0103'||:year, 'DDMMYYYY')
                    when :month = '04' then to_date('0104'||:year, 'DDMMYYYY')
                    when :month = '05' then to_date('0105'||:year, 'DDMMYYYY')
                    when :month = '06' then to_date('0106'||:year, 'DDMMYYYY')
                    when :month = '07' then to_date('0107'||:year, 'DDMMYYYY')
                    when :month = '08' then to_date('0108'||:year, 'DDMMYYYY')
                    when :month = '09' then to_date('0109'||:year, 'DDMMYYYY')
                    when :month = '10' then to_date('0110'||:year, 'DDMMYYYY')
                    when :month = '11' then to_date('0111'||:year, 'DDMMYYYY')
                    when :month = '12' then to_date('0112'||:year, 'DDMMYYYY')
                  end as month_first_day
                , case 
                    when :month = '01' then to_date('3101'||:year, 'DDMMYYYY')
                    when :month = '02' then to_date('0103'||:year, 'DDMMYYYY') -1
                    when :month = '03' then to_date('3103'||:year, 'DDMMYYYY')
                    when :month = '04' then to_date('3004'||:year, 'DDMMYYYY')
                    when :month = '05' then to_date('3105'||:year, 'DDMMYYYY')
                    when :month = '06' then to_date('3006'||:year, 'DDMMYYYY')
                    when :month = '07' then to_date('3107'||:year, 'DDMMYYYY')
                    when :month = '08' then to_date('3108'||:year, 'DDMMYYYY')
                    when :month = '09' then to_date('3009'||:year, 'DDMMYYYY')
                    when :month = '10' then to_date('3110'||:year, 'DDMMYYYY')
                    when :month = '11' then to_date('3011'||:year, 'DDMMYYYY')
                    when :month = '12' then to_date('3112'||:year, 'DDMMYYYY')
                  end as month_last_day
             from dual
          )
          ;
          
-- LOV Months of quarter
   -- Inputs are: YEAR, QUARTER
    select to_char( level, '00') as month_d 
         , to_char( level, '00') as month_r
      from dual 
     where level >= 4
       and level <= 6
    connect by level <= 12 
    order by 1
    ;
    
   
   select selected_year, selected_quarter
        , to_number( to_char( quarter_first_day, 'MM')) as quarter_first_month
        , to_number( to_char( quarter_last_day, 'MM')) as quarter_last_month
     from (
           select :year as selected_year, :quarter as selected_quarter
                , case 
                    when :quarter = '1' then to_date('0101'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('0104'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('0107'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('0110'||:year, 'DDMMYYYY')
                  end as quarter_first_day
                , case 
                    when :quarter = '1' then to_date('3103'||:year, 'DDMMYYYY')
                    when :quarter = '2' then to_date('3006'||:year, 'DDMMYYYY')
                    when :quarter = '3' then to_date('3009'||:year, 'DDMMYYYY')
                    when :quarter = '4' then to_date('3112'||:year, 'DDMMYYYY')
                  end as quarter_last_day
             from dual
          );
          
    select to_char( level, '00') as month_d 
         , to_char( level, '00') as month_r
      from (
           select selected_year, selected_quarter
                , to_number( to_char( quarter_first_day, 'MM')) as quarter_first_month
                , to_number( to_char( quarter_last_day, 'MM')) as quarter_last_month
             from (
                   select :year as selected_year, :quarter as selected_quarter
                        , case 
                            when :quarter = '1' then to_date('0101'||:year, 'DDMMYYYY')
                            when :quarter = '2' then to_date('0104'||:year, 'DDMMYYYY')
                            when :quarter = '3' then to_date('0107'||:year, 'DDMMYYYY')
                            when :quarter = '4' then to_date('0110'||:year, 'DDMMYYYY')
                          end as quarter_first_day
                        , case 
                            when :quarter = '1' then to_date('3103'||:year, 'DDMMYYYY')
                            when :quarter = '2' then to_date('3006'||:year, 'DDMMYYYY')
                            when :quarter = '3' then to_date('3009'||:year, 'DDMMYYYY')
                            when :quarter = '4' then to_date('3112'||:year, 'DDMMYYYY')
                          end as quarter_last_day
                     from dual
                  )
           )
     where level >= quarter_first_month
       and level <= quarter_last_month
    connect by level <= 12 
    order by 1
    ;
    
-- LOV weeks of month
   -- Inputs are: YEAR, MONTH
   select level as week_d
        , level as week_r
     from dual
   connect by level <= greatest(  to_char( next_day(to_date( to_char( sysdate, 'YYYY') || '-12-24', 'yyyy-mm-dd'), 'Monday'), 'IW'), to_char( next_day(to_date( to_char( sysdate, 'YYYY') || '-12-24', 'yyyy-mm-dd'), 'Sunday'), 'IW') )
   ;
   
   select selected_year, selected_month
        , to_char( month_first_day, 'IW') as month_first_week
        , to_char( month_last_day, 'IW') as month_last_week
     from (
           select :year as selected_year, :month as selected_month
                , case 
                    when :month = '01' then to_date('0101'||:year, 'DDMMYYYY')
                    when :month = '02' then to_date('0102'||:year, 'DDMMYYYY')
                    when :month = '03' then to_date('0103'||:year, 'DDMMYYYY')
                    when :month = '04' then to_date('0104'||:year, 'DDMMYYYY')
                    when :month = '05' then to_date('0105'||:year, 'DDMMYYYY')
                    when :month = '06' then to_date('0106'||:year, 'DDMMYYYY')
                    when :month = '07' then to_date('0107'||:year, 'DDMMYYYY')
                    when :month = '08' then to_date('0108'||:year, 'DDMMYYYY')
                    when :month = '09' then to_date('0109'||:year, 'DDMMYYYY')
                    when :month = '10' then to_date('0110'||:year, 'DDMMYYYY')
                    when :month = '11' then to_date('0111'||:year, 'DDMMYYYY')
                    when :month = '12' then to_date('0112'||:year, 'DDMMYYYY')
                  end as month_first_day
                , case 
                    when :month = '01' then to_date('3101'||:year, 'DDMMYYYY')
                    when :month = '02' then to_date('0103'||:year, 'DDMMYYYY') -1
                    when :month = '03' then to_date('3103'||:year, 'DDMMYYYY')
                    when :month = '04' then to_date('3004'||:year, 'DDMMYYYY')
                    when :month = '05' then to_date('3105'||:year, 'DDMMYYYY')
                    when :month = '06' then to_date('3006'||:year, 'DDMMYYYY')
                    when :month = '07' then to_date('3107'||:year, 'DDMMYYYY')
                    when :month = '08' then to_date('3108'||:year, 'DDMMYYYY')
                    when :month = '09' then to_date('3009'||:year, 'DDMMYYYY')
                    when :month = '10' then to_date('3110'||:year, 'DDMMYYYY')
                    when :month = '11' then to_date('3011'||:year, 'DDMMYYYY')
                    when :month = '12' then to_date('3112'||:year, 'DDMMYYYY')
                  end as month_last_day
             from dual
          )
          ;
          
   select to_char( level, '00') as week_d
        , to_char( level, '00') as week_r
     from (
           select selected_year, selected_month
                , to_char( month_first_day, 'IW') as month_first_week
                , case 
                    when to_number( to_char( month_last_day, 'IW')) < 2 then max_weeks
                    else to_char( month_last_day, 'IW') 
                  end as month_last_week
                , month_first_day
                , month_last_day
                , max_weeks
                , case
                    when :P32_MONTH = '12' then max_weeks
                    else to_char( month_last_day, 'IW')
                  end as max_connect_by
             from (
                   select :P32_YEAR as selected_year, :P32_MONTH as selected_month
                        , case 
                            when :P32_MONTH = '01' then to_date('0101'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '02' then to_date('0102'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '03' then to_date('0103'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '04' then to_date('0104'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '05' then to_date('0105'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '06' then to_date('0106'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '07' then to_date('0107'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '08' then to_date('0108'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '09' then to_date('0109'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '10' then to_date('0110'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '11' then to_date('0111'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '12' then to_date('0112'||:P32_YEAR, 'DDMMYYYY')
                          end as month_first_day
                        , case 
                            when :P32_MONTH = '01' then to_date('3101'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '02' then to_date('0103'||:P32_YEAR, 'DDMMYYYY') -1
                            when :P32_MONTH = '03' then to_date('3103'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '04' then to_date('3004'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '05' then to_date('3105'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '06' then to_date('3006'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '07' then to_date('3107'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '08' then to_date('3108'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '09' then to_date('3009'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '10' then to_date('3110'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '11' then to_date('3011'||:P32_YEAR, 'DDMMYYYY')
                            when :P32_MONTH = '12' then greatest(  next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Monday'), next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Sunday') )
                           end as month_last_day
                        , greatest(  to_char( next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Monday'), 'IW'), to_char( next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Sunday'), 'IW') ) as max_weeks
                        , greatest(  next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Monday'), next_day(to_date( :P32_YEAR || '-12-24', 'yyyy-mm-dd'), 'Sunday') ) as cutoff_date
                     from dual
                  )
          ) v
     where level >= month_first_week
       and level <= month_last_week
   connect by level <= max_connect_by
   ;