select table_name from all_tables where table_name like 'WKY%LKP';

select 'select * from ' || table_name || ';' from all_tables where table_name like 'WKY%LKP';



select * from wky_carriertypes_lkp; -- 2
select * from wky_carrierpreferances_lkp; -- 0
select * from wky_contractrecordingtypes_lkp; -- 0
select * from wky_daysofweek_lkp; -- 7
select * from wky_deliveryforms_lkp; -- 2
select * from wky_ticketstatuses_lkp; -- 7
select * from wky_languages_lkp; -- 12
select * from wky_orderstatuses_lkp; -- 10
select * from wky_packagetypes_lkp; -- 0
select * from wky_paymentmethods_lkp; -- 5
select * from wky_paymentstatuses_lkp; -- 7
select * from wky_returnvalues_lkp; -- 0
select * from wky_shipmentstatuses_lkp; -- 0
select * from wky_companies_lkp; -- 3
 
select * from wky_mail_statuses_lkp; -- 6
select * from wky_complaint_actions_lkp; -- 11
select * from wky_complaint_reasons_lkp; -- 20
select * from wky_contact_types_lkp; -- 5
select * from wky_return_reasons_lkp; -- 11
select * from wky_tickettype_lkp; -- 6
