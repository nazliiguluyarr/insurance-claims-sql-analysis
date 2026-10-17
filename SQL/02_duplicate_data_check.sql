-- ============================================
-- 02. DUPLICATE DATA CHECK
-- ============================================

-- Duplicate agent IDs
SELECT
    agent_id,
    COUNT(*) AS record_count
FROM agents
GROUP BY agent_id
HAVING COUNT(*) > 1;


-- Duplicate vendor IDs
SELECT
    vendor_id,
    COUNT(*) AS record_count
FROM vendors
GROUP BY vendor_id
HAVING COUNT(*) > 1;


-- Duplicate claim transaction IDs
SELECT
    transaction_id,
    COUNT(*) AS record_count
FROM claims
GROUP BY transaction_id
HAVING COUNT(*) > 1;