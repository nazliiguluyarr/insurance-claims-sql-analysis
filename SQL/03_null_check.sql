-- =========================================================
-- 03. NULL / MISSING DATA CHECK
-- Insurance Claims Analytics Project
-- =========================================================


-- ---------------------------------------------------------
-- 1. AGENTS TABLE
-- ---------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE agent_id IS NULL) AS agent_id_nulls,
    COUNT(*) FILTER (WHERE agent_name IS NULL) AS agent_name_nulls,
    COUNT(*) FILTER (WHERE date_of_joining IS NULL) AS joining_date_nulls,
    COUNT(*) FILTER (WHERE address_line1 IS NULL) AS address_line1_nulls,
    COUNT(*) FILTER (WHERE address_line2 IS NULL) AS address_line2_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE state IS NULL) AS state_nulls
FROM agents;


-- Check records with missing city information
SELECT *
FROM agents
WHERE city IS NULL
   OR city = '';


-- Finding:
-- 7 agent records have missing city information.
-- Missing values are limited to address-related fields.
-- Core identifiers are available, therefore these records are retained.



-- ---------------------------------------------------------
-- 2. VENDORS TABLE
-- ---------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE vendor_id IS NULL) AS vendor_id_nulls,
    COUNT(*) FILTER (WHERE vendor_name IS NULL) AS vendor_name_nulls,
    COUNT(*) FILTER (WHERE address_line1 IS NULL) AS address_line1_nulls,
    COUNT(*) FILTER (WHERE address_line2 IS NULL) AS address_line2_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE state IS NULL) AS state_nulls
FROM vendors;


-- Check records with missing city information
SELECT *
FROM vendors
WHERE city IS NULL
   OR city = '';


-- Finding:
-- 6 vendor records have missing city information.
-- Missing values are limited to address-related fields.
-- Core vendor identifiers are available, therefore these records are retained.



-- ---------------------------------------------------------
-- 3. CLAIMS TABLE
-- ---------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS transaction_id_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE policy_number IS NULL) AS policy_number_nulls,
    COUNT(*) FILTER (WHERE claim_amount IS NULL) AS claim_amount_nulls,
    COUNT(*) FILTER (WHERE premium_amount IS NULL) AS premium_amount_nulls,
    COUNT(*) FILTER (WHERE claim_status IS NULL) AS claim_status_nulls,
    COUNT(*) FILTER (WHERE incident_severity IS NULL) AS severity_nulls,
    COUNT(*) FILTER (WHERE insurance_type IS NULL) AS insurance_type_nulls,
    COUNT(*) FILTER (WHERE loss_dt IS NULL) AS loss_date_nulls,
    COUNT(*) FILTER (WHERE report_dt IS NULL) AS report_date_nulls,
    COUNT(*) FILTER (WHERE agent_id IS NULL) AS agent_id_nulls,
    COUNT(*) FILTER (WHERE vendor_id IS NULL) AS vendor_id_nulls
FROM claims;
 

-- Inspect claims without a vendor
SELECT *
FROM claims
WHERE vendor_id IS NULL
   OR vendor_id = '';


-- Finding:
-- insurance_type, loss_dt and report_dt contain no NULL values.
-- 3,245 claims have no vendor_id.
-- These records are retained.
-- Missing vendor information does not necessarily indicate bad data:
-- vendor involvement may not be required for every claim.
-- This may later be analysed as:
-- vendor-involved claims vs. claims without vendor involvement.