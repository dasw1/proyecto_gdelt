SELECT 
    country_from,
    country_to,
    COUNT(*) AS cnt
FROM {{ ref('fact_bilateral_relations') }}
GROUP BY country_from, country_to
HAVING COUNT(*) > 1