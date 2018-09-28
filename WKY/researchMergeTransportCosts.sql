select sysdate from dual;

select * from wky_zipcode_carrier_costs where ate_id=134258073486752753727566402276393884288 and crr_id=143469652094644148674578672513496827321;

select count(*) from wky_carriers;

select to_char( updated, 'DD-MM-YYYY HH24:MI') as when_merged, updated, updated_by
  from wky_zipcode_carrier_costs
 order by updated desc
  ;
  
/*
  start_date       : 01-01-2016
  end_date         : null
  ate_id           : excel translate artikel to ate_id
  cty_id           : excel translate land to ate_id
  postal_code_from : excel von plz
  postal_code_to   : excel bis plz
  crr_id           : excel translate spedition 1 to crr_id
  price            : excel preis 1
  -----
  ? Article not found => logging table
  ? Carier not found => create
*/

select 'Y' from wky_carriers where upper( carriername) = 'MOELLER' and rownum < 2
  ;
  
  select * from rve_test;
  
  insert into rve_test( test_id, test_case) values (1, 'Case one');
  
merge into rve_test t
     using ( select 3 as test_id, 'Case three' as test_case
               from dual
           ) s
        on ( t.test_id = s.test_id)
      when matched
      then
        update set t.test_case = s.test_case
      when not matched
      then
        insert ( test_id
               , test_case
               )
        values ( s.test_id
               , s.test_case
               )
               ;
               
               /*
               4 Moeller  - Y
               1 Moellers - N
               */
select count(*) as number_of_carriers, c007 as carrier, nvl( (select 'Y' from wky_carriers where upper( carriername) = upper( c007) and rownum < 2), 'N') as carrier_exists
  from apex_collections
 where collection_name = 'WKY_TRANSPORT_PRICES'
   and ( upper( c001) <> 'ART.-NR.' or :P10001_SKIP_FIRST_ROW = 'N')
   and ( upper( c007) <> 'SPEDTION 1' or :p10001_skip_first_row = 'N')
 group by c007;
 
select *
  from wky_carriers
 where upper( carriername) = upper( 'moeller')
 ;
 
 
-- The merge statement
merge into wky_zipcode_carrier_costs zct
     using (    select col.c001 as articlenumber
                     , col.c002 as articlename
                     , col.c003 as countrycode
                     , col.c004 as zipcode_from
                     , col.c005 as zipcode_to
                     , col.c006 as price
                     , col.c007 as carriername
                     , ate.id as ate_id
                     , cty.id as cty_id
                     , crr.id as crr_id
                  from apex_collections col
                     , wky_articles ate
                     , wky_countries cty
                     , wky_carriers crr
                 where collection_name = 'WKY_TRANSPORT_PRICES'
                   and ( upper( c001) <> 'ART.-NR.' or :p10001_skip_first_row = 'N')
                   and ( upper( c007) <> 'SPEDTION 1' or :p10001_skip_first_row = 'N')
                   and col.c001 = to_char( ate.articlenumber) (+)
                   and col.c003 = cty.iso_code (+)
                   and upper( col.c007) = upper( crr.carriername) (+)
           ) mrg
        on ( zct.ate_id = mrg.ate_id and zct.crr_id = mrg.crr_id)
      when matched
      then
        update set zct.start_date = to_date( '01012016', 'DDMMYYYY')
                 , zct.end_date = null
                 , zct.ate_id = mrg.ate_id
                 , zct.cty_id = mrg.cty_id
                 , zct.crr_id = mrg.crr_id
                 , zct.postal_code_from = mrg.zipcode_from
                 , zct.postal_code_to = mrg.zipcode_to
                 , zct.price = mrg.price
      when not matched
      then
        insert ( start_date
               , end_date
               , ate_id
               , cty_id
               , crr_id
               , postal_code_from
               , postal_code_to
               , price
               )
        values ( to_date( '01012016', 'DDMMYYYY')
               , null
               , mrg.ate_id
               , mrg.cty_id
               , mrg.crr_id
               , mrg.zipcode_from
               , mrg.zipcode_to
               , mrg.price
               )
               ;
               
               
               select * from apex_collections;
               
               
                   select coll.c001 as articlenumber
                        , coll.c002 as articlename
                        , coll.c003 as countrycode
                        , coll.c004 as zipcode_from
                        , coll.c005 as zipcode_to
                        , coll.c006 as cost_price
                        , coll.c007 as carriername
                        , ate.id as ate_id
                        , cty.id as cty_id
                        , crr.id as crr_id
                     from apex_collections coll
                        , wky_articles ate
                        , wky_countries cty
                        , wky_carriers crr
                    where coll.collection_name = 'WKY_TRANSPORT_PRICES'
                      and ( upper( coll.c001) <> 'ART.-NR.' or :p_skip_header_row = 'N')
                      and ( upper( coll.c007) <> 'SPEDTION 1' or :p_skip_header_row = 'N')
                      and coll.c001 = ate.articlenumber 
                      and coll.c003 = cty.iso_code 
                      and upper( coll.c007) = upper( crr.carriername)
                      ;
                      
                      
select sysdate from dual;

select count(*) from rve_zipcode_carrier_costs; -- 
select count(*) from wky_zipcode_carrier_costs; -- 88343

select merge_action, to_char( zct.created, 'DD-MM-YYYY HH24:MI') as created, to_char( zct.updated, 'DD-MM-YYYY HH24:MI') as updated, zct.updated_by
     , cty.iso_code, zct.postal_code_from, zct.postal_code_to, ate.articlenumber
     , zct.start_date, zct.end_date, ate.articlenumber, cty.iso_code, crr.carriername
  from rve_zipcode_carrier_costs zct
     , wky_articles ate
     , wky_countries cty
     , wky_carriers crr
 where ate.id = zct.ate_id
   and cty.id = zct.cty_id
   and crr.id = zct.crr_id
 order by updated desc
  ;
  
delete rve_zipcode_carrier_costs where merge_action = 'INSERT';

truncate table rve_zipcode_carrier_costs;
  
select count(*), zct.merge_action
  from rve_zipcode_carrier_costs zct
 group by zct.merge_action
 ;
 
select count(*), length( lpad( zct.postal_code_from, 5, '0'))
  from rve_zipcode_carrier_costs zct
     , wky_countries cty
 where cty.id = zct.cty_id
   --and cty.iso_code = 'FR'
 group by length( lpad( zct.postal_code_from, 5, '0'))
 ;
 
select count(*), cty.iso_code, crr.carriername
  from rve_zipcode_carrier_costs zct
     , wky_carriers crr
     , wky_countries cty
 where crr.id = zct.crr_id
   and cty.id = zct.cty_id
 group by cty.iso_code, crr.carriername
 ;
 
select * from wky_carriers; 

select max( zct.price), cty.iso_code, crr.carriername
  from rve_zipcode_carrier_costs zct
     , wky_carriers crr
     , wky_countries cty
 where crr.id = zct.crr_id
   and cty.id = zct.cty_id
 group by cty.iso_code, crr.carriername
 ;

select count(*) from (
select count(*), ate.articlenumber, cty.iso_code, zct.postal_code_from, zct.postal_code_to, zct.price, crr.carriername, zct.start_date, zct.end_date
  from wky_zipcode_carrier_costs zct
     , wky_countries cty
     , wky_carriers crr
     , wky_articles ate
 where cty.id = zct.cty_id
   and crr.id = zct.crr_id
   and ate.id = zct.ate_id
  -- and cty.iso_code = 'FR'
  -- and crr.carriername = 'Gefco'
 group by ate.articlenumber, cty.iso_code, zct.postal_code_from, zct.postal_code_to, zct.price, crr.carriername, zct.start_date, zct.end_date
having count(*) > 1)
   ;
 
delete rve_zipcode_carrier_costs
 where id in (
              select zct.id
                from rve_zipcode_carrier_costs zct
                   , wky_countries cty
                   , wky_carriers crr
               where cty.id = zct.cty_id
                 and crr.id = zct.crr_id
                 and cty.iso_code = 'FR'
                 and crr.carriername = 'Moeller'             
             );
 
 
/*


INSERT	28-09-2018 07:45	28-09-2018 07:45	RVANDENE@APEXRND.BE	FR	01000	01999	01/01/16		625630	FR	Moeller
INSERT	28-09-2018 07:45	28-09-2018 07:45	RVANDENE@APEXRND.BE	FR	01000	01999	01/01/16		614487	FR	Moeller
INSERT	28-09-2018 07:45	28-09-2018 07:45	RVANDENE@APEXRND.BE	FR	01000	01999	01/01/16		810398	FR	Moeller
INSERT	28-09-2018 07:45	28-09-2018 07:45	RVANDENE@APEXRND.BE	FR	01000	01999	01/01/16		810407	FR	Moeller

*/

select *
  from wky_shipmentstatuses_lkp
  ;
  
select *
  from wky_languages_lkp
  ;
  
  select *
  from wky_trucks_vw;
  
select carriername || ' - ' || week_number || ' - ' || day_number || ' - ' || truck_nbr as d
     , id as r
  from wky_trucks_vw
 order by 1
  ;                      