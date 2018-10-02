select sysdate from dual;

select mls.* from wky_mail_loggings mls;
  
select mtp.* from wky_mail_templates mtp;

select * from wky_countries_v;

select * from wky_languages_lkp;
  
create or replace force view wky_mail_loggings_v
as
select mls.mail_id
     , mls.mail_to, mls.mail_cc, mls.mail_bcc, mls.mail_from, mls.mail_reply_to, mls.mail_language
     , mls.date_sent, mls.subject, mls.message_body
     , mls.postmark_feedback, mls.remarks
     --
     , mtp.name as template_name
     , mtp.comments as template_comments
     --
     , odr.id as odr_id
     , odr.ordernumber
     --
     , ctr.id as ctr_id
     , ctr.firstname, ctr.lastname, ctr.company
     , ctr.delcty_id, ctr.bilcty_id
     , dcty.countryname as delivery_country, dcty.iso_code as delivery_country_code
     , bcty.countryname as billing_country, bcty.iso_code as billing_country_code
  from wky_mail_loggings mls
     , wky_mail_templates mtp
     , wky_orders odr
     , wky_customers ctr
     , wky_countries_v dcty
     , wky_countries_v bcty
 where mls.mtp_id = mtp.id
   and mls.odr_id = odr.id (+)
   and mls.ctr_id = ctr.id (+)
   and ctr.delcty_id = dcty.cty_id (+)
   and ctr.bilcty_id = bcty.cty_id (+)
  ;
  
select firstname
     , lastname
     , phonenumber
     , emailaddress
     , iban
     , lge_id
     , company
     , companytaxcode
     --
     , deliveryaddressstreetname
     , deliveryaddresshousenumber
     , deliveryaddresszipcode
     , deliveryaddresscity
     , delcty_id
     , deliveryaddressfirstname
     , deliveryaddresslastname
     , deliveryaddresstitle
     , deliveryaddresscompany
     , deliveryaddressphonenumber
     --
     , billingaddressstreetname
     , billingaddresshousenumber
     , billingaddresszipcode
     , billingaddresscity
     , bilcty_id
     , billingaddressfirstname
     , billingaddresslastname
     , billingaddresstitle
     , billingaddresscompany
     , billingaddressphonenumber
     , billingaddressfax
     , billingaddressmail
  from wky_customers
  ;