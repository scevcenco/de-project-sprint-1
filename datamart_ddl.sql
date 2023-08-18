

CREATE TABLE analysis.dm_rfm_segments (
	user_id int4 NOT null primary key,
	recency smallint not null check (recency >= 1 and recency <= 5),
	frequency smallint not null check (frequency >= 1 and frequency <= 5),
	monetary_value smallint not null check (monetary_value >= 1 and monetary_value <= 5)
); 