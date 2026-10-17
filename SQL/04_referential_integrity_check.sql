-- =========================================================
-- 04. REFERENTIAL INTEGRITY CHECK
-- Insurance Claims Analytics Project
-- =========================================================


-- ---------------------------------------------------------
-- 1. CHECK CLAIMS -> AGENTS RELATIONSHIP
-- ---------------------------------------------------------

-- Claims with an agent_id that does not exist in agents table
SELECT
    c.transaction_id,
    c.agent_id
FROM claims c
LEFT JOIN agents a
    ON c.agent_id = a.agent_id
WHERE c.agent_id IS NOT NULL
  AND a.agent_id IS NULL;


-- Finding:
-- If this query returns 0 rows, all non-null agent_id values
-- in claims have a matching record in agents.



-- ---------------------------------------------------------
-- 2. CHECK CLAIMS -> VENDORS RELATIONSHIP
-- ---------------------------------------------------------

-- Claims with a vendor_id that does not exist in vendors table
SELECT
    c.transaction_id,
    c.vendor_id
FROM claims c
LEFT JOIN vendors v
    ON c.vendor_id = v.vendor_id
WHERE c.vendor_id IS NOT NULL
  AND v.vendor_id IS NULL;


-- Finding:
-- vendor_id may legitimately be NULL.
-- This query checks only non-null vendor IDs.
-- If 0 rows are returned, all populated vendor IDs
-- have a matching record in vendors.



-- ---------------------------------------------------------
-- 3. THREE-TABLE JOIN VALIDATION
-- ---------------------------------------------------------

-- Combine claims with agent and vendor information
SELECT
    c.transaction_id,
    c.claim_amount,
    c.claim_status,
    c.incident_severity,
    c.agent_id,
    a.agent_name,
    c.vendor_id,
    v.vendor_name
FROM claims c
LEFT JOIN agents a
    ON c.agent_id = a.agent_id
LEFT JOIN vendors v
    ON c.vendor_id = v.vendor_id
LIMIT 100;


-- Finding:
-- LEFT JOIN is used to preserve all claim records.
-- Claims without vendor involvement remain in the result
-- with vendor_name shown as NULL.