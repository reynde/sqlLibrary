select ute.table_name
     , nvl( substr( utt.comments, 1, 3), 'ZZZ') as table_comment
  from user_tables ute
     , user_tab_comments utt
 where ute.table_name = utt.table_name
   and ute.table_name like 'WKY_%'
   and nvl( substr( utt.comments, 1, 3), 'ZZZ') in ('PMD', 'PMT')
--order by 1
order by 2 desc
;

-- Double aliases: TMP, Tab, DPT

comment on table wky_group_of_goods is 'WAR';
comment on table wky_access_levels_t is 'ALS';
comment on table wky_errors_t is 'ERR';
comment on table wky_error_lookup_t is 'ELP'; 
comment on table wky_departments is 'DEP'; 
comment on table wky_bill_of_materials is 'BOM: tree of articles'; 
comment on table wky_complaint_actions_lkp is 'CAN'; 
comment on table wky_depots is 'DPT';  
comment on table wky_depot_postalcodes is 'DPE'; 
comment on table wky_ledger is 'LGR'; 
comment on table wky_mail_htmlemails is 'MHL';  
comment on table wky_mail_statuses_lkp is 'MSS';  
comment on table WKY_PRODUCTION_LOCATION is 'PLN';  
comment on table WKY_SALESCHANNEL_DELIVERY_TIME is 'SDE';  
comment on table WKY_ACCESS_LEVELS_T is 'ALS';  
comment on table WKY_ERROR_LOOKUP_T is 'ELP';  
comment on table WKY_ERRORS_T is 'ERR';  




select ute.table_name
     , nvl( substr( utt.comments, 1, 3), 'ZZZ') as table_comment
  from user_tables ute
     , user_tab_comments utt
 where ute.table_name = utt.table_name
   and ute.table_name like 'WKY_%'
   and nvl( substr( utt.comments, 1, 3), 'ZZZ') = 'ZZZ'
--order by 1
order by 2 desc
;

select count(*)
     , nvl( substr( utt.comments, 1, 3), 'ZZZ') as table_comment
  from user_tables ute
     , user_tab_comments utt
 where ute.table_name = utt.table_name
   and ute.table_name like 'WKY_%'
group by nvl( substr( utt.comments, 1, 3), 'ZZZ')
having count(*) > 1
;

select *
  from wky_paymentmethods_lkp
  ;