insert into analysis.tmp_rfm_frequency (
user_id,
frequency
)
select user_id, ntile(5) over (order by order_quantity) as frequency
from
(select user_id, count(order_id) as order_quantity  
from analysis.orders
group by user_id) f;