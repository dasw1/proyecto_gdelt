{{ config(materialized='table') }}

WITH latest_events AS (
    SELECT *
    FROM {{ ref('fact_events') }}
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY event_id
        ORDER BY date_added DESC
    ) = 1
),

global_avg AS (
    SELECT AVG(num_articles) AS global_avg_articles
    FROM latest_events
)

SELECT
    d.full_date,
    d.year,
    d.month,
    d.month_name,
    c.country_id,
    c.country_name,
    cr.cameo_code_desc                                          AS cameo_root_name,
    cf.cameo_code_desc                                          AS cameo_full_code_desc,
    COUNT(*)                                                    AS total_events,
    AVG(f.goldstein_scale)                                      AS avg_goldstein,
    AVG(f.num_articles)                                         AS avg_articles,
    AVG(f.num_mentions)                                         AS avg_mentions,
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
JOIN {{ ref('dim_cameo') }} cf   ON f.cameo_code_id = cf.cameo_full_id
WHERE c.country_id IS NOT NULL
GROUP BY
    d.full_date,
    d.year,
    d.month,
    d.month_name,
    c.country_id,
    c.country_name,
    cr.cameo_root_id,
    cr.cameo_code_desc,
    cf.cameo_full_id,
    cf.cameo_code_desc