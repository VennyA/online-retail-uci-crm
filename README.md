## Executive Summary
This project explores 541,909 transactions from a wholesale distributor between December 2010 and December 2011 to understand account value, churn risk, and revenue concentration.
Using RFM segmentation, 4,334 business accounts were analyzed based on purchasing behaviour. The results show a clear imbalance: a small group of accounts drives the majority of revenue, while a large portion becomes inactive quickly. About 1 in 5 accounts had gone quiet (no purchases in 180+ days), and the top 20% of accounts generated nearly three-quarters of total revenue — highlighting a strong dependency on a limited number of customers.

## Project Overview

**Industry:** Retail / Wholesale Distribution  
**Domain:** CRM Analytics / Customer Intelligence  
**Business Context:** This project reframes a B2C retail dataset as a B2B wholesale portfolio. Each CustomerID is treated as a business account, and each transaction as a purchase order.
The focus is on understanding account health which accounts are valuable, which are declining, and how behaviour changes over time. In a wholesale setting, losing a high-value account has a very strong impact, so visibility here is critical.


**Why This Project Matters:**  
Without visibility into account behavior, an analyst cannot identify which accounts are at risk, which are growing, or where revenue is concentrated. This analysis provides that visibility through RFM segmentation, churn flagging, cohort retention tracking, and CLV ranking.



## Data Source

- **Source:** UCI Machine Learning Repository — Online Retail Dataset
- **Dataset type:** Transactional (B2C reframed as B2B wholesale)
- **Time period:** December 2010 – December 2011
- **Raw records:** 541,909 rows and 8 columns
- **Cleaned records:** ~396,470 rows (after removing nulls,cancellations, and invalid entries)
- **Unique accounts:** 4,334 unique Customers
- **Columns:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

**Data Limitations:**
-Originally a B2C dataset, adapted here for B2B analysis
-25% of records removed due to missing CustomerIDs
-Only one year of data, so long-term behaviour is limited


  ## Problem Statement

The business lacks visibility into how its accounts behave.
Without this, it’s difficult to:

-Identify high-value accounts worth protecting
-Spot accounts at risk of churning
-Understand what separates strong accounts from weak ones
-Track retention over time
-See where revenue is actually coming from

This analysis was designed to answer the following business questions:

- Which accounts are most valuable to the business?
- Which accounts are at risk of churning and need urgent attention?
- What does a healthy account look like versus an at-risk account?
- How does account retention change over time across different cohorts?
- Where is revenue concentrated across the account?

## Tools & Methodology

**Tools Used:**
- **PostgreSQL** — Used for data cleaning, RFM scoring, cohort analysis, CLV calculation
- **Power BI** — data modelling, DAX measures, interactive dashboard
- **GitHub** — Documentation
 

**Methodology:**

### 1. Data Collection & Loading
The Online Retail UCI dataset was loaded into PostgreSQL. The initial exploration confirmed 541,909 raw transactions across 
8 columns spanning from December 2010 to December 2011.

### 2. Data Cleaning & Preparation
The following steps were applied to ensure data quality:
- Removed rows with missing CustomerIDs 
- Removed cancelled orders (InvoiceNo starting with 'C')
- Filtered out invalid StockCodes (non-numeric entries)
- Removed transactions with zero or negative Quantity and UnitPrice
- Parsed InvoiceDate as TIMESTAMP for date calculations
- Created TotalValue column (Quantity × UnitPrice)

### 3. RFM Analysis
Each account was scored across three dimensions:
- **Recency** — days since last purchase (reference date: 2011-12-10)
- **Frequency** — distinct invoice count per account
- **Monetary** — total spend per account

Accounts were scored 1–4 using NTILE(4) in PostgreSQL and percentile-based scoring in Power BI. Segments were assigned 
using CASE/SWITCH logic across 10 categories.

### 4. Churn Flag
Accounts with Recency greater than 180 days were flagged as 'churned. Overall churn rate was calculated as a 
percentage of total accounts.

### 5. Cohort Analysis
Accounts were grouped by their first purchase month. Retention rate was calculated as the percentage of each 
cohort still active in subsequent months using a cohort index (Month 0 = first purchase month).

### 6. CLV Calculation
Customer Lifetime Value was calculated as:
CLV = Average Order Value × Frequency × Customer Lifespan (months). A minimum lifespan of 1 month was applied to avoid zero CLV for single-purchase accounts.

### 7. Data Visualisation
A 2-page interactive Power BI dashboard was built covering:
- RFM segmentation and revenue by segment
- Cohort retention heatmap and account churn status



## Exploratory Data Analysis (EDA)

### Key Patterns
Initial analysis revealed significant variation in purchasing behavior across accounts. A small number of high-frequency accounts contributed more to total revenue, while the majority of accounts placed fewer than 5 orders across the entire year. This purchasing inequality was recurring throughout the analysis.

### Distributions
- **Recency** ranged from 1 to 374 days, indicating a wide spread between recently active and long-dormant accounts
- **Frequency** was heavily right-skewed most accounts placed between 1–10 orders while a small group placed 40–70+ orders
- **Monetary** was similarly skewed, top accounts spent upwards of £279,000 while median account spend was significantly lower
- **CLV** ranged from near zero to £3.3M, driven by high-frequency, high-spend Champion accounts

### Trends
- The 2010-12 cohort was the largest (884 accounts) and showed the strongest long-term retention across all cohorts
- Retention dropped sharply after Month 0 across all cohorts, with most cohorts retaining only 15–25% of accounts by Month 3
- Revenue was heavily weighted toward Q4 2011, consistent with seasonal wholesale purchasing patterns

### Outliers
- CustomerID 14646 recorded the highest monetary value at £279,138 with 72 orders
- Several accounts had a customer lifespan of 0 months, indicating single-month purchasing activity
- A small number of accounts had extremely high frequency scores despite low monetary values.

### Correlations
- Accounts with high Recency scores consistently recorded higher Frequency and Monetary values, confirming that recently active accounts are also the most engaged and highest spending.
- Churn risk was concentrated in accounts with low Recency and Frequency scores, confirming that declining purchase frequency is an early warning signal for churn.
- Revenue concentration aligned directly with RFM ranking the top 20% of account generated 72.71% of 
  total revenue.


## Key Insights

### Insight 1 — Revenue is highly concentrated
A relatively small group of accounts drives most of the revenue. This creates risk — losing even a few top accounts would have an immediate impact.

### Insight 2 — A large portion of accounts are inactive
Roughly 20% of accounts haven’t purchased in over 6 months. These accounts are unlikely to return without intervention.

### Insight 3 — Most accounts don’t come back after their first month
Retention drops sharply after the first purchase. By Month 3, only a small percentage of accounts remain active, pointing to weak onboarding or early engagement.

## Recommendations

### Recommendation 1 — Focus on high-value accounts
Monitor top accounts closely
Flag inactivity early (e.g. 30 days without orders)
Offer incentives or priority support


 

### Recommendation 2 — Run targeted win-back campaigns
Identify churned and at-risk accounts
Prioritise by value (CLV)
Use personalised outreach tied to past purchases

 

### Recommendation 3 — Improve early engagement
Follow up after first purchase
Encourage a second order quickly
Track and nurture new accounts into repeat buyers


## Visuals Preview
-**Dashboard Screenshots**-
<img width="679" height="378" alt="image" src="https://github.com/user-attachments/assets/737c1506-e5ef-410e-84cb-15b6e5d8f1ba" />

<img width="679" height="382" alt="image" src="https://github.com/user-attachments/assets/6c2477fb-795b-4a57-aa5e-0b02ec02211d" />

-**Before and After Cleaning**-
<img width="603" height="346" alt="image" src="https://github.com/user-attachments/assets/ea675e45-9524-4519-a105-785f48b22b29" /> 
<img width="628" height="351" alt="image" src="https://github.com/user-attachments/assets/9b680413-3cd4-48c1-8652-9a097c09cf32" />


<img width="782" height="388" alt="image" src="https://github.com/user-attachments/assets/9e5f21c0-4d5b-4068-8d77-aee90574cc0d" />
 

<img width="782" height="391" alt="image" src="https://github.com/user-attachments/assets/ef31dfaf-50fe-426d-9cad-86d340342880" />




-**SQL Query**-

<img width="777" height="389" alt="image" src="https://github.com/user-attachments/assets/245c522a-3436-4fa2-b490-aa4275165981" />

-**Data Model Diagram**-
<img width="729" height="310" alt="image" src="https://github.com/user-attachments/assets/6ecb76d4-0ae6-42a8-8c59-56340de42455" />



## Limitations

While this analysis provides meaningful insights into account behavior and portfolio health, the following limitations 
must be acknowledged:

- **B2C dataset reframed as B2B** —
The original data is consumer retail. Treating CustomerIDs as business accounts works for analysis, but real B2B datasets would include contract values, account tiers, and sales ownership.

- **No firmographic data beyond country** — No firmographic data (e.g. industry, company size), so segmentation is based only on purchasing behaviour.

- **One year of data only** — Data covers just one year (Dec 2010 – Dec 2011), limiting long-term trend analysis and lifecycle tracking.


- **Churn threshold is assumed** — The 180-day threshold is a standard benchmark. In practice, churn would depend on the company’s actual sales cycle.

- **Missing CustomerIDs** — A significant portion of transactions were excluded due to missing IDs, which may slightly skew customer counts and revenue distribution.



## Conclusion

This project evaluates account health, purchasing behaviour, and revenue concentration across 4,334 customers using transactional data.

Applying RFM segmentation, churn analysis, cohort tracking, and CLV highlights three core patterns:

Revenue is highly concentrated in a small group of customers → retention here is critical
Around 1 in 5 customers are already inactive → clear recovery opportunity
Most customers don’t return after their first month → weak early engagement

