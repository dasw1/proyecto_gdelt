WITH countries AS (
    SELECT DISTINCT actor1_country_code AS country_code
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor1_country_code IS NOT NULL AND actor1_country_code != ''

    UNION

    SELECT DISTINCT actor2_country_code
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE actor2_country_code IS NOT NULL AND actor2_country_code != ''

    UNION

    SELECT DISTINCT action_geo_country_code
    FROM {{ ref('__stg_gdelt_export') }}
    WHERE action_geo_country_code IS NOT NULL AND action_geo_country_code != ''
)

SELECT DISTINCT
    L.iso3_code                         AS country_id,
    L.country_name                      AS country_name,
    L.country_type_id                   AS country_type_id
FROM countries C
INNER JOIN {{ ref('__stg_country_list') }} L
    ON C.country_code = L.country_code
WHERE L.iso3_code IS NOT NULL
  AND L.iso3_code != ''