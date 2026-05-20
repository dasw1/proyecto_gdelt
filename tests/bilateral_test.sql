SELECT 
    actor1_id,
    actor2_id,
    COUNT(*) AS cnt
FROM {{ ref('fact_bilateral_relations') }}
GROUP BY actor1_id, actor2_id
HAVING COUNT(*) > 1