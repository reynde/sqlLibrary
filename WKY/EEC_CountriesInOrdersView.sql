  select -- Order
       odr.ordernumber  
     , odr.orderdate
       -- Customer
     , ctr.firstname
     , ctr.lastname
     , ctr.company
     , ctr.companytaxcode
     , ctr.phonenumber
     , ctr.emailaddress
     , ctr.delcty_id
     , ( select countryname from wky_countries
         where id = ctr.delcty_id and nvl( language, 'US') = 'US'
       ) as deliverycountry
     , ( select current_eec_flag from wky_countries_v
         where cty_id = ctr.delcty_id
       )as eec_flag
     , ctr.lge_id
     , ( select lookupvalue from wky_languages_lkp
         where id = ctr.lge_id and nvl( language, 'US') = 'US'
       ) as customer_language
       -- Technical ID columns and audit info
     , odr.id as odr_id
     , odr.row_version as odr_row_version
     , odr.created as odr_created
     , odr.created_by as odr_created_by
     , odr.updated as odr_updated
     , odr.updated_by as odr_updated_by
     , ctr.id as ctr_id
     , ctr.row_version as ctr_row_version
     , ctr.created as ctr_created
     , ctr.created_by as ctr_created_by
     , ctr.updated as ctr_updated
     , ctr.updated_by as ctr_updated_by
  from wky_orders odr
     , wky_customers ctr
 where odr.ctr_id = ctr.id
   and odr.ordernumber in ( '12312300', 'N1000000060')
;

select * from wky_current_eec_countries_v
             where id =128551001677863016609805769029395831652;
             
create or replace force view wky_countries_v
as
select cty.id as cty_id, cty.countryname, cty.iso_code, cty.language
     , ecy.id as ecy_id, ecy.start_date as eec_start_date, ecy.end_date as eec_end_date, nvl( ecy.eec_flag, 'Y') as current_eec_flag
  from wky_countries cty
     , wky_eec_countries ecy
 where cty.id = ecy.cty_id (+)
   and sysdate between nvl( ecy.start_date, sysdate) and nvl( ecy.end_date, sysdate)
 ;
 
select *
  from wky_countries_v;