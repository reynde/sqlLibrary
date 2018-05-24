
alter table int_mysql_kunde add kundennr_vc varchar2(2000);

update int_mysql_kunde set kundennr_vc = to_char(kundennr);


create unique index kundennr_vc_idx  on  int_mysql_kunde (kundennr_vc);


select count(*), kundennr_vc
  from int_mysql_kunde
 group by kundennr_vc
having count(*) > 1
;