select count(*), o.rest_source, s.saleschannelname
  from wky_orders o
     , wky_saleschannels s
 where o.scl_id = s.id(+)
   and o.scl_id is not null
   --and rest_source = 'Afterbuy'
 group by o.rest_source, s.saleschannelname
 order by o.rest_source;

 

 
 
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
   --and rest_source = 'Afterbuy'
 group by s.saleschannelname
 order by s.saleschannelname; 
 
 
select count(*)
  from wky_orders
 where scl_id = ( select id
                    from wky_saleschannels
                   where saleschannelname = 'wickey.se'
                )
                ;
                
update wky_orders
   set scl_id = ( select id
                    from wky_saleschannels
                   where saleschannelname = 'Wickey.se'
                )
 where scl_id = ( select id
                    from wky_saleschannels
                   where saleschannelname = 'wickey.se'
                )
                ;
                
                
select * from (
select sc.id as sc_id, sc.saleschannelname, (select count(*) from wky_orders where scl_id = sc.id) as times_used_in_orders 
     , (select count(*) from int_greyhound_tickets where scl_id = sc.id) as times_used_in_grey 
  from wky_saleschannels     sc
)
where exists (select 1 from int_greyhound_tickets g where sc_id = g.scl_id)
order by saleschannelname 
  ;                
  
update int_greyhound_tickets
   set scl_id = 133329932584845868526509517721068767965
  where scl_id = 137920312764559155495435891665351133860
  ;