select * from users;

select id as user_id from users;

select id from orderstatuses where "key"='Closed';

select * from orders;

select user_id, date_trunc('day', order_ts)::date as last_order_dt
from orders 
where status=(select id from orderstatuses where "key"='Closed'); --4.991 orders closed


select u.id, o.order_id
from users u 
left join orders o 
on u.id=o.user_id
where order_id is null; --no users without orders

select user_id, row_number() over (partition by user_id order by order_ts desc)
from orders 
where status=(select id from orderstatuses where "key"='Closed'); -- row number


select user_id, date_trunc('day', order_ts)::date as last_order_dt
from 
(select user_id, order_ts, row_number() over (partition by user_id order by order_ts desc) rn
from orders 
where status=(select id from orderstatuses where "key"='Closed'))n
where rn=1; --user_id + date of last order

select user_id, ntile(5) over (order by last_order_dt) as recency
from
(select user_id, date_trunc('day', order_ts)::date as last_order_dt
from 
(select user_id, order_ts, row_number() over (partition by user_id order by order_ts desc) rn
from orders 
where status=(select id from orderstatuses where "key"='Closed'))r
where rn=1) rr
order by user_id; --recency metric done!!!

select user_id, ntile(5) over (order by order_quantity) as frequency
from
(select user_id, count(order_id) as order_quantity  
from orders
group by user_id) f
order by user_id; --frequency metric done!!!

select user_id, payed, ntile(5) over (order by payed) as monetary_value
from
(select user_id, sum(payment) as payed  
from orders
group by user_id) mv
order by user_id; --monetary value done!!!

select count(id), count (distinct id) from users;
select count(order_id), count (distinct order_id) from orders;

select payment 
from orders
where payment is null;

select order_ts  
from orders
where order_ts  is null;

CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

insert into analysis.tmp_rfm_recency (
user_id,
recency
)
select user_id, ntile(5) over (order by order_ts) as recency
from
(select user_id, order_ts
from 
(select user_id, order_ts, row_number() over (partition by user_id order by order_ts desc) rn
from analysis.orders 
where status=(select id from analysis.orderstatuses where "key"='Closed'))r
where rn=1) rr;

CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

insert into analysis.tmp_rfm_frequency (
user_id,
frequency
)
select user_id, ntile(5) over (order by order_quantity) as frequency
from
(select user_id, count(order_id) as order_quantity  
from analysis.orders
group by user_id) f;

CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);