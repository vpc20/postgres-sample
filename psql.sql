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
order by 1, 2;

select *, 
  case 
    when channel = 'facebook' or channel = 'twitter' or channel = 'adwords'then 'yes'
    else 'no'
  end as using_internet
from web_events;

select account_id, occurred_at, total,
  CASE
    WHEN total > 500 then 'Over 500'
    WHEN total > 300 and total <= 500 then '301 - 500'
    WHEN total > 100 and total <= 300 then '101 - 300'
    ELSE '100 and under'
  END as total_group
from orders;

select
  CASE
    WHEN total > 500 then 'Over 500'
    WHEN total > 300 and total <= 500 then '301 - 500'
    WHEN total > 100 and total <= 300 then '101 - 300'
    ELSE '100 and under'
  END as total_group,
  sum(total) as total_per_group
from orders
group by 1
order by 1;


SELECT channel,
       AVG(event_count) as avg_event_count
FROM
(SELECT date_trunc('day', occurred_at) as day,
       channel,
       count(*) as event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1,2) subq
GROUP BY 1
ORDER BY 2 DESC;


SELECT * 
FROM orders
where date_trunc ('month', occurred_at) = 
(SELECT date_trunc('month', min(occurred_at)) as min_month
       from orders)
order by occurred_at;


select a.id, a.name, we.channel, count(*)  
from accounts a
join web_events we
on a.id = we.account_id
group by a.id, a.name, we.channel;

select t1.id, t1.name, max(ct)
from (select a.id, a.name, we.channel, count(*) ct
      from accounts a
      join web_events we
	  on a.id = we.account_id
      group by a.id, a.name, we.channel
      order by a.id) t1
group by t1.id, t1.name;

select t3.id, t3.name, t3.channel, t3.ct
from (select a.id, a.name, we.channel, count(*)  ct
      from accounts a
      join web_events we
      on a.id = we.account_id
      group by a.id, a.name, we.channel) t3
join (select t1.id, t1.name, max(ct) maxchan
      from (select a.id, a.name, we.channel, count(*) ct
            from accounts a
            join web_events we 
	          on a.id = we.account_id
            group by a.id, a.name, we.channel
            order by a.id) t1
      group by t1.id, t1.name) t2
on t2.id = t3.id and t2.maxchan = t3.ct
order by t3.id;

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

-- select r.name, sr.id, sr.name srname
-- from region r
-- join sales_reps sr
-- on r.id = sr.region_id;

-- select a.sales_rep_id, sum(o.total_amt_usd)
-- from accounts a
-- join orders o
-- on a.id = o.account_id
-- group by a.sales_rep_id
-- order by a.sales_rep_id;


-- select r.name, sr.id, sr.name srname, sreptot
-- from region r
-- join sales_reps sr
-- on r.id = sr.region_id
-- join (select a.sales_rep_id, sum(o.total_amt_usd) sreptot
--      from accounts a
--      join orders o
--      on a.id = o.account_id
--      group by a.sales_rep_id
--      order by a.sales_rep_id) t1
-- on sr.id = t1.sales_rep_id;

-- select t2.name, max(t2.sreptot) maxsreptot
-- from (select r.name, sr.id, sr.name srname, sreptot
--       from region r
--       join sales_reps sr
--       on r.id = sr.region_id
--       join (select a.sales_rep_id, sum(o.total_amt_usd) sreptot
--            from accounts a
--            join orders o
--            on a.id = o.account_id
--            group by a.sales_rep_id
--            order by a.sales_rep_id) t1
--       on sr.id = t1.sales_rep_id) t2
-- group by t2.name
-- order by t2.name;


select t3.name, t3.srname, t3.sreptot 
from (select name, max(sreptot) maxsreptot
      from (select r.name, sr.name srname, sum(o.total_amt_usd) sreptot
            from region r
            join sales_reps sr
            on r.id = sr.region_id
            join accounts a
            on sr.id = a.sales_rep_id
            join orders o
            on a.id = o.account_id
            group by r.name, sr.name 
            order by r.name, sr.name) t1
      group by name
      order by name) t2
join (select r.name, sr.name srname, sum(o.total_amt_usd) sreptot
      from region r
      join sales_reps sr
      on r.id = sr.region_id
      join accounts a
      on sr.id = a.sales_rep_id
      join orders o
      on a.id = o.account_id
      group by r.name, sr.name 
      order by r.name, sr.name) t3
 on t2.maxsreptot = t3.sreptot; 

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
select count(*)
      from region r
      join sales_reps sr
      on r.id = sr.region_id
      join accounts a
      on sr.id = a.sales_rep_id
      join orders o
      on a.id = o.account_id
where r.name = (select t2.name
                from (select r.name, sum(o.total_amt_usd) regtot
                      from region r
                      join sales_reps sr
                      on r.id = sr.region_id
                      join accounts a
                      on sr.id = a.sales_rep_id
                      join orders o
                      on a.id = o.account_id
                      group by r.name
                      order by r.name) t2
                join (select max(regtot) maxregtot
                      from (select r.name, sum(o.total_amt_usd) regtot
                            from region r
                            join sales_reps sr
                            on r.id = sr.region_id
                            join accounts a
                            on sr.id = a.sales_rep_id
                            join orders o
                            on a.id = o.account_id
                            group by r.name
                            order by r.name) t1) t3
                on t2.regtot = t3.maxregtot);
      
-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
select channel, count(*)
from web_events
where account_id = 4211
group by 1;
order by 1;

select t2.account_id
from (select o.account_id, sum(o.total_amt_usd ) acctot
       from orders o
       join accounts a
       on o.account_id = a.id
       group by 1
       order by 1) t2
join (select max(acctot) maxacctot
      from (select o.account_id, sum(o.total_amt_usd ) acctot
            from orders o
            join accounts a
            on o.account_id = a.id
            group by 1
            order by 1) t1) t3
on t2.acctot = t3.maxacctot;


-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
select account_id, round(avg(total_amt_usd), 2) avgamt
from orders
group by account_id
order by account_id;

select account_id, acctot
from (select account_id, sum(total_amt_usd) acctot
      from orders
      group by 1
      order by 1) t1
order by acctot desc
limit 10;

select t1.account_id, t1.acctot, t2.avgamt
from (select account_id, sum(total_amt_usd) acctot
      from orders
      group by 1
      order by 1) t1
join (select account_id acc_id, round(avg(total_amt_usd), 2) avgamt
      from orders
      group by account_id
      order by account_id) t2
on account_id = acc_id
order by acctot desc
limit 10;

with  t1 as (select account_id, sum(total_amt_usd) acctot
             from orders
             group by 1
             order by 1), 
      t2 as (select account_id acc_id, round(avg(total_amt_usd), 2) avgamt
            from orders
            group by account_id
            order by account_id) 
select t1.account_id, t1.acctot, t2.avgamt
from  t1
join t2
on account_id = acc_id
order by acctot desc
limit 10;

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
with t1 as (select avg(total_amt_usd) avgall
                 from orders),
     t2 as (select account_id, avg(total_amt_usd) avgperacc
            from orders
            group by 1
            order by 1)
select account_id, round(avgperacc,2)
from t2
where t2.avgperacc > (select avgall from t1)
