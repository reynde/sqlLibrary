select count(*)
  from wky_customers
 where lge_id is not null;
 
select *
  from wky_languages_lkp
 order by sortingsequence
  ;
  
  
select count(*)
  from wky_customers
 where lge_id is not null
   and lge_id not in 
         (
          select id
            from wky_languages_lkp
           where nvl( active, 'N') = 'Y'
         )
         ;
         
select distinct c.countryname
  from int_greyhound_tickets g
     , wky_countries c
 where g.cty_id = c.id
  ;
         
update wky_customers
   set lge_id = null
 where lge_id is not null
   and lge_id not in 
         (
          select id
            from wky_languages_lkp
           where nvl( active, 'N') = 'Y'
         )
         ;

delete wky_languages_lkp
 where active = 'N';
 
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('IT', 'US', 'Italian', 5, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('DA', 'US', 'Danish', 7, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('SV', 'US', 'Swedish', 7, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('FI', 'US', 'Finnish', 7, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('NO', 'US', 'Norwegian', 7, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('PL', 'US', 'Polish', 9, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('ES', 'US', 'Spanish', 9, 'Y');
insert into wky_languages_lkp ( lookupcode, language, lookupvalue, sortingsequence, active) values ('CS', 'US', 'Czech', 9, 'Y');