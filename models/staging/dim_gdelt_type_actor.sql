WITH actors AS (
    SELECT DISTINCT
        actor1_id           AS actor_id,
        actor1_code         AS actor_code,
        actor1_name         AS actor_name,
        actor1_country_code AS country_code,
        actor1_known_group_code AS known_group_id,
        actor1_ethnic_code  AS ethnic_id,
        actor1_religion1_code AS religion1_id,
        actor1_religion2_code AS religion2_id
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_id IS NOT NULL

    UNION

    SELECT DISTINCT
        actor2_id,
        actor2_code,
        actor2_name,
        actor2_country_code,
        actor2_known_group_code,
        actor2_ethnic_code,
        actor2_religion1_code,
        actor2_religion2_code
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_id IS NOT NULL
)

SELECT DISTINCT
    a.actor_id,
    a.actor_code,
    a.actor_name,
    c.iso3_code                             AS country_id,
    TRIM(UPPER(a.known_group_id))           AS known_group_id,
    TRIM(UPPER(a.ethnic_id))                AS ethnic_id,
    TRIM(UPPER(a.religion1_id))             AS religion1_id,
    TRIM(UPPER(a.religion2_id))             AS religion2_id
FROM actors a
LEFT JOIN {{ source('seeds', 'country_list') }} c
    ON a.country_code = c.country_code