WITH actor_types AS (
    SELECT DISTINCT TRIM(UPPER(actor1_type1_code)) AS actor_type_id
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_type1_code IS NOT NULL AND actor1_type1_code != ''

    UNION

    SELECT DISTINCT TRIM(UPPER(actor1_type2_code))
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_type2_code IS NOT NULL AND actor1_type2_code != ''

    UNION

    SELECT DISTINCT TRIM(UPPER(actor1_type3_code))
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_type3_code IS NOT NULL AND actor1_type3_code != ''

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_type1_code))
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_type1_code IS NOT NULL AND actor2_type1_code != ''

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_type2_code))
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_type2_code IS NOT NULL AND actor2_type2_code != ''

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_type3_code))
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_type3_code IS NOT NULL AND actor2_type3_code != ''
)

SELECT DISTINCT
    a.actor_type_id,
    COALESCE(l.actor_type_name, 'Not Specified')    AS actor_type_name,
    COALESCE(l.actor_type_desc, 'Not Specified')    AS actor_type_desc
FROM actor_types a
LEFT JOIN {{ ref('__stg_actor_type_list') }} l
    ON a.actor_type_id = l.actor_type_id