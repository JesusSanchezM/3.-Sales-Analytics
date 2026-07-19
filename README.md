# Sales Analytics – SQL Project

**Customer segmentation, cohort retention, and product performance analysis for an e‑commerce.**

---

## 📌 Project Overview

This project demonstrates advanced SQL skills applied to a real-world e-commerce dataset (Olist). The goal is to extract actionable business insights from transactional data using only SQL — no Python or external tools for the core analysis.

**Key objectives:**
- Segment customers based on purchasing behavior (RFM).
- Measure customer retention over time using cohort analysis.
- Classify products by revenue contribution (ABC analysis).
- Provide executive-level KPIs and recommendations.

---

## 📊 Dataset

- **Source:** [Olist Brazilian E-commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Scope:** 96,478 orders, 93,358 unique customers, 32,216 products.
- **Period:** September 2016 – August 2018.
- **Database:** PostgreSQL (loaded from CSV files).

---

## 🛠️ Technologies Used

- **PostgreSQL** – data storage and query execution.
- **SQL (advanced)** – CTEs, window functions, date functions, conditional logic.
- **SQLTools (VS Code)** – query runner and connection manager.
- **Tableau (optional)** – for dashboard visualization (exported CSV).
- **Python (optional)** – for quick visualizations (notebook provided).

---

## 📁 Repository Structure
.
├── sql/
│ ├── 01_exploratory.sql # Data exploration and counts
│ ├── 02_rfm_segmentation.sql # RFM customer segmentation
│ ├── 03_cohort_retention.sql # Monthly cohort retention
│ ├── 04_product_abc.sql # ABC product classification
│ └── 05_kpis.sql # Executive KPIs summary
├── data/
│ ├── raw/ # Original CSV files
│ └── processed/ # Exported results (optional)
├── notebooks/
│ └── 01_sql_visualizations.ipynb # Python visualizations (optional)
├── docs/ # Business case and data dictionary
├── exports/ # CSV exports for Tableau
└── README.md # This file


---

## 🔍 Key SQL Queries

### 1. RFM Segmentation (`02_rfm_segmentation.sql`)
- Uses `NTILE(5)` to assign scores for Recency, Frequency, and Monetary.
- Classifies customers into: **Champions (VIP)**, **Big Spenders**, **Core Customers**, and **At Risk / Hibernating**.
- **Insight:** 20% of customers (Champions + Big Spenders) generate ~65% of total revenue.

### 2. Cohort Retention (`03_cohort_retention.sql`)
- Identifies each customer's first purchase month (cohort).
- Calculates retention rate for each subsequent month using `DATE_TRUNC`, `AGE`, and `FIRST_VALUE`.
- **Insight:** Customers who make a second purchase within 30 days have 50% higher 12‑month retention.

### 3. ABC Product Classification (`04_product_abc.sql`)
- Ranks product categories by cumulative revenue contribution.
- Assigns **A** (top 80%), **B** (next 15%), and **C** (remaining 5%) classes.
- **Insight:** Category A products (top 20% of categories) account for 80% of revenue and 75% of margin.

### 4. Executive KPIs (`05_kpis.sql`)
- Aggregates key metrics: total orders, customers, revenue, average ticket, freight, etc.
- Includes last‑30‑day activity (useful for monitoring recent performance).

---

## 📈 Results & Business Impact

| KPI | Value |
| :--- | :--- |
| Total Orders | 96,478 |
| Unique Customers | 93,358 |
| Total Revenue | $15.42M |
| Average Ticket | $139.93 |
| Revenue per Customer | $165.17 |
| Products Sold | 32,216 |
| Total Freight | $2.20M |

**Recommended actions:**
- **Loyalty programs** for the Top segment.
- **Re‑engagement campaigns** for At‑Risk customers.
- **Inventory prioritization** for Category A products.
- **Seasonal marketing** in Q4 (October–December).

**Estimated financial impact:** +8% average ticket in Top segment, 15% reduction in obsolete inventory → **~$500K USD annual margin increase**.

---

## 🚀 How to Reproduce

1. **Clone the repository**:
   ```bash
   git clone https://github.com/JesusSanchezM/3.-Sales-Analytics.git
