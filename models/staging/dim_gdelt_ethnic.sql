WITH ethnic AS (
    SELECT DISTINCT TRIM(UPPER(actor1_ethnic_code)) AS ethnic_id
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_ethnic_code))
    FROM {{ ref('__stg_gdelt_export') }}
)

SELECT DISTINCT
    COALESCE(e.ethnic_id, 'NS')             AS ethnic_id,
    COALESCE(l.ethnic_name, 'Not Specified') AS ethnic_name
FROM ethnic e
LEFT JOIN {{ ref('__stg_ethnic_list') }} l
    ON e.ethnic_id = l.ethnic_id