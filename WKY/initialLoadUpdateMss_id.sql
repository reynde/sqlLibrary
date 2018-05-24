select *
  from wky_mail_statuses_lkp;
  
  
  /*
  -- Versand_vorbereited DEV
      update wky_mail_htmlemails
          set mss_id = 143469652096358405486792216683230184889
     where id IN (143469652096456328478181001646381385145, --for Austria
                  143469652096463582033098689421429622201, --for Belgium
                  143469652096443030294165240725459617209, --for Switzerland
                  143469652096441821368345626096284911033, --for Germany
                  143469652096462373107279074792254916025, --for Spain
                  143469652096458746329820230904730797497, --for France
                  143469652096459955255639845533905503673, --for Italy
                  143469652096461164181459460163080209849, --for Netherlands
                  143469652096422478555231792029489612217, --for Poland
                  143469652096457537404000616275556091321  --for United Kingdom
                  );
    -- Missing phone DEV              
    update wky_mail_htmlemails
       set mss_id = 143469652096360823338431445941579597241
     where id IN (143469652096479298068753679600700802489, --for Austria
                  143469652096418851777772948141965493689, --for Belgium
                  143469652096478089142934064971526096313, --for Switzerland
                  143469652096476880217114450342351390137, --for Germany
                  143469652096445448145804469983809029561, --for Spain
                  143469652096420060703592562771140199865, --for France
                  143469652096421269629412177400314906041, --for Italy
                  143469652096480506994573294229875508665, --for Netherlands
                  143469652096453910626541772388031972793, --for Poland
                  143469652096446657071624084612983735737  --for United Kingdom
                  );              
  
  */
  
  
-- DEV
select id, (select countryname from wky_countries where id = cty_id) as country, subject, text, mss_id, cty_id
  from wky_mail_htmlemails
 where id = 143469652096446657071624084612983735737
  ;
  