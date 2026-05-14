SELECT DISTINCT
    action_geo_type AS geo_location_type_id,
    CASE action_geo_type
        WHEN 0 THEN 'Unknown'
        WHEN 1 THEN 'Country'
        WHEN 2 THEN 'US State / World Region'
        WHEN 3 THEN 'US City / World City'
        WHEN 4 THEN 'US Landmark / World Landmark'
        WHEN 5 THEN 'Extended Location'
        ELSE 'Not Specified'
    END AS geo_location_type_name
FROM {{ ref('__stg_gdelt_export') }}
order by action_geo_type