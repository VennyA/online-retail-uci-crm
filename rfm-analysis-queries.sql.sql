select * from online_retail;


select * from online_retail
where customerid is not null
and invoiceno not like 'C%'
and StockCode ~ '[0-9]'
and Quantity > 0
and unitprice > 0;


create table online_retails as
select * from online_retail
where customerid is not null
and invoiceno not like 'C%'
and StockCode ~ '[0-9]'
and Quantity > 0
and unitprice > 0;


select * from online_retails;


select 
Sum(quantity * Unitprice) Total_Revenue
from online_retails;


select count (distinct customerid) Total_Customer
from online_retails;


ALTER TABLE online_retails 
ALTER COLUMN invoicedate TYPE TIMESTAMP 
USING TO_TIMESTAMP(invoicedate, 'MM/DD/YYYY HH24:MI');


with Recency as(
select customerid,
'2011-12-10' :: date - max(invoicedate) :: date as Recency
from online_retails 
group by customerid
),
Frequency as(
select customerid, count (distinct invoiceno) as Frequency
from online_retails 
group by customerid
),
Monetary as(
select customerid, 
sum(quantity * unitprice) as Monetary
from online_retails 
group by customerid
),
rfm_scoring as(
select r.customerid, r.recency,f.frequency,m.monetary,
ntile(4) over (order by recency DESC) as r_score,
ntile(4) over (order by frequency ) as f_score,
ntile(4) over (order by monetary ) as m_score
from recency r join frequency f
on r.customerid = f.customerid
join monetary m on 
f.customerid = m.customerid),
rfm_segments AS (
select *,
case 
when r_score = 4 and f_score = 4 and m_score =4 then 'champions'
when r_score >=3 and f_score >=3 then 'loyal_Customers'
when r_score =1 and f_score =1 then 'Lost'
when r_score <= 2 and f_score <=2 then 'hibernating'
when r_score >=2 and f_score >=2 then 'at_risk'
when r_score <=2 and f_score >=3 then 'cannot_lose_them'
when r_score>=4 and f_score <=2 then 'new_customers'
when r_score = 3 and f_score <= 2 then 'need_attention'
else 'others'
end as segments
from rfm_scoring
),
Churn_Risk as (
select *,
case when recency >= 180 then 'At_risk_of_churn'
else 'Active' end as Churn_risks
from rfm_segments
),
Churn as (
select *,
case when  churn_risks = 'At_risk_of_churn' then 1 else 0 end as Churn_Flag
from Churn_Risk
)
select * from churn;



with Recency as(
select customerid,
'2011-12-10' :: date - max(invoicedate) :: date as Recency
from online_retails 
group by customerid
),
Frequency as(
select customerid, count (distinct invoiceno) as Frequency
from online_retails 
group by customerid
),
Monetary as(
select customerid, 
sum(quantity * unitprice) as Monetary
from online_retails 
group by customerid
),
rfm_scoring as(
select r.customerid, r.recency,f.frequency,m.monetary,
ntile(4) over (order by recency DESC) as r_score,
ntile(4) over (order by frequency ) as f_score,
ntile(4) over (order by monetary ) as m_score
from recency r join frequency f
on r.customerid = f.customerid
join monetary m on 
f.customerid = m.customerid),
rfm_segments AS (
select *,
case 
when r_score = 4 and f_score = 4 and m_score =4 then 'champions'
when r_score >=3 and f_score >=3 then 'loyal_Customers'
when r_score =1 and f_score =1 then 'Lost'
when r_score <= 2 and f_score <=2 then 'hibernating'
when r_score >=2 and f_score >=2 then 'at_risk'
when r_score <=2 and f_score >=3 then 'cannot_lose_them'
when r_score>=4 and f_score <=2 then 'new_customers'
when r_score = 3 and f_score <= 2 then 'need_attention'
else 'others'
end as segments
from rfm_scoring
)
select segments,
count (customerid) Customer_count
from rfm_segments
group by segments
order by customer_count desc;






with Recency as(
select customerid,
'2011-12-10' :: date - max(invoicedate) :: date as Recency
from online_retails 
group by customerid
),
Frequency as(
select customerid, count (distinct invoiceno) as Frequency
from online_retails 
group by customerid
),
Monetary as(
select customerid, 
sum(quantity * unitprice) as Monetary
from online_retails 
group by customerid
),
rfm_scoring as(
select r.customerid, r.recency,f.frequency,m.monetary,
ntile(4) over (order by recency DESC) as r_score,
ntile(4) over (order by frequency ) as f_score,
ntile(4) over (order by monetary ) as m_score
from recency r join frequency f
on r.customerid = f.customerid
join monetary m on 
f.customerid = m.customerid),
rfm_segments AS (
select *,
case 
when r_score = 4 and f_score = 4 and m_score =4 then 'champions'
when r_score >=3 and f_score >=3 then 'loyal_Customers'
when r_score =1 and f_score =1 then 'Lost'
when r_score <= 2 and f_score <=2 then 'hibernating'
when r_score >=2 and f_score >=2 then 'at_risk'
when r_score <=2 and f_score >=3 then 'cannot_lose_them'
when r_score>=4 and f_score <=2 then 'new_customers'
when r_score = 3 and f_score <= 2 then 'need_attention'
else 'others'
end as segments
from rfm_scoring
),
Churn_Risk as (
select *,
case when recency >= 180 then 'At_risk_of_churn'
else 'Active' end as Churn_risks
from rfm_segments
),
Churn as (
select *,
case when  churn_risks = 'At_risk_of_churn' then 1 else 0 end as Churn_Flag
from Churn_Risk
)
select round(avg(churn_flag)* 100,2)from churn;



with invoice_month as(
select
customerid, 
date_trunc('month', invoicedate) :: date as invoice_month
from online_retails
group by customerid, invoice_month
),
first_purchase as(
select
customerid, 
min(date_trunc('month', invoicedate)) :: date as first_purchase_month
from online_retails
group by customerid
),
Cohort_index as 
(
select 
i.customerid,
invoice_month, 
first_purchase_month,
(DATE_PART('year', AGE(invoice_month, first_purchase_month)) * 12 + 
DATE_PART('month', AGE(invoice_month, first_purchase_month)))
AS cohort_index from invoice_month i join first_purchase f
on i.customerid = f.customerid
),
cohort_counts AS (
    SELECT
	first_purchase_month,
    cohort_index,
    COUNT(DISTINCT customerid) AS distinct_customers
    FROM cohort_index
    GROUP BY first_purchase_month, cohort_index
),
Cohort_Size as 
(SELECT 
first_purchase_month,
COUNT(DISTINCT customerid) Cohort_customers
FROM cohort_index
where cohort_index = 0
GROUP BY first_purchase_month, cohort_index
)
select 
a. first_purchase_month, 
cohort_index, 
cohort_customers, 
round((Distinct_customers :: decimal /cohort_customers) * 100,2) as retention_rate
from cohort_counts a join cohort_size b
on a.first_purchase_month=b.first_purchase_month;



with Frequency as(
select customerid, count (distinct invoiceno) as Frequency
from online_retails 
group by customerid
),
Monetary as(
select customerid, 
sum(quantity * unitprice) as Monetary
from online_retails 
group by customerid
),
AOV as(
select f.customerid,
f.frequency,
m.monetary,
round((m.monetary/f.frequency),2) as AOV
from frequency f
join monetary m on 
f.customerid=m.customerid
),
first_purchase as(
select
customerid, 
min(date_trunc('month', invoicedate)) :: date as first_purchase_month
from online_retails
group by customerid
),
Last_purchase as(
select
customerid, 
max(date_trunc('month', invoicedate)) :: date as last_purchase_month
from online_retails
group by customerid
),
customer_lifespan as (select a.customerid, 
frequency,
monetary,
a.AOV,
DATE_PART('year', AGE(last_purchase_month, first_purchase_month)) * 12 + 
DATE_PART('month', AGE(last_purchase_month, first_purchase_month)) AS CUSTOMER_LIFESPAN
FROM aov a join first_purchase fp
on a.customerid = fp.customerid
JOIN last_purchase lp on
lp.customerid = a. customerid
)
select customerid, 
frequency,
monetary,
aov,
customer_lifespan,
ROUND((aov * frequency * GREATEST(customer_lifespan, 1))::numeric, 2) as clv
from customer_lifespan



