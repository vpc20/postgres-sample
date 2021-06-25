-- In the accounts table, there is a column holding the website for each company. 
-- The last three digits specify what type of web address they are using. 
-- A list of extensions (and pricing) is provided here. 
-- Pull these extensions and provide how many of each website type exist in the accounts table.

select distinct right(website,3) ext, count(*)
from accounts
group by 1
order by 1;


-- There is much debate about how much the name (or even the first letter of a company name) matters. 
-- Use the accounts table to pull the first letter of each company name to see the distribution of 
-- company names that begin with each letter (or number). 

select  lower(left(name, 1)) first_ltr, count(*)
from accounts
group by 1
order by 1;

-- Use the accounts table and a CASE statement to create two groups: one group of company names that 
-- start with a number and a second group of those company names that start with a letter. 
-- What proportion of company names start with a letter?

with t1 as (select name,
                   CASE
                      WHEN lower(left(name, 1)) between 'a' and 'z' then 'ltrgrp'
                      ELSE 'numgrp'
                   END as accgrp 
            from accounts)
select round(count(*)::decimal / (select count(*) from accounts) * 100, 2)
from t1
where accgrp = 'ltrgrp';


-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, 
-- and what percent start with anything else? 

