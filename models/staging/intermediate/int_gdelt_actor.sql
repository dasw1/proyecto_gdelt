
WITH actors AS (
    SELECT DISTINCT
        actor1_id                               AS actor_id,
        UPPER(TRIM(actor1_name))                AS actor_name,
        UPPER(TRIM(actor1_code))                AS actor_code,
        actor1_country_code                     AS country_code,
        UPPER(TRIM(actor1_ethnic_code))         AS ethnic_id,
        UPPER(TRIM(actor1_known_group_code))    AS known_group_id,
        UPPER(TRIM(actor1_religion1_code))      AS religion1_id,
        UPPER(TRIM(actor1_religion2_code))      AS religion2_id
    FROM {{ ref('__stg_gdelt_export') }}

    UNION ALL

    SELECT DISTINCT
        actor2_id,
        UPPER(TRIM(actor2_name)),
        UPPER(TRIM(actor2_code)),
        actor2_country_code,
        UPPER(TRIM(actor2_ethnic_code)),
        UPPER(TRIM(actor2_known_group_code)),
        UPPER(TRIM(actor2_religion1_code)),
        UPPER(TRIM(actor2_religion2_code))
    FROM {{ ref('__stg_gdelt_export') }}
)

SELECT
    a.actor_id,
    a.actor_name,
    a.actor_code,
    c.iso3_code                             AS country_id,
    a.ethnic_id,
    a.known_group_id,
    a.religion1_id,
    a.religion2_id
FROM actors a
LEFT JOIN {{ ref('__stg_country_list') }} c
    ON a.country_code = c.country_code
QUALIFY ROW_NUMBER() OVER (PARTITION BY a.actor_id ORDER BY c.iso3_code) = 1