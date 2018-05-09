select count(*), lxw_action from wky_articles group by lxw_action;
select count(*), lxw_action from wky_bill_of_materials group by lxw_action;
select count(*), lxw_action from wky_orders group by lxw_action;
select count(*), lxw_action from wky_group_of_goods group by lxw_action;
select count(*), lxw_action from wky_customers group by lxw_action;
select count(*), lxw_action from wky_depots group by lxw_action;
select count(*), lxw_action from wky_depot_postalcodes group by lxw_action;
select count(*), lxw_action from wky_saleschannel_delivery_time group by lxw_action;
select count(*), lxw_action from wky_production_location group by lxw_action;
select count(*), lxw_action from wky_packages group by lxw_action;
select count(*), lxw_action from wky_complaints group by lxw_action;
select count(*), lxw_action from wky_complaintconcerningarticle group by lxw_action;
select count(*), lxw_action from wky_complaintconcerningchild group by lxw_action;




select * from wky_complaint_actions_lkp;