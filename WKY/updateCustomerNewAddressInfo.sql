select *
  from int_afterbuy_orders
 where orderid = 442266548
  ;
  
  
select id
  from wky_customers
 where firstname = 'Maren'
   and lastname = 'Werner'
   and id = (
            select ctr_id
              from wky_orders
             where ordernumber = '442266548'
            )
 ;
 


update wky_customers
   set deliveryaddressfirstname = 'rveTest'
     , deliveryaddresslastname = 'rveTest'
     , deliveryaddresstitle = 'rveTest'
     , deliveryaddresscompany = 'rveTest'
     , deliveryaddressstreetname2 = 'rveTest'
     , deliveryaddressprovince = 'rveTest'
     , deliveryaddressphonenumber = 'rveTest'
     , deliveryaddressfax = 'rveTest'
     , deliveryaddressmail = 'rveTest'
     , billingaddressfirstname = 'rveTest'
     , billingaddresslastname = 'rveTest'
     , billingaddresstitle = 'rveTest'
     , billingaddresscompany = 'rveTest'
     , billingaddressstreetname2 = 'rveTest'
     , billingaddressprovince = 'rveTest'
     , billingaddressphonenumber = 'rveTest'
  where id = (
              select id
                from wky_customers
               where firstname = 'Maren'
                 and lastname = 'Werner'
                 and id = (
                          select ctr_id
                            from wky_orders
                           where ordernumber = '442266548'
                          )
             )
;

