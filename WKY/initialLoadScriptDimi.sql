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
    -- insert 6330 records on 19-APR-2018
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
    
      
    --
    -- Update existing records that don't come from Lexware
    -- 2690 rows
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
    where lxw_action is null
      and to_char(articlenumber) in (select artikelnr from int_lexware_fk_artikel where bezeichnung is not null);
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
    where artikelnr in (select to_char(articlenumber) from wky_articles);
    
end;

begin
    --
    --
    --
    update wky_orders
    set (oss_id, LXW_ACTION, LXW_DATE, LXW_SHEETNR) = 
    (SELECT
         case when auftragskennung = 3 then (select id from wky_orderstatuses_lkp where lookupcode = 'PAYED') else oss_id end as oss_id,
        'UPDATE' as LXW_ACTION,
        sysdate  as LXW_DATE,
        sheetnr  as LXW_SHEETNR
    from int_lexware_fk_auftrag
    where ordernumber = auftragsnr)
    where ordernumber in (select auftragsnr from int_lexware_fk_auftrag);

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
    FROM int_lexware_fk_warengruppe;    
    
end;