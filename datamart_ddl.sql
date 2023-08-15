

CREATE TABLE analysis.dm_rfm_segments (
	user_id int4 NOT NULL,
	recency smallint not null,
	frequency smallint not null,
	monetary_value smallint not null,
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
); 