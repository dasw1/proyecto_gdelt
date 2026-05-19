SELECT 
    a.actor_id,
    a.actor_name,
    a.actor_code,
    c.country_id,
    c.country_name
FROM {{ ref('int_gdelt_actor') }} a
LEFT JOIN {{ ref('int_gdelt_country') }} c 
    ON a.country_id = c.country_id