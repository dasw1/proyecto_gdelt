
SELECT DISTINCT
    event_id,
    CAST(TO_CHAR(event_date, 'YYYYMMDD') AS INT)    AS date_id,
    source_url,
    is_root_event,
    goldstein_scale,
    num_mentions,
    num_sources,
    num_articles,
    avg_tone,
    actor1_id,
    actor2_id,
    cameo_code_id,
    quad_class_id,
    loaded_at,
    source_file
FROM {{ ref('__stg_gdelt_export') }}

