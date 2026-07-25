# 🏦 Financial Fraud Detection — Anomaly Detection in Credit Card Transactions

[![Python](https://img.shields.io/badge/Python-3.11-blue?logo=python&logoColor=white)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Tableau](https://img.shields.io/badge/Tableau-Public-lightblue?logo=tableau&logoColor=white)](https://public.tableau.com/)
[![Excel](https://img.shields.io/badge/Microsoft-Excel-green?logo=microsoft-excel&logoColor=white)](https://www.microsoft.com/excel)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> **Simplilearn Data Science & Business Analytics Capstone Project**  
> Client: *SecureGuard Financial Solutions*

---

## 📋 Table of Contents
- [Project Overview](#-project-overview)
- [Problem Statement](#-problem-statement)
- [Dataset](#-dataset)
- [Tools & Technologies](#-tools--technologies)
- [Project Structure](#-project-structure)
- [Key Findings](#-key-findings)
- [Machine Learning Results](#-machine-learning-results)
- [How to Run](#-how-to-run)
- [Dashboard](#-tableau-dashboard)
- [Acknowledgements](#-acknowledgements)

---

## 🔍 Project Overview

SecureGuard Financial Solutions processes millions of credit card transactions daily. This project builds a **complete end-to-end fraud detection system** using a multi-tool analytical approach to identify anomalous and fraudulent transactions.

The analysis covers **389,002 credit card transactions** from January 2019 to May 2020, using Python for EDA and machine learning, SQL for database analysis, Excel for statistical exploration, and Tableau for interactive dashboards.

---

## ❓ Problem Statement

Fraudulent transactions cause direct financial losses and erode customer trust. With only **0.58% of transactions being fraudulent**, this is a classic **highly imbalanced classification problem**. The goal is to:

1. Identify patterns and anomalies in transaction data
2. Determine the strongest predictors of fraud
3. Build a machine learning model to automate fraud detection
4. Provide actionable business recommendations

---

## 📊 Dataset

| File | Rows | Description |
|------|------|-------------|
| `cc_data.csv` | 389,002 | Primary credit card transactions dataset |
| `cc_data_dec19.csv` | ~50,000 | December 2019 supplement |
| `location_data.csv` | 979 | Cardholder home location coordinates |

**Key Variables:**

| Column | Type | Description |
|--------|------|-------------|
| `trans_date_trans_time` | DateTime | Transaction timestamp |
| `amt` | Float | Transaction amount (USD) |
| `category` | String | Merchant category (14 types) |
| `merchant` | String | Merchant name |
| `is_fraud` | Binary | Target variable (1=Fraud, 0=Legitimate) |
| `lat`, `long` | Float | Cardholder home coordinates |
| `merch_lat`, `merch_long` | Float | Merchant coordinates |
| `city_pop` | Integer | Population of cardholder's city |
| `dob` | Date | Cardholder date of birth |

> **Data Quality**: No missing values. No duplicate records. Fully clean dataset.

---

## 🛠 Tools & Technologies

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.11 | EDA, Feature Engineering, ML Modeling |
| Pandas | 2.x | Data manipulation and analysis |
| Matplotlib / Seaborn | Latest | Data visualization |
| Scikit-learn | 1.x | Machine learning models |
| MySQL | 8.0 | Database creation and SQL querying |
| MySQL Workbench | 8.0 | SQL IDE |
| Microsoft Excel | 365 | Statistical analysis and PivotTables |
| Tableau Public | Latest | Interactive dashboard |

---

## 📁 Project Structure

```
Financial-Fraud-Detection-Capstone/
│
├── 📂 Source Code/
│   ├── fraud_detection_eda.ipynb     # Python EDA + ML Notebook (38 cells)
│   └── sql_queries.sql               # All SQL scripts (Tasks 3, 4, 5)
│
├── 📂 Screenshots/
│   ├── Python/                       # EDA plots and ML evaluation charts
│   ├── SQL/                          # MySQL Workbench query results
│   ├── Excel/                        # Statistical summaries and PivotTables
│   └── Tableau/                      # Dashboard and individual charts
│
├── 📄 Financial Fraud Detection Report.pdf   # Full project report
├── 📄 1716553599_financialfrauddetection.pdf # Project requirements
└── 📊 fraud_dashboard.twbx                   # Tableau Packaged Workbook
```

---

## 🔑 Key Findings

### 📌 Fraud Overview
- Only **0.58%** of transactions are fraudulent (2,252 out of 389,002)
- Total dataset value: **~$26.5 million** across all transactions
- Date range: **January 2019 – May 2020** (503 days)

### 📌 Top Fraud Predictors
1. **Transaction Amount (amt)** — Fraudulent transactions average **~$527** vs **~$66** for legitimate
2. **Time of Day** — Fraud rate is **3–4× higher between 12AM and 5AM**
3. **Merchant Category** — `shopping_net` and `misc_net` show highest fraud rates (~2.6–2.8%)
4. **Geographic Distance** — Transactions **500+ km from cardholder's home** have significantly higher fraud rates

### 📌 Category Analysis
| Category | Fraud Rate |
|----------|-----------|
| shopping_net | ~2.8% |
| misc_net | ~2.6% |
| grocery_net | ~2.1% |
| gas_transport | ~0.3% |
| food_dining | ~0.2% |

### 📌 No Significant Effect
- **Gender**: Male and female cardholders show nearly identical fraud rates
- **City Population**: Near-zero correlation with fraud (r ≈ 0.002)

---

## 🤖 Machine Learning Results

Two models were built and compared using an 80/20 train-test split with stratification:

| Metric | Logistic Regression | Random Forest |
|--------|--------------------|--------------------|
| Accuracy | ~75% | ~98% |
| Precision (Fraud) | ~3% | ~85% |
| Recall (Fraud) | ~89% | ~78% |
| F1-Score (Fraud) | ~0.06 | ~0.81 |
| **ROC-AUC** | ~0.87 | **~0.97** ✅ |

> ✅ **Random Forest** is the recommended model for production deployment.  
> The model uses `class_weight='balanced'` to handle the severe class imbalance.

**Features used:**
- Transaction amount, city population, lat/long
- Merchant category (encoded), gender (binary encoded)
- Hour of day, day of week, cardholder age
- Cardholder-to-merchant distance (km) — engineered feature

---

## ▶️ How to Run

### Python Notebook
```bash
# 1. Clone the repository
git clone https://github.com/Harsha-mandala/Financial-Fraud-Detection-Capstone.git

# 2. Install required libraries
pip install pandas numpy matplotlib seaborn scikit-learn jupyter

# 3. Open the notebook
jupyter notebook "Source Code/fraud_detection_eda.ipynb"

# 4. Run all cells (Kernel → Restart & Run All)
#    Note: cc_data.csv (~98MB) must be in the correct path
#    Expected path: Financial_Fraud_Detection_dataset/cc_data.csv
```

### SQL Scripts
```sql
-- Run in MySQL Workbench 8.0
-- 1. Open Source Code/sql_queries.sql
-- 2. Run Task 3 first (creates schema + loads data)
-- 3. Then run Task 4 and Task 5 queries individually

-- Files must be placed in MySQL uploads folder:
-- C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/
```

### Requirements
```
pandas>=1.5.0
numpy>=1.23.0
matplotlib>=3.6.0
seaborn>=0.12.0
scikit-learn>=1.1.0
```

---

## 📈 Tableau Dashboard

🔗 **Live Dashboard**: [View on Tableau Public](https://public.tableau.com) *(https://public.tableau.com/app/profile/harsha.mandala8583/viz/fraud_dashboard_17849835305220/Dashboard1)*

The dashboard includes 5 interactive visualizations:
1. **Box & Whisker Plot** — Transaction amount by gender and category
2. **Geographic Map** — Distribution of all transactions across the US
3. **Fraud Map** — Geographic distribution of fraudulent transactions
4. **Time Series** — Monthly transaction trend (Jan 2019 – May 2020)
5. **Inflation-Adjusted Chart** — Transaction amounts normalized for inflation

---

## 💡 Business Recommendations

1. **Real-time amount alerts** — Flag transactions exceeding 3× cardholder's historical average
2. **Time-of-day risk scoring** — Enhanced verification between 12AM and 5AM
3. **Geographic velocity checks** — Alert on transactions 200+ km from last known location
4. **Category-based rules** — Stricter verification for `shopping_net` and `misc_net`
5. **Random Forest deployment** — Use as real-time fraud scoring engine (threshold: 0.7)
6. **Quarterly model retraining** — Keep up with evolving fraud patterns

---

## 🙏 Acknowledgements

- **Simplilearn** — Project framework and requirements
- **Dataset** — Synthetic credit card transaction data for educational purposes
- **SecureGuard Financial Solutions** — Capstone project client (fictional)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---
