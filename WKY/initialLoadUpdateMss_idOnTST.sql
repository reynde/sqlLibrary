select *
  from ( select id, (select countryname from wky_countries where id = cty_id) as country, subject, text, mss_id, cty_id
           from wky_mail_htmlemails
       )
 where country = 'United-Kingdom'
;





begin
    -- Versand_vorbereited TST
    update wky_mail_htmlemails
          set mss_id = 143469652096358405486792216683230184889
     where id IN (144722774007190085148783640574574631802, --for Austria
                  144722774007197338703701328349622868858, --for Belgium
                  144722774007176786964767879653652863866, --for Switzerland
                  144722774007175578038948265024478157690, --for Germany
                  144722774007196129777881713720448162682, --for Spain
                  144722774007192503000422869832924044154, --for France
                  144722774007193711926242484462098750330, --for Italy
                  144722774007194920852062099091273456506, --for The Netherlands
                  144722774007156235225834430957682858874, --for Poland
                  144722774007191294074603255203749337978  --for United-Kingdom
                  );
    -- Missing phone TST              
    update wky_mail_htmlemails
       set mss_id = 143469652096360823338431445941579597241
     where id IN (144722774007213054739356318528894049146, --for Austria
                  144722774007152608448375587070158740346, --for Belgium
                  144722774007211845813536703899719342970, --for Switzerland
                  144722774007210636887717089270544636794, --for Germany
                  144722774007179204816407108912002276218, --for Spain
                  144722774007153817374195201699333446522, --for France
                  144722774007155026300014816328508152698, --for Italy
                  144722774007214263665175933158068755322, --for Netherlands
                  144722774007187667297144411316225219450, --for Poland
                  144722774007180413742226723541176982394  --for United Kingdom
                  );  
  commit;

end;