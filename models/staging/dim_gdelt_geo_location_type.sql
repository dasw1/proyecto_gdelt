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
    END AS geo_location_type_name,
    CASE action_geo_type
    WHEN 0 THEN 'Location could not be determined'
    WHEN 1 THEN 'Entire country referenced'
    WHEN 2 THEN 'US state or world administrative region'
    WHEN 3 THEN 'US or world city'
    WHEN 4 THEN 'Specific landmark or point of interest'
    WHEN 5 THEN 'Extended or undocumented location type'
END AS geo_location_type_desc
FROM {{ ref('__stg_gdelt_export') }}
order by action_geo_type