-- =========================================================
-- 05. EXPLORATORY DATA ANALYSIS
-- Insurance Claims Analytics Project
-- =========================================================


-- ---------------------------------------------------------
-- 1. OVERALL CLAIM PORTFOLIO SUMMARY
-- ---------------------------------------------------------

SELECT
    COUNT(*) AS total_claims,
    SUM(claim_amount) AS total_claim_amount,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
    MIN(claim_amount) AS min_claim_amount,
    MAX(claim_amount) AS max_claim_amount
FROM claims;


/*
Finding:
- Total claims: 10,000
- Total claim amount: 165,638,300
- Average claim amount: 16,563.83
- Claim amounts range from 100 to 100,000.

The wide min-max range suggests that overall averages should not
be interpreted without examining differences between insurance types.
*/



-- ---------------------------------------------------------
-- 2. CLAIM FREQUENCY & SEVERITY BY INSURANCE TYPE
-- ---------------------------------------------------------

WITH claims_statistics AS (
    SELECT
        insurance_type,
        COUNT(*) AS claim_count,
        SUM(claim_amount) AS total_claim_amount,
        AVG(claim_amount) AS avg_claim_amount,
        MIN(claim_amount) AS min_claim_amount,
        MAX(claim_amount) AS max_claim_amount,

        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS median_claim_amount

    FROM claims
    GROUP BY insurance_type
)

SELECT
    insurance_type,
    ROUND(avg_claim_amount, 2) AS avg_claim_amount,
    min_claim_amount,
    max_claim_amount,
    median_claim_amount,

    ROUND(
        claim_count * 100.0
        / SUM(claim_count) OVER (),
        2
    ) AS claim_count_pct,

    ROUND(
        total_claim_amount * 100.0
        / SUM(total_claim_amount) OVER (),
        2
    ) AS claim_amount_pct

FROM claims_statistics
ORDER BY claim_amount_pct DESC;


/*
Findings:
- Claim frequency is relatively evenly distributed across insurance types.
- Claim severity differs substantially between insurance types.

- Life insurance represents approximately 16.82% of claim volume
  but approximately 55.23% of total claim value.

- Property represents approximately 16.92% of claim volume
  but approximately 25.10% of total claim value.

- Mobile represents approximately 16.92% of claim volume
  but only approximately 0.42% of total claim value.

- Mean and median claim amounts are relatively close within most
  insurance types, suggesting that the large differences in total
  claim value are mainly driven by structural differences in typical
  claim size rather than claim frequency alone.
*/



-- ---------------------------------------------------------
-- 3. CLAIM STATUS DISTRIBUTION
-- ---------------------------------------------------------

WITH claim_status_summary AS (
    SELECT
        claim_status,
        COUNT(*) AS claim_count
    FROM claims
    GROUP BY claim_status
)

SELECT
    claim_status,
    claim_count,

    ROUND(
        claim_count * 100.0
        / SUM(claim_count) OVER (),
        2
    ) AS claim_status_pct

FROM claim_status_summary;


/*
Finding:
- Status A represents 94.97% of claim records.
- Status D represents 5.03% of claim records.

Note:
The dataset should be consulted before assigning business meanings
such as "Approved" or "Denied" to A and D.
The analysis therefore retains the original status codes.
*/



-- ---------------------------------------------------------
-- 4. CLAIM ANALYSIS BY INCIDENT SEVERITY
-- ---------------------------------------------------------

SELECT
    incident_severity,
    COUNT(*) AS severity_count,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(claim_amount), 2) AS total_claim_amount,
    MIN(claim_amount) AS min_claim_amount,
    MAX(claim_amount) AS max_claim_amount,

    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY claim_amount
    ) AS median_claim_amount

FROM claims
GROUP BY incident_severity;


/*
Findings:
- Claim counts are relatively similar across Major Loss,
  Minor Loss and Total Loss categories.

- Average claim amounts are also relatively similar across
  the three severity groups.

- Mean claim amounts are substantially higher than median claim
  amounts in all severity groups, suggesting that higher-value
  claims may be pulling the averages upward.

- At the aggregate level, incident severity alone does not appear
  to explain large differences in claim cost.

Further analysis could examine severity within each insurance type.
*/



-- ---------------------------------------------------------
-- 5. MONTHLY CLAIM TREND
-- ---------------------------------------------------------

SELECT
    DATE_TRUNC('month', loss_dt) AS loss_month,
    COUNT(*) AS claim_count,
    SUM(claim_amount) AS total_claim_amount,
    MIN(loss_dt) AS min_loss_date,
    MAX(loss_dt) AS max_loss_date,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount

FROM claims
GROUP BY loss_month
ORDER BY loss_month;


/*
Findings:
- Monthly claim volume is relatively stable across full months.
- May 2020 contains only records from May 12 to May 31 and is therefore
  a partial month. It should not be directly compared with full months.

- June 2021 contains records from June 1 to June 29.
  It is retained in the analysis but should be interpreted with
  a completeness caveat.

- Across the complete months, claim volume and average claim amount
  do not show extreme month-to-month volatility.
*/



-- =========================================================
-- EDA SUMMARY
-- =========================================================

/*
1. Claim frequency is relatively balanced across insurance types,
   but claim severity differs substantially.

2. Life and Property insurance account for a disproportionately
   large share of total claim value despite similar claim frequencies
   to the other insurance types.

3. Mobile insurance shows the opposite pattern:
   similar claim frequency but very low claim severity.

4. Incident severity categories show similar aggregate claim counts
   and average claim amounts. Insurance type appears to explain
   claim-cost differences more strongly at this stage of the analysis.

5. The first month in the dataset is incomplete and should not be
   treated as directly comparable with full months.

These EDA findings will be used to formulate deeper business questions
in 06_business_analysis.sql.
*/