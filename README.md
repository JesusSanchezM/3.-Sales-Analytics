# Sales Analytics – SQL Project

**Customer segmentation, cohort retention, and product performance analysis for an e‑commerce.**

---

## 📌 Project Overview

This project demonstrates advanced SQL skills applied to a real‑world e‑commerce dataset (Olist). The goal is to extract actionable business insights from transactional data using **only SQL** for the core analysis — no Python or external tools for the heavy lifting.

**Key objectives:**
- Segment customers based on purchasing behavior (RFM).
- Measure customer retention over time using cohort analysis.
- Classify products by revenue contribution (ABC analysis).
- Provide executive‑level KPIs and recommendations.

---

## 📊 Dataset

- **Source:** [Olist Brazilian E-commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Scope:** 96,478 orders, 93,358 unique customers, 32,216 products.
- **Period:** September 2016 – August 2018.
- **Database:** PostgreSQL (loaded from CSV files).

---

## 🛠️ Technologies Used

- **PostgreSQL** – data storage and query execution.
- **Advanced SQL** – CTEs, window functions (`NTILE`, `FIRST_VALUE`), date functions, conditional logic.
- **SQLTools (VS Code)** – query runner and connection manager.
- **Python (optional)** – for downloading datasets and quick visualizations.
- **Tableau (optional)** – for dashboard visualization (exported CSV).

---

## 📁 Repository Structure

```
.
├── sql/                                 # All SQL queries (the core of the project)
│   ├── 01_exploratory.sql               # Data exploration and counts
│   ├── 02_rfm_segmentation.sql          # RFM customer segmentation
│   ├── 03_cohort_retention.sql          # Monthly cohort retention
│   ├── 04_product_abc.sql               # ABC product classification
│   └── 05_kpis.sql                      # Executive KPIs summary
│
├── data/
│   ├── raw/                             # Original CSV files (downloaded via KaggleHub)
│   └── processed/                       # Exported results (optional)
│
├── notebooks/
│   └── 01_sql_visualizations.ipynb      # Python notebook for quick visualizations
│
├── src/                                 # Helper Python scripts
│   ├── install.py                       # Downloads CSV files using KaggleHub
│   └── load_to_postgres.py              # Loads CSVs into PostgreSQL
│
├── exports/                             # PNG charts and CSV exports for Tableau
│
├── docs/                                # Business case and data dictionary
│
├── requirements.txt                     # Python dependencies
└── README.md                            # This file
```

---

## 🔍 Key SQL Queries

### 1. RFM Segmentation (`02_rfm_segmentation.sql`)
- **What it does:** Uses `NTILE(5)` to assign scores (1–5) for Recency, Frequency, and Monetary to each customer.
- **Segments:** Champions (VIP), Big Spenders, Core Customers, At Risk / Hibernating, New Loyal.
- **Key insight:** 20% of customers (Champions + Big Spenders) generate ~65% of total revenue.

### 2. Cohort Retention (`03_cohort_retention.sql`)
- **What it does:** Identifies each customer's first purchase month (cohort) and calculates retention rate for each subsequent month using `DATE_TRUNC`, `AGE`, and `FIRST_VALUE`.
- **Key insight:** Customers who make a second purchase within 30 days have 50% higher 12‑month retention than average.

### 3. ABC Product Classification (`04_product_abc.sql`)
- **What it does:** Ranks product categories by cumulative revenue contribution and assigns classes:
  - **A** (top 80% revenue)
  - **B** (next 15%)
  - **C** (remaining 5%)
- **Key insight:** Category A products (top 20% of categories) account for 80% of revenue and 75% of margin.

### 4. Executive KPIs (`05_kpis.sql`)
- **What it does:** Aggregates key metrics: total orders, customers, revenue, average ticket, freight, etc. Includes a last‑30‑day snapshot.
- **Key insight:** The business has a large customer base but low purchase frequency (avg 1.03 orders per customer), indicating strong potential for loyalty programs.

---

## 📊 Visualizations (from Python notebook)

The notebook `notebooks/01_sql_visualizations.ipynb` connects to PostgreSQL and generates the following charts, all saved as PNG in the `exports/` folder.

| Chart | Description | Key Business Insight |
| :--- | :--- | :--- |
| **RFM Segments (count)** | Bar chart of customer count per RFM segment. | Champions are the smallest group but the most valuable. Core Customers form the bulk of the base. |
| **RFM Segments (revenue)** | Bar chart of total revenue per RFM segment. | Champions + Big Spenders generate ~65% of total revenue, confirming the 80/20 rule. |
| **Cohort Retention** | Line chart showing retention rate for the first 6 months, split by cohort (month of first purchase). | Retention drops sharply after month 1; early engagement (e.g., second purchase within 30 days) is critical. |
| **ABC Product Categories** | Horizontal bar chart of top 20 categories by revenue, colored by ABC class (A, B, C). | The top 4 categories (A) drive most revenue; C categories have marginal contribution and could be candidates for discontinuation. |
| **KPI Overview** | Simple bar chart comparing total orders, unique customers, and distinct products sold. | The business has many customers but low purchase frequency (avg 1.03 orders/customer). |

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
- **Loyalty program:** Focus promotions on the Champions and Big Spenders to increase their frequency and ticket.
- **Re‑engagement campaigns:** Target At‑Risk customers (no purchase in >90 days) with win‑back offers.
- **Inventory optimization:** Prioritize stock for Category A products; reduce investment in Category C.
- **Seasonal marketing:** Plan campaigns for peak months (October–December).

**Estimated financial impact:** +8% average ticket in Top segment and 15% reduction in obsolete inventory → **~$500K USD annual margin increase**.

---

## 🚀 How to Reproduce (Step‑by‑Step)

### Prerequisites
- **PostgreSQL** installed and running (version 12 or higher).
- **Python 3.8+** installed.
- **Git** installed.
- **VS Code** (optional, but recommended with SQLTools extension).

### Step 1: Clone the repository
```bash
git clone https://github.com/JesusSanchezM/3.-Sales-Analytics.git
cd 3.-Sales-Analytics
```

### Step 2: Create and activate a virtual environment (recommended)
```bash
python -m venv venv
source venv/bin/activate          # On macOS/Linux
# or
venv\Scripts\activate             # On Windows
```

### Step 3: Install Python dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Download the dataset
The `src/install.py` script uses the `kagglehub` library to download the Olist CSV files and copies them to `data/raw/`.
```bash
python src/install.py
```
You should see output like:
```
Downloading to /Users/.../.cache/kagglehub/datasets/olistbr/brazilian-ecommerce/...
✅ Copiado: olist_customers_dataset.csv
✅ Copiado: olist_orders_dataset.csv
...
🎉 ¡Todos los archivos copiados a tu proyecto!
```

### Step 5: Set up PostgreSQL and create the database
Open your PostgreSQL client (e.g., `psql` or pgAdmin) and run:
```sql
CREATE DATABASE olist_db;
```
Or from the terminal:
```bash
psql -U your_username -c "CREATE DATABASE olist_db;"
```

### Step 6: Load the CSV files into PostgreSQL
Before running the script, **edit the credentials** in `src/load_to_postgres.py` if needed. By default it uses:
- User: `jesussanchez` (you should change to your PostgreSQL username)
- Password: blank (or set your own)
- Database: `olist_db`

Then run:
```bash
python src/load_to_postgres.py
```
This will create all tables and populate them with the CSV data. You should see output like:
```
⏳ Conectando a PostgreSQL...
📤 Cargando datos...
   📥 olist_customers_dataset.csv -> customers ... ✅ 99441 registros insertados.
   ...
🎉 ¡Todos los datos cargados exitosamente a PostgreSQL!
```

### Step 7: Run the SQL queries
- Connect to `olist_db` using **SQLTools** in VS Code or any SQL client (e.g., pgAdmin, DBeaver).
- Open and execute the SQL files in the `sql/` folder **in order** (01 → 05). Each query builds on the previous ones, but they can also be run independently.

### Step 8: (Optional) Generate Python visualizations
Open `notebooks/01_sql_visualizations.ipynb` and run all cells. It will:
- Connect to your PostgreSQL database (using the same credentials)
- Execute the same SQL queries
- Generate and save the charts in the `exports/` folder

---

## 🧠 Key Skills Demonstrated

- **Advanced SQL**: CTEs, window functions (`NTILE`, `FIRST_VALUE`), date arithmetic (`DATE_TRUNC`, `AGE`, `EXTRACT`), conditional logic (`CASE`).
- **Database Design**: Understanding relational schemas and foreign keys (Olist has 9 interconnected tables).
- **ETL / Data Engineering**: Downloading and loading CSV data into PostgreSQL using Python (pandas + SQLAlchemy).
- **Business Acumen**: Translating data into actionable recommendations (RFM, cohort retention, ABC).
- **Data Storytelling**: Communicating insights through clear visualizations and executive summaries.

---

## 📬 Contact

- **LinkedIn:** [Jesus Alexis Sánchez Moreno](https://linkedin.com/in/jesus-alexis-sanchez-moreno-b64694247)
- **GitHub:** [JesusSanchezM](https://github.com/JesusSanchezM)
- **Email:** alexissanchez281200@gmail.com

---

## 📄 License

This project is for portfolio purposes. Dataset provided by Olist under open license.
```
