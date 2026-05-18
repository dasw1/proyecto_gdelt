WITH religion AS (
    SELECT DISTINCT TRIM(UPPER(actor1_religion1_code)) AS religion_id
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor1_religion2_code))
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_religion1_code))
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_religion2_code))
    FROM {{ ref('__stg_gdelt_export') }}
)

SELECT DISTINCT
    COALESCE(r.religion_id, 'NS')                           AS religion_id,
    COALESCE(l.religion_name, 'Not Specified')              AS religion_name,
    COALESCE(l.parent_id, l.religion_id, 'NS')             AS parent_id,
    COALESCE(
        CASE 
            WHEN COALESCE(l.parent_id, l.religion_id) = 'CHR' THEN 'Christianity'
            WHEN COALESCE(l.parent_id, l.religion_id) = 'MOS' THEN 'Islam'
            WHEN COALESCE(l.parent_id, l.religion_id) = 'JEW' THEN 'Judaism'
            ELSE l.religion_name
        END,
        'Not Specified'
    )                                                       AS parent_name
FROM religion r
LEFT JOIN {{ ref('__stg_religion_list') }} l
    ON r.religion_id = l.religion_id