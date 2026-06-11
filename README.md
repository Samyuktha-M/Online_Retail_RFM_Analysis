# Online Retail RFM Customer Segmentation Analysis

An end-to-end data analytics portfolio project analysing 541,909 transactions from a UK online gift retailer (Dec 2010 — Dec 2011) using RFM segmentation and Claude AI integration.

---

## 📊 Tableau Dashboards

| Dashboard | Description | Link |
|-----------|-------------|------|
| Sales Overview | Monthly revenue, top products, day of week analysis | [View →](https://public.tableau.com/views/OnlineRetailRFMAnalysis_17793169720000/SalesOverview) |
| Customer Segmentation | Segment analysis, revenue treemap, RFM metrics | [View →](https://public.tableau.com/views/OnlineRetailRFMAnalysis_17793169720000/CustomerSegmentation) |
| RFM Deep Dive | Scatter plot, score heatmap, anomaly annotation | [View →](https://public.tableau.com/views/OnlineRetailRFMAnalysis_17793169720000/RFMDeepDive) |

---

## 📊 Project Overview

This project builds a complete customer analytics pipeline from raw data to AI-powered business insights:

- **541,909 rows** cleaned to **390,857** valid transactions
- **4,334 customers** scored and segmented using RFM methodology
- **7 customer segments** identified — Champions to Lost
- **7 Claude AI features** — insight narrator, SWOT analysis, 
  business improvement plan, email generator, interactive text-to-SQL, 
  customer intelligence centre, executive summary
- **3 Tableau dashboards** published to Tableau Public

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| MySQL + MySQL Workbench | Data storage and RFM SQL analysis |
| Python + pandas | Data cleaning and EDA |
| SQLAlchemy | Python-MySQL connection for AI notebook |
| Jupyter Notebook | Data cleaning and AI analysis |
| Anthropic Claude API | AI-powered business insights |
| Tableau Public | BI dashboards |
| VS Code | Development environment |

---

## 📁 Repository Structure

Online-Retail-RFM-Analysis/
    ├── notebooks/
    │   ├── RFM_Data_Cleaning.ipynb
    │   └── RFM_AI_Analysis.ipynb
    ├── sql/
    │   ├── 01_data_cleaning.sql
    │   ├── 02_rfm_scoring.sql
    │   └── 03_rfm_segments.sql
    ├── scripts/
    │   └── export_csv.py
    ├── data/
    │   ├── rfm_segments.csv
    │   └── rfm_scores.csv 
    └── README.md

---

## 🤖 Claude AI Features

The Jupyter notebook integrates Claude API for 7 use cases:

| Feature | Description |
|---------|-------------|
| **Insight Narrator** | Auto-generates business narrative from segment data |
| **SWOT Analysis** | Dynamic SWOT using live database context |
| **Business Improvement Plan** | Phased 30/90/180 day action plan built from segment summary, business context and SWOT output —     with revenue recovery projections |
| **Email Generator** | Tailored marketing emails per segment — At Risk tiered by recency, Lost restricted to top 200 high-value      customers, each with segment-specific tone and offer |
| **Text-to-SQL** | Interactive natural language interface — type any question, Claude generates and executes SQL, returns results    with AI interpretation |
| **Customer Intelligence Centre** | Interactive lookup — enter customer ID for full RFM profile, AI narrative and personalised       email tailored by segment and spend level |
| **Executive Summary** | 6-section board report synthesising all previous analysis outputs — key findings, critical risks, priority recommendations and expected revenue impact|

---

## 📈 Key Findings

- **£8.72M** total revenue across 13 months
- **Champions** (28.1% of customers) drive **67.3%** of revenue
- **531 At Risk** customers represent **£746K** recoverable revenue
- **No Saturday transactions** — confirms B2B wholesale model
- **Thursday peak** at £1.94M — optimal day for campaigns
- **784 Lost customers** — 18.1% of total base — 
  gone for an average of 9 months with £378K revenue lost
- **Customer 16446** — £168K in 2 orders — wholesale anomaly identified

---

## 🗂️ RFM Segments

| Segment | Customers | % of Base | Revenue | Avg Recency | Avg Frequency | Avg Monetary |
|---------|-----------|-----------|---------|-------------|---------------|--------------|
| Champions | 1,219 | 28.1% | £5,869,362 | 13.7 days | 9.4 orders | £4,815 |
| Loyal Customers | 571 | 13.2% | £992,204 | 50.7 days | 4.2 orders | £1,738 |
| At Risk | 531 | 12.3% | £746,433 | 126.2 days | 3.7 orders | £1,406 |
| Lost | 784 | 18.1% | £377,897 | 273.2 days | 1.2 orders | £482 |
| Potential Loyalists | 279 | 6.4% | £344,295 | 16.4 days | 2.0 orders | £1,234 |
| Need Attention | 715 | 16.5% | £316,093 | 95.2 days | 1.1 orders | £442 |
| New Customers | 235 | 5.4% | £75,173 | 19.2 days | 1.0 orders | £320 |
| **Total** | **4,334** | **100%** | **£8,721,457** |

---
## 📋 Original Dataset Schema

Source: UCI Machine Learning Repository

| Variable | Role | Type | Description | Units |
|----------|------|------|-------------|-------|
| InvoiceNo | ID | Categorical | 6-digit transaction number — prefix 'C' indicates cancellation | — |
| StockCode | ID | Categorical | 5-digit product code | — |
| Description | Feature | Categorical | Product name | — |
| Quantity | Feature | Integer | Units per transaction | — |
| InvoiceDate | Feature | Date | Transaction date and time | — |
| UnitPrice | Feature | Continuous | Product price per unit | £ Sterling |
| CustomerID | Feature | Categorical | 5-digit customer identifier | — |
| Country | Feature | Categorical | Customer country of residence | — |

## 🔍 Data Cleaning Summary

**Data type conversions:**

| Column | Original Type | Converted To | Reason |
|--------|--------------|--------------|--------|
| `InvoiceNo` | Object | String | Explicit conversion to ensure string type for C-prefix detection |
| `InvoiceDate` | Object | Datetime | Needed datetime for recency date calculations |
| `CustomerID` | Float | Integer | Loaded as float due to null values — converted after dropping nulls |
| `Revenue` | — | Float | New calculated column — Quantity × UnitPrice |

**Cleaning steps applied:**

| Step | Action |
|------|--------|
| Remove cancellations | Separate C-prefix invoices into cancellations dataframe |
| Remove non-products | StockCode temporarily converted to string for regex validation — filter out non-product codes (POST, DOT,     AMAZONFEE) — keep only valid 5-digit product SKUs |
| Remove nulls | Drop rows with missing CustomerID |
| Remove negatives | Remove zero and negative quantities and prices — indicates returns, errors or free items |
| Remove duplicates | Identified and removed exact duplicate rows — investigated description-only duplicate pairs (BUNTING SPOTTY,    JUMBO BAG) with different spelling variations — resolved by standardising to one description per transaction |
| **Final dataset** | **390,857 clean rows** |

**Additional notes:**
- Cancellations saved as separate dataframe for potential future analysis
- Revenue column added as Quantity × UnitPrice
- Raw dataset: 541,909 rows → Clean dataset: 390,857 rows

---

## ⚙️ Setup

### Prerequisites
```bash
pip install pandas sqlalchemy pymysql anthropic jupyter
```

### Step by Step Run Order

**Step 1 — Data Cleaning:**
- Download dataset from UCI or Kaggle (links above)
- Open `notebooks/01_Data_Cleaning.ipynb`
- Run all cells
- Exports `Online_Retail_clean.csv` to your Desktop

**Step 2 — Load into MySQL:**
- Open MySQL Workbench
- Create database:
```sql
CREATE DATABASE online_retail;
```
- Import `Online_Retail_clean.csv` as table `sales_clean`

**Step 3 — RFM Analysis in SQL:**
- Run SQL files in `/sql` folder in order:
- 01_data_cleaning.sql   ← sanity checks
02_rfm_scoring.sql     ← RFM metrics + NTILE scoring
03_rfm_segments.sql    ← segment labels

  **Step 4 — Export CSV files:**
- Run `scripts/export_csv.py`
- Exports `rfm_segments.csv` and `rfm_scores.csv` to Desktop

**Step 5 — Claude API Analysis:**
- Get API key from https://console.anthropic.com
- Replace `YOUR_ANTHROPIC_API_KEY` in Cell 1
- Open `notebooks/02_RFM_AI_Analysis.ipynb`
- Run all cells

**Step 6 — Tableau Dashboard (optional):**
- Open Tableau Public
- Connect to `rfm_segments.csv` and `sales_clean.csv`
- Or view published dashboards at links above
---

## 📂 Data Source

**UCI Machine Learning Repository — Online Retail Dataset**
- 541,909 transactions
- December 2010 — December 2011
- UK-based non-store online retailer
- 38 countries

| Source | Link |
|--------|------|
| UCI Repository | [Download](https://archive.ics.uci.edu/ml/datasets/online+retail) |
| Kaggle | [Download](https://www.kaggle.com/datasets/vijayuv/onlineretail) |

---

## 🗄️ Data Files Included

| File | Description | Rows |
|------|-------------|------|
| `rfm_segments.csv` | Customer RFM scores and segment assignments (Champions, At Risk, Lost etc.) | 4,334 |
| `rfm_scores.csv` | Raw RFM metrics and scores before segmentation  | 4,334 |

> Note: `sales_clean.csv` not included due to file size.
> Download raw dataset from UCI or Kaggle links above.

## 💡 Notable Anomaly

**Customer 16446** — classified as Potential Loyalist but spent £168,472 in just 2 orders. Analysis identified this as a likely wholesale buyer misclassified by standard RFM scoring. In production this would warrant a separate wholesale customer tier.

---

## 👤 Author

**Samyuktha Muralidharan**

- 📊 Tableau Public: [View Dashboards](https://public.tableau.com/app/profile/samyuktha.muralidharan7364)
- 💻 GitHub: [github.com/your-username](https://github.com)
