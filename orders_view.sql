create or replace view analysis.orders as
with l as(
select order_id, status_id, dttm
from
(select order_id, status_id, dttm, (row_number() over (partition by order_id order by dttm desc)) last_dttm
from production.orderstatuslog)t
where last_dttm = 1
)
select o.order_id, o.order_ts, o.user_id, o.bonus_payment, o.payment, o."cost", o.bonus_grant, l.status_id as status
from production.orders o
inner join l on o.order_id=l.order_id;