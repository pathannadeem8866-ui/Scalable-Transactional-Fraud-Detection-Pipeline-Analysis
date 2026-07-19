🛡️ Scalable Transactional Fraud Detection Pipeline

Author: Mohammad Nadeem Khan

Date: July 2026

Tools Used: Python (Pandas, NumPy), MS SQL Server (T-SQL), Power BI

📑 Project Overview

This project is an end-to-end data analytics and engineering pipeline designed to process a massive, highly imbalanced dataset of 4.97 million simulated financial transactions.

The primary business objective is to detect anomalous transaction patterns, quantify the financial impact of fraudulent behavior, and equip stakeholders with actionable intelligence to optimize fraud detection thresholds—balancing financial loss mitigation against the operational costs of false positives.

🛠️ Tech Stack & Workflow

1. Data Engineering & Wrangling (Python)

Real-world ledger data is inherently messy. To mimic a production environment, a 5-million-row synthetic dataset was engineered with deliberate inconsistencies, nulls, and duplicates using numpy and pandas.

Data Generation (Creating_Dataset.py): Simulated customer behavior, transaction amounts, timestamps, and merchant categories with a baseline fraud rate of ~1%.

Data Cleaning (Cleaning_Dataset.py): Executed programmatic deduplication on primary keys, imputed missing categorical values (merchant_category, payment_method), and standardized temporal and spatial string formats to prepare for database ingestion.

2. Database Management & Analysis (SQL Server)

Loaded the sanitized 4.97M row dataset into a relational database, enforcing strict NOT NULL constraints to ensure pipeline data integrity.

KPI Extraction (fraud_kpis.sql): Developed highly performant T-SQL aggregation queries (including Window Functions and CTEs) to extract core business metrics related to transaction velocity, category vulnerabilities, and account compromises.

3. Data Visualization (Power BI)

Connected Power BI directly to the SQL Server database using DirectQuery for real-time visualization of massive datasets without memory bottlenecks.

Engineered custom DAX measures to accurately calculate dynamic fraud rates.

Designed an enterprise-grade interactive dashboard featuring advanced slicers and cohesive visual formatting to present 
findings to non-technical stakeholders.

## 📈 Fraud Analysis Dashboard
<img width="882" height="500" alt="Screenshot 2026-07-19 163420" src="https://github.com/user-attachments/assets/a1872098-a279-416b-8a21-0f501be00d3d" />

📊 Key Findings & Business Insights

After processing $205.19M in total transaction volume, the analysis yielded the following insights:

Macro-Level Health: Identified a 1.01% overall fraud rate, resulting in $2.05M in preventable financial loss.

Vulnerability by Payment Method: Credit Cards (25.22%) and NetBanking (25.02%) were the most exploited infrastructures, accounting for the highest financial losses (over $1M combined) despite transaction volumes being nearly identical across all channels.

High-Risk Merchant Categories: Fraudsters primarily cashed out through everyday categories like Utilities (~$328K) and Retail (~$326K), indicating that bad actors test stolen credentials on basic bills and retail goods to avoid detection.

Account Compromise: Isolated the Top 10 customer accounts exhibiting the highest volume of fraudulent activity, requiring immediate operational intervention (account freezing and credential resets).

💡 Strategic Recommendations

Dynamic Thresholding: Implement stricter transaction limits (velocity checks) specifically on Credit Card and NetBanking channels, rather than applying blanket rules that cause friction for all users.

Targeted Merchant Monitoring: Deploy automated alert systems for rapid, back-to-back transactions occurring within the Utilities and Retail sectors.

📂 Repository Structure

Creating_Dataset.py - Python script used to generate the raw 5M row messy dataset.

Cleaning_Dataset.py - Python script containing the Pandas cleaning logic (deduplication, imputation, formatting).

fraud_kpis.sql - T-SQL script used to query the database and extract business KPIs.

Fraud_Analysis_Dashboard.png - High-resolution screenshot of the final Power BI dashboard.

Scalable-Transactional-Fraud-Detection-Pipeline-and-Analysis.pdf - The final presentation deck summarizing the methodology and insights.

🚀 How to Reproduce This Project

Run Creating_Dataset.py to generate the local CSV file.

Run Cleaning_Dataset.py to output the sanitized dataset.

Import the cleaned CSV into an MS SQL Server database.

Execute the queries in fraud_kpis.sql via SQL Server Management Studio (SSMS).

Connect Power BI to your SQL Server instance via DirectQuery to build the visualizations.
