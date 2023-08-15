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