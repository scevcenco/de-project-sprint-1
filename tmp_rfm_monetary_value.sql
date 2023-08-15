insert into analysis.tmp_rfm_monetary_value (
user_id,
monetary_value
)
select user_id, ntile(5) over (order by payed) as monetary_value
from
(select user_id, sum(payment) as payed  
from analysis.orders
group by user_id) mv