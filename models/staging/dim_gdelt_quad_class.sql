SELECT DISTINCT
    quad_class_id AS quad_class_id,
    CASE quad_class_id
        WHEN 1 THEN 'Verbal Cooperation'
        WHEN 2 THEN 'Material Cooperation'
        WHEN 3 THEN 'Verbal Conflict'
        WHEN 4 THEN 'Material Conflict'
    END AS quad_class_name
FROM {{ ref('__stg_gdelt_export') }}
order by quad_class_id