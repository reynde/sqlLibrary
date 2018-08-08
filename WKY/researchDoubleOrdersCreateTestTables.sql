-- drop objects
drop table rve_orders cascade constraints;
drop table rve_order_lines cascade constraints;

-- create tables
create table rve_orders (
    id                             number not null constraint rve_orders_id_pk primary key,
    order_number                   number
                                   constraint rve_orders_order_number_unq unique not null,
    customer_id                    number not null,
    total_price                    number
)
;

create table rve_order_lines (
    id                             number not null constraint rve_order_lines_id_pk primary key,
    order_id                       number
                                   constraint rve_order_lines_order_id_fk
                                   references rve_orders on delete cascade,
    quantity                       number not null,
    unit_price                     number not null,
    article_number                 number,
    article_name                   varchar2(255)
)
;


-- triggers
create or replace trigger rve_orders_biu
    before insert or update 
    on rve_orders
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
end rve_orders_biu;
/

create or replace trigger rve_order_lines_biu
    before insert or update 
    on rve_order_lines
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
end rve_order_lines_biu;
/


-- indexes
create index rve_order_lines_i1 on rve_order_lines (order_id);
-- load data
 
insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502807549901351770671236824902,
    30,
    5,
    32
);

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502808758827171385300411531078,
    35,
    57,
    31
);

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502809967752990999929586237254,
    80,
    48,
    32
);

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502811176678810614558760943430,
    67,
    69,
    64
);

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502812385604630229187935649606,
    90,
    12,
    88
);

commit;
-- load data
-- load data
 
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502813594530449843817110355782,
    152749262502812385604630229187935649606,
    64,
    40,
    95,
    'Fixed Asset Tracking'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502814803456269458446285061958,
    152749262502808758827171385300411531078,
    7,
    11,
    69,
    'Buying Activity Analysis'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502816012382089073075459768134,
    152749262502808758827171385300411531078,
    72,
    21,
    46,
    'Evaluation Of Compiler Performance'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502817221307908687704634474310,
    152749262502809967752990999929586237254,
    82,
    91,
    18,
    'Participation Rate Improvement'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502818430233728302333809180486,
    152749262502809967752990999929586237254,
    19,
    8,
    74,
    'New Graduate Training'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502819639159547916962983886662,
    152749262502808758827171385300411531078,
    88,
    94,
    100,
    'Evaluation Of Compiler Performance'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502820848085367531592158592838,
    152749262502809967752990999929586237254,
    84,
    50,
    60,
    'Energy Efficiency'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502822057011187146221333299014,
    152749262502807549901351770671236824902,
    21,
    95,
    76,
    'Evaluation Of Compiler Performance'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502823265937006760850508005190,
    152749262502807549901351770671236824902,
    33,
    62,
    44,
    'Documentation Review'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502824474862826375479682711366,
    152749262502809967752990999929586237254,
    79,
    68,
    100,
    'Night Call Reduction'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502825683788645990108857417542,
    152749262502811176678810614558760943430,
    50,
    66,
    100,
    'Reduce Development Cost'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502826892714465604738032123718,
    152749262502809967752990999929586237254,
    85,
    46,
    78,
    'New Graduate Training'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502828101640285219367206829894,
    152749262502812385604630229187935649606,
    86,
    71,
    27,
    'Claim Reduction Plan'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502829310566104833996381536070,
    152749262502812385604630229187935649606,
    23,
    86,
    1,
    'Buying Activity Analysis'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502830519491924448625556242246,
    152749262502812385604630229187935649606,
    92,
    84,
    66,
    'Database Implementation'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502831728417744063254730948422,
    152749262502807549901351770671236824902,
    95,
    80,
    52,
    'Reduce Development Cost'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502832937343563677883905654598,
    152749262502807549901351770671236824902,
    13,
    78,
    86,
    'Demo Development'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080360774,
    152749262502812385604630229187935649606,
    30,
    41,
    20,
    'Release Cycle Change'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502835355195202907142255066950,
    152749262502812385604630229187935649606,
    3,
    80,
    94,
    'Git Migration'
);

insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502836564121022521771429773126,
    152749262502812385604630229187935649606,
    24,
    50,
    48,
    'Availability Optimization'
);

commit;
 
-- Generated by Quick SQL Wednesday August 08, 2018  09:50:17
 
/*
orders /insert 5
  order_number /nn /unique
  customer_id /nn
  total_price num
 order_lines /insert 20
    quantity num /nn
    unit_price num /nn
    article_number
    article_name

# settings = { prefix: "rve", PK: "TRIG", drop: true, language: "EN", APEX: true }
*/


/* Double entries */
insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502812385604630229187935699990,
    99990,
    12,
    100
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399990,
    152749262502812385604630229187935699990,
    30,
    41,
    20,
    'Release Cycle Change'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399991,
    152749262502812385604630229187935699990,
    3,
    80,
    94,
    'Git Migration'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399992,
    152749262502812385604630229187935699990,
    24,
    50,
    48,
    'Availability Optimization'
);
commit;

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502812385604630229187935699991,
    99991,
    12,
    100
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399993,
    152749262502812385604630229187935699991,
    30,
    41,
    20,
    'Release Cycle Change'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399994,
    152749262502812385604630229187935699991,
    3,
    80,
    94,
    'Git Migration'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399995,
    152749262502812385604630229187935699991,
    24,
    50,
    48,
    'Availability Optimization'
);
commit;

insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502812385604630229187935699992,
    99992,
    12,
    100
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399996,
    152749262502812385604630229187935699992,
    30,
    41,
    20,
    'Release Cycle Change'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399997,
    152749262502812385604630229187935699992,
    3,
    80,
    94,
    'Git Migration'
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080399998,
    152749262502812385604630229187935699992,
    24,
    50,
    48,
    'Availability Optimization'
);
commit;

/* Not a double entry */
insert into rve_orders (
    id,
    order_number,
    customer_id,
    total_price
) values (
    152749262502812385604630229187935699995,
    99995,
    12,
    200
);
insert into rve_order_lines (
    id,
    order_id,
    quantity,
    unit_price,
    article_number,
    article_name
) values (
    152749262502834146269383292513080359990,
    152749262502812385604630229187935699995,
    60,
    52,
    20,
    'Release Cycle Change'
);
commit;