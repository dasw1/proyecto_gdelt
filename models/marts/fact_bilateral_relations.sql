{{ config(materialized='table') }}

WITH latest_events AS (
    SELECT *
    FROM {{ ref('fact_events') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY event_id
        ORDER BY loaded_at DESC
    ) = 1
)

SELECT
    a1.actor_id                             AS country_from,
    a2.actor_id                             AS country_to,
    COUNT(*)                                    AS total_events,
    COALESCE(AVG(f.goldstein_scale), 0)         AS avg_goldstein,
    COALESCE(AVG(f.avg_tone), 0)                AS avg_tone,
    COALESCE(AVG(f.goldstein_scale), 0) + COALESCE(AVG(f.avg_tone), 0) AS narrative_vs_reality_value,
    MODE(cf.cameo_code_desc)                    AS dominant_cameo_root,
    CASE
        WHEN AVG(f.goldstein_scale) >= 0 AND AVG(f.avg_tone) < 0 
            THEN 'Cooperation under tension'
        WHEN AVG(f.goldstein_scale) < 0 AND AVG(f.avg_tone) >= 0 
            THEN 'Conflict with positive narrative'
        WHEN AVG(f.goldstein_scale) >= 0 AND AVG(f.avg_tone) >= 0 
            THEN 'Clear cooperation'
        ELSE 
            'Clear conflict'
    END                                         AS narrative_vs_reality,
    SUM(f.num_articles)                         AS total_articles,
    SUM(f.num_mentions)                         AS total_mentions,
    AVG(f.num_articles)                         AS avg_articles_per_event
FROM latest_events f
JOIN {{ ref('dim_actor') }} a1  ON f.actor1_id = a1.actor_id
JOIN {{ ref('dim_actor') }} a2  ON f.actor2_id = a2.actor_id
JOIN {{ ref('dim_cameo') }} cf  ON f.cameo_code_id = cf.cameo_full_id
WHERE a1.country_name IS NOT NULL
  AND a2.country_name IS NOT NULL
  AND a1.country_name != a2.country_name
GROUP BY 
     a1.actor_id,
     a2.actor_id