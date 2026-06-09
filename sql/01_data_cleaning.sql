-- ══════════════════════════════════════════════════════
-- 01_DATA_CLEANING.SQL
-- Online Retail RFM Analysis
-- UCI Online Retail Dataset (Dec 2010 - Dec 2011)
-- ══════════════════════════════════════════════════════

-- ── STEP 1: CREATE DATABASE ───────────────────────────
CREATE DATABASE IF NOT EXISTS online_retail;
USE online_retail;

-- ── STEP 2: CREATE RAW TABLE ──────────────────────────
CREATE TABLE sales (
    invoice_no  VARCHAR(20),
    stock_code  VARCHAR(20),
    descriptn   VARCHAR(255),
    quantity    INT,
    invoice_date DATETIME,
    unit_price  DECIMAL(10,2),
    customer_id INT,
    country     VARCHAR(255),
    revenue     DECIMAL(10,2)
);

-- ── STEP 3: SANITY CHECKS ─────────────────────────────

-- Check null values across all columns
SELECT 
    COUNT(*)                    AS total_rows,
    SUM(customer_id IS NULL)    AS null_customers,
    SUM(invoice_no IS NULL)     AS null_invoice_no,
    SUM(stock_code IS NULL)     AS null_stock_code,
    SUM(descriptn IS NULL)      AS null_desc,
    SUM(quantity <= 0)          AS invalid_quantity,
    SUM(unit_price <= 0)        AS invalid_price,
    SUM(revenue IS NULL)        AS invalid_revenue
FROM sales;

-- Check for duplicate rows
SELECT 
    COUNT(*) AS row_count,
    invoice_no, stock_code, quantity,
    invoice_date, unit_price, customer_id
FROM sales
GROUP BY 
    invoice_no, stock_code, quantity,
    invoice_date, unit_price, customer_id
HAVING COUNT(*) > 1;

-- Investigate specific duplicate pairs
SELECT 
    invoice_no, stock_code, descriptn, quantity,
    invoice_date, unit_price, customer_id 
FROM sales
WHERE invoice_no IN ('554084', '575335')
AND stock_code IN ('23298','23203');

-- ── STEP 4: CREATE CLEAN TABLE ────────────────────────
-- Resolves description-only duplicates by picking MIN description

CREATE TABLE sales_clean AS
SELECT
    invoice_no,
    stock_code,
    MIN(descriptn) AS descriptn,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    revenue
FROM sales
GROUP BY
    invoice_no, stock_code, quantity,
    invoice_date, unit_price, customer_id,
    country, revenue;

-- ── STEP 5: VERIFY CLEAN TABLE ────────────────────────

-- Confirm duplicates resolved
SELECT 
    invoice_no, stock_code, descriptn, quantity,
    invoice_date, unit_price, customer_id 
FROM sales_clean
WHERE invoice_no IN ('554084', '575335')
AND stock_code IN ('23298','23203');

-- Confirm no remaining duplicates
SELECT 
    COUNT(*) AS row_count,
    invoice_no, stock_code, quantity,
    invoice_date, unit_price, customer_id
FROM sales_clean
GROUP BY 
    invoice_no, stock_code, quantity,
    invoice_date, unit_price, customer_id
HAVING COUNT(*) > 1;

-- Confirm no negative quantities or prices
SELECT * FROM sales_clean 
WHERE quantity <= 0 OR unit_price <= 0;

-- Confirm date range: Dec 2010 - Dec 2011
SELECT 
    MIN(invoice_date) AS earliest_date, 
    MAX(invoice_date) AS latest_date 
FROM sales_clean;

-- Confirm no cancellation invoices (C-prefix)
SELECT * FROM sales_clean 
WHERE invoice_no LIKE 'C%';

-- Confirm no non-product stock codes
SELECT * FROM sales_clean 
WHERE stock_code NOT REGEXP '^[0-9]{5}[A-Za-z]?$';

-- Final row count
SELECT COUNT(*) AS clean_rows FROM sales_clean;
-- Expected: 390,857

-- ── STEP 6: FINAL SUMMARY STATS ──────────────────────
SELECT
    ROUND(SUM(revenue), 2)        AS total_revenue,
    COUNT(DISTINCT customer_id)   AS unique_customers,
    COUNT(DISTINCT invoice_no)    AS unique_invoices,
    COUNT(DISTINCT stock_code)    AS unique_products,
    COUNT(DISTINCT country)       AS unique_countries
FROM sales;

-- Verify revenue calculation accuracy
SELECT * FROM sales_clean
WHERE ABS(revenue - (quantity * unit_price)) > 0.01;
