-- ====================================================================
-- PROJECT: Scalable Transactional Fraud Detection Pipeline
-- SCRIPT: Core Business KPIs & Exploratory Data Analysis
-- ====================================================================

-- --------------------------------------------------------------------
-- KPI 1: Executive Summary (Macro Level Health)
-- Tells the business how much money is being processed and lost to fraud.
-- --------------------------------------------------------------------
SELECT 
    COUNT(transaction_id) AS Total_Transactions,
    SUM(CAST(is_fraud AS INT)) AS Total_Fraud_Cases,
    CAST(SUM(CAST(is_fraud AS INT)) * 100.0 / COUNT(transaction_id) AS DECIMAL(5,2)) AS Fraud_Rate_Pct,
    CAST(SUM(amount) AS DECIMAL(15,2)) AS Total_Processed_Volume_USD,
    CAST(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS DECIMAL(15,2)) AS Total_Fraud_Loss_USD
FROM cleaned_transaction_data;

-- --------------------------------------------------------------------
-- KPI 2: Transaction Value Analysis
-- Are fraudsters stealing in large chunks or small, unnoticeable amounts?
-- --------------------------------------------------------------------
SELECT 
    CAST(AVG(CASE WHEN is_fraud = 0 THEN amount END) AS DECIMAL(10,2)) AS Avg_Legit_Transaction_Value,
    CAST(AVG(CASE WHEN is_fraud = 1 THEN amount END) AS DECIMAL(10,2)) AS Avg_Fraud_Transaction_Value,
    CAST(MAX(CASE WHEN is_fraud = 1 THEN amount END) AS DECIMAL(10,2)) AS Max_Fraud_Amount
FROM cleaned_transaction_data;

-- --------------------------------------------------------------------
-- KPI 3: Vulnerability by Payment Method
-- Identifies which payment channels (e.g., Credit Card vs UPI) need tighter security.
-- --------------------------------------------------------------------
SELECT 
    payment_method,
    COUNT(transaction_id) AS Total_Transactions,
    SUM(CAST(is_fraud AS INT)) AS Fraud_Cases,
    CAST(SUM(CAST(is_fraud AS INT)) * 100.0 / COUNT(transaction_id) AS DECIMAL(5,2)) AS Fraud_Rate_Pct,
    CAST(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS DECIMAL(15,2)) AS Financial_Loss
FROM cleaned_transaction_data
GROUP BY payment_method
ORDER BY Fraud_Rate_Pct DESC;

-- --------------------------------------------------------------------
-- KPI 4: High-Risk Merchant Categories
-- Identifies where fraudsters are cashing out (e.g., Electronics, Travel).
-- --------------------------------------------------------------------
SELECT 
    merchant_category,
    COUNT(transaction_id) AS Total_Transactions,
    SUM(CAST(is_fraud AS INT)) AS Fraud_Cases,
    CAST(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS DECIMAL(15,2)) AS Total_Stolen_Amount
FROM cleaned_transaction_data
GROUP BY merchant_category
ORDER BY Total_Stolen_Amount DESC;

-- --------------------------------------------------------------------
-- KPI 5: Top 10 Most Compromised Accounts
-- Identifies specific customer accounts that have been hit the hardest.
-- --------------------------------------------------------------------
SELECT TOP 10
    customer_id,
    COUNT(transaction_id) AS Total_Transactions,
    SUM(CAST(is_fraud AS INT)) AS Fraudulent_Transactions,
    CAST(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS DECIMAL(15,2)) AS Total_Fraud_Amount
FROM cleaned_transaction_data
GROUP BY customer_id
HAVING SUM(CAST(is_fraud AS INT)) > 0
ORDER BY Total_Fraud_Amount DESC;