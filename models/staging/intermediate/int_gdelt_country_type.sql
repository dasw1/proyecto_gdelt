SELECT DISTINCT
    country_type_id,
    CASE country_type_id
        WHEN 1 THEN 'Region'
        WHEN 2 THEN 'Territory'
        WHEN 3 THEN 'Country'
    END AS country_type_name,
    CASE country_type_id
        WHEN 1 THEN 'Geographical or political region (e.g. Europe, Asia)'
        WHEN 2 THEN 'Dependent or special territory (e.g. Hong Kong, Taiwan)'
        WHEN 3 THEN 'Sovereign country'
    END AS country_type_desc
FROM {{ ref('__stg_country_list') }}
ORDER BY country_type_id