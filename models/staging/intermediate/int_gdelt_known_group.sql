WITH known_groups AS (
    SELECT DISTINCT TRIM(UPPER(actor1_known_group_code)) AS known_group_id
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_known_group_code))
    FROM {{ ref('__stg_gdelt_export') }}
)

SELECT DISTINCT
    COALESCE(k.known_group_id, 'NS')              AS known_group_id,
    COALESCE(l.known_group_name, 'Not Specified')  AS known_group_name
FROM known_groups k
LEFT JOIN {{ ref('__stg_known_group_list') }} l
    ON k.known_group_id = l.known_group_id