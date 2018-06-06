declare
    l_pmt_id number;
    l_cry_id number;
    l_odr_id number;
    l_pss_id number;
    l_oss_id wky_orders.oss_id%type;  
    l_totalprice wky_orders.totalprice%type;  
    l_status varchar2(1000);    
  begin
    apex_debug.message(p_message => 'WKY KSK: begin match payments', p_level => 3);            

    for r in (SELECT
                    id,
                    file_id,
                    row_version,
                    auftragskonto,
                    to_date(buchungstag,'DD.MM.YY') as Buchungstag,
                    valutadatum,
                    buchungstext,
                    verwendungszweck,
                    glaeubiger_id,
                    mandatsreferenz,
                    kundenreferenz,
                    sammlerreferenz,
                    lastschrift,
                    auslagenersatz,
                    beguenstigter,
                    kontonummer_iban,
                    bic,
                    to_number(replace(replace(betrag,'.',''),',',',')) as betrag, -- remove . from file and replace , by .
                    waehrung_currency,
                    info,
                    pmt_id,
                    created,
                    created_by,
                    updated,
                    updated_by
                from wky_ksk_csvs
                where pmt_id is null)
              -- where file_id = p_file_id)
    loop
      -- find currency
      begin
        select id
          into l_cry_id
          from wky_currencies
         where currencyname = r.waehrung_currency;
      exception
      when no_data_found
      then 
         -- we will ignore this
         l_cry_id := null;
      end;

      -- find status
      select id
        into l_pss_id
        from wky_paymentstatuses_lkp
       where lookupcode = 'TT';

      -- try to find the order
      begin
        begin
          select id, totalprice
            into l_odr_id, l_totalprice
            from wky_orders
          where replace(replace(r.verwendungszweck,'-',''),' ','') like '%'||  replace(replace(ordernumber,'-',''),' ','') ||'%'
            and id not in (select odr_id from wky_payments where odr_id is not null); -- remove incase of perf issue

        exception
        when others then
            begin
              select o.id, o.totalprice
                into l_odr_id, l_totalprice
                from wky_orders o, wky_customers c
              where o.ctr_id = c.id
                and trunc(o.orderdate) <= trunc(r.Buchungstag)
                and trim(replace(lower(r.beguenstigter),' ','')) like '%' || trim(replace(lower(c.lastname),' ','')) || '%'
                and o.totalprice = r.betrag
                and o.id not in (select odr_id from wky_payments where odr_id is not null); -- remove incase of perf issue
            exception
            when no_data_found then
                l_odr_id := null;
                l_totalprice := null;
            when too_many_rows
            then
                l_odr_id := null;
                l_totalprice := null;
            end;
        end;

        -- set the status
        if l_totalprice > r.betrag
        then
          l_status := r.info || ' - Payment is not sufficient.';
        elsif l_totalprice < r.betrag
        then
          l_status := r.info || ' - Payment is too much.';  
        else
          l_status := r.info;  
        end if;

        -- insert payment record when order found
        insert into wky_payments (paymentdate, odr_id, cry_id, paymentamount, status, pss_id)
        values (r.Buchungstag, l_odr_id, l_cry_id, r.betrag, l_status, l_pss_id)
        returning id into l_pmt_id;

        -- update record with link to payment
        update wky_ksk_csvs
           set pmt_id = l_pmt_id
         where id = r.id;     

        -- update the order and set oss_id to PAYED
        select id
          into l_oss_id
          from wky_orderstatuses_lkp
         where active = 'Y'
           and nvl( language, 'US') = 'US'
           and lookupcode = 'PAYED';

        update wky_orders
           set oss_id = l_oss_id
         where id = l_odr_id;

      exception
      when no_data_found
      then
        l_status := r.info || ' - No automated match.';

        -- no order found, create payment record with empty order id
        insert into wky_payments (paymentdate, odr_id, cry_id, paymentamount, status, pss_id)
        values (r.Buchungstag, null, l_cry_id, r.betrag, l_status, l_pss_id)
        returning id into l_pmt_id;

        -- update record with link to payment
        update wky_ksk_csvs
           set pmt_id = l_pmt_id
         where id = r.id;     

      end;     
    end loop;

    apex_debug.message(p_message => 'WKY KSK: end match payments', p_level => 3);            
end;