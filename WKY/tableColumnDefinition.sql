select to_char( sysdate, 'DD-MM-YYYY HH24:MI') as current_date_time from dual;

desc int_mysql_reklamation

select table_name, column_name, data_type, data_length, data_precision, nullable
  from user_tab_columns
 where table_name like 'INT_LEXW%'
order by table_name, column_id
;