{{ config(materialized='table') }}

WITH latest_events AS (
    SELECT *
    FROM {{ ref('fact_gdelt_events') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY event_id
        ORDER BY date_added DESC
    ) = 1
)

SELECT
    c1.country_name                                 AS country_from,
    c2.country_name                                 AS country_to,
    COUNT(*)                                        AS total_events,
    AVG(f.goldstein_scale)                          AS avg_goldstein,
    AVG(f.avg_tone)                                 AS avg_tone,
    MODE(f.quad_class_id)                           AS dominant_quad_class,
    MODE(cf.cameo_code_desc)                        AS dominant_cameo_root,
    CASE
        WHEN AVG(f.goldstein_scale) >= 3  THEN 'Strong Cooperation'
        WHEN AVG(f.goldstein_scale) >= 0  THEN 'Mild Cooperation'
        WHEN AVG(f.goldstein_scale) >= -3 THEN 'Mild Conflict'
        ELSE 'Strong Conflict'
    END                                             AS relationship_type,
    CASE
        WHEN AVG(f.goldstein_scale) >= 0 AND AVG(f.avg_tone) < 0 
            THEN 'Cooperation under tension'
        WHEN AVG(f.goldstein_scale) < 0 AND AVG(f.avg_tone) >= 0 
            THEN 'Conflict with positive narrative'
        WHEN AVG(f.goldstein_scale) >= 0 AND AVG(f.avg_tone) >= 0 
            THEN 'Clear cooperation'
        ELSE 
            'Clear conflict'
    END                                             AS narrative_vs_reality,
    SUM(f.num_articles)                             AS total_articles,
    SUM(f.num_mentions)                             AS total_mentions,
    AVG(f.num_articles)                             AS avg_articles_per_event,
    COUNT(DISTINCT cf.cameo_root_id)                AS distinct_cameo_roots,
    SUM(CASE 
        WHEN f.quad_class_id IN (1,2) THEN 1 ELSE 0 
        END)                                        AS cooperation_events,
    SUM(CASE 
        WHEN f.quad_class_id IN (3,4) THEN 1 ELSE 0 
        END)                                        AS conflict_events,
    ROUND(
        SUM(CASE 
            WHEN f.quad_class_id IN (1,2) THEN 1 ELSE 0 
            END) * 100.0 / COUNT(*), 1)             AS cooperation_rate,
    STDDEV(f.goldstein_scale)                       AS goldstein_volatility,
    SUM(CASE WHEN ABS(f.goldstein_scale) >= 7 THEN 1 ELSE 0 END) AS high_impact_events
FROM latest_events f
JOIN {{ ref('dim_gdelt_actor') }} a1        ON f.actor1_id = a1.actor_id
JOIN {{ ref('dim_gdelt_actor') }} a2        ON f.actor2_id = a2.actor_id
JOIN {{ ref('dim_gdelt_country') }} c1      ON a1.country_id = c1.country_id
JOIN {{ ref('dim_gdelt_country') }} c2      ON a2.country_id = c2.country_id
JOIN {{ ref('dim_gdelt_cameo_full') }} cf   ON f.cameo_code_id = cf.cameo_full_id
WHERE a1.country_id IS NOT NULL
  AND a2.country_id IS NOT NULL
  AND a1.country_id != a2.country_id
GROUP BY c1.country_name, c2.country_name