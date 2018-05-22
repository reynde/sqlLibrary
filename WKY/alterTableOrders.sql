select sysdate from dual;

alter table wky_orders
add column group_of_goods varchar2(4000);