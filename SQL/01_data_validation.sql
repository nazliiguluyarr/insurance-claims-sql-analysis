SELECT
    'agents' AS table_name,
    COUNT(*) AS row_count
FROM agents

UNION ALL

SELECT
    'claims' AS table_name,
    COUNT(*) AS row_count
FROM claims

UNION ALL

SELECT
    'vendors' AS table_name,
    COUNT(*) AS row_count
FROM vendors;