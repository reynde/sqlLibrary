select *
  from rve_orders
 where to_char( order_number) like '9999_'
  ;
  
select *
  from rve_order_lines
 where order_id in (    select id
                          from rve_orders
                         where to_char( order_number) like '9999_'
                   ) 
  ;
  
/*
In case where multiple columns identify unique row (e.g relations table ) there you can use following

Use row id e.g. emp_dept(empid, deptid, startdate, enddate) suppose empid and deptid are unique and identify row in that case

select oed.empid, count(oed.empid) 
from emp_dept oed 
where exists ( select * 
               from  emp_dept ied 
                where oed.rowid <> ied.rowid and 
                       ied.empid = oed.empid and 
                      ied.deptid = oed.deptid )  
        group by oed.empid having count(oed.empid) > 1 order by count(oed.empid);

And if such table has primary key then use primary key instead of rowid, e.g id is pk then

select oed.empid, count(oed.empid) 
from emp_dept oed 
where exists ( select * 
               from  emp_dept ied 
                where oed.id <> ied.id and 
                       ied.empid = oed.empid and 
                      ied.deptid = oed.deptid )  
        group by oed.empid having count(oed.empid) > 1 order by count(oed.empid);
*/



update rve_order_lines set quantity = 4 where id = 152749262502834146269383292513080399997
;

/* Geeft alle dubbele order lines */
with double_orders as 
(
select v.order_number, v.customer_id, v.total_price
     , v.quantity, v.unit_price, v.article_number, v.article_name, v.ole_id
     , count(*) over ( partition by v.quantity, v.unit_price, v.article_number) as cnt_doubles
  from (
        select odr.*, ole.id as ole_id, ole.*
          from rve_order_lines ole
             , rve_orders odr
         where odr.id = ole.order_id
           and to_char( odr.order_number) like '9999_'     
       ) v
)
select *
  from double_orders
 where cnt_doubles > 1
  ;
  
  
select odr.order_number, count(*)
  from rve_orders odr
     , rve_order_lines ole
 where odr.id = ole.order_id
   and to_char( odr.order_number) like '9999_'
 group by odr.order_number
 ;
 

/*
select * from films
  where  (title, uk_release_date) in (
   select title, uk_release_date
 from   films
 group  by title, uk_release_date
 having count(*) > 1
  ) 
*/

select * from rve_orders;
select * from rve_order_lines;

select *
  from rve_orders odr
     , rve_order_lines ole
 where odr.id = ole.order_id
   and to_char( odr.order_number) like '9999_'
 order by odr.order_number, ole.article_number
   ;
   
select count(*), dbls
  from (
        select odr_id, order_number, listagg( double_attributes, ';') within group ( order by order_number) as dbls
          from (
                    select odr.id as odr_id, odr.order_number, odr.customer_id, odr.total_price
                         , ole.id as ole_id, ole.quantity, ole.unit_price, ole.article_number, ole.article_name
                         , odr.total_price || ole.quantity || ole.unit_price || ole.article_number as double_attributes
                      from rve_orders odr
                         , rve_order_lines ole
                     where odr.id = ole.order_id
                       and to_char( odr.order_number) like '9999_'
               )
         group by odr_id, order_number
       )
  group by dbls
having count(*) > 1
  ; 
  
with double_orders as
    (
    select count(*) over ( partition by dbls) as cnt_doubles, customer_id, odr_id, order_number
      from (
            select odr_id, order_number, customer_id, listagg( double_attributes, ';') within group ( order by order_number) as dbls
              from (
                        select odr.id as odr_id, odr.order_number, odr.customer_id, odr.total_price
                             , ole.id as ole_id, ole.quantity, ole.unit_price, ole.article_number, ole.article_name
                             , odr.total_price || ole.quantity || ole.unit_price || ole.article_number as double_attributes
                          from rve_orders odr
                             , rve_order_lines ole
                         where odr.id = ole.order_id
                           and to_char( odr.order_number) like '9999_'
                   ) v
             group by odr_id, order_number, customer_id
           )
    )
select *
  from double_orders
 where cnt_doubles > 1
 ;
 
select * from wky_orders;
select * from wky_orderscontainarticle;

select sysdate from dual;

with double_orders as
    (
    select count(*) over ( partition by dbls) as cnt_doubles, ctr_id, odr_id, ordernumber
      from (
            select odr_id, ordernumber, ctr_id, listagg( double_attributes) within group ( order by ordernumber) as dbls
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov
                   )
             group by odr_id, ordernumber, ctr_id
           )
    )  
select *
  from double_orders
 where cnt_doubles > 1
 ;
 
 
 
 
 
 
 
 
 /* Verbeterd door Dimi */
            select double_attributes, count(*) as cnt, listagg(odr_id || '|'|| ordernumber  || '|'|| ctr_id , ' ### ' ) within group ( order by ordernumber) as dbls
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber || ov.ctr_id as double_attributes
                      from wky_order_overview_v ov                      
                   )
             group by double_attributes
             having count(*)>1
             ;


            select ctr_id, double_attributes, count(*) as cnt, listagg(ordernumber, ',' ) within group ( order by ordernumber) as dbls
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov                      
                   )
             group by ctr_id, double_attributes
             having count(*)>1
             ;             
             

            select distinct dbls.ctr_id, dbls.double_attributes, dbls.cnt, ord.odr_id, ord.ordernumber
            from(
            select ctr_id, double_attributes, count(*) as cnt
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov                      
                   )
             group by ctr_id, double_attributes
             having count(*)>1
             ) dbls, (select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov ) ord
             where dbls.double_attributes = ord.double_attributes
             
             
             
             select distinct odr.ctr_id, odr.odr_id, odr.ordernumber, odr.double_attributes
             from(
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov                      
             ) odr
             where odr.double_attributes in (
             select double_attributes
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov                      
                   )
             group by ctr_id, double_attributes
             having count(*)>1
             )
             group by  odr.ctr_id, odr.odr_id, odr.ordernumber
             having count(*) > 1
             ;
             
    select max( ov.orderdate)
                      from wky_order_overview_v ov          ;
                      
                                          select count(*)
                      from wky_order_overview_v ov 
                      where ov.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and ov.orderdate < to_date( '30032018', 'DDMMYYYY') +1;
             

begin
   for r in ( 
            select ctr_id, double_attributes, count(*) as cnt
              from (
                    select ov.odr_id, ov.ordernumber, ov.orderdate, ov.totalprice, ov.oss_order_status, ov.delivery_form, ov.currency
                         , ov.sales_channel, ov.ate_quantity, ov.ate_unitprice, ov.articlenumber, ov.articlename
                         , ov.ctr_id, ov.firstname, ov.lastname
                         , ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || 
                           ov.ate_unitprice || ov.articlenumber as double_attributes
                      from wky_order_overview_v ov 
                      where ov.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and ov.orderdate < to_date( '30032018', 'DDMMYYYY') +1
                   )
             group by ctr_id, double_attributes
             having count(*)>1
             order by 1,2
    ) loop  
          sys.htp.p(r.ctr_id || r.double_attributes);
      /*for s in ( select distinct ov.ordernumber
                   from wky_order_overview_v ov   
                  where  ov.orderdate || ov.totalprice || ov.delivery_form || ov.sales_channel || ov.ate_quantity || ov.ate_unitprice || ov.articlenumber = r.double_attributes
                    and ov.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and ov.orderdate < to_date( '30032018', 'DDMMYYYY') +1
                  order by 1
      )
      loop
       -- print all order numbers of this double
       sys.htp.p(' -'|| s.ordernumber);
      end loop;   */
    end loop;                                       
end;             


-- not using view anymore
/* Base query */
select odr.id as odr_id
     , oce.id as oce_id
  from wky_orders odr
     , wky_orderscontainarticle oce
 where odr.id = oce.odr_id
 ;
 
 
declare
  l_customer varchar2(4000);
begin
   for r in ( 
            select distinct ctr_id, double_attributes, count(*) as cnt
              from (
                    select odr.id as odr_id, odr.ordernumber, odr.orderdate, odr.totalprice, odr.oss_id, odr.dfm_id, odr.cry_id
                         , odr.scl_id, oce.quantity, oce.unitprice, oce.ate_id
                         , odr.ctr_id 
                         , odr.orderdate || odr.totalprice || odr.dfm_id || odr.scl_id || oce.quantity || 
                           oce.unitprice || oce.ate_id as double_attributes
                      from wky_orders odr
                         , wky_orderscontainarticle oce
                      where odr.id = oce.odr_id
                        and odr.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and odr.orderdate < to_date( '30032018', 'DDMMYYYY') +1
                        --
                        and odr.ctr_id = 133868194843374335398853657847755623585
                        --
                   )
             group by ctr_id, double_attributes
             having count(*)>1
             order by 1,2
    ) loop  
          select firstname || ' ' || lastname into l_customer
            from wky_customers
           where id = r.ctr_id;
           
          sys.htp.p(l_customer || '('|| r.ctr_id|| ')' || ' has doubles in following orders: ' ); /* || r.double_attributes);*/
      for s in ( select distinct odr.ordernumber
                   from wky_orders odr  
                      , wky_orderscontainarticle oce
                  where odr.id = oce.odr_id
                    and odr.orderdate || odr.totalprice || odr.dfm_id || odr.scl_id || oce.quantity || oce.unitprice || oce.ate_id = r.double_attributes
                    and odr.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                    and odr.orderdate < to_date( '30032018', 'DDMMYYYY') +1
                  order by 1
      )
      loop
       -- print all order numbers of this double
       sys.htp.p(' -'|| s.ordernumber);
      end loop;   
    end loop;                                       
end;     


-- Best query so far ! But takes 33 seconds !!
select distinct a.ctr_id, a.odr_id, a.ordernumber, b.ordernumber as equal_ordernumber
from
(select odr.id as odr_id, odr.ordernumber, odr.orderdate, odr.totalprice, odr.oss_id, odr.dfm_id, odr.cry_id
                         , odr.scl_id, oce.quantity, oce.unitprice, oce.ate_id
                         , odr.ctr_id 
                         , odr.orderdate || odr.totalprice || odr.dfm_id || odr.scl_id || oce.quantity || 
                           oce.unitprice || oce.ate_id as double_attributes
                      from wky_orders odr
                         , wky_orderscontainarticle oce
                      where odr.id = oce.odr_id
                        and odr.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and odr.orderdate < to_date( '30032018', 'DDMMYYYY') -5
                        --
                        --and odr.ctr_id = 133868194816441885989478949093651434657
)a, (
 select odr.id as odr_id, odr.ordernumber, odr.orderdate, odr.totalprice, odr.oss_id, odr.dfm_id, odr.cry_id
                         , odr.scl_id, oce.quantity, oce.unitprice, oce.ate_id
                         , odr.ctr_id 
                         , odr.orderdate || odr.totalprice || odr.dfm_id || odr.scl_id || oce.quantity || 
                           oce.unitprice || oce.ate_id as double_attributes
                      from wky_orders odr
                         , wky_orderscontainarticle oce
                      where odr.id = oce.odr_id
                        and odr.orderdate > to_date( '30032018', 'DDMMYYYY') -7
                        and odr.orderdate < to_date( '30032018', 'DDMMYYYY') -5
                        --
                        --and odr.ctr_id = 133868194816441885989478949093651434657
)b
where a.odr_id <> b.odr_id
and a.double_attributes = b.double_attributes
;