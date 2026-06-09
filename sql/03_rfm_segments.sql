-- ══════════════════════════════════════════════════════
-- 03_RFM_SEGMENTS.SQL
-- Online Retail RFM Analysis
-- Assigns segment labels based on R and F scores
-- ══════════════════════════════════════════════════════

-- ── STEP 1: CREATE SEGMENTS TABLE ────────────────────
-- Segment logic based on R and F scores
-- M score used for scoring but not segmentation rules

CREATE TABLE rfm_segments AS
SELECT 
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score = 3  THEN 'Potential Loyalists'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score = 3  AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score = 3  AND f_score <= 2 THEN 'Need Attention'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score = 1  AND f_score <= 2 THEN 'Lost'
        WHEN r_score = 2  AND f_score <= 2 THEN 'Need Attention'
        ELSE 'Need Attention'
    END AS segment
FROM rfm_scores;

-- ── STEP 2: VERIFY ────────────────────────────────────

-- Row count — expected: 4,334
SELECT COUNT(*) AS total_customers FROM rfm_segments;

-- No nulls in segment column
SELECT COUNT(*) AS null_segments 
FROM rfm_segments 
WHERE segment IS NULL;
-- Expected: 0

-- ── STEP 3: SEGMENT DISTRIBUTION ─────────────────────
SELECT 
    segment,
    COUNT(*)                                        AS customer_count,
    ROUND(SUM(monetary), 2)                         AS total_revenue,
    ROUND(AVG(recency), 2)                          AS avg_recency,
    ROUND(AVG(frequency), 2)                        AS avg_frequency,
    ROUND(AVG(monetary), 2)                         AS avg_monetary,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM rfm_segments
GROUP BY segment
ORDER BY total_revenue DESC;
