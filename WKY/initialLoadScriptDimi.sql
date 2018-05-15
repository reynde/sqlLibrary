--
-- ignore following records due to invalid articlenumber
--
SELECT
    artikelnr as articlenumber,
    bezeichnung as articlename,
    beschreibung as description,
    null as canbeordered,
    null as eos,
    gewicht as weight,
    null as volume,
    null as iscomposed,
    null as composedarticlenumber,
    null as standardnumberofpackages,
    null as sre_id, 
    (select 'Y' from int_lexware_fk_stueckliste i where i.unterartikelnr = o.artikelnr and rownum < 2) as ispart,
    (select i.artikelnr from int_lexware_fk_stueckliste i where i.unterartikelnr = o.artikelnr and rownum < 2) as partnumber,
    null as ispartwoodpiece,
    null as woodpiecenumber,
    null as woodtype,
    null as length,
    null as width,
    null as height,
    null as status,
    null as atp_id,
    null as cte_id,
    null as dfm_id,
    null as shipping_minimum_date,
    null as shipping_maximum_date,
    null as load_type,
    'INSERT' as LXW_ACTION,
    sysdate  as LXW_DATE,
    sheetnr  as LXW_SHEETNR
FROM int_lexware_fk_artikel o
WHERE REGEXP_SUBSTR(artikelnr,'[0-9]+') <> artikelnr;  


begin
    --
    -- insert 
    --
    INSERT INTO wky_articles (
        articlenumber,
        articlename,
        description,
        canbeordered,
        eos,
        weight,
        volume,
        iscomposed,
        composedarticlenumber,
        standardnumberofpackages,
        sre_id,
        ispart,
        partnumber,
        ispartwoodpiece,
        woodpiecenumber,
        woodtype,
        length,
        width,
        height,
        status,
        atp_id,
        cte_id,
        dfm_id,
        shipping_minimum_date,
        shipping_maximum_date,
        load_type,
        LXW_ACTION,
        LXW_DATE,
        LXW_SHEETNR
    ) 
    SELECT
        to_number(artikelnr) as articlenumber,
        bezeichnung as articlename,
        beschreibung as description,
        null as canbeordered,
        null as eos,
        gewicht as weight,
        null as volume,
        null as iscomposed,
        null as composedarticlenumber,
        null as standardnumberofpackages,
        null as sre_id, 
        (select 'Y' from int_lexware_fk_stueckliste i where i.unterartikelnr = o.artikelnr and rownum < 2) as ispart,
        (select i.artikelnr from int_lexware_fk_stueckliste i where i.unterartikelnr = o.artikelnr and rownum < 2) as partnumber,
        null as ispartwoodpiece,
        null as woodpiecenumber,
        null as woodtype,
        null as length,
        null as width,
        null as height,
        null as status,
        null as atp_id,
        null as cte_id,
        null as dfm_id,
        null as shipping_minimum_date,
        null as shipping_maximum_date,
        null as load_type,
        'INSERT' as LXW_ACTION,
        sysdate  as LXW_DATE,
        sheetnr  as LXW_SHEETNR
    FROM int_lexware_fk_artikel o
    WHERE to_number(artikelnr) not in (select articlenumber from wky_articles)
      and REGEXP_SUBSTR(artikelnr,'[0-9]+') = artikelnr;
    
    commit;  
end;

begin
    --
    -- Update existing records 
    --
    update wky_articles 
       set
        (articlename,
        description,
        LXW_ACTION,
        LXW_DATE,
        LXW_SHEETNR) = (
    SELECT
        bezeichnung as articlename,
        beschreibung as description,
        'UPDATE' as LXW_ACTION,
        sysdate  as LXW_DATE,
        sheetnr  as LXW_SHEETNR
    FROM int_lexware_fk_artikel 
    WHERE artikelnr = to_char(articlenumber)
    )
    where 1=1
      -- and lxw_action is null
      and to_char(articlenumber) in (select artikelnr from int_lexware_fk_artikel where bezeichnung is not null);
      
    commit;
end;      
    
begin
    --
    --
    --
    INSERT INTO wky_bill_of_materials (
        ate_id,
        part_id,
        quantity,
        sorting_sequence,
        lxw_action,
        lxw_date,
        lxw_sheetnr
    )
    SELECT
        (select id from wky_articles where to_char(articlenumber) = artikelnr) as ate_id,
        (select id from wky_articles where to_char(articlenumber) = unterartikelnr) as part_id,
        menge,
        lfnr,
        'INSERT' as LXW_ACTION,
        sysdate  as LXW_DATE,
        null  as LXW_SHEETNR    
    FROM int_lexware_fk_stueckliste
    where artikelnr in (select to_char(articlenumber) from wky_articles)
      and artikelnr||lfnr not in (select to_char(a.articlenumber)||b.sorting_sequence from wky_articles a, wky_bill_of_materials b
                                  where a.id = b.ate_id
                                 );
    
    commit;
    
--    update wky_bill_of_materials
--       set ( ate_id
--           , part_id
--           , quantity
--           , sorting_sequence
--           , lxw_action
--           , lxw_date
--           ) = (
--                 select (select id from wky_articles where to_char(articlenumber) = artikelnr) as ate_id
--                      , (select id from wky_articles where to_char(articlenumber) = unterartikelnr) as part_id
--                      , menge
--                      , lfnr
--                      , 'INSERT' as lxw_action
--                      , sysdate  as lxw_date
--                   from int_lexware_fk_stueckliste
--                  where artikelnr in (select to_char(articlenumber) from wky_articles)
--                    and artikelnr||lfnr = (select to_char(a.articlenumber)||b.sorting_sequence from wky_articles a, wky_bill_of_materials b
--                                           where a.id = b.ate_id
--                                          )
--               );
--    commit;
    
end;

select sysdate from dual;

begin
    --
    --
    --
    update wky_orders
    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR, lxw_auftragsnr) = 
          (SELECT
               case when auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else oss_id end as oss_id,
              'UPDATE' as LXW_ACTION,
              sysdate  as LXW_DATE,
              sheetnr  as lxw_sheetnr,
              auftragsnr as lxw_auftragsnr
          from int_lexware_fk_auftrag
          where ordernumber = szuserdefined5 and system_created >= to_date( '01012016', 'DDMMYYYY') and rownum<2 )
    where ordernumber in (select szuserdefined5 from int_lexware_fk_auftrag where system_created >= to_date( '01012016', 'DDMMYYYY') );
  commit;
end;

begin
    
    --
    --
    --    
    INSERT INTO wky_group_of_goods (
    group_number,
    parent_group_number,
    group_name,
    sorting_sequence,
    lxw_action,
    lxw_date,
    lxw_sheetnr
    )
    SELECT
    warengrpnr,
    parent,
    bezeichnung,
    null as sorting_sequence,
    'INSERT' as LXW_ACTION,
    sysdate  as LXW_DATE,
    null  as LXW_SHEETNR
    from int_lexware_fk_warengruppe
    where not exists (select group_number from wky_group_of_goods where group_number = warengrpnr);    
    
    commit;
end;

select sysdate from dual;

begin

  --
  --
  --
  update wky_customers
       set
        (lxw_sheetnr,
        lxw_action,
        lxw_date,
        lxw_customer_number) = (
              select
                  sheetnr  as LXW_SHEETNR,
                  'UPDATE' as lxw_action,
                  sysdate  as lxw_date,
                  kundennr as lxw_customer_number
              from int_lexware_fk_kunde
              where lower(anschrift_vorname) = lower(firstname)
                and lower(anschrift_name) = lower(lastname) and rownum < 2
              )
    where lxw_action is null
      and lower(lastname) in (select lower(anschrift_name) from int_lexware_fk_kunde where lower( anschrift_name) is not null)
      ;
  commit;
end;

select sysdate from dual;




begin
  --
  --
  --
  insert into wky_depots 
    ( depot_name
    , crr_id
    , spedition
    , lxw_action
    , lxw_date
    , lxw_pk
    )
    select name
         , null
         , spedition
         , 'INSERT' as lxw_action
         , sysdate  as lxw_date
         , pk       as lxw_pk
    from int_mysql_lkwplanung_depot
    where not exists ( select lxw_pk from wky_depots where lxw_pk = pk)
    ;  

  commit;
  
  update wky_depots
     set ( depot_name, spedition, lxw_action, lxw_date) =
            (
             select name, spedition, 'UPDATE', sysdate
               from int_mysql_lkwplanung_depot
              where pk = lxw_pk
            );
  commit;
  
  
end;



begin
  --
  --
  --
  insert into wky_depot_postalcodes 
    ( dpt_id
    , cty_id
    , postalcode_start
    , postalcode_end
    , lxw_action
    , lxw_date
    , lxw_pk
    )
    select (select id from wky_depots where lxw_pk = depot_fk) as dpt_id
         , (select id from wky_countries where iso_code = land) as cty_id
         , von
         , bis
         , 'INSERT' as lxw_action
         , sysdate  as lxw_date
         , pk       as lxw_pk
    from int_mysql_lkwplanung_depot_has_plz
    where not exists (select lxw_pk from wky_depot_postalcodes where lxw_pk = pk)
    ;   

  commit;
  
  update wky_depot_postalcodes
     set ( dpt_id, cty_id, postalcode_start, postalcode_end, lxw_action, lxw_date) =
           ( select (select id from wky_depots where lxw_pk = depot_fk) as dpt_id
                 , (select id from wky_countries where iso_code = land) as cty_id
                 , von
                 , bis
                 , 'UPDATE' as lxw_action
                 , sysdate  as lxw_date
              from int_mysql_lkwplanung_depot_has_plz
             where pk = lxw_pk
           );
  commit;
end;



begin
  --
  -- Saleschannel 'Fatmoose.ie' was added before this operation.
  --
  insert into wky_saleschannel_delivery_time 
    ( scl_id
    , shipping_method
    , cty_id
    , start_date
    , end_date
    , days_min
    , days_max
    , lxw_action
    , lxw_date
    , lxw_pk
    )
    select ( select id from wky_saleschannels where lower( saleschannelname) = 
                decode( instr( saleschannelname, '.')
                      , 0, lower( webshop)
                      , lower( webshop) || '.' || decode( lower( land), 'uk', 'co.uk', lower(land) )
                      ) 
           ) as scl_id
         , versandart
         , (select id from wky_countries where iso_code = land) as cty_id
         , startdatum
         , enddatum
         , min
         , max
         , 'INSERT' as lxw_action
         , sysdate  as lxw_date
         , pk       as lxw_pk
    from int_mysql_lkwplanung_lieferzeiten
    where not exists (select lxw_pk from wky_saleschannel_delivery_time where lxw_pk = pk)
    ;   

  commit;
  
  update wky_saleschannel_delivery_time
     set ( scl_id, shipping_method, cty_id, start_date, end_date, days_min, days_max, lxw_action, lxw_date) =
           ( select ( select id from wky_saleschannels where lower( saleschannelname) = 
                        decode( instr( saleschannelname, '.')
                              , 0, lower( webshop)
                              , lower( webshop) || '.' || decode( lower( land), 'uk', 'co.uk', lower(land) )
                              ) 
                    ) as scl_id
                  , versandart as shipping_method
                  , (select id from wky_countries where iso_code = land) as cty_id
                  , startdatum
                  , enddatum
                  , min
                  , max
                  , 'UPDATE' as lxw_action
                  , sysdate  as lxw_date
               from int_mysql_lkwplanung_lieferzeiten
              where pk = lxw_pk
           );
  commit;
  
end;



begin
  --
  -- 
  --
  insert into wky_production_location 
    ( name
    , status
    , deleted
    , lxw_action
    , lxw_date
    , lxw_pk
    )
    select packstation
         , status
         , deleted
         , 'INSERT' as lxw_action
         , sysdate  as lxw_date
         , pk       as lxw_pk
    from int_mysql_lkwplanung_packstation
    where not exists (select lxw_pk from wky_production_location where lxw_pk = pk)
    ;   

  commit;
  
  update wky_production_location
     set (name, status, deleted, lxw_action, lxw_date) =
           (  select packstation
                   , status
                   , deleted
                   , 'UPDATE' as lxw_action
                 , sysdate  as lxw_date
                from int_mysql_lkwplanung_packstation
               where pk = lxw_pk
           );
  commit;
end;



begin
  --
  --
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'A', 'US', 'Spontanious retour; Contact customer', 'Y', 'unangemeldete Retour; Kunde kontaktieren' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'B', 'US', 'Return', 'Y', 'retour' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'C', 'US', 'Refund money', 'Y', 'Geld erstatten' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'D', 'US', 'Post delivery of complete tower', 'Y', 'Gesamten Spielturm nachliefern' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'E', 'US', 'Pick up and refund money', 'Y', 'Abholen; Geld erstatten' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'F', 'US', 'Return and then refund money', 'Y', 'retour; dann Geld erstatten' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'G', 'US', 'Pick up and post delivery', 'Y', 'Abholen; nachliefern' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'H', 'US', 'Other', 'Y', 'anders...' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'I', 'US', 'Return and then post delivery', 'Y', 'retour; dann nachliefern' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'J', 'US', 'Post delivery', 'Y', 'nachliefern' );
  --
  insert into wky_complaint_actions_lkp
    ( lookupcode, language, lookupvalue, active, mapping_code )
  values
    ( 'K', 'US', 'Post delivery and return money', 'Y', 'Nachliefern; Geld erstatten' );
  --
  commit;
  
end;

begin
  --
  -- 
  --
  insert into wky_packages
    ( packet_name
    , tower_name
    , file_name
    , number_of_picks
    , pln_id
    , lxw_action
    , lxw_date
    , lxw_pk
    )
    select paket
         , spielturm
         , datei
         , picks
         , (select id from wky_production_location where lxw_pk = packstation_fk) as pln_id
         , 'INSERT' as lxw_action
         , sysdate  as lxw_date
         , pk       as lxw_pk
    from int_mysql_lkwplanung_paketdaten
    where not exists (select lxw_pk from wky_packages where lxw_pk = pk)
    ;   

  commit;
  
  update wky_packages
     set (packet_name, tower_name, file_name, number_of_picks, pln_id, lxw_action, lxw_date) = 
           (  select paket
                   , spielturm
                   , datei
                   , picks
                   , (select id from wky_production_location where lxw_pk = packstation_fk) as pln_id
                   , 'UPDATE' as lxw_action
                   , sysdate  as lxw_date
                from int_mysql_lkwplanung_paketdaten
               where pk = lxw_pk
           );
  commit;
  
end;



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
and c.system_created between to_date('01-JAN-2018','DD-MON-YYYY') and to_date('31-MAR-2018','DD-MON-YYYY')
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





begin
--
--

  INSERT INTO wky_complaintconcerningarticle (
      ate_id,
      oce_id,
      cpt_id,
      status,
      lxw_id,
      lxw_action,
      lxw_date,
      quantity,
      reason_for_complaint
  )
  select 
      (select i.id from wky_articles i where i.articlenumber = a.artikelnr) as ate_id,
      null as oce_id,
      (select i.id from wky_complaints i where i.lxw_id = a.reklamation_id) as cpt_id,
      null as status,
      id,
      'INSERT',
      sysdate,
      menge,
      reklamationsgrund
  FROM int_mysql_reklamation_hauptartikel a
  where a.reklamation_id in (select i.lxw_id  from wky_complaints i)
    and not exists (select lxw_id from wky_complaintconcerningarticle where lxw_id = a.id)
  ;
  commit;
  
  update wky_complaintconcerningarticle
     set (ate_id, oce_id,cpt_id,status,quantity,reason_for_complaint, lxw_action,lxw_date) =
           (  select (select id from wky_articles where articlenumber = artikelnr) as ate_id
                   , null as oce_id
                   , (select id from wky_complaints  where lxw_id = reklamation_id) as cpt_id
                   , null as status
                   , menge as quantity
                   , reklamationsgrund as reason_for_complaint
                   , 'UPDATE'
                   , sysdate
                from int_mysql_reklamation_hauptartikel
               where id = lxw_id
           );
  commit;
end;

select sysdate from dual;

begin
  insert into wky_complaintconcerningarticle 
    ( ate_id
    , oce_id
    , cpt_id
    , status
    , lxw_id
    , lxw_action
    , lxw_date
    , quantity
    , reason_for_complaint
  )
  select 
      (select i.id from wky_articles i where i.articlenumber = a.artikelnr) as ate_id,
      null as oce_id,
      (select i.id from wky_complaints i where i.lxw_id = (select reklamation_id from int_mysql_reklamation_hauptartikel where id = a.reklamation_hauptartikel_id )) as cpt_id,
      null as status,
      id,
      'INSERT',
      sysdate,
      menge,
      reklamationsgrund
  FROM int_mysql_reklamation_artikel a
  where (select reklamation_id from int_mysql_reklamation_hauptartikel where id = a.reklamation_hauptartikel_id ) in (select i.lxw_id  from wky_complaints i)
    and not exists (select lxw_id from wky_complaintconcerningarticle where lxw_id = a.id)
  ;
  commit;
  

end;

-- 11-05-2018

begin
  --
  --
  insert into wky_carriers
    ( lxw_pk
    , lxw_action
    , lxw_date
    , carriername
    , carriercode
    , broker
    , servicelevel_time
    )
    select pk as lxw_pk
         , 'INSERT' as lxw_action
         , sysdate as lxw_date
         , spedition as carriername
         , code as carriercode
         , broker as broker
         , serviceleveltime as servicelevel_time
      from int_mysql_lkwplanung_spedition
     where not exists (select lxw_pk from wky_carriers where lxw_pk = pk)
      ;
  commit;
  -- Missing Carriers
  insert into wky_carriers ( carriername, carriercode)
                    values ( 'Möller', '???');
  insert into wky_carriers ( carriername, carriercode)
                    values ( 'Post', '???');
  insert into wky_carriers ( carriername, carriercode)
                    values ( 'DHL', '???');
  insert into wky_carriers ( carriername, carriercode)
                    values ( 'DSV', '???');
  insert into wky_carriers ( carriername, carriercode)
                    values ( 'freie Spedition', '???');
  commit;
  
  update wky_carriers
     set  ( lxw_action
          , lxw_date
          , carriername
          , carriercode
          , broker
          , servicelevel_time
          ) = 
            ( select 'UPDATE' as lxw_action
                   , sysdate as lxw_date
                   , spedition as carriername
                   , code as carriercode
                   , broker as broker
                   , serviceleveltime as servicelevel_time
                from int_mysql_lkwplanung_spedition
               where pk = lxw_pk
            );
  commit;
end;

begin
  --
  --
  insert into wky_cargoplace
    ( lxw_pk
    , lxw_action
    , lxw_date
    , week
    , day
    , date_created
    , collection_date
    , collection_time
    , crr_id
    , price
    , picks
    , picks_pfp
    , picks_pal
    )
    select pk as lxw_pk
         , 'INSERT' as lxw_action
         , sysdate as lxw_date
         , wochennr as week
         , tagesnr as day
         , erstelldatum as date_created
         , abholdatum as collection_date
         , abholzeit as collection_time
         , ( select id from wky_carriers where carriername = spedition) as crr_id
         , preis as price
         , picks as picks
         , pickspfp as picks_pfp
         , pickspal as picks_pal
      from int_mysql_lkwplanung_lkw
     where not exists (select lxw_pk from wky_cargoplace where lxw_pk = pk)
      ;
    
  commit;
  
  update wky_cargoplace
     set  ( lxw_action
          , lxw_date
          , week
          , day
          , date_created
          , collection_date
          , collection_time
          , crr_id
          , price
          , picks
          , picks_pfp
          , picks_pal
          ) = ( select 'UPDATE' as lxw_action
                     , sysdate as lxw_date
                     , wochennr as week
                     , tagesnr as day
                     , erstelldatum as date_created
                     , abholdatum as collection_date
                     , abholzeit as collection_time
                     , ( select id from wky_carriers where carriername = spedition) as crr_id
                     , preis as price
                     , picks as picks
                     , pickspfp as picks_pfp
                     , pickspal as picks_pal
                  from int_mysql_lkwplanung_lkw
                 where pk = lxw_pk
              );
  commit;
  
end;

begin
  --
  --
  insert into wky_mail_htmlemails
    ( lxw_pk
    , lxw_action
    , lxw_date
    , cty_id
    , subject
    , text
    )
    select pk as lxw_pk
         , 'INSERT' as lxw_action
         , sysdate as lxw_date
         , ( select id from wky_countries where decode(land, 'UK', 'GB', land) = iso_code) as cty_id
         , nvl( betreff, 'No subject') as subject
         , text as text
      from int_mysql_mail_htmlemails
     where not exists (select lxw_pk from wky_mail_htmlemails where lxw_pk = pk)
      ;
  commit;
  
  update wky_mail_htmlemails
     set  ( lxw_action
          , lxw_date
          , cty_id
          , subject
          , text
          ) =
            ( select 'UPDATE' as lxw_action
                   , sysdate as lxw_date
                   , ( select id from wky_countries where decode(land, 'UK', 'GB', land) = iso_code) as cty_id
                   , nvl( betreff, 'No subject') as subject
                   , text as text
                from int_mysql_mail_htmlemails
               where pk = lxw_pk
            );
  commit;
  
end;


--
-- Validations
--
select count(*), lxw_action from wky_articles group by lxw_action;
select count(*), lxw_action from wky_bill_of_materials group by lxw_action;
select count(*), lxw_action from wky_orders group by lxw_action;
select count(*), lxw_action from wky_group_of_goods group by lxw_action;
select count(*), lxw_action from wky_customers group by lxw_action;
select count(*), lxw_action from wky_depots group by lxw_action;
select count(*), lxw_action from wky_depot_postalcodes group by lxw_action;
select count(*), lxw_action from wky_saleschannel_delivery_time group by lxw_action;
select count(*), lxw_action from wky_production_location group by lxw_action;
select count(*), lxw_action from wky_packages group by lxw_action;
select count(*), lxw_action from wky_complaints group by lxw_action;
select count(*), lxw_action from wky_complaintconcerningarticle group by lxw_action;
select count(*), lxw_action from wky_carriers group by lxw_action;
select count(*), lxw_action from wky_cargoplace group by lxw_action;
select count(*), lxw_action from wky_mail_htmlemails group by lxw_action;
