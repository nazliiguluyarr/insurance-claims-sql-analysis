-- =========================================================
-- 06. BUSINESS ANALYSIS
-- Insurance Claims Analytics Project
-- =========================================================


-- =========================================================
-- 1. INSURANCE TYPE × INCIDENT SEVERITY ANALYSIS
-- =========================================================
-- Business Question:
-- Does incident severity affect claim amount
-- when insurance type is controlled for? 

SELECT
    insurance_type,
    incident_severity,
    COUNT(*) AS claim_count,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
    MIN(claim_amount) AS min_claim_amount,
    MAX(claim_amount) AS max_claim_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY claim_amount
    ) AS median_claim_amount
FROM claims
GROUP BY
    insurance_type,
    incident_severity
ORDER BY
    insurance_type,
    incident_severity;


/*
Finding:
Claim amounts remain relatively similar across incident severity
categories when insurance type is held constant.

Insurance type appears to explain claim-cost differences more
strongly than incident severity in this dataset.
*/



-- =========================================================
-- 2. VENDOR INVOLVEMENT ANALYSIS
-- =========================================================
-- Business Question:
-- Are claims involving a vendor more expensive?

SELECT
    CASE
        WHEN vendor_id IS NULL THEN 'No Vendor'
        ELSE 'Vendor Involved'
    END AS vendor_involvement,

    COUNT(*) AS claim_count,
    ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
    MIN(claim_amount) AS min_claim_amount,
    MAX(claim_amount) AS max_claim_amount,
    SUM(claim_amount) AS total_claim_amount,

    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY claim_amount
    ) AS median_claim_amount

FROM claims
GROUP BY vendor_involvement
ORDER BY claim_count DESC;


/*
Findings:
- Vendor Involved claims: 6,755
- No Vendor claims: 3,245

Vendor-involved claims are more common, but average and median
claim amounts are very similar between the two groups.

The higher total claim amount for vendor-involved claims is mainly
a volume effect rather than evidence that individual claims are
systematically more expensive.
*/



-- =========================================================
-- 3. AGENT-LEVEL CLAIM ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- 3.1 CLAIM VOLUME BY AGENT
-- ---------------------------------------------------------

SELECT
    a.agent_id,
    a.agent_name,
    COUNT(c.transaction_id) AS claim_count,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount,
    ROUND(SUM(c.claim_amount), 0) AS total_claim_amount

FROM agents a

LEFT JOIN claims c
    ON a.agent_id = c.agent_id

GROUP BY
    a.agent_id,
    a.agent_name

ORDER BY claim_count DESC;


/*
This identifies agents with the highest claim volume.
*/


-- ---------------------------------------------------------
-- 3.2 TOTAL CLAIM COST BY AGENT
-- ---------------------------------------------------------

SELECT
    a.agent_id,
    a.agent_name,
    COUNT(c.transaction_id) AS claim_count,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount,
    ROUND(SUM(c.claim_amount), 0) AS total_claim_amount

FROM agents a

LEFT JOIN claims c
    ON a.agent_id = c.agent_id

GROUP BY
    a.agent_id,
    a.agent_name

ORDER BY total_claim_amount DESC NULLS LAST;


/*
The agents with the highest claim volume are not necessarily
the same agents with the highest total claim cost.
*/


-- ---------------------------------------------------------
-- 3.3 AGENT-LEVEL CORRELATION ANALYSIS
-- ---------------------------------------------------------

WITH agents_statistics AS (

    SELECT
        a.agent_id,
        a.agent_name,
        COUNT(c.transaction_id) AS claim_count,
        AVG(c.claim_amount) AS avg_claim_amount,
        SUM(c.claim_amount) AS total_claim_amount

    FROM agents a

    LEFT JOIN claims c
        ON a.agent_id = c.agent_id

    GROUP BY
        a.agent_id,
        a.agent_name
)

SELECT
    CORR(
        claim_count,
        total_claim_amount
    ) AS count_total_correlation,

    CORR(
        claim_count,
        avg_claim_amount
    ) AS count_avg_correlation

FROM agents_statistics

WHERE claim_count > 0;


/*
Findings:
- Claim count vs total claim amount correlation ≈ +0.585
- Claim count vs average claim amount correlation ≈ -0.010

Claim volume has a moderate positive relationship with total claim cost.

However, claim volume has almost no linear relationship with
average claim amount.

Higher-volume agents therefore generate more total cost mainly
because they handle more claims, not because their individual
claims are systematically more expensive.
*/



-- =========================================================
-- 4. VENDOR-LEVEL CLAIM ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- 4.1 CLAIM VOLUME BY VENDOR
-- ---------------------------------------------------------

SELECT
    v.vendor_id,
    v.vendor_name,
    COUNT(c.transaction_id) AS claim_count,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount,
    ROUND(SUM(c.claim_amount), 0) AS total_claim_amount

FROM vendors v

LEFT JOIN claims c
    ON v.vendor_id = c.vendor_id

GROUP BY
    v.vendor_id,
    v.vendor_name

ORDER BY claim_count DESC;


/*
This identifies vendors associated with the highest claim volume.
*/


-- ---------------------------------------------------------
-- 4.2 TOTAL CLAIM COST BY VENDOR
-- ---------------------------------------------------------

SELECT
    v.vendor_id,
    v.vendor_name,
    COUNT(c.transaction_id) AS claim_count,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount,
    ROUND(SUM(c.claim_amount), 0) AS total_claim_amount

FROM vendors v

LEFT JOIN claims c
    ON v.vendor_id = c.vendor_id

GROUP BY
    v.vendor_id,
    v.vendor_name

ORDER BY total_claim_amount DESC NULLS LAST;


/*
Vendor rankings by claim volume and total claim cost
do not fully overlap.
*/


-- ---------------------------------------------------------
-- 4.3 VENDOR-LEVEL CORRELATION ANALYSIS
-- ---------------------------------------------------------

WITH vendor_statistics AS (

    SELECT
        v.vendor_id,
        v.vendor_name,
        COUNT(c.transaction_id) AS claim_count,
        AVG(c.claim_amount) AS avg_claim_amount,
        SUM(c.claim_amount) AS total_claim_amount

    FROM vendors v

    LEFT JOIN claims c
        ON v.vendor_id = c.vendor_id

    GROUP BY
        v.vendor_id,
        v.vendor_name
)

SELECT
    CORR(
        claim_count,
        total_claim_amount
    ) AS count_total_correlation,

    CORR(
        claim_count,
        avg_claim_amount
    ) AS count_avg_correlation

FROM vendor_statistics

WHERE claim_count > 0;


/*
Findings:
- Claim count vs total claim amount correlation ≈ +0.603
- Claim count vs average claim amount correlation ≈ +0.018

Vendor claim volume has a moderate positive relationship with
total claim cost.

There is almost no relationship between vendor claim volume
and average claim amount.
*/



-- =========================================================
-- 5. REPORTING DELAY ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- 5.1 OVERALL REPORTING DELAY
-- ---------------------------------------------------------
-- Reporting delay =
-- report date - loss date

WITH reporting_delay AS (

    SELECT
        transaction_id,
        loss_dt,
        report_dt,
        report_dt - loss_dt AS reporting_delay_days

    FROM claims
)

SELECT
    ROUND(
        AVG(reporting_delay_days),
        2
    ) AS average_reporting_delay,

    MIN(reporting_delay_days) AS min_reporting_delay,

    MAX(reporting_delay_days) AS max_reporting_delay,

    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY reporting_delay_days
    ) AS median_reporting_delay

FROM reporting_delay;


/*
Findings:
- Average reporting delay: 3.21 days
- Median reporting delay: 3 days
- Minimum: 0 days
- Maximum: 5 days

Reporting delays are concentrated within a relatively narrow range.
*/



-- ---------------------------------------------------------
-- 5.2 REPORTING DELAY BY INSURANCE TYPE
-- ---------------------------------------------------------

WITH reporting_delay AS (

    SELECT
        insurance_type,
        transaction_id,
        loss_dt,
        report_dt,
        report_dt - loss_dt AS reporting_delay_days

    FROM claims
)

SELECT
    insurance_type,

    ROUND(
        AVG(reporting_delay_days),
        2
    ) AS average_reporting_delay,

    MIN(reporting_delay_days) AS min_reporting_delay,

    MAX(reporting_delay_days) AS max_reporting_delay,

    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY reporting_delay_days
    ) AS median_reporting_delay

FROM reporting_delay

GROUP BY insurance_type

ORDER BY insurance_type;


/*
Average reporting delays are very similar across insurance types.

Property had a median reporting delay of 5 days,
while the other insurance types generally had a median of 3 days.
*/



-- ---------------------------------------------------------
-- 5.3 REPORTING DELAY BY INSURANCE TYPE × INCIDENT SEVERITY
-- ---------------------------------------------------------

WITH reporting_delay AS (

    SELECT
        insurance_type,
        incident_severity,
        transaction_id,
        loss_dt,
        report_dt,
        report_dt - loss_dt AS reporting_delay_days

    FROM claims
)

SELECT
    insurance_type,
    incident_severity,

    ROUND(
        AVG(reporting_delay_days),
        2
    ) AS average_reporting_delay,

    MIN(reporting_delay_days) AS min_reporting_delay,

    MAX(reporting_delay_days) AS max_reporting_delay,

    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY reporting_delay_days
    ) AS median_reporting_delay

FROM reporting_delay

GROUP BY
    insurance_type,
    incident_severity

ORDER BY
    insurance_type,
    incident_severity;


/*
Several insurance type × severity combinations showed
a median reporting delay of 5 days despite averages
remaining around 3 days.
*/



-- ---------------------------------------------------------
-- 5.4 REPORTING DELAY DISTRIBUTION EXAMPLE:
-- PROPERTY × MAJOR LOSS
-- ---------------------------------------------------------

WITH reporting_delay AS (

    SELECT
        insurance_type,
        incident_severity,
        transaction_id,
        loss_dt,
        report_dt,
        report_dt - loss_dt AS reporting_delay_days

    FROM claims
)

SELECT
    reporting_delay_days,
    COUNT(*) AS claim_count

FROM reporting_delay

WHERE insurance_type = 'Property'
  AND incident_severity = 'Major Loss'

GROUP BY reporting_delay_days

ORDER BY reporting_delay_days;


/*
Property + Major Loss distribution:

0 days → 91 claims
1 day  → 58 claims
2 days → 53 claims
3 days → 64 claims
5 days → 277 claims

More than half of this segment is reported after 5 days,
which explains why the median is 5 days.

Faster-reported claims reduce the average delay to approximately
3.21 days.
*/



-- =========================================================
-- 6. HIGH-VALUE CLAIM / RISK CONCENTRATION ANALYSIS
-- =========================================================


-- ---------------------------------------------------------
-- 6.1 DEFINE HIGH-VALUE CLAIM THRESHOLD
-- ---------------------------------------------------------
-- High-value claims are defined using the 95th percentile
-- rather than an arbitrary monetary threshold.

SELECT
    PERCENTILE_CONT(0.95) WITHIN GROUP (
        ORDER BY claim_amount
    ) AS high_value_threshold

FROM claims;


/*
95th percentile threshold = 72,000
*/



-- ---------------------------------------------------------
-- 6.2 CLASSIFY CLAIMS AS HIGH VALUE OR REGULAR
-- ---------------------------------------------------------

WITH threshold AS (

    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS high_value_threshold

    FROM claims
),

classified_claims AS (

    SELECT
        c.transaction_id,
        c.claim_amount,

        CASE
            WHEN c.claim_amount > t.high_value_threshold
                THEN 'High Value'
            ELSE 'Regular'
        END AS claim_category

    FROM claims c

    CROSS JOIN threshold t
),

category_summary AS (

    SELECT
        claim_category,
        COUNT(*) AS claim_count

    FROM classified_claims

    GROUP BY claim_category
)

SELECT
    claim_category,
    claim_count,

    ROUND(
        claim_count * 100.0
        / SUM(claim_count) OVER (),
        2
    ) AS claim_pct

FROM category_summary

ORDER BY claim_count DESC;


/*
Results:
- Regular: 9,502 claims → 95.02%
- High Value: 498 claims → 4.98%

Because the threshold is > 72,000 rather than >= 72,000,
the High Value group is slightly below exactly 5%.
*/



-- ---------------------------------------------------------
-- 6.3 HIGH-VALUE CLAIMS BY INSURANCE TYPE
-- ---------------------------------------------------------

WITH threshold AS (

    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS high_value_threshold

    FROM claims
),

classified_claims AS (

    SELECT
        c.transaction_id,
        c.claim_amount,
        c.insurance_type,

        CASE
            WHEN c.claim_amount > t.high_value_threshold
                THEN 'High Value'
            ELSE 'Regular'
        END AS claim_category

    FROM claims c

    CROSS JOIN threshold t
)

SELECT
    insurance_type,
    COUNT(*) AS high_value_claim_count

FROM classified_claims

WHERE claim_category = 'High Value'

GROUP BY insurance_type

ORDER BY high_value_claim_count DESC;


/*
Finding:
All 498 portfolio-level high-value claims belong to Life insurance.

High-value claim risk is therefore fully concentrated in the
Life insurance segment when using a portfolio-wide 95th percentile
threshold.
*/



-- ---------------------------------------------------------
-- 6.4 HIGH-VALUE LIFE CLAIMS BY INCIDENT SEVERITY
-- ---------------------------------------------------------

WITH threshold AS (

    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS high_value_threshold

    FROM claims
),

classified_claims AS (

    SELECT
        c.transaction_id,
        c.claim_amount,
        c.insurance_type,
        c.incident_severity,

        CASE
            WHEN c.claim_amount > t.high_value_threshold
                THEN 'High Value'
            ELSE 'Regular'
        END AS claim_category

    FROM claims c

    CROSS JOIN threshold t
)

SELECT
    insurance_type,
    incident_severity,
    COUNT(*) AS high_value_claim_count

FROM classified_claims

WHERE claim_category = 'High Value'

GROUP BY
    insurance_type,
    incident_severity

ORDER BY high_value_claim_count DESC;


/*
Results:
Major Loss → 175
Total Loss → 163
Minor Loss → 160

High-value Life claims are relatively evenly distributed across
incident severity categories.

Risk concentration therefore appears much stronger by insurance
type than by incident severity.
*/



-- ---------------------------------------------------------
-- 6.5 HIGH-VALUE CLAIM CONCENTRATION BY AGENT
-- ---------------------------------------------------------

WITH threshold AS (

    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS high_value_threshold

    FROM claims
),

classified_claims AS (

    SELECT
        c.transaction_id,
        c.claim_amount,
        c.agent_id,

        CASE
            WHEN c.claim_amount > t.high_value_threshold
                THEN 'High Value'
            ELSE 'Regular'
        END AS claim_category

    FROM claims c

    CROSS JOIN threshold t
),

agent_summary AS (

    SELECT
        agent_id,
        COUNT(*) AS high_value_claim_count

    FROM classified_claims

    WHERE claim_category = 'High Value'

    GROUP BY agent_id
)

SELECT
    agent_id,
    high_value_claim_count,
    COUNT(*) OVER () AS agents_with_high_value_claims

FROM agent_summary

ORDER BY high_value_claim_count DESC

LIMIT 10;


/*
Findings:
498 high-value claims are spread across 421 different agents.

The highest concentration for a single agent is only 4 claims.

High-value claims therefore do not appear to be concentrated
among a small number of agents.
*/



-- ---------------------------------------------------------
-- 6.6 HIGH-VALUE CLAIM CONCENTRATION BY VENDOR
-- ---------------------------------------------------------

WITH threshold AS (

    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (
            ORDER BY claim_amount
        ) AS high_value_threshold

    FROM claims
),

classified_claims AS (

    SELECT
        c.transaction_id,
        c.claim_amount,
        c.vendor_id,

        CASE
            WHEN c.claim_amount > t.high_value_threshold
                THEN 'High Value'
            ELSE 'Regular'
        END AS claim_category

    FROM claims c

    CROSS JOIN threshold t
)

SELECT
    vendor_id,
    COUNT(*) AS high_value_claim_count

FROM classified_claims

WHERE claim_category = 'High Value'

GROUP BY vendor_id

ORDER BY high_value_claim_count DESC

LIMIT 10;


/*
Findings:
- 156 high-value claims have no vendor assigned.
- The highest identified vendor concentration is only 4 claims.

High-value claims do not appear to be concentrated among a small
number of vendors.

The share of high-value claims without a vendor is also close to
the overall no-vendor share in the dataset.
*/



-- =========================================================
-- BUSINESS ANALYSIS SUMMARY
-- =========================================================

/*
1. Insurance type explains claim-cost differences more strongly
   than incident severity.

2. Vendor involvement is common, but vendor-involved claims are
   not systematically more expensive on a per-claim basis.

3. At agent level, claim volume has a moderate positive relationship
   with total claim cost, but almost no relationship with average
   claim amount.

4. Vendor-level analysis shows the same pattern:
   higher volume increases total cost, while average claim severity
   remains largely unrelated to vendor claim volume.

5. Overall reporting delay is approximately 3.21 days, with a
   median of 3 days and a range of 0–5 days.

6. Portfolio-level high-value claim risk is strongly concentrated
   in Life insurance.

7. Within Life insurance, high-value claims are relatively evenly
   distributed across incident severity categories.

8. High-value claims are widely distributed across agents and vendors
   rather than being concentrated among a small number of entities.

Overall, the strongest driver of claim-cost differences in this
dataset is insurance type rather than incident severity, agent,
or vendor.
*/