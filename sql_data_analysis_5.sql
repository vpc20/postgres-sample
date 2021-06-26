-- In the accounts table, there is a column holding the website for each company. 
-- The last three digits specify what type of web address they are using. 
-- A list of extensions (and pricing) is provided here. 
-- Pull these extensions and provide how many of each website type exist in the accounts table.

select distinct right(website,3) ext, count(*)
from accounts
group by 1
order by 2 desc;


-- There is much debate about how much the name (or even the first letter of a company name) matters. 
-- Use the accounts table to pull the first letter of each company name to see the distribution of 
-- company names that begin with each letter (or number). 

select  lower(left(name, 1)) first_ltr, count(*)
from accounts
group by 1
order by 2 desc;

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

select round(count(*)::decimal / (select count(*) from accounts) * 100, 2)
from accounts
where lower(left(name, 1)) in ('a', 'e', 'i', 'o', 'u');


-- Use the accounts table to create first and last name columns that hold the first 
-- and last names for the primary_poc

select substr(name, 1, position(' ' in name) - 1) first_name,
       substr(name, position(' ' in name) + 1) last_name
from sales_reps;

-- Each company in the accounts table wants to create an email address for each primary_poc. 
-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
-- You may have noticed that in the previous solution some of the company names include spaces, which will 
-- certainly not work in an email address. See if you can create an email address that will work by removing 
-- all of the spaces in the account name.
select lower(substr(primary_poc, 1, position(' ' in primary_poc) - 1)) || '.' ||
       lower (substr(primary_poc, position(' ' in primary_poc) + 1)) || '@' ||
       lower(replace(name, ' ', '')) || '.com'
from accounts;

-- We would also like to create an initial password, which they will change after their first log in. 
-- The first password will be the first letter of the primary_poc's first name (lowercase), 
-- then the last letter of their first name (lowercase), the first letter of their last name (lowercase), 
-- the last letter of their last name (lowercase), the number of letters in their first name, 
-- the number of letters in their last name, and then the name of the company they are working with, 
-- all capitalized with no spaces. 

select lower(substr(primary_poc, 1, position(' ' in primary_poc) - 1)),
       lower (substr(primary_poc, position(' ' in primary_poc) + 1)),
       lower(left(primary_poc,1)),
       substr(primary_poc, 1, position(' ' in primary_poc) - 1)
      --  left(lower(substr(primary_poc, 1, position(' ' in primary_poc) - 1)), 1),
from accounts
;


