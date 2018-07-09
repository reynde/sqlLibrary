select b.tablespace_name, sum(tbs_size) size_mb, sum(a.free_space) free_mb
  from ( select tablespace_name, round(sum( bytes) / 1024 / 1024, 2) as free_space
           from dba_free_space
          group by tablespace_name
       ) a
     , ( select tablespace_name, sum(bytes) / 1024 / 1024 as tbs_size
           from dba_data_files
          group by tablespace_name
       ) b
  where a.tablespace_name (+) = b.tablespace_name
 group by rollup(b.tablespace_name)
 order by free_mb desc
 ;
 
select
   fs.tablespace_name                          "Tablespace",
   (df.totalspace - fs.freespace)              "Used MB",
   fs.freespace                                "Free MB",
   df.totalspace                               "Total MB",
   round(100 * (fs.freespace / df.totalspace)) "Pct. Free"
from
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) TotalSpace
   from
      dba_data_files
   group by
      tablespace_name
   ) df,
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) FreeSpace
   from
      dba_free_space
   group by
      tablespace_name
   ) fs
where
   df.tablespace_name = fs.tablespace_name
order by 2 desc   ;   