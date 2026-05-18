SELECT DISTINCT
    g.geo_locations_id,
    g.action_geo_fullname,
    c.iso3_code                 AS country_id,
    g.action_geo_type           AS geo_location_type_id
FROM {{ ref('__stg_gdelt_export') }} g
LEFT JOIN {{ ref('__stg_country_list') }} c
    ON g.action_geo_country_code = c.country_code
WHERE g.geo_locations_id IS NOT NULL