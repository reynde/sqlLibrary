/*
  USe these statements to check and cleanup DB storage
*/

-- 1. Checks whichs segment holds the most space
select us.bytes /2024 /2024 as storage_mb, us.* 
  from user_segments us
 order by us.bytes desc;

-- 2. Check which table + column eats the storage, use segment-name from query 1
select ul.* 
  from user_lobs ul
 where ul.segment_name = 'SYS_LOB0000083942C00078$$'
 ;

-- 3. Check the table and column combination
select *
  from wky_orders
 where json_source is not null
   and created <= sysdate-10;

-- 4. Check if interfaces are running
select *
  from wky_interface_jobs
  ;

-- 5. Stop interface
update wky_interface_jobs
   set enabled = 'N'
-- where job_name = p_job_name
;  
 
-- 6. Empty the identified table-column combination
update wky_orders
   set json_source = null
 --where created <= sysdate - 15
 ;

-- 7. Removing the high-watermark for the table+column combination
alter table wky_orders move lob( json_source) store as ( tablespace DTQPJJJKMGQ_DATA) ;

-- 8. Restart the interfaces
update wky_interface_jobs
   set enabled = 'N'
-- where job_name = p_job_name
;

-- 9. Restart DB (need to be pdb_admin as sysoper)
alter pluggable database close immediate;
alter pluggable database open;





