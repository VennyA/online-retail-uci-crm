## Executive Summary

This project analyzes 541,909 transactions from a wholesale distributor's account spanning from December 2010 to December 2011. Using RFM scoring, 4,334 business accounts were segmented by purchasing behavior to identify high-value accounts, churn risk, and retention patterns. Key findings reveal a 20.1% churn rate among inactive accounts with recency greater than 180 days, with the top 20% of accounts generating 72.71% of total revenue confirming significant revenue concentration risk for the business.

## Project Overview

**Industry:** Retail / Wholesale Distribution  
**Domain:** CRM Analytics / Customer Intelligence  
**Business Context:** This project reframes a B2C retail dataset as a B2B  wholesale distributor's account portfolio. Each CustomerID represents a business account and each transaction represents a purchase order placed by that account.The analysis was conducted from the perspective of a CRM analyst tasked with understanding account health across the distributor's portfolio. In B2B wholesale, losing a high-value account is significantly more damaging. 

**Why This Project Matters:**  
Without visibility into account behavior, an analyst cannot identify which accounts are at risk, which are growing, or where revenue is concentrated. This analysis provides that visibility through RFM segmentation, churn flagging, cohort retention tracking, and CLV ranking.



## Data Source

- **Source:** UCI Machine Learning Repository — Online Retail Dataset
- **Dataset type:** Transactional (B2C reframed as B2B wholesale)
- **Time period:** December 2010 – December 2011
- **Raw records:** 541,909 rows and 8 columns
- **Cleaned records:** ~396,360 rows (after removing nulls,cancellations, and invalid entries)
- **Unique accounts:** 4,334 CustomerIDs
- **Columns:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

**Data Limitations:**
- Dataset is originally B2C — reframed as B2B for portfolio relevance, 25% of transactions had missing CustomerIDs and were excluded
- Dataset covers one year only one year.


  ## Problem Statement

The wholesale distributor lacks visibility into the health and behavior of its 4,334 business accounts. Without this visibility, the CRM team cannot effectively prioritize retention efforts, identify accounts at risk of churning, or understand what separates a high-value account from a declining one.

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
- **GitHub** — version control and portfolio documentation

---

**Methodology:**

### 1. Data Collection & Loading
The Online Retail UCI dataset was loaded into PostgreSQL. The initial exploration confirmed 541,909 raw transactions across 
8 columns spanning from December 2010 to December 2011.

### 2. Data Cleaning & Preparation
The following steps were applied to ensure data quality:
- Removed rows with missing CustomerIDs (~25% of raw data)
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
CLV = Average Order Value × Frequency × Customer Lifespan (months) A minimum lifespan of 1 month was applied to avoid zero CLV for single-purchase accounts.

### 7. Data Visualisation
A 2-page interactive Power BI dashboard was built covering:
- RFM segmentation and revenue by segment
- Cohort retention heatmap and account churn status

<img width="679" height="378" alt="image" src="https://github.com/user-attachments/assets/737c1506-e5ef-410e-84cb-15b6e5d8f1ba" /> <img width="679" height="382" alt="image" src="https://github.com/user-attachments/assets/6c2477fb-795b-4a57-aa5e-0b02ec02211d" />

