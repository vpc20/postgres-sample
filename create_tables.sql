CREATE TABLE region(
	id integer PRIMARY KEY,
	name VARCHAR (50) NOT NULL
);

COPY region FROM 'C:\Users\public\region.csv' DELIMITER ',' CSV;


CREATE TABLE sales_reps(
    id integer PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    region_id integer NOT NULL
);

COPY sales_reps FROM 'C:\Users\public\sales_reps.csv' DELIMITER ',' CSV;

CREATE TABLE accounts(
    id INTEGER PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    website TEXT,
    lat NUMERIC, 
    long NUMERIC,
    primary_poc VARCHAR (50) NOT NULL,
    sales_rep_id INTEGER
);

COPY accounts FROM 'C:\Users\public\accounts.csv' DELIMITER ',' CSV;

CREATE TABLE orders(
    id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    standard_qty INTEGER,
    gloss_qty INTEGER,
    poster_qty INTEGER,
    total INTEGER,
    standard_amt_usd NUMERIC,
    gloss_amt_usd NUMERIC,
    poster_amt_usd NUMERIC,
    total_amt_usd NUMERIC
);

COPY orders FROM 'C:\Users\public\orders.csv' DELIMITER ',' CSV;

CREATE TABLE web_events(
    id INTEGER PRIMARY KEY,
    account_id INTEGER,
    occurred_at TIMESTAMP,
    channel VARCHAR (25)
);

COPY web_events FROM 'C:\Users\public\web_events.csv' DELIMITER ',' CSV;
