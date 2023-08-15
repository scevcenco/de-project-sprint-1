insert into analysis.dm_rfm_segments (
user_id,
recency,
frequency,
monetary_value)
select rec.user_id as user_id, rec.recency as recency, fre.frequency as frequency, mv.monetary_value as monetary_value
from analysis.tmp_rfm_recency rec
inner join analysis.tmp_rfm_frequency fre on rec.user_id=fre.user_id
inner join analysis.tmp_rfm_monetary_value mv on mv.user_id = rec.user_id;


0	1	5	5
1	4	4	4
2	2	3	3
3	2	3	2
4	4	4	2
5	5	5	5
6	1	2	2
7	4	1	2
8	1	1	2
9	1	3	2

