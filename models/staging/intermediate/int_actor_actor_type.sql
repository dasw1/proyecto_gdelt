WITH actor_types AS (
    SELECT DISTINCT
        actor1_id           AS actor_id,
        actor1_type1_code   AS actor_type_id,
        1                   AS type_order
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_id IS NOT NULL AND actor1_type1_code IS NOT NULL AND actor1_type1_code != ''

    UNION

    SELECT DISTINCT
        actor1_id,
        actor1_type2_code,
        2
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_id IS NOT NULL AND actor1_type2_code IS NOT NULL AND actor1_type2_code != ''

    UNION

    SELECT DISTINCT
        actor1_id,
        actor1_type3_code,
        3
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_id IS NOT NULL AND actor1_type3_code IS NOT NULL AND actor1_type3_code != ''

    UNION

    SELECT DISTINCT
        actor2_id,
        actor2_type1_code,
        1
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_id IS NOT NULL AND actor2_type1_code IS NOT NULL AND actor2_type1_code != ''

    UNION

    SELECT DISTINCT
        actor2_id,
        actor2_type2_code,
        2
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_id IS NOT NULL AND actor2_type2_code IS NOT NULL AND actor2_type2_code != ''

    UNION

    SELECT DISTINCT
        actor2_id,
        actor2_type3_code,
        3
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_id IS NOT NULL AND actor2_type3_code IS NOT NULL AND actor2_type3_code != ''
)

SELECT DISTINCT
    actor_id,
    TRIM(UPPER(actor_type_id)) AS actor_type_id,
    type_order
FROM actor_types