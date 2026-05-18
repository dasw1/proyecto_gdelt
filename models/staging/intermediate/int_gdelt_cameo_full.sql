WITH CAMEO_FC AS (   
    SELECT DISTINCT
        cameo_code_id         AS cameo_code,
        event_root_code     AS cameo_root_id,
        event_subcode       AS cameo_subcode
    FROM {{ ref('__stg_gdelt_export') }}
)

SELECT distinct
    C.cameo_code AS cameo_full_id,
    L.cameo_code_desc,
    C.cameo_root_id,
    C.cameo_subcode
FROM CAMEO_FC C
    LEFT JOIN {{ ref('__stg_gdelt_cameo_code_list') }} L
        ON C.cameo_code = L.cameo_code_full_id
ORDER BY C.cameo_code