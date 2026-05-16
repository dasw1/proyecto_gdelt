SELECT DISTINCT
    quad_class_id AS quad_class_id,
    CASE quad_class_id
        WHEN 1 THEN 'Verbal Cooperation'
        WHEN 2 THEN 'Material Cooperation'
        WHEN 3 THEN 'Verbal Conflict'
        WHEN 4 THEN 'Material Conflict'
    END AS quad_class_name,
    CASE quad_class_id
    WHEN 1 THEN 'Verbal statements of cooperation, intent or agreement'
    WHEN 2 THEN 'Physical or material acts of cooperation and assistance'
    WHEN 3 THEN 'Verbal statements of conflict, threats or accusations'
    WHEN 4 THEN 'Physical acts of conflict, violence or coercion'
END AS quad_class_desc
FROM {{ ref('__stg_gdelt_export') }}
order by quad_class_id