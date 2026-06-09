-- ══════════════════════════════════════════════════════
-- 02_RFM_SCORING.SQL
-- Online Retail RFM Analysis
-- Snapshot date: 2011-12-10
-- ══════════════════════════════════════════════════════

-- ── STEP 1: CALCULATE RFM METRICS ────────────────────
-- Recency  = days since last purchase (snapshot: 2011-12-10)
-- Frequency = count of distinct invoices
-- Monetary  = total revenue

CREATE TABLE rfm_scores AS
WITH rfm_base AS (
    SELECT 
        customer_id,
        DATEDIFF('2011-12-10', MAX(invoice_date)) AS recency,
        COUNT(DISTINCT invoice_no)                AS frequency,
        SUM(revenue)                              AS monetary
    FROM sales_clean
    GROUP BY customer_id
    ORDER BY recency
),

-- ── STEP 2: SCORE EACH METRIC USING NTILE(5) ─────────
-- Recency:  ORDER BY DESC — lower days = more recent = better = score 5
-- Frequency: ORDER BY ASC  — higher frequency = better = score 5
-- Monetary:  ORDER BY ASC  — higher spend = better = score 5

rfm_scored AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency   DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC)  AS f_score,
        NTILE(5) OVER (ORDER BY monetary  ASC)  AS m_score
    FROM rfm_base
)
SELECT * FROM rfm_scored;

-- ── VERIFY ────────────────────────────────────────────
-- Row count — expected: 4,334
SELECT COUNT(*) AS total_customers FROM rfm_scores;

-- Preview scores
SELECT * FROM rfm_scores LIMIT 10;
