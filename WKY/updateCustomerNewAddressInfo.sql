


            select count(*)
              from int_afterbuy_orders
             where 1=1
               --and orderid = 442266548
               and lower( street) <> lower( shippingstreet)
             ;

declare
  l_cnt number := 0;
begin
  dbms_output.put_line('START UPDATE');
  for r in (
            select *
              from int_afterbuy_orders
             where lower( street) <> lower( shippingstreet)
               -- and orderid = 442266548
           )
  loop
    l_cnt := l_cnt + 1;
    -- dbms_output.put_line('UPDATING ' || r.orderid);
    update wky_customers
       set deliveryaddressfirstname = r.shippingfirstname
         , deliveryaddresslastname = r.shippinglastname
         , deliveryaddresstitle = r.title
         , deliveryaddresscompany = r.shippingcompany
         , deliveryaddressstreetname2 = r.shippingstreet2
         , deliveryaddressprovince = r.shippingstateorprovince
         , deliveryaddressphonenumber = r.shippingphone
         , billingaddressfax = r.fax
         , billingaddressmail = r.mail
         , billingaddressfirstname = r.firstname
         , billingaddresslastname = r.lastname
         , billingaddresstitle = r.title
         , billingaddresscompany = r.company
         , billingaddressstreetname2 = r.street2
         , billingaddressprovince = r.stateorprovince
         , billingaddressphonenumber = r.phone
     where id = (
                          select ctr_id
                            from wky_orders
                           where ordernumber = to_char( r.orderid)
                );
             
  
  end loop;

  dbms_output.put_line( l_cnt || ' lines updated.');
  dbms_output.put_line('END UPDATE');

end;
