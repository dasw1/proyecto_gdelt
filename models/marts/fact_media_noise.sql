{{ config(materialized='table') }}

WITH latest_events AS (
    SELECT *
    FROM {{ ref('fact_events') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY event_id
        ORDER BY loaded_at DESC
    ) = 1
),

global_avg AS (
    SELECT AVG(num_articles) AS global_avg_articles
    FROM latest_events
)

SELECT
    d.date_id,
    a.actor_id,
    cf.cameo_full_id,
    COUNT(*)                                                    AS total_events,
    COALESCE(AVG(f.goldstein_scale), 0)                                      AS avg_goldstein,
    COALESCE(AVG(f.num_articles), 0)                                         AS avg_articles,
    COALESCE(AVG(f.num_mentions), 0)                                         AS avg_mentions,
    ROUND(AVG(f.num_articles) / NULLIF(ABS(AVG(f.goldstein_scale)), 0), 2) AS noise_index,
    CASE
        WHEN AVG(f.goldstein_scale) >= 0 
            AND AVG(f.num_articles) > (SELECT global_avg_articles FROM global_avg)
            THEN 'Overrepresented'
        WHEN AVG(f.goldstein_scale) >= 0 
            AND AVG(f.num_articles) <= (SELECT global_avg_articles FROM global_avg)
            THEN 'Underrepresented'
        WHEN AVG(f.goldstein_scale) < 0 
            AND AVG(f.num_articles) > (SELECT global_avg_articles FROM global_avg)
            THEN 'Noise'
        ELSE
            'Ignored'
    END                                                         AS noise_category
FROM latest_events f
JOIN {{ ref('dim_date') }} d          ON f.date_id = d.date_id
JOIN {{ ref('dim_actor') }} a   ON f.actor1_id = a.actor_id
JOIN {{ ref('dim_cameo') }} cf   ON f.cameo_code_id = cf.cameo_full_id
WHERE a.country_name IS NOT NULL
GROUP BY
    d.date_id,
    a.actor_id,
    cf.cameo_full_id