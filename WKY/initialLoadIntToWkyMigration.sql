-- Initial Load: INT to WKY migration
select sysdate from dual;

--
-- Ignore following records due to invalid articlenumber
--
 select artikelnr as articlenumber
      , bezeichnung as articlename
      , beschreibung as description
      , null as canbeordered
      , null as eos
      , gewicht as weight
      , null as volume
      , null as iscomposed
      , null as composedarticlenumber
      , null as standardnumberofpackages
      , null as sre_id
      , (select 'Y'
           from int_lexware_fk_stueckliste i
          where i.unterartikelnr = o.artikelnr
            and rownum < 2
        ) as ispart
      , (select i.artikelnr
           from int_lexware_fk_stueckliste i
          where i.unterartikelnr = o.artikelnr
            and rownum < 2
        ) as partnumber
      , null as ispartwoodpiece
      , null as woodpiecenumber
      , null as woodtype
      , null as length
      , null as width
      , null as height
      , null as status
      , null as atp_id
      , null as cte_id
      , null as dfm_id
      , null as shipping_minimum_date
      , null as shipping_maximum_date
      , null as load_type
      , 'INSERT' as lxw_action
      , sysdate as lxw_date
      , sheetnr as lxw_sheetnr
   from int_lexware_fk_artikel o
  where regexp_substr( artikelnr, '[0-9]+') <> artikelnr;
  
--
-- FK_ARTIKEL to WKY_ARTICLES
--
begin
  cnv_dataconversion_pkg.int_lexware_fk_artikel;
  commit;
end;

--
-- FK_STUECKLISTE to WKY_BILL_OF_MATERIALS
--
begin
  cnv_dataconversion_pkg.int_lexware_fk_stueckliste;
  commit;
end;

--
-- FK_AUFTRAG to WKY_ORDERS
--
begin
  cnv_dataconversion_pkg.int_lexware_fk_auftrag;
  commit;
end;

--
-- FK_WARENGRUPPE to WKY_GROUP_OF_GOODS
--
begin
  cnv_dataconversion_pkg.int_lexware_fk_warengruppe;
  commit;
end;

--
-- FK_KUNDE to WKY_CUSTOMERS
--
begin
  cnv_dataconversion_pkg.int_lexware_fk_kunde;
  commit;
end;

--
-- LKWPLANUNG_DEPOT to WKY_DEPOTS
--
begin
  cnv_dataconversion_pkg.int_mysql_lkwplanung_depot;
  commit;
end;

--
-- LKWPLANUNG_DEPOT_HAS_PLZ to WKY_DEPOT_POSTALCODES
--
begin
  cnv_dataconversion_pkg.int_mysql_lkwplanung_depot_has_plz;
  commit;
end;

--
-- LKWPLANUNG_LIEFERZEITEN to WKY_SALESCHANNEL_DELIVERY_TIME
--
begin
  cnv_dataconversion_pkg.int_mysql_lkwplanung_lieferzeiten;
  commit;
end;

--
-- LKWPLANUNG_PACKSTATION to WKY_PRODUCTION_LOCATION
--
begin
  cnv_dataconversion_pkg.int_mysql_lkwplanung_packstation;
  commit;
end;

--
-- LKWPLANUNG_PAKETDATEN to WKY_PACKAGES
--
begin
  cnv_dataconversion_pkg.int_mysql_lkwplanung_paketdaten;
  commit;
end;

--
-- REKLAMMATION to WKY_COMPLAINTS
--
begin
  cnv_dataconversion_pkg.int_mysql_reklamation;
  commit;
end;

--
-- REKLAMMATION_HAUPTARTIKEL to WKY_COMPLAINTCONCERNINGARTICLE
--
begin
  cnv_dataconversion_pkg.int_mysql_reklamation_hauptartikel;
  commit;
end;

--
-- REKLAMMATION_ARTIKEL to WKY_COMPLAINTCONCERNINGCHILD
--
begin
  cnv_dataconversion_pkg.int_mysql_reklamation_artikel;
  commit;
end;
