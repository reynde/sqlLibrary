-- ===== U P D A T E S =====  
select count(*), lower( saleschannelname)
  from wky_saleschannels
 group by lower( saleschannelname)
having count(*) > 1
 order by lower( saleschannelname);

select * from (
select sc.id as sc_id, sc.saleschannelname, (select count(*) from wky_orders where scl_id = sc.id) as times_used_in_orders 
     , (select count(*) from int_greyhound_tickets where scl_id = sc.id) as times_used_in_grey 
  from wky_saleschannels     sc
 where lower( saleschannelname) = :lowerscn
)
where exists (select 1 from int_greyhound_tickets g where sc_id = g.scl_id)
order by saleschannelname 
  ;              
               
update wky_orders
   set scl_id = ( select id
                    from wky_saleschannels
                   where saleschannelname = :upperscn
                )
 where scl_id in ( select id
                    from wky_saleschannels
                   where saleschannelname = :lowerscn
                )
                ;
  
update int_greyhound_tickets
   set scl_id = ( select id
                    from wky_saleschannels
                   where saleschannelname = :upperscn
                )
  where scl_id  in ( select id
                    from wky_saleschannels
                   where saleschannelname = :lowerscn
                )
  ;
  
delete wky_saleschannels where saleschannelname = :lowerscn and status <> 'CONFIRMED';
  
  
  
  
  
  
  
-- ===== R E S E A R C H =====  
  
  select count(*), o.rest_source, s.saleschannelname
  from wky_orders o
     , wky_saleschannels s
 where o.scl_id = s.id(+)
   and o.scl_id is  null
--   and rest_source = 'Fatmoose'
--   and lower(s.saleschannelname) = 'fatmoose.at'
 group by o.rest_source, s.saleschannelname
 order by o.rest_source, s.saleschannelname;


select count(*), lower( saleschannelname)
  from wky_saleschannels
 group by lower( saleschannelname)
having count(*) > 1;

select *
  from wky_saleschannels
 where lower( saleschannelname) = 'wickeydream.be'
 ;


 
select count(*), o.rest_source, s.saleschannelname
  from wky_orders o
     , wky_saleschannels s
 where o.scl_id = s.id(+)
   and o.scl_id is null
   --and rest_source = 'Afterbuy'
 group by o.rest_source, s.saleschannelname
 order by o.rest_source, s.saleschannelname;
 
 
select count(*), lower( saleschannelname)
  from wky_saleschannels
 group by lower( saleschannelname)
having count(*) > 1
 ;
 
 
 
 
 
select count(*), saleschannelname
  from wky_saleschannels
 group by saleschannelname
 order by saleschannelname
 ;
 
 
 -- *********************
 

select count(*), s.saleschannelname
  from wky_orders o
     , wky_saleschannels s
 where o.scl_id = s.id(+)
   and o.scl_id is not null
   and lower(s.saleschannelname) = 'fatmoose.de'
 group by s.saleschannelname
 order by s.saleschannelname; 
 
--select * from wky_saleschannels where saleschannelname = 'fatmoose.de';
--delete wky_saleschannels where id in (139477414107611476528555107993747367360,139477414107684012077731985744229737920,139477414107699728113386975923500918208);
 
select count(*)
  from wky_orders
 where scl_id in ( select id
                    from wky_saleschannels
                   where saleschannelname = 'fatmoose.de'
                )
                ;
                
                
                
                
select * from wky_saleschannels where status <> 'CONFIRMED';
update wky_saleschannels set status = 'CONFIRMED' where status <> 'CONFIRMED';
                
