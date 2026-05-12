SELECT DISTINCT
    cameo_event_id        AS cameo_event_id,
    event_code         AS cameo_code,
    event_root_code     AS cameo_root_id,
    event_subcode       AS cameo_subcode
FROM {{ ref('__stg_gdelt_export') }}