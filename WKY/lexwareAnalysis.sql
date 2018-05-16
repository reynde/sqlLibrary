select lkw.auftragsnr, lkw.auftragsdatum, lkw.pk, lkw.kundennr, lkw.bestellnr
     , lkw.*
  from int_mysql_lkwplanung_auftrag lkw
 where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('06052018','ddmmyyyy')
   and lkw.auftragsnr not in  
         ( select lex.auftragsnr 
             from int_lexware_fk_auftrag lex
            where lex.datum_erfassung between to_date('03112017','ddmmyyyy') and to_date('06052018','ddmmyyyy')
         );
         
         
select lex.sheetnr, lex.auftragsnr, lex.kundennr -- 1757
     , lex.*
  from int_lexware_fk_auftrag lex
 where lex.datum_erfassung between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
   and upper( texte_kopftext) not like '%ERSTATTUNG%'
   and lex.auftragsnr not in
         ( select lkw.auftragsnr 
             from int_mysql_lkwplanung_auftrag lkw
            where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
         ) 
; 




--- 
select lex.auftragsnr, lex.datum_erfassung
     , lex.*
  from int_lexware_fk_auftrag lex
 where auftragsnr in 
        (
        select lkw.auftragsnr
          from int_mysql_lkwplanung_auftrag lkw
         where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('06052018','ddmmyyyy')
           and lkw.auftragsnr not in  
                 ( select lex.auftragsnr 
                     from int_lexware_fk_auftrag lex
                    where lex.datum_erfassung between to_date('03112017','ddmmyyyy') and to_date('06052018','ddmmyyyy')
                 )
        )
 ;
 
select lex.auftragsnr, lex.auftragskennung, lex.datum_erfassung, lex.texte_kopftext
     , lex.*
  from int_lexware_fk_auftrag lex
 where auftragsnr in 
         (
          select lex.auftragsnr
            from int_lexware_fk_auftrag lex
           where lex.datum_erfassung between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
             and upper( texte_kopftext) not like '%ERSTATTUNG%'
             and lex.auftragsnr not in
                   ( select lkw.auftragsnr 
                       from int_mysql_lkwplanung_auftrag lkw
                      where lkw.auftragsdatum between to_date('03112017','ddmmyyyy') and to_date('08052018','ddmmyyyy')
                   )
         )          
 ;