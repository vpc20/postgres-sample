SELECT	*
FROM pg_catalog.pg_tables
WHERE  schemaname NOT IN ('pg_catalog', 'information_schema');

SELECT *
FROM information_schema.COLUMNS
WHERE table_name = 'orders';

SELECT *
FROM orders;

SELECT *
FROM orders
LIMIT 10;


SELECT *
FROM orders
ORDER BY occurred_at DESC;

SELECT account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd desc, account_id;

SELECT *
FROM orders
where EXTRACT(YEAR FROM occurred_at) = 2015
  and EXTRACT(MONTH FROM occurred_at) = 12
order by occurred_at;

SELECT *
FROM orders
where occurred_at >= '2015-12-01'  
  and occurred_at <= '2015-12-31'
order by occurred_at;

select id, standard_qty + gloss_qty + poster_qty, total
from orders;

select * from accounts
where name like '%Group%';

select * from accounts
where name in ('Apple', 'Walmart');

select * from accounts
where sales_rep_id not in (321500, 321520);

select * from orders
where occurred_at >= '2015-01-01' and occurred_at <= '2015-01-31'
order by occurred_at;

select * from orders
where occurred_at between '2015-01-01' and '2015-01-31'
order by occurred_at;

select * from orders
where standard_qty = 0 or gloss_qty = 0 or poster_qty = 0;

select * from orders
where (standard_qty = 0 or gloss_qty = 0 or poster_qty = 0 )
and   occurred_at >= '2016-10-01'
order by occurred_at;

SELECT *
FROM orders o
JOIN accounts a ON o.account_id = a.id;

SELECT *
FROM orders o
LEFT JOIN accounts a ON o.account_id = a.id;

SELECT *
FROM orders o
LEFT JOIN accounts a ON o.account_id = a.id
      AND a.sales_rep_id = 321500;

SELECT *
FROM orders o
RIGHT JOIN accounts a ON o.account_id = a.id;

SELECT *
FROM accounts a
where a.id NOT IN (SELECT account_id FROM orders);

SELECT *
FROM accounts
WHERE primary_poc IS NULL;


SELECT COUNT(*) as order_count
FROM orders
WHERE occurred_at BETWEEN '2016-01-01' and '2016-12-31';

-- count non-null primary_poc
SELECT COUNT(primary_poc) primary_poc_count
FROM accounts;

SELECT SUM(standard_qty) as standard,
       SUM(gloss_qty) as gloss,
       SUM(poster_qty) as poster
FROM orders;

SELECT MIN(standard_qty) as min_standard,
       MIN(gloss_qty) as min_gloss,
       MIN(poster_qty) as min_poster,
       MAX(standard_qty) as max_standard,
       MAX(gloss_qty) as max_gloss,
       MAX(poster_qty) as max_poster
FROM orders;

SELECT AVG(standard_qty) as avg_standard,
       AVG(gloss_qty) as avg_gloss,
       AVG(poster_qty) as avg_poster
FROM orders;

SELECT account_id,
       SUM(standard_qty) as standard,
       SUM(gloss_qty) as gloss,
       SUM(poster_qty) as poster
FROM orders
GROUP BY account_id
ORDER BY account_id;

SELECT account_id, channel, count(id) as event_count
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, event_count DESC;

SELECT DISTINCT  account_id, channel
FROM web_events
ORDER BY account_id;

SELECT o.account_id, a.name, SUM(total_amt_usd) as total_amt_usd
FROM orders o
JOIN accounts a ON o.account_id = a.id 
GROUP BY o.account_id, a.name
HAVING SUM(total_amt_usd) >= 250000
ORDER BY total_amt_usd DESC;

SELECT date_trunc('day', occurred_at) as occday, SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY date_trunc('day', occurred_at)
ORDER BY date_trunc('day', occurred_at);

SELECT date_trunc('month', occurred_at) as occmon, SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY date_trunc('month', occurred_at)
ORDER BY date_trunc('month', occurred_at);

select sum(standard_qty)
from orders
where occurred_at between '2013-12-01 00:00:00' and '2013-12-31 23:59:59';

SELECT date_part('dow', occurred_at) as day_of_week,  sum(total) as total_qty
from orders
group by 1
ORDER BY 2 desc;

select account_id,  date_trunc('year', occurred_at), sum(total_amt_usd) 
from orders
group by 1, 2
order by 1, 2;

select account_id, EXTRACT(YEAR FROM occurred_at)::INTEGER as occyr, EXTRACT(MONTH FROM occurred_at)::INTEGER as occmon, sum(total_amt_usd) 
from orders
group by account_id, EXTRACT(YEAR FROM occurred_at), EXTRACT(MONTH FROM occurred_at)
order by account_id, EXTRACT(YEAR FROM occurred_at), EXTRACT(MONTH FROM occurred_at);

select account_id, date_trunc('month', occurred_at), sum(total_amt_usd) 
from orders
group by 1, 2
order by 1, 2

