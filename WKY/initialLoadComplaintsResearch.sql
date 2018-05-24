select sysdate from dual;


select count(*)  from wky_complaints;

            select count(*) 
            from int_mysql_reklamation a, int_mysql_kunde b, int_lexware_fk_kunde c 
            where a.kunde_id = b.id
            and b.kundennr_vc = c.kundennr -- to_char(b.kundennr)
            and c.system_created between to_date( '01012016','DDMMYYYY') and to_date( '31052018','DDMMYYYY')
            and not exists (select lxw_id from wky_complaints where lxw_id = a.id)
            and a.id = 36434

select * from wky_complaints;



declare
  l_cnt number := 0;

begin

  for r in (
            select 
                  a.Widerrufsgrund as reasonforcomplaint
                , null as description
                , null as action
                , (select i.id from wky_customers i where i.lxw_sheetnr = c.sheetnr and rownum < 2) as ctr_id
                --, odr_id
                , null as status
                --, cre_id
                , a.kommentar as text
                , a.kontaktart as contact_type
                --, gtt_id
                , (select i.id from wky_complaint_actions_lkp i where i.mapping_code = a.aktion) as can_id
                , decode(a.retour_erhalten,'Nein','N','Ja','Y', null) as return_received
                , a.retour as return1
                , decode(a.retour_angekommen,'Nein','N','Ja','Y', null) as return_arrived
                , a.retour_datum as return_date
                , a.belegnummer as receipt_number
                , a.ueberwiesen as date_booked
                , a.erledigt as date_solved
                , decode(a.schadensrg,'Nein','N','Ja','Y', null) as damaged
                ,  a.schadensrg_betrag as amount_damaged_for
                , 'INSERT' as lxw_action
                , sysdate  as lxw_date
                , a.id       as lxw_id    
            from int_mysql_reklamation a, int_mysql_kunde b, int_lexware_fk_kunde c 
            where a.kunde_id = b.id
            and b.kundennr_vc = c.kundennr -- to_char(b.kundennr)
            and c.system_created between to_date( '01012018','DDMMYYYY') and to_date( '31052018','DDMMYYYY')
            and not exists (select lxw_id from wky_complaints where lxw_id = a.id)
            --and a.id = 36434
           )
  loop
    l_cnt := l_cnt + 1;
    
    insert into wky_complaints 
        ( reasonforcomplaint
        , description
        , action
        , ctr_id
        --, odr_id
        , status
        --, cre_id
        , text
        , contact_type
        --, gtt_id
        , can_id
        , return_received
        , return
        , return_arrived
        , return_date
        , receipt_number
        , date_booked
        , date_solved
        , damaged
        , amount_damaged_for
        , lxw_action
        , lxw_date
        , lxw_id
        )
    values
        ( r.reasonforcomplaint
        , r.description
        , r.action
        , r.ctr_id
        , r.status
        , r.text
        , r.contact_type
        , r.can_id
        , r.return_received
        , r.return1
        , r.return_arrived
        , r.return_date
        , r.receipt_number
        , r.date_booked
        , r.date_solved
        , r.damaged
        , r.amount_damaged_for
        , r.lxw_action
        , r.lxw_date
        , r.lxw_id
        );
    
    if l_cnt >= 500
    then
      l_cnt := 0;
      commit;
    end if;
    
  end loop;

  commit;

end;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
--
-- OLD CODE
--
begin
  --
  -- 
  --
  insert into wky_complaints
    ( reasonforcomplaint
    , description
    , action
    , ctr_id
    --, odr_id
    , status
    --, cre_id
    , text
    , contact_type
    --, gtt_id
    , can_id
    , return_received
    , return
    , return_arrived
    , return_date
    , receipt_number
    , date_booked
    , date_solved
    , damaged
    , amount_damaged_for
    , lxw_action
    , lxw_date
    , lxw_id
    )
select 
      a.Widerrufsgrund as reasonforcomplaint
    , null as description
    , null as action
    , (select i.id from wky_customers i where i.lxw_sheetnr = c.sheetnr and rownum < 2) as ctr_id
    --, odr_id
    , null as status
    --, cre_id
    , a.kommentar as text
    , a.kontaktart as contact_type
    --, gtt_id
    , (select i.id from wky_complaint_actions_lkp i where i.mapping_code = a.aktion) as can_id
    , decode(a.retour_erhalten,'Nein','N','Ja','Y', null) as return_received
    , a.retour as return1
    , decode(a.retour_angekommen,'Nein','N','Ja','Y', null) as return_arrived
    , a.retour_datum as return_date
    , a.belegnummer as receipt_number
    , a.ueberwiesen as date_booked
    , a.erledigt as date_solved
    , decode(a.schadensrg,'Nein','N','Ja','Y', null) asdamaged
    ,  a.schadensrg_betrag as amount_damaged_for
    , 'INSERT' as lxw_action
    , sysdate  as lxw_date
    , a.id       as lxw_id    
from int_mysql_reklamation a, int_mysql_kunde b, int_lexware_fk_kunde c 
where a.kunde_id = b.id
and to_char(b.kundennr) = c.kundennr
and trunc( c.system_created) between to_date( '01012016','DDMMYYYY') and to_date( '31052018','DDMMYYYY')
and not exists (select lxw_id from wky_complaints where lxw_id = a.id)
    ;    
  commit;
  
--  update wky_complaints
--     set (  reasonforcomplaint
--          , description
--          , action
--          , ctr_id
--          --, odr_id
--          , status
--          --, cre_id
--          , text
--          , contact_type
--          --, gtt_id
--          , can_id
--          , return_received
--          , return
--          , return_arrived
--          , return_date
--          , receipt_number
--          , date_booked
--          , date_solved
--          , damaged
--          , amount_damaged_for
--          , lxw_action
--          , lxw_date
--         ) = ( select a.Widerrufsgrund as reasonforcomplaint
--                    , null as description
--                    , null as action
--                    , (select i.id from wky_customers i where i.lxw_sheetnr = c.sheetnr and rownum < 2) as ctr_id
--                    --, odr_id
--                    , null as status
--                    --, cre_id
--                    , a.kommentar as text
--                    , a.kontaktart as contact_type
--                    --, gtt_id
--                    , (select i.id from wky_complaint_actions_lkp i where i.mapping_code = a.aktion) as can_id
--                    , decode(a.retour_erhalten,'Nein','N','Ja','Y', null) as return_received
--                    , a.retour as return1
--                    , decode(a.retour_angekommen,'Nein','N','Ja','Y', null) as return_arrived
--                    , a.retour_datum as return_date
--                    , a.belegnummer as receipt_number
--                    , a.ueberwiesen as date_booked
--                    , a.erledigt as date_solved
--                    , decode(a.schadensrg,'Nein','N','Ja','Y', null) asdamaged
--                    ,  a.schadensrg_betrag as amount_damaged_for
--                    , 'UPDATE' as lxw_action
--                    , sysdate  as lxw_date  
--                from int_mysql_reklamation a, int_mysql_kunde b, int_lexware_fk_kunde c 
--                where a.kunde_id = b.id
--                and to_char(b.kundennr) = c.kundennr
--                and c.system_created between to_date('01-JAN-2018','DD-MON-YYYY') and to_date('31-MAR-2018','DD-MON-YYYY')
--                and a.id = lxw_id
--             );
--  commit;

end;

